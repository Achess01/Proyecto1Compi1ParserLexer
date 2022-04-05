%%
%class CopyLexer
%public 
%line 
%column
%standalone
//%cup

/* %{  
  StringBuilder string = new StringBuilder();    

  public void setFirstProject(boolean firstProject){
    this.firstProject = firstProject;    
  }

  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }
%} */

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

/* integer  */
Integer = 0 | [1-9][0-9]*
    
/* Decimal */        

//Decimal = {Integer} \. [0-9]* 


/* string */
StringCharacter = [^\r\n\"\\]

/* no case-sensitive */
a = [aA]
b = [bB]
c = [cC]
d = [dD]
e = [eE]
f = [fF]
g = [gG]
h = [hH]
i = [iI]
j = [jJ]
k = [kK]
l = [lL]
m = [mM]
n = [nN]
o = [oO]
p = [pP]
q = [qQ]
r = [rR]
s = [sS]
t = [tT]
u = [uU]
v = [vV]
w = [wW]
x = [xX]
y = [yY]
z = [zZ]

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


%state STRING, CHARLITERAL

%%

<YYINITIAL> {

    {html}
    {return symbol(sym.HTML)}
    {h1}
    {return symbol(sym.H1)}
    "h2"
    {return symbol(sym.)}
    
    /* grouping */
    "("                         { return symbol(sym.LPAREN); }
    ")"                         { return symbol(sym.RPAREN); }
    "{"                         { return symbol(sym.LBRACE); }
    "}"                         { return symbol(sym.RBRACE); }    
    /* separators */
    ";"                         { return symbol(sym.SEMICOLON); }
    ","                         { return symbol(sym.COMMA); }
    "."                         { return symbol(sym.DOT); }
    ":"                         { return symbol(sym.COLON); }
  
    /* operators */
    "="                         { return symbol(sym.EQ);}
    "+="                        { return symbol(sym.PLUSEQ);}
    "-="                        { return symbol(sym.MINUSEQ);}
    "*="                        { return symbol(sym.MULTEQ);}
    "/="                        { return symbol(sym.DIVEQ);}     
    "%="                        { return symbol(sym.MODEQ);}
    "%"                         { return symbol(sym.MOD);}

    ">"                         { return symbol(sym.GT); }
    "<"                         { return symbol(sym.LT); }
    "=="                        { return symbol(sym.EQEQ); }
    "!="                        { return symbol(sym.NOTEQ); }
    "<="                        { return symbol(sym.LTEQ); }
    ">="                        { return symbol(sym.GTEQ); }

    "&&"                        { return symbol(sym.ANDAND); }
    "||"                        { return symbol(sym.OROR); }
    "!"                         { return symbol(sym.NOT); }            
    "&"                         { return symbol(sym.AND); }
    "|"                         { return symbol(sym.OR); }

    "++"                        { return symbol(sym.PLUSPLUS); }
    "--"                        { return symbol(sym.MINUSMINUS); }

    "+"                         { return symbol(sym.PLUS); }
    "-"                         { return symbol(sym.MINUS); }
    "*"                         { return symbol(sym.MULT); }
    "/"                         { return symbol(sym.DIV); }            
  
  /* string literal */
  \"                             { yybegin(STRING); string.setLength(0); }
  
  /* Numbers */     
  {Integer}                      { return symbol(sym.INTEGER_LITERAL, Integer.valueOf(yytext())); }
  {Decimal}                      { return symbol(sym.FLOATING_POINT_LITERAL, new Double(yytext())); }
  /* comments */
  {Comment}                      { JavaProject.getProject(firstProject).addComment(yytext()); }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  /* identifiers */ 
  {Identifier}                   { return symbol(sym.IDENTIFIER, yytext()); }  
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
    \\.                            { JavaError.getError().log("Illegal escape sequence \""+yytext()+"\""); }
    {LineTerminator}               { JavaError.getError().log("Unterminated string at end of line"); }
}

/* error fallback */
[^]                              { JavaError.getError().log("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>                          { return symbol(sym.EOF); }