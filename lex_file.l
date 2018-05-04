%{
#include<stdio.h>
#include "y.tab.h"

%}


letter [A-Za-z]
digit [0-9]
%%

if   return IF;
then return THEN;
else return ELSE;
while return WHILE;
[+]     {return '+';}
[-]     {return '-';}
[*]     {return '*';}
[/]     {return '/';}
"=="  {yylval.strval=strdup(yytext);return RELOP;}
[=]     {return '=';}

[" "]+  {}
">"  {yylval.strval=strdup(yytext); return RELOP;}
"<"  {yylval.strval=strdup(yytext); return RELOP;}
">=" {yylval.strval=strdup(yytext); return RELOP;}
"<=" {yylval.strval=strdup(yytext); return RELOP;}
"!=" {yylval.strval=strdup(yytext); return RELOP;}

{letter}({letter}|{digit})* {yylval.strval=strdup(yytext);return id;}
[0-9]+  {yylval.strval=strdup(yytext);return num;}

[\n]    {return 0;}
.   {return yytext[0];}


%%

