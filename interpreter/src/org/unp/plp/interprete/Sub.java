package org.unp.plp.interprete;

public class Sub implements Expr {

    final Expr a, b;

    public Sub(Expr a, Expr b) {
        this.a = a;
        this.b = b;
    }

    @Override
    public int eval(int i, int j) {
        return a.eval(i, j) - b.eval(i, j);
    }
}
