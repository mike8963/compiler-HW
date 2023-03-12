all:	clean y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -ly -lfl -o B073040050

y.tab.c:  
	bison -y -d B073040050.y

lex.yy.c: 
	flex B073040050.l

clean:
	rm -f B073040050 lex.yy.c y.tab.c y.tab.h
