package org.unp.plp.interprete;

public class Const implements Expr {

    final int v;

    public Const(int v) {
        this.v = v;
    }

    @Override
    public int eval(int i, int j) {
        return v;
    }
}
