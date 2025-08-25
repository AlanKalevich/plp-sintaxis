// fuente byaccj para una calculadora sencilla


%{
  import java.io.*;
  import java.util.List;
  import java.util.ArrayList;
%}


// lista de tokens por orden de prioridad

%token NL         // nueva línea
%token CONSTANT   // constante
%token WORLD   // world palabra reservda
%token EQUIS   // equis palabra reservda
%token PUT
%token HERO
%token IN
%token PARENTESIS_ABRE
%token COMA
%token PARENTESIS_CIERRA
%token CORCHETE_ABRE
%token CORCHETE_CIERRA
%token IGUAL
%token GOLD
%token PIT
%token WUMPUS
%token I
%token J
%token MAS
%token MENOS
%token MULTIPLICADO
%token DIVIDIDO
%token DISTINTO
%%

program
  : world_stmt statement_list
  |
  ;

statement_list
  : statement                // Unica sentencia
  | statement statement_list // Sentencia,y lista
  ;

world_stmt
  : WORLD CONSTANT EQUIS CONSTANT NL {  world = WumpusWorld.crear((int)$2,(int)$4);  }
  ;

statement
  : put_stmt 
  | NL
  ;

put_stmt 
  : PUT elem IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA NL {  world.agregarElemento( (ELEMENTO)$2 , new Celda((int)$5,(int)$7));  }
  | PUT PIT IN CORCHETE_ABRE cond_list CORCHETE_CIERRA NL {}
  | PUT PIT IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA NL {}
  ;

elem 
  : HERO { $$ = ELEMENTO.HERO; }
  | GOLD { $$ = ELEMENTO.GOLD; }
  | PIT { $$ = ELEMENTO.PIT; }
  | WUMPUS { $$ = ELEMENTO.WUMPUS; }
  ;
  
cond_list
  : cond
  | cond COMA cond_list
  ;

cond
  : exp exp_arit exp
  ;

exp_arit : IGUAL | MAYOR | MENOR | MAYOR_IGUAL | MENOR_IGUAL | DISTINTO;

coord : I | J;

exp 
  : exp op_princ term
  | term
  ;

term 
  : term op_sec factor
  | factor
  ;

factor 
  : CONSTANT
  | coord
  ;


op_princ  : MAS           |   MENOS;
op_sec    : MULTIPLICADO  |   DIVIDIDO;

%%

  /** referencia al analizador léxico
  **/
  private Lexer lexer ;

  private WumpusWorld world;

  /** constructor: crea el Interpreteranalizador léxico (lexer)
  **/
  public Parser(Reader r)
  {
     lexer = new Lexer(r, this);
    // world = new WumpusWorld();
  }

  /** esta función se invoca por el analizador cuando necesita el
  *** siguiente token del analizador léxico
  **/
  private int yylex ()
  {
    int yyl_return = -1;

    try
    {
       yylval = new Object();
       yyl_return = lexer.yylex();
    }
    catch (IOException e)
    {
       System.err.println("error de E/S:"+e);
    }

    return yyl_return;
  }

  /** invocada cuando se produce un error
  **/
  public void yyerror (String descripcion, int yystate, int token)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     System.err.println ("Token leído : "+yyname[token]);
  }

  public void yyerror (String descripcion)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     //System.err.println ("Token leido : "+yyname[token]);
  }
