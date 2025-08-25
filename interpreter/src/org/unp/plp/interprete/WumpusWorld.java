package org.unp.plp.interprete;

import java.util.ArrayList;
import java.util.List; // G(old)

public class WumpusWorld {

    private int filas;
    private int columnas;
    private Celda celdaHero;
    private Celda celdaGold;
    private Celda celdaWumpus;
    private List<Celda> celdasPit;

    public static WumpusWorld crear(int filas, int columnas) {
        System.out.println("Esto esta dentro de WumpusWorld " + filas + " " + columnas);

        return new WumpusWorld(filas, columnas);
    }

    public WumpusWorld(int filas, int columnas) {
        this.filas = filas;
        this.columnas = columnas;
        celdasPit = new ArrayList<>();
    }

    void agregarElemento(ELEMENTO elem, Celda celda) {

        if (elem == ELEMENTO.HERO) {
            System.out.println("Agregando al heroe en la celda " + celda.i + ", " + celda.j);
            this.celdaHero = celda;
        }

        if (elem == ELEMENTO.GOLD) {
            System.out.println("Agregando el oro en la celda " + celda.i + ", " + celda.j);
            this.celdaGold = celda;
        }

        if (elem == ELEMENTO.WUMPUS) {
            System.out.println("Agregando al Wumpus en la celda " + celda.i + ", " + celda.j);
            this.celdaWumpus = celda;
        }

        if (elem == ELEMENTO.PIT) {
            System.out.println("Agregando un pozo en la celda " + celda.i + ", " + celda.j);
            this.celdasPit.add(celda);
        }

    }

    void removerElemento(ELEMENTO elem, Celda celda) {
    }

    void print() {
        System.out.println("El mundillo");
    }
}

enum ELEMENTO { PIT, GOLD, WUMPUS, HERO }

class Celda {

    public Celda(int i, int j) {
        this.i = i;
        this.j = j;
    }

    public int i;
    public int j;
}
