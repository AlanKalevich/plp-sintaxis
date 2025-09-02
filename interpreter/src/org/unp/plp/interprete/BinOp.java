package org.unp.plp.interprete;

public interface BinOp {
    Expr apply(Expr left, Expr right);
}

