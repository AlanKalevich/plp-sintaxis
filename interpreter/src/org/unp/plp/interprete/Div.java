package org.unp.plp.interprete;

public class Div implements Expr {

    final Expr a, b;

    public Div(Expr a, Expr b) {
        this.a = a;
        this.b = b;
    }

    @Override
    public int eval(int i, int j) {
        int den = b.eval(i, j);
        return den == 0 ? 0 : a.eval(i, j) / den; // división segura
    }
}
