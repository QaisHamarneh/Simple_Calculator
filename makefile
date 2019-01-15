calc: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c hashtable.c -lm -o my_calculator

lex.yy.c: y.tab.c calculator_scanner.l
	lex calculator_scanner.l

y.tab.c: calculator_parser.y
	yacc -d calculator_parser.y

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h my_calculator

