var constructors = dart.defineLibrary(constructors, {});
var core = dart.import(core);
(function(exports, core) {
  'use strict';
  class A extends core.Object {}
  class B extends core.Object {
    B() {
    }
  }
  class C extends core.Object {
    named() {
    }
  }
  dart.defineNamedConstructor(C, 'named');
  class C2 extends C {
    named() {
      super.named();
    }
  }
  dart.defineNamedConstructor(C2, 'named');
  class D extends core.Object {
    D() {
    }
    named() {
    }
  }
  dart.defineNamedConstructor(D, 'named');
  class E extends core.Object {
    E(name) {
      this.name = name;
    }
  }
  class F extends E {
    F(name) {
      super.E(name);
    }
  }
  class G extends core.Object {
    G(p1) {
      if (p1 === void 0)
        p1 = null;
    }
  }
  class H extends core.Object {
    H(opts) {
      let p1 = opts && 'p1' in opts ? opts.p1 : null;
    }
  }
  class I extends core.Object {
    I() {
      this.name = 'default';
    }
    named(name) {
      this.name = name;
    }
  }
  dart.defineNamedConstructor(I, 'named');
  class J extends core.Object {
    J() {
      this.initialized = true;
      this.nonInitialized = null;
    }
  }
  class K extends core.Object {
    K() {
      this.s = 'a';
    }
    withS(s) {
      this.s = s;
    }
  }
  dart.defineNamedConstructor(K, 'withS');
  class L extends core.Object {
    L(foo) {
      this.foo = foo;
    }
  }
  class M extends L {
    named(x) {
      super.L(dart.notNull(x) + 42);
    }
  }
  dart.defineNamedConstructor(M, 'named');
  class N extends M {
    named(y) {
      super.named(dart.notNull(y) + 100);
    }
  }
  dart.defineNamedConstructor(N, 'named');
  class P extends N {
    P(z) {
      super.named(dart.notNull(z) + 9000);
    }
    foo(x) {
      this.P(dart.notNull(x) + 42);
    }
    bar() {
      this.foo(1);
    }
  }
  dart.defineNamedConstructor(P, 'foo');
  dart.defineNamedConstructor(P, 'bar');
  let Q$ = dart.generic(function(T) {
    class Q extends core.Object {
      Q(y) {
        this.x = dart.as(y, T);
      }
      static foo() {
        return new (Q$())("hello");
      }
      bar() {
        let q = Q$().foo();
        return dart.as(q.x, core.String);
      }
      bar2() {
        let q = new (Q$())("world");
        return dart.as(q.x, core.String);
      }
      static baz() {
        let q = new (Q$(core.int))(42);
        return dart.notNull(q.bar()) + dart.notNull(q.bar2());
      }
    }
    dart.setSignature(Q, {
      methods: () => ({
        bar: dart.functionType(core.String, []),
        bar2: dart.functionType(core.String, [])
      }),
      statics: () => ({
        foo: dart.functionType(Q$(), []),
        baz: dart.functionType(core.String, [])
      }),
      names: ['foo', 'baz']
    });
    return Q;
  });
  let Q = Q$();
  // Exports:
  exports.A = A;
  exports.B = B;
  exports.C = C;
  exports.C2 = C2;
  exports.D = D;
  exports.E = E;
  exports.F = F;
  exports.G = G;
  exports.H = H;
  exports.I = I;
  exports.J = J;
  exports.K = K;
  exports.L = L;
  exports.M = M;
  exports.N = N;
  exports.P = P;
  exports.Q$ = Q$;
  exports.Q = Q;
})(constructors, core);
