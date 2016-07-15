// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:kernel/ast.dart' as dart;

import 'ast.dart' as java;
import 'visitor.dart' as java;
import 'constants.dart';
import '../compiler/compiler_state.dart';
import '../compiler/runner.dart' show CompileErrorException;

/// Builds a Java class from Dart IR.
///
/// Clients should only call static methods on this class. The fact that
/// this class is a [dart.Visitor] is an implementation detail that callers must
/// not rely on.
class JavaAstBuilder extends dart.Visitor {
  /// Builds a Java class that contains the top-level procedures and fields in
  /// a Dart [Library].
  static java.ClassDecl buildWrapperClass(String package, String className,
      dart.Library library, CompilerState compilerState) {
    java.ClassDecl result =
        new java.ClassDecl(package, className, java.Access.Public, [], []);
    var instance =
        new JavaAstBuilder(package, compilerState, thisClass: result);

    for (var f in library.fields) {
      result.fields.add(f.accept(instance));
    }
    for (var p in library.procedures) {
      result.methods.add(p.accept(instance));
    }

    return result;
  }

  /// Builds a Java class AST from a kernel class AST.
  static java.ClassDecl buildClass(
      String package, dart.Class node, CompilerState compilerState) {
    var instance = new JavaAstBuilder(package, compilerState);
    return node.accept(instance);
  }

  JavaAstBuilder(this.package, this.compilerState, {this.thisClass});

  String package;
  java.ClassDecl thisClass;
  final CompilerState compilerState;
  bool isInterceptorClass = false;

  /// Need to know if this is a static method to generate correct
  /// implicit "this"
  bool isInsideStaticMethod;

  /// Visits a non-mixin class.
  @override
  java.ClassDecl visitNormalClass(dart.NormalClass node) {
    assert(thisClass == null);
    thisClass =
        new java.ClassDecl(package, node.name, java.Access.Public, [], []);

    String javaClassAnnotation = 
        getSimpleAnnotation(node, Constants.javaClassAnnotation);
    if (javaClassAnnotation != null) {
      // This class is backed by a Java class
      isInterceptorClass = true;
      compilerState.registerPrimitiveCoreClass(node.thisType, javaClassAnnotation, getThisClassJavaName());
    }

    for (var f in node.fields) {
      thisClass.fields.add(f.accept(this));
    }
    for (var p in node.procedures) {
      thisClass.methods.add(p.accept(this));
    }

    return thisClass;
  }

  @override
  java.FieldDecl visitField(dart.Field node) {
    return new java.FieldDecl(node.name.name, node.type.accept(this),
        initializer: node.initializer?.accept(this),
        access: java.Access.Public,
        isStatic: node.isStatic,
        isFinal: node.isFinal);
  }

  String capitalizeString(String str) =>
      str[0].toUpperCase() + str.substring(1);

  String javaMethodName(String methodName, dart.ProcedureKind kind) {
    switch (kind) {
      case dart.ProcedureKind.Method:
        return methodName;
      case dart.ProcedureKind.Operator:
        var translatedMethodName = Constants.operatorToMethodName[methodName];
        if (translatedMethodName == null) {
          throw new CompileErrorException(
              "Operator ${methodName} not implemented yet.");
        }
        return translatedMethodName;
      case dart.ProcedureKind.Getter:
        return "get" + capitalizeString(methodName);
      default:
        // TODO(springerm): handle remaining kinds
        throw new CompileErrorException(
            "Method kind ${kind} not implemented yet.");
    }
  }

  @override
  java.MethodDef visitProcedure(dart.Procedure node) {
    String methodName = javaMethodName(node.name.name, node.kind);
    dart.FunctionNode functionNode = node.function;
    String returnType = functionNode.returnType.accept(this);
    // TODO: handle named parameters, etc.
    List<java.VariableDecl> parameters =
        functionNode.positionalParameters.map((p) => p.accept(this)).toList();
    var isStatic = node.isStatic;

    java.Statement body;
    if (node.isExternal) {
      // Generate a method call to a static Java method
      // Every external Dart method must be annotated with "javaCall"!
      String externalJavaMethod =
          getSimpleAnnotation(node, Constants.javaCallAnnotation);
      if (externalJavaMethod == null) {
        throw new CompileErrorException(
          "No JavaCall annotation found for external "
          "method definition ${methodName}");
      }

      List<String> methodTokens = externalJavaMethod.split(".");
      var extReceiver = new java.ClassRefExpr(
          methodTokens.getRange(0, methodTokens.length - 1).join("."));
      var extMethodName = methodTokens.last;

      List<java.Expression> arguments = [];
      if (!node.isStatic) {
        // First argument is "this"
        arguments
            .add(new java.IdentifierExpr(Constants.javaStaticThisIdentifier));
      }
      // Remaining arguments are parameters of Dart method
      arguments.addAll(parameters.map((p) => new java.IdentifierExpr(p.name)));

      body = new java.ReturnStmt(
          new java.MethodInvocation(extReceiver, extMethodName, arguments));
    } else {
      assert(isInsideStaticMethod == null);
      isInsideStaticMethod = isStatic;
      body = buildStatement(functionNode.body);
      isInsideStaticMethod = null;
    }

    if (isInterceptorClass) {
      // All methods in interceptor classes are static
      isStatic = true;
      parameters.insert(
          0,
          new java.VariableDecl(
              Constants.javaStaticThisIdentifier, getThisClassJavaName()));
    }

    if (methodName == "main" && isStatic && parameters.length == 1) {
      // This method can act as a program entry point, generate a Java
      // wrapper method with a String[] parameter type
      // TODO(springerm): Ensure that type of first parameter is List<String>
      thisClass.methods.add(buildMainMethodWrapper(parameters.first));
    }

    return new java.MethodDef(methodName, wrapInJavaBlock(body), parameters,
        returnType: returnType, isStatic: isStatic, isFinal: false);
  }

