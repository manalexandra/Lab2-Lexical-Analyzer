/*** Definition Section ***/
%{
#include <string.h>

typedef struct {
    char token[257];
    int symbolTableCode;
}PIF;

typedef struct{
    char token[257];
    int index;
}ST;

ST SymbolTable[100];
int stLength = 0;

PIF ProgramInternalForm[300];
int pifLength = 0;

int errorFound = 0;
int lineNumber = 1;


int addToST(char* token) {
	for(int i = 0; i < stLength; i++) {
		
		if(strcmp(SymbolTable[i].token, token) == 0) {
		  return SymbolTable[i].index;
		}
	}
	strcpy(SymbolTable[stLength].token, token);
	SymbolTable[stLength].index = stLength;
	stLength++;
	
	return stLength - 1;
}

void addToPIF(char* token, int stCode) {
	strcpy(ProgramInternalForm[pifLength].token, token);
	ProgramInternalForm[pifLength].symbolTableCode = stCode;
	
	pifLength++;
}

void showSymbolTable() {
    printf("~~~~~~~ Symbol table ~~~~~~~\n");
    
    for(int i = 0 ; i < stLength; i++) {
        printf(" %s  %d", SymbolTable[i].token, SymbolTable[i].index);
        printf("\n");
    }
    
    printf("~~~~~~~ End ST ~~~~~~~\n");
    printf("\n");
}

void showProgramInternalForm() {
    printf("~~~~~~~ Program internal form ~~~~~~~\n");
    
    for(int i = 0; i < pifLength; i++) {
    
        printf(" %s  %d ", ProgramInternalForm[i].token, ProgramInternalForm[i].symbolTableCode);
        printf("\n");
    }
    
    printf("~~~~~~~ End PIF ~~~~~~~\n");
    printf("\n");
}

%}


constant  [+-]?(0|[1-9][0-9]*)(\.[0-9]+)?
identifier   [a-z][a-z0-9_]*

/*** Rule Section ***/
%%
					/* yytext is the text in the buffer */
number                                  { addToPIF(yytext, -1); }
letter					{ addToPIF(yytext, -1); }
letters					{ addToPIF(yytext, -1); }
list					{ addToPIF(yytext, -1); }
if                                    	{ addToPIF(yytext, -1); }
while                                   { addToPIF(yytext, -1); }
for                                    	{ addToPIF(yytext, -1); }
dodo                                    { addToPIF(yytext, -1); }
read                                    { addToPIF(yytext, -1); }
write                                   { addToPIF(yytext, -1); }
otherwise                               { addToPIF(yytext, -1); }
\;;  					{ addToPIF(yytext, -1); }
\::  					{ addToPIF(yytext, -1); }
\(                                    	{ addToPIF(yytext, -1); }
\)                                    	{ addToPIF(yytext, -1); }
\{                                    	{ addToPIF(yytext, -1); }
\}                                    	{ addToPIF(yytext, -1); }
\++                                    	{ addToPIF(yytext, -1); }
\--                                    	{ addToPIF(yytext, -1); }
\**                                    	{ addToPIF(yytext, -1); }
\//                                    	{ addToPIF(yytext, -1); }
\!=                                    	{ addToPIF(yytext, -1); }
\>>                                    	{ addToPIF(yytext, -1); }
\<<                                    	{ addToPIF(yytext, -1); }
\>=                                    	{ addToPIF(yytext, -1); }
\<=                                    	{ addToPIF(yytext, -1); }
\=                                    	{ addToPIF(yytext, -1); }
\==                                    	{ addToPIF(yytext, -1); }
{identifier}				{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{constant}                              { int stCode = addToST(yytext); addToPIF(yytext, stCode); }
[\n]					{ ++lineNumber; }
[ \t\n]+             		        { ; /* eat up whitespace */ }
.                		        { errorFound = 1; printf("Illegal token %s at line %d !", yytext, lineNumber); printf("\n"); }
%%
/* yywrap() - wraps the above rule section */
int yywrap() {}
int main(int argc, char** argv) {
	FILE *fp;
	fp = fopen(argv[1], "r");
	
	/* yyin - takes the file pointer which contains the input*/
	yyin = fp;
	/* yylex() - this is the main flex function which runs the Rule Section*/ 
	yylex();
	
	if (errorFound == 0) {
    		showSymbolTable();
    		showProgramInternalForm();
	}
  
	return 0;
}
