package generics;

public class Foo1<T> extends dart._runtime.base.DartObject implements generics.Foo1_interface<T>
{
    public static dart._runtime.types.simple.InterfaceTypeInfo dart2java$typeInfo = new dart._runtime.types.simple.InterfaceTypeInfo(new java.lang.String[] {"T"}, generics.Foo1.class, generics.Foo1_interface.class);
    public static dart._runtime.types.simple.FunctionTypeInfo factory$$typeInfo = new dart._runtime.types.simple.FunctionTypeInfo("generics.Foo1::factory$", new java.lang.String[] {"T"});
    private static dart._runtime.types.simple.TypeExpr dart2java$typeExpr_Foo1$T = generics.Foo1.dart2java$typeInfo.typeVariables[0];
    private static dart._runtime.types.simple.InterfaceTypeExpr dart2java$typeExpr_Object = new dart._runtime.types.simple.InterfaceTypeExpr(dart._runtime.helpers.ObjectHelper.dart2java$typeInfo);
    static {
      generics.Foo1.dart2java$typeInfo.superclass = dart2java$typeExpr_Object;
    }
    public T variable;
    public generics.Foo1_interface<T> anotherFoo1;
  
    public Foo1(dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker arg, dart._runtime.types.simple.Type type)
    {
      super(arg, type);
    }
  
    public void createInnerFoo_Foo1()
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      this.setAnotherFoo1_Foo1(((generics.Foo1_interface) ((generics.Foo1_interface<T>) generics.Foo1.<T>factory$(dart2java$localTypeEnv.extend(generics.Foo1.factory$$typeInfo.typeVariables, new dart._runtime.types.simple.Type[] {dart2java$localTypeEnv.evaluate(dart2java$typeExpr_Foo1$T)})))));
    }
    public T foo_Foo1(T t)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      dart2java$localTypeEnv.evaluate(dart2java$typeExpr_Foo1$T).check(t);
      return t;
    }
    public void writeVariable_Foo1(T value)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      dart2java$localTypeEnv.evaluate(dart2java$typeExpr_Foo1$T).check(value);
      this.setVariable_Foo1(value);
    }
    public void _constructornewMe()
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      super._constructor();
    }
    public T getVariable_Foo1()
    {
      return this.variable;
    }
    public generics.Foo1_interface<T> getAnotherFoo1_Foo1()
    {
      return this.anotherFoo1;
    }
    public T setVariable_Foo1(T value)
    {
      this.variable = value;
      return value;
    }
    public generics.Foo1_interface<T> setAnotherFoo1_Foo1(generics.Foo1_interface<T> value)
    {
      this.anotherFoo1 = value;
      return value;
    }
    public T getVariable()
    {
      return this.getVariable_Foo1();
    }
    public generics.Foo1_interface<T> getAnotherFoo1()
    {
      return this.getAnotherFoo1_Foo1();
    }
    public T setVariable(T value)
    {
      return this.setVariable_Foo1(((T) value));
    }
    public generics.Foo1_interface<T> setAnotherFoo1(generics.Foo1_interface<T> value)
    {
      return this.setAnotherFoo1_Foo1(((generics.Foo1_interface<T>) value));
    }
    public void createInnerFoo()
    {
      this.createInnerFoo_Foo1();
    }
    public T foo(T t)
    {
      return this.foo_Foo1(((T) t));
    }
    public void writeVariable(T value)
    {
      this.writeVariable_Foo1(((T) value));
    }
    public static <T> generics.Foo1_interface<T> factory$(dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv)
    {
      return ((generics.Foo1_interface) generics.Foo1._new_Foo1$newMe(dart2java$localTypeEnv.evaluate(new dart._runtime.types.simple.InterfaceTypeExpr(generics.Foo1.dart2java$typeInfo, new dart._runtime.types.simple.TypeExpr[] {generics.Foo1.factory$$typeInfo.typeVariables[0]}))));
    }
    public static <T> generics.Foo1_interface _new_Foo1$newMe(dart._runtime.types.simple.Type type)
    {
      dart._runtime.types.simple.Type cached_0_int = null;
      dart._runtime.types.simple.Type cached_0_boolean = null;
      dart._runtime.types.simple.Type cached_0_double = null;
      if ((true && ((((cached_0_int == null)) ? (cached_0_int = type.env.evaluate(generics.Foo1.dart2java$typeInfo.typeVariables[0])) : (cached_0_int)) == dart._runtime.helpers.IntegerHelper.type)))
      {
        generics.Foo1__int result;
        result = new generics.Foo1__int(((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null), type);
        result._constructornewMe();
        return result;
      }
      if ((true && ((((cached_0_boolean == null)) ? (cached_0_boolean = type.env.evaluate(generics.Foo1.dart2java$typeInfo.typeVariables[0])) : (cached_0_boolean)) == dart._runtime.helpers.BoolHelper.type)))
      {
        generics.Foo1__boolean result;
        result = new generics.Foo1__boolean(((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null), type);
        result._constructornewMe();
        return result;
      }
      if ((true && ((((cached_0_double == null)) ? (cached_0_double = type.env.evaluate(generics.Foo1.dart2java$typeInfo.typeVariables[0])) : (cached_0_double)) == dart._runtime.helpers.DoubleHelper.type)))
      {
        generics.Foo1__double result;
        result = new generics.Foo1__double(((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null), type);
        result._constructornewMe();
        return result;
      }
      generics.Foo1 result;
      result = new generics.Foo1(((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null), type);
      result._constructornewMe();
      return result;
    }
}
