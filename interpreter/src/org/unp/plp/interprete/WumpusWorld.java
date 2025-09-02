package org.unp.plp.interprete;

import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

public class WumpusWorld {

    private int filas;
    private int columnas;
    private Celda celdaHero;
    private Celda celdaGold;
    private Celda celdaWumpus;
    private Set<Celda> celdasPit;

    public static WumpusWorld crear(int filas, int columnas) {
        return new WumpusWorld(filas, columnas);
    }

    private WumpusWorld(int filas, int columnas) {
        this.filas = filas;
        this.columnas = columnas;
        celdasPit = new LinkedHashSet<>();  // <-- único y mantiene orden    
    }

    void agregarElemento(ELEMENTO elem, Celda celda) {
        switch (elem) {
            case HERO -> {
                celdasPit.remove(celda);
                this.celdaHero = celda;
            }
            case GOLD -> {
                celdasPit.remove(celda);
                this.celdaGold = celda;
            }
            case WUMPUS -> {
                celdasPit.remove(celda);
                this.celdaWumpus = celda;
            }
            case PIT -> {
                // ignorar pits en celdas especiales
                if (esCeldaEspecial(celda)) {
                    return;
                }
                // LinkedHashSet evita duplicados; solo avisamos si se agregó
                this.celdasPit.add(celda);

            }
        }
    }

    public void removerElemento(ELEMENTO elem, Celda celda) {
        switch (elem) {
            case PIT -> {
                if (celdasPit.remove(celda)) {
                    System.out.println("Removiendo pozo en " + celda.i + "," + celda.j);
                } else {
                    System.out.println("No había pozo en " + celda.i + "," + celda.j);
                }
            }
            case HERO -> {
                if (celdaHero != null && celdaHero.equals(celda)) {
                    celdaHero = null;
                    System.out.println("Removiendo hero en " + celda.i + "," + celda.j);
                }
            }
            case GOLD -> {
                if (celdaGold != null && celdaGold.equals(celda)) {
                    celdaGold = null;
                    System.out.println("Removiendo gold en " + celda.i + "," + celda.j);
                }
            }
            case WUMPUS -> {
                if (celdaWumpus != null && celdaWumpus.equals(celda)) {
                    celdaWumpus = null;
                    System.out.println("Removiendo wumpus en " + celda.i + "," + celda.j);
                }
            }
        }
    }

    public void removerPits(Set<Celda> celdas) {
        for (Celda c : celdas) {
            removerElemento(ELEMENTO.PIT, c);
        }
    }

    /**
     * Evalúa (left <op> right) sobre TODAS las celdas y devuelve el conjunto de
     * celdas que cumplen.
     */
    public Set<Celda> evaluarExpresion(Expr left, EXP_ARIT op, Expr right) {
        Set<Celda> out = new HashSet<>();
        for (int i = 1; i <= filas; i++) {
            for (int j = 1; j <= columnas; j++) {
                int a = left.eval(i, j);
                int b = right.eval(i, j);
                boolean ok = switch (op) {
                    case IGUAL ->
                        a == b;
                    case MAYOR ->
                        a > b;
                    case MENOR ->
                        a < b;
                    case MAYOR_IGUAL ->
                        a >= b;
                    case MENOR_IGUAL ->
                        a <= b;
                    case DISTINTO ->
                        a != b;
                };
                if (ok) {
                    out.add(new Celda(i, j));
                }
            }
        }
        return out;
    }

    /**
     * Intersección de resultados de condiciones (la coma en [ cond , cond , ...
     * ]).
     */
    public Set<Celda> intersect(Set<Celda> a, Set<Celda> b) {
        Set<Celda> r = new HashSet<>(a);
        r.retainAll(b);
        return r;
    }

    /**
     * Agrega pits en todas las celdas del set.
     */
    public void agregarPits(Set<Celda> celdas) {
        for (Celda c : celdas) {
            agregarElemento(ELEMENTO.PIT, c);
        }
    }

    private boolean esCeldaEspecial(Celda c) {
        return (celdaHero != null && celdaHero.equals(c))
                || (celdaGold != null && celdaGold.equals(c))
                || (celdaWumpus != null && celdaWumpus.equals(c));
    }

    private boolean hayPit(int i, int j) {
        // gracias a equals/hashCode en Celda, funciona el contains
        return celdasPit.contains(new Celda(i, j));
    }

    private char simbolo(int i, int j) {
        if (celdaHero != null && celdaHero.i == i && celdaHero.j == j) {
            return 'H';
        }
        if (celdaGold != null && celdaGold.i == i && celdaGold.j == j) {
            return 'G';
        }
        if (celdaWumpus != null && celdaWumpus.i == i && celdaWumpus.j == j) {
            return 'W';
        }
        return hayPit(i, j) ? 'P' : '.';
    }

    public void print() {
        System.out.println("\n-----------------------------------------\n");

        // CSV "estricto"
        System.out.println("world," + filas + "," + columnas);
        if (celdaWumpus != null) {
            System.out.println("wumpus," + celdaWumpus.i + "," + celdaWumpus.j);
        }
        if (celdaGold != null) {
            System.out.println("gold," + celdaGold.i + "," + celdaGold.j);
        }
        if (celdaHero != null) {
            System.out.println("hero," + celdaHero.i + "," + celdaHero.j);
        }
        for (Celda c : celdasPit) {
            System.out.println("pit," + c.i + "," + c.j);
        }

        System.out.println("\n\n-----------------------------------------\n");

        printAscii();
    }

    private void printAscii() {
        StringBuilder sb = new StringBuilder();
        sb.append("\n=== Wumpus World ").append(filas).append("x").append(columnas).append(" ===\n");

        // Encabezado de columnas
        sb.append("    "); // margen para números de fila
        for (int j = 1; j <= columnas; j++) {
            sb.append(String.format(" %2d", j));
        }
        sb.append("\n");

        // Separador
        sb.append("   +");
        for (int j = 1; j <= columnas; j++) {
            sb.append("---");
        }
        sb.append("+\n");

        // Filas
        for (int i = 1; i <= filas; i++) {
            sb.append(String.format("%2d |", i));
            for (int j = 1; j <= columnas; j++) {
                sb.append(' ').append(simbolo(i, j)).append(' ');
            }
            sb.append("|\n");
        }

        // Separador inferior
        sb.append("   +");
        for (int j = 1; j <= columnas; j++) {
            sb.append("---");
        }
        sb.append("+\n");

        // Leyenda
        sb.append("Leyenda: H=Hero G=Gold W=Wumpus P=Pit .=Vacío\n");

        System.out.print(sb.toString());
    }

}

enum ELEMENTO {
    PIT, GOLD, WUMPUS, HERO
}

enum EXP_ARIT {
    IGUAL, MAYOR, MENOR, MAYOR_IGUAL, MENOR_IGUAL, DISTINTO
}
