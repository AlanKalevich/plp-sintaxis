package org.unp.plp.interprete;

public class DivOp implements BinOp {

    @Override
    public Expr apply(Expr l, Expr r) {
        return new Div(l, r);
    }
}