  java.MethodDef buildMainMethodWrapper(java.VariableDecl firstParameter) {
    var methodInvoke = new java.MethodInvocation(
        buildDefaultReceiver(isStatic: true),
        "main",
        [new java.CastExpr(java.NullLiteral.instance, firstParameter.type)]);
    var body = wrapInJavaBlock(new java.ExpressionStmt(methodInvoke));
    var methodDef = new java.MethodDef(
        "main", body, [new java.VariableDecl("args", "String[]")],
        returnType: "void", isStatic: true);
    return methodDef;
  }

  /// Wraps a Java statement in a block, if [stmt] is not already a block.
  java.Block wrapInJavaBlock(java.Statement stmt) {
    if (stmt is java.Block) {
      return stmt;
    } else {
      return new java.Block([stmt]);
    }
  }

  @override
  java.Block visitBlock(dart.Block node) {
    return new java.Block(node.statements.map(buildStatement).toList());
  }

  @override
  java.IfStmt visitIfStatement(dart.IfStatement node) {
    return new java.IfStmt(
        node.condition.accept(this),
        wrapInJavaBlock(buildStatement(node.then)),
        node.otherwise == null
            ? null
            : wrapInJavaBlock(buildStatement(node.otherwise)));
  }

  @override
  java.ReturnStmt visitReturnStatement(dart.ReturnStatement node) {
    return new java.ReturnStmt(node.expression?.accept(this));
  }

  @override
  java.ExpressionStmt visitExpressionStatement(dart.ExpressionStatement node) {
    return new java.ExpressionStmt(node.expression.accept(this));
  }

  /// Builds a Java MethodInvocation node. This method is reused for "normal"
  /// method and for getter/setters etc.
  java.MethodInvocation buildMethodInvocation(
      java.Expression receiver,
      dart.DartType receiverType,
      String methodName,
      List<dart.Expression> positionalArguments) {
    // TODO(springerm): Handle other argument types
    List<java.Expression> args =
        positionalArguments.map((a) => a.accept(this)).toList();

    // Replace with static method call if necessary
    if (compilerState.javaClasses.containsKey(receiverType)) {
      // Receiver type is an already existing Java class, generate static
      // method call.
      var dartClass = compilerState.interceptorClasses[receiverType];
      var argsWithSelf = [receiver]..addAll(args);
      return new java.MethodInvocation(
          buildClassReference(dartClass), methodName, argsWithSelf);
    }

    return new java.MethodInvocation(receiver, methodName, args);
  }

  /// Builds a method invocation where the call target is not statically known.
  java.MethodInvocation buildDynamicMethodInvocation(dart.Expression receiver,
      String methodName, List<dart.Expression> positionalArguments) {
    // Translate receiver
    java.Expression recv;
    String recvType;
    if (receiver == null) {
      // Implicit "this" receiver
      recv = buildDefaultReceiver();
      recvType = getThisClassDartName();
    } else {
      recv = receiver.accept(this);
      recvType = getType(receiver);
    }

    return buildMethodInvocation(
        recv, recvType, methodName, positionalArguments);
  }

  @override
  java.MethodInvocation visitPropertyGet(dart.PropertyGet node) {
    String methodName =
        javaMethodName(node.name.name, dart.ProcedureKind.Getter);
    return buildDynamicMethodInvocation(node.receiver, methodName, []);
  }

  @override
  java.MethodInvocation visitMethodInvocation(dart.MethodInvocation node) {
    String name = node.name.name;
    // Expand operator symbol to Java-compatible method name
    name = Constants.operatorToMethodName[name] ?? name;
    return buildDynamicMethodInvocation(
        node.receiver, name, node.arguments.positional);
  }

  @override
  java.MethodInvocation visitStaticInvocation(dart.StaticInvocation node) {
    if (node.target is dart.Procedure) {
      // TODO(springerm): Instead of constructing types/classnames from
      // strings, use DartType here (and in compiler_state) eventually
      String libraryName =
          compilerState.getJavaPackageName(node.target.enclosingLibrary);
      String className;
      if (node.target.enclosingClass == null) {
        // Target is a top-level member of the library
        className = CompilerState.getClassNameForPackageTopLevel(package);
      } else {
        className = node.target.enclosingClass.name;
      }

      var receiverName = libraryName + "::" + className;
      return buildMethodInvocation(
          new java.ClassRefExpr(getJavaClassName(receiverName)),
          receiverName,
          node.target.name.name,
          node.arguments.positional);
    } else {
      throw new CompileErrorException(
          "Not implemented yet: Cannot handle ${node.target.runtimeType} "
          "targets in static invocations");
    }
  }

