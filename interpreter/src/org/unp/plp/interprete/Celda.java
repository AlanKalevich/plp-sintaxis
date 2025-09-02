package org.unp.plp.interprete;

public class Celda {

    public int i;
    public int j;

    public Celda(int i, int j) {
        this.i = i;
        this.j = j;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Celda c)) {
            return false;
        }
        return i == c.i && j == c.j;
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(i, j);
    }
}
