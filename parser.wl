(* ::Package:: *)

(*Abstract Syntax Tree (AST) Definitions*)
ClearAll[lamVar,lamAbs,lamApp,lamNum,lamLet,lamFunc, foldRight]
foldRight[ f_, x_, list_ ] := f[First[list], foldRight[f, x, Drop[list, 1]]];
foldRight[ f_, x_, {} ] := x;





((*Recursive Descent Parser*)
parse[tokens_List]:=
Module[{currentToken,tokenIndex=1,len=Length[tokens]},(*Helper function to advance to the next token*)
advanceToken[]:=( 
If[tokenIndex<=len,
currentToken=tokens[[tokenIndex]];
tokenIndex++;
,
currentToken={EOF,"$"} (*End of File token*)
];
);
(*Helper function to check and consume an expected token type*)
expect[expectedType_]:=(If[currentToken[[1]]===expectedType,
Module[{value=currentToken[[2]]},(*Store the value before advancing*)
advanceToken[];
value
]
,
Throw["Parsing error: Expected "<>ToString[expectedType]<>", found "<>ToString[currentToken[[1]]]] <>  "(" <> currentToken[[2]]<>")"]
);
(*Helper function to peek at the current token type without consuming*)
peek[]:=currentToken[[1]];
(*Grammar Rules*)(* <expression> ::='let'<var>'='<expression>'in'<expression> | <abstraction> | <application>*)
parseExpression[]:=If[peek[]===let,expect[let];
Module[{var,val,bod},var=expect[varName];
expect[equal];
val=parseExpression[];
expect[in];
bod=parseExpression[];
lamLet[var,val,bod]],parseApplication[] (*Application has higher precedence than abstraction*)];
(* <abstraction> ::='\[Lambda]'<varlist>'.'<expression>*)
parseAbstraction[]:=(expect[lambda];(*Consume the lambda token*)
Module[{vars={},bod,r},
While[peek[]===varName,
AppendTo[vars,expect[varName]]
];
expect[dot];
bod=parseExpression[];
(*Create nested lambda abstractions using Fold with reversed variables*)foldRight[lamAbs,bod,vars]]);
(* <application> ::= <atom>{ <atom>}*)
parseApplication[]:=
Module[{func=parseAtom[],arg},
While[MemberQ[{varName,openBrac,num,macro,lambda},peek[]],(*Atom can start with these*)
arg=parseAtom[];
func=lamApp[func,arg]];
func
];
(* <varlist> ::= <var>{ <var>}-Handled directly in parseAbstraction*)(* <atom> = <var> |'(', <expr> ,')'| <number> | <macro>;*)
parseAtom[]:=
Switch[peek[],
varName,lamVar[expect[varName]],
num,lamNum[ToExpression[expect[num]]],
macro,lamMacro[expect[macro]],
lambda,parseAbstraction[],
openBrac,expect[openBrac]; Module[{expr=parseExpression[]},expect[closeBrac];expr],
_,Throw["Syntax error: Unexpected token "<>ToString[currentToken[[1]]]<>" at atom parsing"]
];

(*Start parsing*)
advanceToken[];
(*Initialize currentToken*)
parseExpression[]];



defaultMacroDict = <|
"SUCC"->parse[tokenize["@n.@f.@x. f (n f x)"]],
"PLUS"->parse[tokenize["@n.@m. n SUCC m"]],
"MULT"->parse[tokenize["@m.@n.@f. m (n f)"]],
"POW"->parse[tokenize["@m.@n. n m"]],
"TRUE"-> parse[tokenize["@x.@y. x"]],
"FALSE"-> parse[tokenize["@x.@y. y"]],
"IF"->parse[tokenize["@p.@x.@y. p x y"]],
"ISZERO"->parse @ tokenize["@n. n (@x. FALSE) TRUE"],
"NOT"->parse@tokenize["@p.@x.@y. p y x"],
"AND"->parse@tokenize["@p1.@p2. p1 p2 p1"],
"OR"->parse@tokenize["@p1.@p2. p1 p1 p2"],
"XOR"->parse@tokenize["@p1.@p2. p1 (NOT p2) p2"],
"Y"->parse@tokenize["@f. (@x. f (x x)) (@x. f (x x))"],
"PRED"->parse@tokenize["\[Lambda]n.\[Lambda]f.\[Lambda]x.n (\[Lambda]g.\[Lambda]h.h (g f)) (\[Lambda]u.x) (\[Lambda]u.u)"],
"MINUS"->parse@tokenize["@m.@n. n PRED m"],
"LEQ"->parse@tokenize["@n.@m. ISZERO (MINUS n m)"],
"I"-> parse@tokenize["@x. x"], 
"K" -> parse@tokenize["@x.@f. x"],
"S"->  parse@tokenize["@x.@y.@z. ((x z) (y z))"],
"Z" -> parse@tokenize["@f.(@x. f(@v.x x v)) (@x. f(@v.x x v))"]
|>;

macroDict = defaultMacroDict;