  /// Retrieves the [DartType] for a kernel [Expression] node.
  String getType(dart.Expression node) {
    // TODO(andrewkrieger): Workaround until we get types for implicit "this"
    // working.
    if (node.staticType == null) {
      if (node.toString() == "this") {
        return getThisClassDartName();
      } else {
        throw new CompileErrorException(
            'Unable to retrieve type for Kernel AST expression'
            ' "$node" of type ${node.runtimeType}');
      }
    } else {
      return node.staticType.toString();
    }
  }

  /// Assuming that [node] has a single annotation of type [annotation] and
  /// that annotation has a single String parameter, return the parameter
  /// value. Otherwise, return null.
  String getSimpleAnnotation(dart.TreeNode node, String annotation,
      [String fieldName = "name"]) {
    // TODO(springerm): Try to use DartTypes here instead of Strings
    var obj = node.analyzerMetadata
        .firstWhere((i) => i.type.toString() == annotation);
    if (obj == null) {
      return null;
    }

    return obj.getField(fieldName).toStringValue();
  }

  /// Converts a Dart class name to a Java class name.
  String getJavaClassName(String dartClassName) {
    return dartClassName.replaceFirst("::", ".");
  }

  /// Build a reference to a Dart class.
  java.ClassRefExpr buildClassReference(String dartClassName) {
    return new java.ClassRefExpr(getJavaClassName(dartClassName));
  }

  java.ClassRefExpr buildThisClassRefExpr() {
    return new java.ClassRefExpr(getThisClassJavaName());
  }

  /// Build a reference to "this".
  java.Expression buildDefaultReceiver({bool isStatic: null}) {
    isStatic ??= isInsideStaticMethod;

    if (isStatic) {
      return buildThisClassRefExpr();
    } else {
      if (isInterceptorClass) {
        // Replace "this" with "self" (first arg.) inside interceptor methods
        return new java.IdentifierExpr(Constants.javaStaticThisIdentifier);
      } else {
        return new java.IdentifierExpr("this");
      }
    }
  }

  /// Returns the fully-qualified Dart class name of the current class.
  String getThisClassDartName() {
    return package + "::" + thisClass.name;
  }

  /// Returns the fully-qualified Java class name of the current class.
  String getThisClassJavaName() {
    if (isInterceptorClass) {
      return getJavaClassName(
          compilerState.javaClasses[thisClass.thisType]);
    } else {
      return getJavaClassName(getThisClassDartName());
    }
  }

  @override
  java.IdentifierExpr visitThisExpression(dart.ThisExpression node) {
    return buildDefaultReceiver();
  }

  @override
  java.IdentifierExpr visitVariableGet(dart.VariableGet node) {
    return new java.IdentifierExpr(node.variable.name);
  }

  @override
  java.AssignmentExpr visitVariableSet(dart.VariableSet node) {
    return new java.AssignmentExpr(
        new java.IdentifierExpr(node.variable.name), node.value.accept(this));
  }

  @override
  java.IntLiteral visitIntLiteral(dart.IntLiteral node) {
    return new java.IntLiteral(node.value);
  }

  @override
  java.DoubleLiteral visitDoubleLiteral(dart.DoubleLiteral node) {
    return new java.DoubleLiteral(node.value);
  }

  @override
  java.StringLiteral visitStringLiteral(dart.StringLiteral node) {
    return new java.StringLiteral(node.value);
  }

  /// Convert a Dart statement to a Java statement.
  ///
  /// Some statements require special handling.
  java.Statement buildStatement(dart.Statement node) {
    var result = node.accept(this);

    if (node is dart.VariableDeclaration) {
      // Our AST has VariableDecl and VariableDeclStmt and we want to keep
      // them separate. Kernel AST has only VariableDeclaration as a statement.
      // That kernel class translates to VariableDecl in our builder, but
      // when we expect a statement, we wrap it in a VariableDeclStmt.
      var decl = result as java.VariableDecl;
      return new java.VariableDeclStmt(decl, node.initializer?.accept(this));
    } else {
      return result;
    }
  }

  /// This is the default visitor method for DartType.
  @override
  String defaultDartType(dart.DartType node) {
    if (compilerState.javaClasses.containsKey(node)) {
      // Reuse a Java type
      return compilerState.javaClasses[typeName];
    } else {
      // TODO(springerm): generate proper types
      return node.toString();
    }
  }

  @override
  java.VariableDecl visitVariableDeclaration(dart.VariableDeclaration node) {
    return new java.VariableDecl(node.name, node.type.accept(this),
        isFinal: node.isFinal);
  }
}
