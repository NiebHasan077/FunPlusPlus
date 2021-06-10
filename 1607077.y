%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	int value[58];
	void yyerror(char *s);
	int yylex();
	
%}


%token MAIN CURLYO CURLYC INT FLOOT CHAR NUM VARIABLE FOR IF ELSE    SWITCH CASE DEFAULT BREAK  PRINT SQRT CBRT LOG

%nonassoc IF
%nonassoc ELSE
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%left '<' '>'
%left '+' '-'
%left '*' '/'

%%

program: MAIN  CURLYO cascadestatement CURLYC
	 ;

cascadestatement:      /*NULL*/

	| cascadestatement statement
	;

statement: ';'			
	| declaration ';'		{ printf("Valid variable declaration\n"); }

	| expr ';' 			{   printf("Expression evaluated . Value : %d\n", $1); $$=$1;}
	
	| VARIABLE '=' expr ';' { 
							value[$1] = $3; 
							printf("Value assigned to variable. Value: %d\t\n",$3);
							$$=$3;
						} 
   
	| FOR '(' NUM '<' NUM ')' CURLYO statement CURLYC {
	                                int i;
	                                for(i=$3 ; i<$5 ; i++) {printf(" i : %d and expression : %d\n", i,$8);}									
				               }
	| SWITCH '(' VARIABLE ')'CURLYO A  CURLYC

	| IF '(' expr ')' CURLYO expr ';' CURLYC {
								if($3){
									printf("\nTrue expression in IF. Value:  %d\n",$6);
								}
								else{
									printf("False expression in IF block\n");
								}
							}

	| IF '(' expr ')' CURLYO expr ';' CURLYC ELSE CURLYO expr ';' CURLYC {
								if($3){
									printf("True expression in IF. Value: %d\n",$6);
								}
								else{
									printf("False expression in IF block. Else evaluated. Value: %d\n",$11);
								}
							}
	| PRINT '(' expr ')' ';' {printf("Printing value of  Variable:  %d\n",$3);}
	;
	
A   : B
	| B C
    ;
B   : B  B
	| CASE NUM ':' expr ';' BREAK ';' {}
	;
C   : DEFAULT ':' expr ';' BREAK ';' {}
	
declaration : TYPE ID   
             ;


TYPE : INT   
     | FLOOT  
     | CHAR   
     ;



ID : ID ',' VARIABLE  
    |VARIABLE  
    ;

expr: NUM					{ $$ = $1; 	}

	| VARIABLE						{ $$ = value[$1]; }
	
	| expr '+' expr	{ $$ = $1 + $3; }

	| expr '-' expr	{ $$ = $1 - $3; }

	| expr '*' expr	{ $$ = $1 * $3; }

	| expr '/' expr	{ if($3){
				     					$$ = $1 / $3;
				  					}
				  					else{
										$$ = 0;
										printf("\ndivision by zero\t");
				  					} 	
				    			}
	| expr '%' expr	{ if($3){
				     					$$ = $1 % $3;
				  					}
				  					else{
										$$ = 0;
										printf("\nMOD by zero\t");
				  					} 	
				    			}
	| expr '^' expr	{ $$ = pow($1 , $3);}
	| expr '<' expr	{ $$ = $1 < $3; }
	| expr '=' expr	{ $$ = $1==$3;}
	| expr '>' expr	{ $$ = $1 > $3; }

	| '(' expr ')'		{ $$ = $2;	}
	| SQRT expr 			{printf("Value of Sqrt(%d) is %lf\n",$2,sqrt($2*1.0)); $$=sqrt($2*1.0);}
	| CBRT expr 			{printf("Value of Cbrt(%d) is %lf\n",$2,cbrt($2*1.0)); $$=cbrt($2*1.0);}


    | LOG expr 			{printf("Value of Log base 10 (%d) is %lf\n",$2,(log($2*1.0)/log(10.0))); $$=(log($2*1.0)/log(10.0));}
	
	;
%%

int yywrap()
{
	return 1;
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();
    
	return 0;
}


void yyerror(char *s){
	printf( "Error Occured !!!\n");
}

