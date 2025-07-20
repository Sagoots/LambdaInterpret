Lambda Calculus REPL

A Read-Eval-Print Loop (REPL) for the untyped Lambda Calculus, implemented in Wolfram Mathematica. This project provides a functional interpreter for lambda expressions, supporting various reduction strategies, Church numeral arithmetic, and macro definitions.
Features

    Tokenization: Converts raw input strings into a stream of tokens.

    Parsing: Transforms token streams into an Abstract Syntax Tree (AST) based on lambda calculus grammar.

    Reduction (Evaluation): Implements normal-order beta-reduction, alpha-conversion (for variable capture avoidance), and eta-reduction.

    Pretty Printing: Converts ASTs back into a human-readable lambda calculus notation, minimizing parentheses based on operator precedence.

    Macro Definitions: Supports user-defined macros using the #define syntax for shorthand notation and complex lambda terms.

    Church Numerals & Arithmetic: Built-in support for Church numerals and basic arithmetic operations (successor, addition, multiplication, predecessor, subtraction, zero check, less-than-or-equal).

    Church Booleans & Logic: Built-in support for Church booleans and logical operations (IF, NOT, AND, OR, XOR).

    Y Combinator: Includes the Y combinator for defining recursive functions.

    Robust Error Handling: Catches and reports syntax errors, invalid macro definitions, and runtime evaluation issues gracefully.

    File Input/Output: Allows reading expressions from an input file and writing all REPL interactions (prompts, reduction steps, results, errors) to an output file.

    Package Structure: Organized as a Wolfram Language package (.wl file) for clean symbol management and easy import.

Getting Started
Prerequisites

    Wolfram Mathematica (Version 10.0 or higher recommended)

Installation

    Save the Package File: Save the entire code for your interpreter (the combined Tokenizer, Parser, Reducer, Printer, and LambdaREPL function logic) into a single file named MyLambdaREPL.wl.

    Place on Mathematica's $Path:

        Locate your Mathematica Applications directory. A common path is FileNameJoin[{$UserBaseDirectory, "Applications"}].

        Place the MyLambdaREPL.wl file directly into this Applications folder.

        Alternatively, you can place MyLambdaREPL.wl in any directory and then add that directory to Mathematica's $Path using AppendTo[$Path, "path/to/your/directory"] (you might put this in your init.m for persistence).

Loading the Package

Once the MyLambdaREPL.wl file is correctly placed, open a Wolfram Mathematica notebook and load the package:

Needs["MyLambdaREPL`"]

Usage

After loading the package, you can start the REPL.
Running the REPL

The LambdaREPL function accepts optional arguments for input and output files. The number of reduction steps is controlled by the public variable MyLambdaREPLLambdaStepNum`.

    Interactive Mode (Default): Reads from the notebook, prints to the notebook.

    LambdaREPL[]

    Input from File: Reads expressions from input.txt, prints to the notebook.

    LambdaREPL["input.txt"]

    Output to File: Reads from the notebook, writes all output to output.txt.

    LambdaREPL["", "output.txt"]

    Input and Output Files: Reads from input.txt, writes all output to output.txt.

    LambdaREPL["input.txt", "output.txt"]

Controlling Reduction Steps

You can change the maximum number of reduction steps by setting the LambdaStepNum variable, which is part of the MyLambdaREPL package context. The default value is 100.

MyLambdaREPL`LambdaStepNum = 500; (* Set to 500 steps *)
LambdaREPL[] (* Run REPL with the new step limit *)

Interacting with the REPL

Once the REPL starts, you will see the λ>  prompt.
1. Evaluating Lambda Expressions

Enter any valid lambda calculus expression.

λ> (\x.x) y
Reduction Chain:
(\x.x) y
y
Out: y

λ> let id = (\x.x) in id A
Reduction Chain:
let id = (\x.x) in id A
(\x.x) A
A
Out: A

λ> PLUS TWO THREE
Reduction Chain:
PLUS TWO THREE
... (many steps) ...
λf x.f (f (f (f (f x))))
Out: λf x.f (f (f (f (f x)))) (* Church numeral for 5 *)

2. Defining Macros

Use the #define syntax to create shortcuts for complex lambda terms.

λ> #define ID = \x.x
Defined macro: ID = λx.x

λ> ID A
Reduction Chain:
ID A
(\x.x) A
A
Out: A

λ> #define FACT_GEN = \f n. IF (ISZERO n) ONE (MULT n (f (PRED n)))
Defined macro: FACT_GEN = λf n.IF (ISZERO n) ONE (MULT n (f (PRED n)))

λ> #define FACT = Y FACT_GEN
Defined macro: FACT = Y FACT_GEN

λ> FACT TWO
Reduction Chain:
FACT TWO
... (many steps) ...
λf x.f (f x)
Out: λf x.f (f x) (* Church numeral for 2 *)

3. Exiting the REPL

Type exit or quit at the prompt.

λ> exit
Exiting REPL. Goodbye!

Supported Lambda Calculus Features

    Variables: x, y, myVar

    Abstractions: \x.x, \x y.x, @x.@y.x (both \ and @ are supported for lambda)

    Applications: f x, (f x) y

    Let Expressions: let var = val in body

    Numbers (Church Numerals): Integers 0, 1, 2, 3... are automatically converted to their Church numeral representation upon parsing.

    Y Combinator: Y

    Church Arithmetic: SUCC, PLUS, MULT, PRED, MINUS, ISZERO, LEQ

    Church Booleans: TRUE, FALSE, IF, NOT, AND, OR, XOR

    Combinators: I, K, S, Z

Project Structure

The entire interpreter is contained within a single Wolfram Language package file:

    MyLambdaREPL.wl: Contains all the code, organized into private contexts for internal functions and a public interface for the LambdaREPL function and LambdaStepNum variable.

Contributing

Feel free to fork the repository, suggest improvements, or report issues.
License

This project is open-source and available under the MIT License.