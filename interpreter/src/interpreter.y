// fuente byaccj para una calculadora sencilla


%{
  import java.io.*;
  import java.util.List;
  import java.util.ArrayList;
  import java.util.Set; 
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
%token MAYOR
%token MENOR
%token MAYOR_IGUAL
%token MENOR_IGUAL
%token PRINT
%token REM
%%

program
  : world_stmt statement_list print_stmt
  ;

print_stmt
  : PRINT WORLD NL { world.print(); }
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
  | rem_stmt
  | NL
  ;

put_stmt 
  : PUT elem IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA NL {  world.agregarElemento( (ELEMENTO)$2 , new Celda((int)$5,(int)$7));  }
  | PUT PIT IN CORCHETE_ABRE cond_list CORCHETE_CIERRA NL { world.agregarPits( (Set<Celda>) $5 ); } 
  | PUT PIT IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA NL { world.agregarElemento( ELEMENTO.PIT, new Celda((int)$5,(int)$7));  } 
  ;

rem_stmt
  : REM elem IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA NL {  world.removerElemento( (ELEMENTO)$2 , new Celda((int)$5,(int)$7));  }
  | REM PIT IN CORCHETE_ABRE cond_list CORCHETE_CIERRA NL { world.removerPits( (Set<Celda>) $5 ); }
  | REM PIT IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA NL { world.removerElemento(ELEMENTO.PIT, new Celda((int)$5,(int)$7)); }
  ;

elem 
  : HERO { $$ = ELEMENTO.HERO; }
  | GOLD { $$ = ELEMENTO.GOLD; }
  | PIT { $$ = ELEMENTO.PIT; }
  | WUMPUS { $$ = ELEMENTO.WUMPUS; }
  ;

cond_list
  : cond                     { $$ = $1; }
  | cond COMA cond_list      { $$ = world.intersect( (Set<Celda>)$1, (Set<Celda>)$3 ); }
  ;

cond
  : exp exp_arit exp         { $$ = world.evaluarExpresion( (Expr)$1, (EXP_ARIT)$2, (Expr)$3 ); }
  ;

exp_arit 
  : IGUAL { $$ = EXP_ARIT.IGUAL; }
  | MAYOR { $$ = EXP_ARIT.MAYOR; }
  | MENOR { $$ = EXP_ARIT.MENOR; }
  | MAYOR_IGUAL { $$ = EXP_ARIT.MAYOR_IGUAL; }
  | MENOR_IGUAL { $$ = EXP_ARIT.MENOR_IGUAL; }
  | DISTINTO { $$ = EXP_ARIT.DISTINTO; }
  ;

exp
  : exp  op_princ term   { $$ = ((BinOp)$2).apply((Expr)$1, (Expr)$3); }
  | term                 { $$ = $1; }
  ;

term
  : term op_sec   factor { $$ = ((BinOp)$2).apply((Expr)$1, (Expr)$3); }
  | factor               { $$ = $1; }
  ;

factor 
  : CONSTANT            { $$ = new Const( ((Integer)$1).intValue() ); }
  | coord               { $$ = $1; }
  ;

coord
  : I { $$ = new VarI(); }
  | J { $$ = new VarJ(); }
  ;

op_princ  
  : MAS           { $$ = new AddOp(); }
  | MENOS         { $$ = new SubOp(); }
  ;

op_sec
  : MULTIPLICADO  { $$ = new MulOp(); }
  | DIVIDIDO      { $$ = new DivOp(); }
  ;


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
