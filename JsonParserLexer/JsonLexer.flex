package com.achess.client.jsonParserLexer;
import java_cup.runtime.Symbol;
%%
%class JsonLexer
%public 
%line 
%column
//%standalone
//%int
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
//InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/* integer  */
Integer = 0 | [1-9][0-9]*
    
/* Decimal */        

//Decimal = {Integer} \. [0-9]* 

//Number = {Integer} | {Decimal}


/* string */
StringCharacter = [^\r\n\"\\]

%state STRING

%%

<YYINITIAL> {   
    "{"                         { return symbol(sym.LBRACE);  }
    "}"                         { return symbol(sym.RBRACE);  }
    "["                         { return symbol(sym.LBRACKET);  }
    "]"                         { return symbol(sym.RBRACKET);  }
    /* separators */    
    ","                         { return symbol(sym.COMMA);  }    
    ":"                         { return symbol(sym.COLON);  }
    // Reserved literals
    "\"Clases\""                { return symbol(sym.CLASSES_LITERAL); }
    "\"Variables\""             { return symbol(sym.VARIABLES_LITERAL); }
    "\"Metodos\""               { return symbol(sym.METHODS_LITERAL); }
    "\"Comentarios\""           { return symbol(sym.COMMENTS_LITERAL); }
    "\"Score\""                 { return symbol(sym.SCORE_LITERAL); }
    "\"Nombre\""                { return symbol(sym.NAME_LITERAL); }
    "\"Funcion\""               { return symbol(sym.FUNCTION_LITERAL); }
    "\"Parametros\""            { return symbol(sym.PARAMETERS_LITERAL); }
    "\"Tipo\""                  { return symbol(sym.TYPE_LITERAL); }
    "\"Texto\""                 { return symbol(sym.TEXT_LITERAL); }    
  /* string literal */
  \"                             { yybegin(STRING); string.setLength(0); }
  
  /* Numbers */     
  {Integer}                      { return symbol(sym.INTEGER_LITERAL, Integer.valueOf(yytext()));  }
  //{Decimal}                      { return symbol(sym.FLOATING_POINT_LITERAL, new Double(yytext()));  }
  
  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
    
}

<STRING> {
    \"                             { yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString());  }    
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
<<EOF>>                          { return symbol(sym.EOF);  }