package specialized_list;

public class __TopLevel
{
    private static dart._runtime.types.simple.InterfaceTypeExpr dart2java$typeExpr_List$ltint$0$gt = new dart._runtime.types.simple.InterfaceTypeExpr(dart.core.List.dart2java$typeInfo, new dart._runtime.types.simple.TypeExpr[] {new dart._runtime.types.simple.InterfaceTypeExpr(dart._runtime.helpers.IntegerHelper.dart2java$typeInfo)});
  
  
  
    public static void main(String[] args)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = dart._runtime.types.simple.TypeEnvironment.ROOT;
      dart.core.__TopLevel.print("Expect output 5, 7, 9");
      dart.core.List_interface__int intList = ((dart.core.List_interface__int) ((dart.core.List_interface__int) dart._runtime.base.DartList.factory$fromArguments(dart2java$localTypeEnv.evaluate(dart2java$typeExpr_List$ltint$0$gt), java.lang.Integer.class, 5, 7, 9)));
      for (int i = 0; (i < intList.getLength__int()); i = (i + 1))
      {
        dart.core.__TopLevel.print(intList.operatorAt__int(i));
      }
    }
}
