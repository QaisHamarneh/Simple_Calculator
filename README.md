# Simple_Calculator
Compiler for a simple calcul with variable definitions using lex and yacc

# To Run the calculator:
1- Compile all the files by typing the command: make
2- Run the executable "my_calculator" by typing the command: ./my_calculator

# Using the calculator: 
  - Relational expression using the operators: 
        Equal to "==" , Inequal to"!=" ,Greater than or equal to ">=" , Less than or equal to "<=" , Greater than '>' , Less than '<'.
  - Arithmatic expression using the operators: 
        Addition '+' , Subtraction '-' , Multiplication '*' , Division '/' , Power '^' , Parantheses '(' ')', Unary Negative '-'.
  - Assign values to variable using '='.
  - Undeclared variables return the value 0.
  - To end a statement (assignment or expression) start a new line using '\n' (The enter botton) or use ';' to start a new statement.
  - To quit the programm type "quit"

# Precedence and Associativity rules are defined as following (lowest to highest Precedence): 
  - Relational operators        :   left associative 
  - Assignment operator         :   right associative 
  - Addition and Subtraction    :   left associative 
  - Multiplication and Division :   left associative 
  - Power operator              :   right associative 
  - Unary Negative operator     :   nonassociative

# Example:
-> a = 5
=> 5
-> b = 4.7; c = 0; d = 2
=> 4.7
=> 0
=> 2
-> b ^ e + d ^ a    
=> 33
-> x = d ^ -a;
=> 0.03125
-> quit


