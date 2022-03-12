//import java_cup.runtime.*

%%

%public 
%line 
%column
%standalone
//%cup

%{
  StringBuilder string = new StringBuilder();    
%}

/* main character classes */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | 
          {DocumentationComment}

TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?

/* identifiers */
Identifier = [:jletter:][:jletterdigit:]*

/* integer  */
Integer = 0 | [1-9][0-9]*
    
/* Decimal */        

Decimal = {Integer} \. [0-9]* 


/* string */
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]


%state STRING, CHARLITERAL

%%

<YYINITIAL> {

    /* imports */
    "import"                    {}
    /* visibility */
    "private"                   {}
    "public"                    {}
    "protected"                 {}
    "final"                     {}

    "void"                         { return symbol(VOID); }
    "static"                       { return symbol(STATIC); }
    /* data types */
    "int"                       {}
    "boolean"                   {}
    "String"                    {}
    "char"                      {}
    "double"                    {}
    "Object"                    {} //Dudas}

    /* Control statements */
    "if"                        {}
    "else"                      {}
    "for"                       {}
    "do"                        {}
    "while"                     {}
    "switch"                    {}
 
    /* output statement */
    "break"                     {}
    "return"                    {}
    /* boolean literals */
    "true"                      { return symbol(sym.BOOLEAN_LITERAL); }
    "false"                     { return symbol(sym.BOOLEAN_LITERAL); }
  
    /* null literal */
    "null"                      { return symbol(sym.NULL_LITERAL); }
  
  
    /* grouping */
    "("                         { return symbol(sym.LPAREN); }
    ")"                         { return symbol(sym.RPAREN); }
    "{"                         { return symbol(sym.LBRACE); }
    "}"                         { return symbol(sym.RBRACE); }
    "["                         { return symbol(sym.LBRACK); }
    "]"                         { return symbol(sym.RBRACK); }
    /* separators */
    ";"                         { return symbol(sym.SEMICOLON); }
    ","                         { return symbol(sym.COMMA); }
    "."                         { return symbol(sym.DOT); }
    ":"                         { return symbol(sym.COLON); }
  
    /* operators */
    "="                         { return symbol(sym.EQ); }
    "+="                        { return symbol(sym.PLUSEQ); }
    "-="                        { return symbol(sym.MINUSEQ); }
    "*="                        { return symbol(sym.MULTEQ); }
    "/="                        { return symbol(sym.DIVEQ); }     
    "%="                        { return symbol(sym.MODEQ); }

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

  /* character literal */
  \'                             { yybegin(CHARLITERAL); }
  /* Numbers */     
  {Integer}                      { return symbol(sym.INTEGER_LITERAL, Integer.valueOf(yytext())); }
  {Decimal}                      { return symbol(sym.DOUBLE_LITERAL, new Double(yytext())); }
  /* comments */
  {Comment}                      { /* ignore */ }

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
    \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
    {LineTerminator}               { throw new RuntimeException("Unterminated string at end of line"); }
}

<CHARLITERAL> {
    {SingleCharacter}\'            { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, yytext().charAt(0)); }
    
    /* escape sequences */
    "\\b"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\b');}
    "\\t"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\t');}
    "\\n"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\n');}
    "\\f"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\f');}
    "\\r"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\r');}
    "\\\""\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\"');}
    "\\'"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\'');}
    "\\\\"\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, '\\'); }    
    
    /* error cases */
    \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
    {LineTerminator}               { throw new RuntimeException("Unterminated character literal at end of line"); }
}

/* error fallback */
[^]                              { throw new RuntimeException("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>                          { return symbol(sym.EOF); }