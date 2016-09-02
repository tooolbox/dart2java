package dart._runtime.types.simple;

/**
 * A singleton class representing the top (a.k.a. dynamic) type.
 */
class TopType extends Type {
  private TopType() {}

  /**
   * A singleton instance of the top type.
   * <p>
   * Client code should access this instance through {@link #EXPR}, for consistency with {@code
   * InterfaceTypeExpr} and {@code FunctionTypeExpr}. Code in this package may access the instance
   * directly.
   */
  static final TopType INSTANCE = new TopType();

  /**
   * A type expression representing the top type.
   */
  public static final TypeExpr EXPR = new TypeExpr("[top]") {
    @Override
    Type evaluateUncached(TypeEnvironment env) {
      return INSTANCE;
    }
  };

  @Override
  protected boolean isSubtypeOfInterfaceType(InterfaceType other) {
    return false;
  }

  @Override
  protected boolean isSubtypeOfFunctionType(FunctionType other) {
    return false;
  }
}
