package richards;

public class Packet extends dart._runtime.base.DartObject
{
    public static dart._runtime.types.simple.InterfaceTypeInfo dart2java$typeInfo = new dart._runtime.types.simple.InterfaceTypeInfo("file:///usr/local/google/home/andrewkrieger/ddc-java/gen/codegen_tests/richards.dart", "Packet");
    static {
      richards.Packet.dart2java$typeInfo.superclass = new dart._runtime.types.simple.InterfaceTypeExpr(dart._runtime.helpers.ObjectHelper.dart2java$typeInfo);
    }
    public richards.Packet link;
    public int id;
    public int kind;
    public int a1;
    public dart._runtime.base.DartList._int a2;
  
    public Packet(dart._runtime.types.simple.Type type, richards.Packet link, int id, int kind)
    {
      super((dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker) null, type);
      this._constructor(link, id, kind);
    }
    public Packet(dart._runtime.helpers.ConstructorHelper.EmptyConstructorMarker arg, dart._runtime.types.simple.Type type)
    {
      super(arg, type);
    }
  
    protected void _constructor(richards.Packet link, int id, int kind)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      this.id = 0;
      this.kind = 0;
      this.a1 = 0;
      this.a2 = dart._runtime.base.DartList._int.newInstance(int.class, richards.Richards.DATA_SIZE);
      this.link = link;
      this.id = id;
      this.kind = kind;
      super._constructor();
    }
    public richards.Packet addTo(richards.Packet queue)
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      this.setLink(null);
      if (dart._runtime.helpers.ObjectHelper.operatorEqual(queue, null))
      {
        return this;
      }
      richards.Packet peek = null;
      richards.Packet next = queue;
      while ((!dart._runtime.helpers.ObjectHelper.operatorEqual(peek = next.getLink(), null)))
      {
        next = peek;
      }
      next.setLink(this);
      return queue;
    }
    public java.lang.String toString()
    {
      final dart._runtime.types.simple.TypeEnvironment dart2java$localTypeEnv = this.dart2java$type.env;
      return "Packet";
    }
    public richards.Packet getLink()
    {
      return this.link;
    }
    public int getId()
    {
      return this.id;
    }
    public int getKind()
    {
      return this.kind;
    }
    public int getA1()
    {
      return this.a1;
    }
    public dart._runtime.base.DartList._int getA2()
    {
      return this.a2;
    }
    public richards.Packet setLink(richards.Packet value)
    {
      this.link = value;
      return value;
    }
    public int setId(int value)
    {
      this.id = value;
      return value;
    }
    public int setKind(int value)
    {
      this.kind = value;
      return value;
    }
    public int setA1(int value)
    {
      this.a1 = value;
      return value;
    }
    public dart._runtime.base.DartList._int setA2(dart._runtime.base.DartList._int value)
    {
      this.a2 = value;
      return value;
    }
}
