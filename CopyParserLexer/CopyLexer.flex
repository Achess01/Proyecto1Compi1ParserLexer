%%
%class CopyLexer
%public 
%line 
%column
%standalone
//%cup

%{  
  StringBuilder string = new StringBuilder();    

  /*
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  } */
%}

/* main character classes */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment}

TraditionalComment = "</" [^*] ~"/>" | "</" "/"+ ">"
//EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?

/* identifiers */
Identifier = [:jletter:][:jletterdigit:]*
Text = [:jletterdigit:][:jletterdigit:]*

/* integer  */
Integer = 0 | [1-9][0-9]*
    
/* Decimal */        

//Decimal = {Integer} \. [0-9]* 


/* string */
StringCharacter = [^\r\n\"\\]

/* no case-sensitive */
a = [aA]
b = [bB]
//c = [cC]
d = [dD]
e = [eE]
f = [fF]
//g = [gG]
h = [hH]
i = [iI]
//j = [jJ]
//k = [kK]
l = [lL]
m = [mM]
//n = [nN]
o = [oO]
//p = [pP]
//q = [qQ]
r = [rR]
s = [sS]
t = [tT]
//u = [uU]
//v = [vV]
//w = [wW]
//x = [xX]
//y = [yY]
//z = [zZ]

Html = {h}{t}{m}{l}
H1 = {h} "1"
H2 = {h} "2"
Table = {t}{a}{b}{l}{e}
For = {f}{o}{r}
Iterador = {i}{t}{e}{r}{a}{d}{o}{r}
Hasta = {h}{a}{s}{t}{a}
Tr = {t}{r}
Th = {t}{h}
Td = {t}{d}
Br = {b}{r}


%state STRING

%%

<YYINITIAL> {

    {Html}
    {System.out.println("HTML") /* System.out.println("HTML") /* return symbol(sym.HTML) */; }
    {H1}
    {System.out.println("H1") /* return symbol(sym.H1) */;}
    {H2}
    {System.out.println("H2") /* return symbol(sym.H2) */;}
    {Table}
    {System.out.println("TABLE") /* return symbol(sym.TABLE) */;}
    {For}
    {System.out.println("FOR") /* return symbol(sym.FOR) */;}
    {Iterador}
    {System.out.println("ITERADOR") /* return symbol(sym.ITERADOR) */;}
    {Hasta}
    {System.out.println("HASTA") /* return symbol(sym.HASTA) */;}    
    {Tr}
    {System.out.println("TR") /* return symbol(sym.TR) */;}
    {Th}
    {System.out.println("TH") /* return symbol(sym.TH) */;}
    {Td}
    {System.out.println("TD") /* return symbol(sym.TD) */;}
    {Br}
    {System.out.println("BR") /* return symbol(sym.BR) */;}

    "String"                    { System.out.println("STRING") /* return symbol(sym.STRING) */; }
    "Integer"                   { System.out.println("INTEGER") /* return symbol(sym.INTEGER) */; }
    "RESULT"                    { System.out.println("RESULT") /* return symbol(sym.RESULT) */; }
    "Score"                     { System.out.println("SCORE") /* return symbol(sym.SCORE) */; }
    "Clases"                    { System.out.println("CLASES") /* return symbol(sym.CLASES) */; }
    "Metodos"                   { System.out.println("METODOS") /* return symbol(sym.METODOS) */; }
    "Variables"                 { System.out.println("VARIABLES") /* return symbol(sym.VARIABLES) */; }
    "Comentarios"               { System.out.println("COMENTARIOS") /* return symbol(sym.COMENTARIOS) */; }
    "Nombre"                    { System.out.println("NOMBRE") /* return symbol(sym.NOMBRE) */; }
    "Tipo"                      { System.out.println("TIPO") /* return symbol(sym.TIPO) */; }
    "Funcion"                   { System.out.println("FUNCION") /* return symbol(sym.FUNCION) */; }
    "Parametros"                { System.out.println("PARAMETROS") /* return symbol(sym.PARAMETROS) */; }
    "Texto"                     { System.out.println("TEXTO_COMENTARIO") /* return symbol(sym.TEXTO_COMENTARIO) */; }
    
    /* grouping */
    "("                         { System.out.println("LPAREN") /* return symbol(sym.LPAREN) */; }
    ")"                         { System.out.println("RPAREN") /* return symbol(sym.RPAREN) */; }
    "["                         { System.out.println("LBRACKET") /* return symbol(sym.LBRACKET) */; }
    "]"                         { System.out.println("RBRACKET") /* return symbol(sym.RBRACKET) */; }    
    /* separators */
    ";"                         { System.out.println("SEMICOLON") /* return symbol(sym.SEMICOLON) */; }
    ","                         { System.out.println("COMMA") /* return symbol(sym.COMMA) */; }
    "."                         { System.out.println("DOT") /* return symbol(sym.DOT) */; }
    ":"                         { System.out.println("COLON") /* return symbol(sym.COLON) */; }
  
    /* operators */
    "="                         { System.out.println("EQ") /* return symbol(sym.EQ) */;}    
            
    "+"                         { System.out.println("PLUS") /* return symbol(sym.PLUS) */; }
    "-"                         { System.out.println("MINUS") /* return symbol(sym.MINUS) */; }
    "*"                         { System.out.println("MULT") /* return symbol(sym.MULT) */; }
    "/"                         { System.out.println("DIV") /* return symbol(sym.DIV) */; }        

    "$$"                        { System.out.println("DPESOS") /* return symbol(sym.DPESOS) */; }
    ">"                         { System.out.println("GT") /* return symbol(sym.GT) */; }
    "<"                         { System.out.println("LT") /* return symbol(sym.LT) */; }
        
  
  /* string literal */
  \"                         { yybegin(STRING); string.setLength(0); }
  
  /* Numbers */     
  {Integer}                      { System.out.println("INTEGER_LITERAL: " + Integer.valueOf(yytext())) /* return symbol(sym.INTEGER_LITERAL, Integer.valueOf(yytext())) */; }
  //{Decimal}                      { return symbol(sym.FLOATING_POINT_LITERAL, new Double(yytext())); }
  /* comments */
  {Comment}                      { /* Ignorar */ System.out.println("Comentario: " + yytext());}

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  /* identifiers */ 
  {Identifier}                   { System.out.println("IDENTIFIER " + yytext()) /* return symbol(sym.IDENTIFIER, yytext()) */; }  
  {Text}                   { System.out.println("TEXT " + yytext()) /* return symbol(sym.TEXT, yytext()) */; }  
}

<STRING> {
    \"                             { yybegin(YYINITIAL); System.out.println("STRING_LITERAL :"  +string.toString()) /* return symbol(sym.STRING_LITERAL, string.toString()) */; }
    
    {StringCharacter}+             { string.append( yytext() ); }
    
    /* escape sequences */
    "\\b"                          { string.append( '\b' ); }
    "\\t"                          { string.append( '\t' ); }
    "\\n"                          { string.append( '\n' ); }
    "\\f"                          { string.append( '\f' ); }
    "\\r"                          { string.append( '\r' ); }
    "\\\""                         { string.append( '\"' ); }
    "\\'"                          { string.append( '\'' ); }
    "\\\\"                         { string.append( '\\' ); }    
    
    /* error cases */
    \\.                            { System.out.println("Illegal escape sequence \""+yytext()+"\""); }
    {LineTerminator}               { System.out.println("Unterminated string at end of line"); }
}

/* error fallback */
[^]                              { System.out.println("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
//<<EOF>>                          { System.out.println("EOF") /* return symbol(sym.EOF) */; }