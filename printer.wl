(* ::Package:: *)

Clear[pretty]
(*Precedence levels for pretty printing*)(*Lower number means lower precedence (binds less tightly)*)(*Higher number means higher precedence (binds more tightly)*)
$AppPrec=100;    (*Applications have high precedence (e.g.,f x y)*)
$AbsPrec=5;     (*Abstractions bind loosely,extend to the right (e.g., \x.M N)*)
$LetPrec=5;     (*Let expressions bind loosely,similar to abstractions*)
$AtomPrec=1000;  (*Atoms (vars,nums,macros) always print as-is,highest precedence*)


(*Main pretty function with an optional'parentPrecedence' argument. This argument helps decide if the current expression needs outer parentheses.*)
pretty[lamVar[x_], ___]:= ToString[x]
pretty[lamMacro[f_], ___] := ToString[f]
pretty[lamNum[n_], ___] := ToString[n]
pretty[expr_,parentPrecedence_:0]:=
Module[{resultString,currentPrecedence},
Switch[Head[expr],
lamAbs,
Module[{vars,actualBod,bodStr},
(*Collect consecutive lambda variables: \x y z.M*)
{vars,actualBod}=collectLambdaChain[expr];
(*Recursively pretty-print the body with the abstraction's precedence*)
bodStr=pretty[actualBod,$AbsPrec];
resultString="\[Lambda]"<>StringJoin[Riffle[ToString/@vars," "]]<>"."<>bodStr;
currentPrecedence=$AbsPrec;];
,
lamApp,
Module[{f=expr[[1]],a=expr[[2]],prettyF,prettyA},
(*Function part of application:print with own precedence*)
prettyF=pretty[f,$AppPrec];
(*Argument part of application:higher precedence to ensure its parens*)
(*This handles cases like f (g h) where g h needs parens, but not (f g) h which becomes f g h*)
prettyA=pretty[a,$AppPrec+1];
resultString=prettyF<>" "<>prettyA;
currentPrecedence=$AppPrec;
];
,
lamLet,
Module[{var=expr[[1]],val=expr[[2]],bod=expr[[3]]},
(*Value part of let:higher precedence to ensure its parens if complex*)
resultString="let "<>ToString[var]<>" = "<>pretty[val,$LetPrec+1]<>" in "<>pretty[bod,$LetPrec];
currentPrecedence=$LetPrec;
];
,
_,(*Catch-all for any other unexpected head,though ideally all AST nodes are handled*)resultString=ToString[expr];
currentPrecedence=0; (*Unknown precedence,might always need parens*)
];
(*Add parentheses if the current expression's precedence is lower than its parent's.This is the core logic for minimizing brackets.*)
If[currentPrecedence<parentPrecedence,
"("<>resultString<>")",
resultString
]
]


(*Helper to collect consecutive lambda abstractions for\x y z.M syntax*)
collectLambdaChain[lamAbs[x_,bod_]]:=
Module[{vars={x},currentBod=bod},
While[Head[currentBod]===lamAbs,AppendTo[vars,currentBod[[1]]];
	currentBod=currentBod[[2]];];
{vars,currentBod}]
collectLambdaChain[expr_]:={{},expr} (*Base case for non-lambda expressions*)



viewReduc[reducSteps_]:=StringJoin[Riffle[pretty/@reducSteps," \[RightArrow]\n"]]
