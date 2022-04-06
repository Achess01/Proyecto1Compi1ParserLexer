package com.achess.client.copyParserLexer;
import java_cup.runtime.Symbol;
import com.achess.client.error.ClientError;
%%
%class CopyLexer
%public 
%line 
%column
//%standalone
%cup

%{  
  StringBuilder string = new StringBuilder();    
  
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }
%}

/* main character classes */
LineTerminator = \r|\n|\r\n

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

Html_open = "<"{h}{t}{m}{l}
H1_open = "<"{h}"1"
H2_open = "<"{h}"2"
Table_open = "<"{t}{a}{b}{l}{e}
For_open = "<"{f}{o}{r}
Tr_open = "<"{t}{r}
Th_open = "<"{t}{h}
Td_open = "<"{t}{d}
Br_open = "<"{b}{r}
Iterador = {i}{t}{e}{r}{a}{d}{o}{r}
Hasta = {h}{a}{s}{t}{a}


Html_close = "</"{h}{t}{m}{l}
H1_close = "</"{h}"1"
H2_close = "</"{h}"2"
Table_close = "</"{t}{a}{b}{l}{e}
For_close = "</"{f}{o}{r}
Tr_close = "</"{t}{r}
Th_close = "</"{t}{h}
Td_close = "</"{t}{d}


%state STRING

%%

<YYINITIAL> {

    {Html_open}
    {return symbol(sym.HTML_OPEN); }
    {H1_open}
    {return symbol(sym.H1_OPEN);}
    {H2_open}
    {return symbol(sym.H2_OPEN);}
    {Table_open}
    {return symbol(sym.TABLE_OPEN);}
    {For_open}
    {return symbol(sym.FOR_OPEN);}
    {Tr_open}
    {return symbol(sym.TR_OPEN);}
    {Th_open}
    {return symbol(sym.TH_OPEN);}
    {Td_open}
    {return symbol(sym.TD_OPEN);}
    {Br_open}
    {return symbol(sym.BR_OPEN);}

    {Html_close}
    {return symbol(sym.HTML_CLOSE); }
    {H1_close}
    {return symbol(sym.H1_CLOSE);}
    {H2_close}
    {return symbol(sym.H2_CLOSE);}
    {Table_close}
    {return symbol(sym.TABLE_CLOSE);}
    {For_close}
    {return symbol(sym.FOR_CLOSE);}
    {Tr_close}
    {return symbol(sym.TR_CLOSE);}
    {Th_close}
    {return symbol(sym.TH_CLOSE);}
    {Td_close}
    {return symbol(sym.TD_CLOSE);}    

    {Iterador}
    {return symbol(sym.ITERADOR);}
    {Hasta}
    {return symbol(sym.HASTA);}    

    "String"                    { return symbol(sym.STRING); }
    "Integer"                   { return symbol(sym.INTEGER); }
    "RESULT"                    { return symbol(sym.RESULT); }
    "Score"                     { return symbol(sym.SCORE, yytext()); }
    "Clases"                    { return symbol(sym.CLASES, yytext()); }
    "Metodos"                   { return symbol(sym.METODOS, yytext()); }
    "Variables"                 { return symbol(sym.VARIABLES, yytext()); }
    "Comentarios"               { return symbol(sym.COMENTARIOS, yytext()); }
    "Nombre"                    { return symbol(sym.NOMBRE, yytext()); }
    "Tipo"                      { return symbol(sym.TIPO, yytext()); }
    "Funcion"                   { return symbol(sym.FUNCION, yytext()); }
    "Parametros"                { return symbol(sym.PARAMETROS, yytext()); }
    "Texto"                     { return symbol(sym.TEXTO_COMENTARIO, yytext()); }
    
    /* grouping */
    "("                         { return symbol(sym.LPAREN); }
    ")"                         { return symbol(sym.RPAREN); }
    "["                         { return symbol(sym.LBRACKET); }
    "]"                         { return symbol(sym.RBRACKET); }    
    /* separators */
    ";"                         { return symbol(sym.SEMICOLON); }
    ","                         { return symbol(sym.COMMA); }
    "."                         { return symbol(sym.DOT); }
    ":"                         { return symbol(sym.COLON); }
  
    /* operators */
    "="                         { return symbol(sym.EQ);}    
            
    "+"                         { return symbol(sym.PLUS); }
    "-"                         { return symbol(sym.MINUS); }
    "*"                         { return symbol(sym.MULT); }
    "/"                         { return symbol(sym.DIV); }        

    "$$"                        { return symbol(sym.DPESOS); }
    ">"                         { return symbol(sym.GT); }
    //"<"                         { return symbol(sym.LT); }
        
  
  /* string literal */
  \"                         { yybegin(STRING); string.setLength(0); }
  
  /* Numbers */     
  {Integer}                      { return symbol(sym.INTEGER_LITERAL, Integer.valueOf(yytext())); }
  //{Decimal}                      { return symbol(sym.FLOATING_POINT_LITERAL, new Double(yytext())); }
  /* comments */
  {Comment}                      { /* Ignorar */}

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  /* identifiers */ 
  {Identifier}                   { return symbol(sym.IDENTIFIER, yytext()); }  
  {Text}                         { return symbol(sym.TEXT, yytext()); }  
}

<STRING> {
    \"                             { yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString()); }
    
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
    \\.                            { ClientError.getError().log("Illegal escape sequence \""+yytext()+"\""); }
    {LineTerminator}               { ClientError.getError().log("Unterminated string at end of line"); }
}

/* error fallback */
[^]                              { ClientError.getError().log("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>                          { return symbol(sym.EOF); }