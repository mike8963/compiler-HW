%{
    #include "y.tab.h"
    #include <string.h>
    
    unsigned charCount = 1,lineCount =1;
    void printLine();
    void dump();
%}

char [a-zA-Z_]
digit [0-9]
integer {digit}+
float {digit}+.{digit}+
identifier {char}({char}|{digit})*
string \"([\\][\"\']|[^\"\'\n])*\"
keyword break|byte|case|char|catch|class|const|continue|default|double|do|else|extends|false|finally|for|if|implements|long|main|new|print|private|protected|public|short|switch|this|true|try
space [ \f\r\t\v]+
comment \/\/[^\r\n]*|\/\*([\*][^\/]|[^\*])*\*\/

%%

"static"        { printLine(); printf("%s",yytext); charCount += yyleng; return STATIC;}
"new"           { printLine(); printf("%s",yytext); charCount += yyleng; return NEW;   }
"final"         { printLine(); printf("%s",yytext); charCount += yyleng; return FINAL; }
"class"         { printLine(); printf("%s",yytext); charCount += yyleng; return CLASS; }
"void"          { printLine(); printf("%s",yytext); charCount += yyleng; return VOID;  }
"int"           { printLine(); printf("%s",yytext); charCount += yyleng; return INT;    }
"float"         { printLine(); printf("%s",yytext); charCount += yyleng; return FLOAT;  }
"boolean"       { printLine(); printf("%s",yytext); charCount += yyleng; return BOOLEAN;}
"char"          { printLine(); printf("%s",yytext); charCount += yyleng; return CHAR;   }
"string"        { printLine(); printf("%s",yytext); charCount += yyleng; return STRING; }
"main"          { printLine(); printf("%s",yytext); charCount += yyleng; return MAIN;   }
"while"         { printLine(); printf("%s",yytext); charCount += yyleng; return WHILE;  }
"return"        { printLine(); printf("%s",yytext); charCount += yyleng; return RETURN; }
"if"            { printLine(); printf("%s",yytext); charCount += yyleng; return IF;     }
"else"          { printLine(); printf("%s",yytext); charCount += yyleng; return ELSE;   }
"for"           { printLine(); printf("%s",yytext); charCount += yyleng; return FOR;    }
"print"         { printLine(); printf("%s",yytext); charCount += yyleng; return PRINT;  }
"read"          { printLine(); printf("%s",yytext); charCount += yyleng; return READ;   }




{identifier}    { printLine(); printf("%s",yytext); yylval.string = strdup(yytext); charCount += yyleng; return ID;     }
{integer}       { printLine(); printf("%s",yytext); charCount += yyleng; return INT_VALUE;     }
{float}         { printLine(); printf("%s",yytext); charCount += yyleng; return FLOAT_VALUE;   }
{string}        { printLine(); printf("%s",yytext); charCount += yyleng; return ID;  }  
{space}         { printLine(); printf("%s",yytext); charCount += yyleng; }


{comment}       { 
    printLine(); 
    int i;
    for(i=0;i<yyleng;i++){
        printf("%c",yytext[i]);
        if(yytext[i] == '\n') {
            lineCount++;
            charCount=1;
            printLine();
        }
        else{
            
        }
    }
    charCount += yyleng; 
}

"+"		{ printLine(); printf("%s",yytext); charCount += yyleng; return PLUS;    }
"-"		{ printLine(); printf("%s",yytext); charCount += yyleng; return MINUS;   }
"*"		{ printLine(); printf("%s",yytext); charCount += yyleng; return MUL;     }
"/"		{ printLine(); printf("%s",yytext); charCount += yyleng; return DIV;     }
"<"		{ printLine(); printf("%s",yytext); charCount += yyleng; return LT;      }
">"		{ printLine(); printf("%s",yytext); charCount += yyleng; return GT;      }
"<="	{ printLine(); printf("%s",yytext); charCount += yyleng; return LE;      }
">="	{ printLine(); printf("%s",yytext); charCount += yyleng; return GE;      }
"=="	{ printLine(); printf("%s",yytext); charCount += yyleng; return EQ;      }
"!="	{ printLine(); printf("%s",yytext); charCount += yyleng; return NE;      }
"&&"	{ printLine(); printf("%s",yytext); charCount += yyleng; return AND;     }
"||"	{ printLine(); printf("%s",yytext); charCount += yyleng; return OR;      }

"++"    { printLine(); printf("%s",yytext); charCount += yyleng; return PLUSPLUS;    }
"--"    { printLine(); printf("%s",yytext); charCount += yyleng; return MINUSMINUS;  }

"="		{ printLine(); printf("%s",yytext); charCount += yyleng; return ASSIGN;  }
"("		{ printLine(); printf("%s",yytext); charCount += yyleng; return LP;      }
")"		{ printLine(); printf("%s",yytext); charCount += yyleng; return RP;      }
"["		{ printLine(); printf("%s",yytext); charCount += yyleng; return LBRACKET;}
"]"		{ printLine(); printf("%s",yytext); charCount += yyleng; return RBRACKET;}
"{"		{ printLine(); printf("%s",yytext); charCount += yyleng; return LBRACE;  }
"}"		{ printLine(); printf("%s",yytext); charCount += yyleng; return RBRACE;  }
"."		{ printLine(); printf("%s",yytext); charCount += yyleng; return DOT;     }
","		{ printLine(); printf("%s",yytext); charCount += yyleng; return COMMA;   }
";"		{ printLine(); printf("%s",yytext); charCount += yyleng; return SEMI;    }
"\n"    { printLine(); printf("%s",yytext); charCount = 1; lineCount++;          }

%%

int yywrap(){
    return 1;
}

void printLine(){
    if(charCount == 1) printf("Line %d : \t",lineCount);
}