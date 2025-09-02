package org.unp.plp.interprete;

public class AddOp implements BinOp {

    @Override
    public Expr apply(Expr l, Expr r) {
        return new Add(l, r);
    }
}
