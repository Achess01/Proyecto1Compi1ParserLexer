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
 
    /* boolean literals */
    "true"                      { return symbol(BOOLEAN_LITERAL, true); }
    "false"                     { return symbol(BOOLEAN_LITERAL, false); }
  
    /* null literal */
    "null"                      { return symbol(NULL_LITERAL); }
  
  
    /* grouping */
    "("                         { return symbol(LPAREN); }
    ")"                         { return symbol(RPAREN); }
    "{"                         { return symbol(LBRACE); }
    "}"                         { return symbol(RBRACE); }
    "["                         { return symbol(LBRACK); }
    "]"                         { return symbol(RBRACK); }
    /* separators */
    ";"                         { return symbol(SEMICOLON); }
    ","                         { return symbol(COMMA); }
    "."                         { return symbol(DOT); }
  
    /* operators */
    "="                         { return symbol(EQ); }
    ">"                         { return symbol(GT); }
    "<"                         { return symbol(LT); }
    "!"                         { return symbol(NOT); }        
    ":"                         { return symbol(COLON); }
    "=="                        { return symbol(EQEQ); }
    "<="                        { return symbol(LTEQ); }
    ">="                        { return symbol(GTEQ); }
    "!="                        { return symbol(NOTEQ); }
    "&&"                        { return symbol(ANDAND); }
    "||"                        { return symbol(OROR); }
    "++"                        { return symbol(PLUSPLUS); }
    "--"                        { return symbol(MINUSMINUS); }
    "+"                         { return symbol(PLUS); }
    "-"                         { return symbol(MINUS); }
    "*"                         { return symbol(MULT); }
    "/"                         { return symbol(DIV); }            
    "+="                        { return symbol(PLUSEQ); }
    "-="                        { return symbol(MINUSEQ); }
    "*="                        { return symbol(MULTEQ); }
    "/="                        { return symbol(DIVEQ); }                
  
  /* string literal */
  \"                             { yybegin(STRING); string.setLength(0); }
       
  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  /* identifiers */ 
  {Identifier}                   { return symbol(IDENTIFIER, yytext()); }  
}