package org.unp.plp.interprete;

public class SubOp implements BinOp {

    @Override
    public Expr apply(Expr l, Expr r) {
        return new Sub(l, r);
    }
}
