%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "1607077.tab.h"
%}

char		 [a-zA-Z]
digit 		[0-9]
string 		[a-zA-Z]+
Comment		[ ]*[%][%][^\n]*
MLComment		[ ]*[%][~][a-zA-Z0-9 \n ]*[~][%]	

%%
"$import["{string}".h]"  					{printf("Included header file\n");}
{char}	    { yylval = *yytext - 'A'; return	VARIABLE; }
{digit}+	{ yylval = atoi(yytext); return NUM; }

"main"	   { return MAIN; }

INT  		 {return INT;}
CHAR 		         {return CHAR;}
FLOOT 			 	{return FLOOT;}

[-+/*<>=,():;%^]         {yylval = yytext[0];	return *yytext;	}

IF 			   { return IF;   }
ELSE 		   { return ELSE; }
FOR 		   { return FOR;}

SWITCH 		   { return SWITCH; }
CASE   		   { return CASE;  } 
BREAK  		   { return BREAK;  }
DEFAULT 	   { return DEFAULT; }
PRINT 		       { return PRINT; }



"{" 		   { return CURLYO;  }
"}"  		   { return CURLYC;	}

SQRT		 {return SQRT;}
CBRT		{return CBRT;}
LOG 		   {return LOG;}

{Comment}	{printf("Single line comment written\n");}
{MLComment}	{printf("Multi-line comment written\n");}


[ ]*	    			{}
[\n]*					{}
[\t]*					{}
.						{printf("%s is an invalid text\n",yytext);}


%%
