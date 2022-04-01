
%%
%class JsonLexer
%public 
%line 
%column
%standalone
%int
//%cup

%{ 
  StringBuilder string = new StringBuilder();    

  /* private Symbol symbol(int type) {
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

/* integer  */
Integer = 0 | [1-9][0-9]*
    
/* Decimal */        

Decimal = {Integer} \. [0-9]* 

Number = {Integer} | {Decimal}


/* string */
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]


%state STRING

%%

<YYINITIAL> {   
    "{"                         { System.out.println(yytext()); /* return symbol(sym.LBRACE); */ }
    "}"                         { System.out.println(yytext()); /* return symbol(sym.RBRACE); */ }
    "["                         { System.out.println(yytext()); /* return symbol(sym.LBRACKET); */ }
    "]"                         { System.out.println(yytext()); /* return symbol(sym.RBRACKET); */ }
    /* separators */    
    ","                         { System.out.println(yytext()); /* return symbol(sym.COMMA); */ }    
    ":"                         { System.out.println(yytext()); /* return symbol(sym.COLON); */ }
    // Reserved literals
    "\"Clases\""                { System.out.println(yytext()); /* return symbol(sym.CLASSES_LITERAL); */}
    "\"Variables\""             { System.out.println(yytext()); /* return symbol(sym.VARIABLES_LITERAL); */}
    "\"Metodos\""               { System.out.println(yytext()); /* return symbol(sym.METHODS_LITERAL); */}
    "\"Comentarios\""           { System.out.println(yytext()); /* return symbol(sym.COMMENTS_LITERAL); */}
    "\"Score\""                 { System.out.println(yytext()); /* return symbol(sym.SCORE_LITERAL); */}
    "\"Nombre\""                { System.out.println(yytext()); /* return symbol(sym.NAME_LITERAL); */}
    "\"Funcion\""               { System.out.println(yytext()); /* return symbol(sym.FUNCTION_LITERAL); */}
    "\"Parametros\""            { System.out.println(yytext()); /* return symbol(sym.PARAMETERS_LITERAL); */}
    "\"Tipo\""                  { System.out.println(yytext()); /* return symbol(sym.TYPE_LITERAL); */}
    "\"Texto\""                 { System.out.println(yytext()); /* return symbol(sym.TEXT_LITERAL); */}    
  /* string literal */
  \"                             { yybegin(STRING); string.setLength(0); }
  
  /* Numbers */     
  {Integer}                      { System.out.println(yytext()); /* return symbol(sym.INTEGER_LITERAL, Integer.valueOf(yytext())); */ }
  //{Decimal}                      { System.out.println(yytext()); /* return symbol(sym.FLOATING_POINT_LITERAL, new Double(yytext())); */ }
  
  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
    
}

<STRING> {
    \"                             { yybegin(YYINITIAL); System.out.println(string.toString()); /* return symbol(sym.STRING_LITERAL, string.toString()); */ }    
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
//<<EOF>>                          { System.out.println("fin"); /* return symbol(sym.EOF); */ }