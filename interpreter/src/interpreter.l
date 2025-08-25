// fuente 'jflex' para interprete

package org.unp.plp.interprete;

%%

%class Lexer
%byaccj

%{

  private Parser yyparser;

  /** constructor del analizador sintáctico
  *** acepta como parámetro el lector de caracteres a usar
  **/

  public Lexer(java.io.Reader r, Parser p )
  {
    this(r);
    yyparser = p  ;
  }

  /** devuelve el numero de linea donde está el último caracter leido
  **/

  public int lineaActual()
  {
     return yyline;
  }

%}

%%
world
  {
    return Parser.WORLD;
  }

x
  {
    return Parser.EQUIS;
  }

put
  {
    return Parser.PUT;
  }

hero
  {
    return Parser.HERO;
  }

pit
  {
    return Parser.PIT;
  }

wumpus
  {
    return Parser.WUMPUS;
  }

gold
  {
    return Parser.GOLD;
  }

in
  {
    return Parser.IN;
  }

\(
  {
    return Parser.PARENTESIS_ABRE;
  }

\)
  {
    return Parser.PARENTESIS_CIERRA;
  }

\,
  {
    return Parser.COMA;
  }

i
  {
    return Parser.I;
  }

j
  {
    return Parser.J;
  }

\[
  {
    return Parser.CORCHETE_ABRE;
  }

\]
  {
    return Parser.CORCHETE_CIERRA;
  }

\+
  {
    return Parser.MAS;
  }

\-
  {
    return Parser.MENOS;
  }

\*
  {
    return Parser.MULTIPLICADO;
  }

\/
  {
    return Parser.DIVIDIDO;
  }

=
  {
    return Parser.IGUAL;
  }

\>
  {
    return Parser.MAYOR;
  }

\<
  {
    return Parser.MENOR;
  }

\>=
  {
    return Parser.MAYOR_IGUAL;
  }

\<=
  {
    return Parser.MENOR_IGUAL;
  }

\!=
  {
    return Parser.DISTINTO;
  }

[0-9]+
   {  yyparser.yylval = new Integer(yytext());
      return Parser.CONSTANT;
   }

\r|\n|\r\n
  { // lleva la cuenta de lineas
    yyline++ ;
    return Parser.NL;
  }

[ \t]+ {  /** accion vacia: se ignoran los espacios y tabuladores **/
       }

.      {  /** token desconocido: se produce un mensaje de error **/
          yyparser.yyerror("El lexema '"+yytext()+"' no corresponden a ningún token conocido");
       }
