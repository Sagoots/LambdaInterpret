(* ::Package:: *)

LambdaStepNum = 200;
LambdaInterpret[lamExp_, depth_ : LambdaDepth] := viewReduc@reduce[parse@tokenize[], depth];


ClearAll[REPL];

(*---Define the REPL function---*)
(*---Define the REPL function---*)(*Arguments:inputFile:Path to an input file.If "",reads from standard input ($Input).outputFile:Path to an output file.If "",writes to standard output ($Output).maxReductionSteps:Maximum number of reduction steps to perform for expressions.*)
LambdaREPL[inputFile_String:"",outputFile_String:"",maxReductionSteps_:LambdaDepth]:=Module[{inputStream,outputStream,line,result},
(*---Initialize Input and Output Streams---*)
inputStream=If[inputFile==="",$Input,OpenRead[inputFile]];
outputStream=If[outputFile==="",$Output,OpenWrite[outputFile, CharacterEncoding->"UTF8"]];
uniqueCounter =0;
macroDict = defaultMacroDict;
(*---Ensure streams are closed on exit or error---*)
(*This uses Protect and On to ensure Close is called even if errors occur.*)
If[inputFile=!="",
Unprotect[inputStream];
inputStream/:MakeBoxes[inputStream,StandardForm]:="InputStream[\""<>inputFile<>"\"]";
Protect[inputStream];
];
If[outputFile=!="",
Unprotect[outputStream];
outputStream/:MakeBoxes[outputStream,StandardForm]:="OutputStream[\""<>outputFile<>"\"]";
Protect[outputStream];
];
(*---Initial REPL Messages---*)
WriteString[outputStream,"--- \[Lambda]-Calculus REPL ---"];
WriteString[outputStream,"Input from: ",If[inputFile==="","Standard Input",inputFile],"\n"];
WriteString[outputStream,"Output to: ",If[outputFile==="","Standard Output",outputFile],"\n"];
WriteString[outputStream,"Enter expressions or macro definitions (e.g., #define ID <expression>).\n Type 'exit' or 'quit' to end.\n"];

(*---Main REPL Loop---*)
While[True,
WriteString[outputStream,"\[Lambda]> "];(*Prompt*)
line=If[inputStream===$Input,InputString["\[Lambda]> "],(*For interactive input,use InputString*)
WriteString[outputStream,"\[Lambda]> "];
(*For file input,print prompt and then read line*)ReadLine[inputStream]
];
(*---Handle Termination Conditions---*)
(*EndOfFile:Reached end of an input file.*)
(*$Canceled:Input was aborted by user (e.g.,Alt+.) or stream closed.*)
If[line===EndOfFile||line===$Canceled,
WriteString[outputStream,"End of input or input canceled. Exiting REPL.\n"];
Break[] (*Exit the While loop*)
];
(*---Handle Explicit Exit Commands---*)
If[StringMatchQ[StringTrim[line],"exit"|"quit",IgnoreCase->True],
WriteString[outputStream,"Exiting REPL. Goodbye!\n"];
Break[] (*Exit the While loop*)
];
(*---Skip Empty Input---*)
If[StringLength[StringTrim[line]]==0,Continue[]];
(*Go to next loop iteration*)
result =Catch[
(*---Process Input:Macro Definition or Expression Evaluation---*)
If[StringStartsQ[StringTrim[line],"#define ", IgnoreCase->True],(*---Macro Definition Parsing---*)
Module[{macroDefTokens,macroName,macroExprTokens,macroExprAST},
macroDefTokens=tokenize[StringTrim[line]];(*Tokenize the entire macro definition line*)
(*Basic validation for macro definition format*)
If[Length[macroDefTokens]<3|| macroDefTokens[[2,1]]=!=macro,(*Check if the second token is a macro*)
Throw["Invalid macro definition format. Expected: #define <ID> <expression>\n"];
];
macroName=macroDefTokens[[2,2]];(*Extract the macro name*)
(*Reconstruct the expression string part for re-tokenization and parsing*)
macroExprTokens=Drop[macroDefTokens,2];
(*Use Check for parsing errors within the macro expression itself*)
macroExprAST=parse[macroExprTokens];
macroDict[macroName]=macroExprAST;(*Store the parsed AST in the global dictionary*)
WriteString[outputStream,"Defined macro: ",macroName," = ",pretty[macroExprAST],"\n"];
Null
],
(*---Expression Evaluation---*)
Module[{exprTokens,parsedExpr,reductionSteps,finalResultString},
exprTokens=tokenize[line];(*Tokenize the input expression*)
parsedExpr=parse[exprTokens];(*Parse the tokens into an AST*)
(*WriteString[outputStream,"Parsed AST: ",ToString[parsedExpr],"\n"];(*Print raw AST*)*)
reductionSteps=reduce[parsedExpr,maxReductionSteps];
(*Reduce the AST*)
WriteString[outputStream,viewReduc[reductionSteps],"\n"];(*Pretty-print the chain*)
(*Return the pretty-printed final reduced form for "Out:"*)
Null
];
]
];
If[result =!= Null,
WriteString[outputStream, "\[WarningSign] " <> result <> "\n"]
];
WriteString[outputStream,"\n"];
];
 (*End While loop*)

(*---Close streams when the REPL loop terminates---*)
If[inputFile=!="",Close[inputStream]];
If[outputFile=!="",Close[outputStream]];
];


(* ::Text:: *)
(*(*---How to Run the REPL---*)*)
(*(*Uncomment one of the following lines to start the REPL after loading this file.*)*)
(**)
(*(*1. Interactive REPL (reads from console,prints to console)*)*)
(*(*LambdaREPL[]*)*)
(**)
(*(*2. LambdaREPL with input file (reads from "input.txt",prints to console)*)*)
(*(*REPL["input.txt"]*)*)
(**)
(*(*3. LambdaREPL with output file (reads from console,writes to "output.txt")*)*)
(*(*REPL["","output.txt"]*)*)
(**)
(*(*4. LambdaREPL with both input and output files*)*)
(*(*REPL["input.txt","output.txt"]*)*)
(**)
(*(*You can also specify a different maximum reduction limit:*)*)
(*(*LambdaREPL["","",500]*)*)
(*(*---To start the REPL---*)*)
(*(*You can uncomment the line below in REPL.wls to make it start automatically on load,*)*)
(*(*or just call REPL[] from a Mathematica notebook cell.*)*)
