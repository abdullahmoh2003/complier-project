%{
#include "globals.h"
#include "util.h"
#include "scan.h"

char tokenString[MAXTOKENLEN + 1];
%}

%%

"if"        { return IF; }
"then"      { return THEN; }
"else"      { return ELSE; }
"end"       { return END; }
"repeat"    { return REPEAT; }
"until"     { return UNTIL; }
"read"      { return READ; }
"write"     { return WRITE; }
":="        { return ASSIGN; }
"="         { return EQ; }
"<"         { return LT; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return OVER; }
"("         { return LPAREN; }
")"         { return RPAREN; }
";"         { return SEMI; }

[0-9]+      { return NUM; }
[a-zA-Z]+   { return ID; }
[\n]        { lineno++; }
[ \t\r]+    { /* ignore whitespace */ }

\{[^}]*\}   { lineno++; }     // comment
.           { return ERROR; }

%%

TokenType getToken(void) {
    static int firstTime = TRUE;
    TokenType currentToken;

    if (firstTime) {
        firstTime = FALSE;
        lineno++;
        yyin = fopen("tiny.txt", "r+");
        yyout = fopen("result.txt", "w+");
        listing = yyout;
    }

    currentToken = yylex();
    strncpy(tokenString, yytext, MAXTOKENLEN);
    fprintf(listing, "\t%d: ", lineno);
    printToken(currentToken, tokenString);
    return currentToken;
}

int main() {
    printf("welcome to the flex scanner :\n");
    while(getToken()) {
        printf("a new token has been detected...\n");
    }
    return 0;
}
