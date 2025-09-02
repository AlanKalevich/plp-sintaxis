package org.unp.plp.interprete;

public class MulOp implements BinOp {

    @Override
    public Expr apply(Expr l, Expr r) {
        return new Mul(l, r);
    }
}
