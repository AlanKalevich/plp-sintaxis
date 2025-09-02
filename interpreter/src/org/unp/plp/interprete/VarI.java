package org.unp.plp.interprete;

public class VarI implements Expr {

    @Override
    public int eval(int i, int j) {
        return i;
    }
}
