package fluidmotion;

public class Expect extends dart._runtime.base.DartObject implements fluidmotion.Expect_interface
{
    public static dart._runtime.types.simple.InterfaceTypeInfo dart2java$typeInfo = new dart._runtime.types.simple.InterfaceTypeInfo(fluidmotion.Expect.class, fluidmotion.Expect_interface.class);
    private static dart._runtime.types.simple.InterfaceTypeExpr dart2java$typeExpr_Object = new dart._runtime.types.simple.InterfaceTypeExpr(dart._runtime.helpers.ObjectHelper.dart2java$typeInfo);
    static {
      fluidmotion.Expect.dart2java$typeInfo.superclass = dart2java$typeExpr_Object;
    }
  
    public Expect(dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker arg, dart._runtime.types.simple.Type type)
    {
      super(arg, type);
    }
  
    public static void equals(java.lang.Object expected, java.lang.Object actual)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = dart._runtime.types.simple.TypeEnvironment.ROOT;
      if ((!dart._runtime.helpers.ObjectHelper.operatorEqual(expected, actual)))
      {
        dart.core.__TopLevel.print("Values not equal: ");
        dart.core.__TopLevel.print(((java.lang.Object) expected));
        dart.core.__TopLevel.print("vs ");
        dart.core.__TopLevel.print(((java.lang.Object) actual));
      }
    }
    public static void listEquals(dart.core.List_interface<java.lang.Object> expected, dart.core.List_interface<java.lang.Object> actual)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = dart._runtime.types.simple.TypeEnvironment.ROOT;
      if ((!(expected.getLength_List() == actual.getLength_List())))
      {
        dart.core.__TopLevel.print("Lists have different lengths: ");
        dart.core.__TopLevel.print(expected.getLength_List());
        dart.core.__TopLevel.print("vs ");
        dart.core.__TopLevel.print(actual.getLength_List());
      }
      for (int i = 0; (i < actual.getLength_List()); i = (i + 1))
      {
        fluidmotion.Expect.equals(expected.operatorAt_List(i), actual.operatorAt_List(i));
      }
    }
    public void fail(java.lang.String message)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      dart.core.__TopLevel.print(message);
    }
    public void _constructor()
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      super._constructor();
    }
    public static fluidmotion.Expect_interface _new(dart._runtime.types.simple.Type type)
    {
      fluidmotion.Expect result;
      result = new fluidmotion.Expect(((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null), type);
      result._constructor();
      return result;
    }
}