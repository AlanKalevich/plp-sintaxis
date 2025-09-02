package org.unp.plp.interprete;

public class VarJ implements Expr {

    @Override
    public int eval(int i, int j) {
        return j;
    }
}
