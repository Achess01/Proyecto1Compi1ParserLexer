package com.achess.server.lexer;
import com.achess.server.parser.sym;
import java_cup.runtime.*;
import com.achess.server.classAndMembers.JavaProject;

%%
%class JavaLexer
%public 
%line 
%column
//%standalone
%cup

%{
  private boolean firstProject;
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
%}

/* main character classes */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}           

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
    "import"                    {return symbol(sym.IMPORT);}
    /* visibility */
    "private"                   { return symbol(sym.PRIVATE);}
    "public"                    { return symbol(sym.PUBLIC);}
    "protected"                 { return symbol(sym.PROTECTED);}
    "final"                     { return symbol(sym.FINAL);}

    "void"                         { return symbol(sym.VOID); }
    "static"                       { return symbol(sym.STATIC); }
    /* data types */
    "int"                       { return symbol(sym.INT);}
    "boolean"                   { return symbol(sym.BOOLEAN);}
    "String"                    { return symbol(sym.STRING);}
    "char"                      { return symbol(sym.CHAR);}
    "double"                    { return symbol(sym.DOUBLE);}
    //"Object"                    { return symbol(sym.);} //Dudas}

    /* Control statements */
    "if"                        { return symbol(sym.IF);}
    "else"                      { return symbol(sym.ELSE);}
    "for"                       { return symbol(sym.FOR);}
    "do"                        { return symbol(sym.DO);}
    "while"                     { return symbol(sym.WHILE);}
    "switch"                    { return symbol(sym.SWITCH);}
    "case"                      { return symbol(sym.CASE); }
    "default"                   { return symbol(sym.DEFAULT); }
 
    /* output statement */
    "break"                     { return symbol(sym.BREAK);}
    "return"                    { return symbol(sym.RETURN);}
    /* boolean literals */
    "true"                      { return symbol(sym.BOOLEAN_LITERAL);}
    "false"                     { return symbol(sym.BOOLEAN_LITERAL);}
  
    /* null literal */
    "null"                      { return symbol(sym.NULL_LITERAL);}
    /* POO */
    "this"                      { return symbol(sym.THIS);}
    "super"                     { return symbol(sym.SUPER);}    
    "new"                       { return symbol(sym.NEW);}
    "class"                     { return symbol(sym.CLASS);}
  
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

  /* character literal */
  \'                             { yybegin(CHARLITERAL); }
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