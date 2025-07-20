(* ::Package:: *)

Clear[tokenize]
tokenize[inputString_] := 
	StringCases[inputString,
	{
	s: RegularExpression["\[Lambda]|\\\\|@" ] :> {lambda, \[Lambda]},
	s: "." :> {dot, "."},
	s: "(" :>  {openBrac, "("},
	s: ")" :> {closeBrac, "+"},
	s: "let" :> {let, "let"},
	s: "=" :> {equal, "="},
	s: "in" :> {in, "in"},

s: RegularExpression["[0-9]+"] :> {num, s},
	s: RegularExpression["[A-Z][A-Za-z0-9_]*"] :> {macro, s},
	s: RegularExpression["[a-z][A-Za-z0-9_]*"] :> {varName, s}
	}];
