(* ::Package:: *)

freeVars[lamVar[x_]] := {x}
freeVars[lamAbs[x_, bod_]]:= Complement[freeVars[bod], {x}]
freeVars[lamApp[f_, a_]] := Union[freeVars[f], freeVars[a]]
freeVars[lamLet[var_, val_, bod_]] := Union[Complement[freeVars[bod], {x}], freeVars[val]]
freeVars[t_] := {}


alphaSub[x_, bod_]  := Module[{freshVar = Symbol["v" <> ToString[Unique[]]]}, 
		{freshVar, substitute[bod, x, lamVar[freshVar]]}]


uniqueCounter = 0;
uniqueIndex[] := uniqueCounter = uniqueCounter+1


(*substitute:Substitutes'newVal' for'x' in'term'.*)
(*This is a core function for beta-reduction and let-expansion.*)
substitute[lamVar[x_],x_,newVal_]:=newVal
substitute[lamVar[x_],y_,newVal_]:=lamVar[x]

(*Substitution in abstraction (lamAbs):*)
substitute[lamAbs[boundVar_,bod_],boundVar_,newVal_]:= lamAbs[boundVar,bod]
substitute[lamAbs[boundVar_,bod_],x_,newVal_] :=
If[MemberQ[freeVars[newVal], boundVar],
(*Capture detected! alpha-rename this lambda.*)
Module[{freshVar=Symbol["v"<>ToString[uniqueIndex[]]]},
lamAbs[freshVar,substitute[substitute[bod,boundVar,lamVar[freshVar]],x,newVal]]]
,
lamAbs[boundVar,substitute[bod,x,newVal]]
]

(*Substitution in application (lamApp):*)
substitute[lamApp[f_,b_],toSub_,newVal_]:=lamApp[substitute[f,toSub,newVal],substitute[b,toSub,newVal]]

(*Substitution in let-binding (lamLet):*)
substitute[lamLet[boundVar_,val_,bod_],boundVar_,newVal_] := lamLet[boundVar,substitute[val, toSub, newVal],bod]
substitute[lamLet[boundVar_,val_,bod_],toSub_,newVal_]:=
If[MemberQ[freeVars[newVal], boundVar],(*Capture detected! alpha-rename this let.*)
	Module[{freshVar=Symbol["v"<>ToString[uniqueIndex[]]]},
		lamLet[freshVar,substitute[val,toSub,newVal],
			substitute[substitute[bod,boundVar,lamVar[freshVar]],toSub,newVal]
		]
	]
,
(*No capture,proceed with substitution in both val and bod.*)
lamLet[boundVar,substitute[val,toSub,newVal],substitute[bod,toSub,newVal]]
]

(*Catch-all for other types (lamNum,lamMacro) that don't have variables to substitute into directly*)
substitute[A_,_,_]:=A (*Catch-all for other types like lamNum,which don't have variables to substitute into directly*)



(*churchNum:Converts an integer'n' into its Church numeral representation.*)
churchNum[n_] := Module[{chruchNumAux},
churchNumAux[0] := lamVar["x"];
churchNumAux[m_] :=lamApp[lamVar["f"], churchNumAux[m-1]];
lamAbs["f", lamAbs["x", churchNumAux[n]]]
]


(*reduceOnce:Performs a single step of beta-reduction or other simplification.*)
Clear[reduceOnce]
(*Beta-reduction:(\[Lambda]x.bod) arg->bod[x/arg]*)
reduceOnce[lamApp[lamAbs[x_, bod_], arg_]] :=substitute[bod, x, arg]

(*Apply reduction recursively to the abstraction*)
reduceOnce[lamApp[f_, a_]] /;reduceOnce[f] =!= f:= lamApp[reduceOnce[f], a]
reduceOnce[lamApp[f_, a_]] := lamApp[f, reduceOnce[a]]
reduceOnce[lamAbs[x_, bod_]] := lamAbs[x, reduceOnce[bod]]

(*Eta reduction:\[Lambda]x.(f x)->f (if x is not free in f)*)
reduceOnce[lamAbs[x_, lamApp[f_, lamVar[x_]]]] := 
If[!MemberQ[freeVars[f],x],
f,
lamAbs[x,lamApp[f,lamVar[x]]]
]

(*Convert a lamNum node to its Church numeral representation*)
reduceOnce[lamNum[n_]] := churchNum[n]

(*Let-expansion:let var=val in bod->bod[var/val]*)
reduceOnce[lamLet[var_, val_,  bod_]] := substitute[bod, var, val]

(*Macro expansion:If a lamMacro node is encountered,expand it using the macroDictionary.*)
reduceOnce[lamMacro[name_]]:=
If[KeyExistsQ[macroDict,name],
	macroDict[name],(*Return the stored AST for the macro*)
	lamMacro[name] (*If for some reason it's not found (e.g.,deleted),return itself*)
]

(*Catch-all:If no reduction rule applies,return the term unchanged*)
reduceOnce[term_] := term



reduce[term_, 0] := {term}
reduce[term_, steps_] := 
Module[{r1 =reduceOnce[term]}, 
If[r1 === term,
	{term},
	Prepend[reduce[r1, steps -1], term]]
]
