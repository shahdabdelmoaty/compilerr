/******************************/
/* File: tiny.flex            */
/* Lex specification for TINY */
/******************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
#include "util.c"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+
comment     /*{number|letter|newline|whitespace}* */


/* This tells flex to read only one input file */
%option noyywrap

%%

"if"            {return IF;}
"return"        {return RESULT;}
"void"          {return VOID;}
"while"         {return WHILE;}
"int"           {return DATATYPE;}
"else"          {return ELSE;}
"=="            {return EQ;}
"="             {return ASSIGN;}
"<="            {return LE;}
"!="		     {return NE;}
">"             {return GT;}
"<"             {return LT;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"["		     {return OPENSSQUAREBRACKET;}
"]"		     {return CLOSESQUAREBRACKET;}
"{"		     {return OPENBRACKET;}
"}"		     {return CLOSEBRACKET;}
";"             {return SEMI;}
","		     {return COMMA;}

{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"{"             { char c;
                  do
                  { c = input();
                    if (c == EOF) break;
                    if (c == '\n') lineno++;
                  } while (c != '}');
                }
.               {return ERROR;}
"/*"    {
    /* Ignore characters until the end of the comment */
    int c;
    while ((c = input()) != '*' && c != EOF) {
        if (c == '\n') {
            lineno++;
        }
    }
    while ((c = input()) != '/' && c != EOF) {
        if (c == '\n') {
            lineno++;
        }
    }
}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = fopen("tiny.txt", "r+");
    yyout = fopen("result.txt","w+");
listing = yyout;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  
    fprintf(listing,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  
  return currentToken;
}

int main()
{
	printf("welcome to the flex scanner: ");
	while(getToken())
	{
		printf("a new token has been detected...\n");
	}
	return 1;
}


