%{
#include<stdio.h>
#include<string.h>

%}

%token num id IF THEN ELSE WHILE RELOP

%right RELOP
%right '='
%left '[' ']'
%left '+' '-'
%left '*' '/'
%left UMINUS
%left  '(' ')'

%union {
char * strval;
int intval;
}

%start SUMO
%type <strval> E T id F
%type  <strval>S SUMO ar
%type  <strval>num RELOP

%%

SUMO : IF '(' SUMO ')' {l1();} THEN SUMO ';' {l2();} ELSE SUMO ';' {l3();}
   | WHILE{w1();} '(' SUMO ')' {w2();} SUMO ';'{w3();}
   | SUMO RELOP{char* s1=malloc(sizeof(char)*(10));
	strcpy(s1,$2);
	
	 new_node(s1);} S {gencode();}
   | S
	
;

S:id{  
	char* s1=malloc(sizeof(char)*(10));
	strcpy(s1,$1);
	new_node(s1);
	} '=' {new_node("=");
		}   
	E{gencode_assign();
	} 
    | E
;
    
    
	
E:  E'+'{new_node("+");} T{gencode();}
  
  |E'-'{new_node("-");} T{gencode();}
  
  | T
  
;
T: T'*'{new_node("*");} F{gencode();}
 
  |T'/'{new_node("/");} F{gencode();}

  |F
;


F:'(' E ')' {}
|'-'{new_node("-");} F{codegen_umin();} %prec UMINUS
|id{ 	
	char* s1=malloc(sizeof(char)*(10));
	strcpy(s1,$1);
	new_node(s1);
	}
|num{   
	char* s1=malloc(sizeof(char)*(10));
	strcpy(s1,$1);
	new_node(s1);
	}

| F ar {
	char* s1=malloc(sizeof(char)*(10));
	array();
	}
;
ar :
   '[' id ']' {
	char* s1=malloc(sizeof(char)*(10));
	
	strcpy(s1,$2);
	
	new_node(s1);
	array_gen();
       }
   | '[' num ']' {
	char* s1=malloc(sizeof(char)*(10));
	
	strcpy(s1,$2);
	
	$$=s1;
	new_node(s1);
	array_gen();
       }
;
%%

char var[2]="t";
char ind[2]="0";
char str[100][100];
int g=0;
int label[20];
int lnum=0;
int ltop=0;

int wnum=1;
int start=1;

main()
{

	printf("GIVE EXPRESSION:\n");
	
	yyparse();
	
} 

l1()
{
	
	lnum++;
	char* s=malloc(sizeof(char)*(10));
		strcpy(s,var);
		strcat(s,ind);
		ind[0]++;
		printf("%s = not %s\n",s,str[g-1]);
		printf("if %s goto L%d\n",s,lnum);
		label[++ltop]=lnum;
		
}

l2()
{
	
	int x;
	lnum++;
	x=label[ltop--];
	printf("goto L%d\n",lnum);
	printf("L%d: \n",x);
	label[++ltop]=lnum;
	
}

l3()
{
	
	int y;
	y=label[ltop--];
	printf("L%d: \n",y);
}

new_node(char y[2])
{
	strcpy(str[g],y);
	g++;
}

gencode()
	{
		char* s=malloc(sizeof(char)*(10));
		strcpy(s,var);
		strcat(s,ind);
		ind[0]++;
		int i;
		printf("%s= %s %s %s\n",s,str[g-3],str[g-2],str[g-1]);
		g-=2;
		strcpy(str[g-1],s);
		
	}

array()
{
	int i;
	
	char* s=malloc(sizeof(char)*(10));
		strcpy(s,var);
		strcat(s,ind);
		ind[0]++;
		printf("%s = %s[%s] \n",s,str[g-2],str[g-1]);
		

		
	
}

array_gen()
{
	int i;
	char* s=malloc(sizeof(char)*(10));
		strcpy(s,var);
		strcat(s,ind);
		ind[0]++;
		printf("%s= %s\n",s,str[g-1]);
		strcpy(str[g-1],s);
		
		
		
	
}

codegen_umin()
 {
	char* s=malloc(sizeof(char)*(10));
		strcpy(s,var);
		strcat(s,ind);
		ind[0]++;
		printf("%s = %s\n",s,str[g-1]);
		g=g-1;
		strcpy(str[g-1],s);
 
 }

gencode_assign()
{	
	int i;
	printf("%s = %s\n",str[g-3],str[g-1]);
	g-=2;

}   

w1()
{
	printf("L%d: \n",wnum++);
}
w2()
{
	char* s=malloc(sizeof(char)*(10));
		strcpy(s,var);
		strcat(s,ind);
		ind[0]++;
		printf("%s = not %s\n",s,str[g-1]);
		printf("if %s goto L%d\n",s,wnum);	
}
w3()
{
	printf("goto L%d \n",start);
	printf("L%d: \n",wnum);
}

yywrap(){}
yyerror()
{
	printf("ERROR\n");
}
