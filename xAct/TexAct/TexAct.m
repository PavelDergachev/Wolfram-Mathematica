xAct`TexAct`$Version={"0.3.7",{2015,8,23}};
xAct`TexAct`$xTensorVersionExpected={"1.1.0",{2013,9,1}};


(* TexAct, Tex code to format xAct expressions *)

(* Copyright (C) 2008-2015 Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell *)

(* This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published
 by the Free Software Foundation; either version 2 of the License,
  or (at your option) any later version.

This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 General Public License for more details.

You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307,
  USA. 
*)


(* :Title: TexAct *)

(* :Author: Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell *)

(* :Summary: Tex code to format xAct expressions *)

(* :Brief Discussion:
*)
  
(* :Context: xAct`Texsor` *)

(* :Package Version: 0.3.7 *)

(* :Copyright: Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell (2008-2015) *)

(* :History: see TexAct.History file *)

(* :Keywords: *)

(* :Source: Texsor.nb *)

(* :Warning: *)

(* :Mathematica Version: 5.1 and later *)

(* :Limitations: *)


If[Unevaluated[xAct`xCore`Private`$LastPackage]===xAct`xCore`Private`$LastPackage,xAct`xCore`Private`$LastPackage="xAct`TexAct`"];


BeginPackage["xAct`TexAct`",{"xAct`xCore`","xAct`xPerm`","xAct`xTensor`"}]


If[Not@OrderedQ@Map[Last,{xAct`TexAct`$xTensorVersionExpected,xAct`xTensor`$Version}],Throw@Message[General::versions,"xTensor",xAct`xTensor`$Version,xAct`TexAct`$xTensorVersionExpected]]


Print[xAct`xCore`Private`bars];
Print["Package xAct`TexAct`  version ",xAct`TexAct`$Version[[1]],", ",xAct`TexAct`$Version[[2]]];
Print["CopyRight (C) 2008-2015, Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell, under the General Public License."]


Off[General::shdw]
xAct`TexAct`Disclaimer[]:=Print["These are points 11 and 12 of the General Public License:\n\nBECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM `AS IS\.b4 WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.\n\nIN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."]
On[General::shdw]


If[xAct`xCore`Private`$LastPackage==="xAct`TexAct`",
Unset[xAct`xCore`Private`$LastPackage];
Print[xAct`xCore`Private`bars];
Print["These packages come with ABSOLUTELY NO WARRANTY; for details type Disclaimer[]. This is free software, and you are welcome to redistribute it under certain conditions. See the General Public License for details."];
Print[xAct`xCore`Private`bars]]


Tex::usage="Tex[expr] returns a string with the TeX formatting of the tensorial expression expr.";
TexPrint::usage="TexPrint[expr] returns a string for screen printing of the TeX formatting of the tensorial expression expr. TexPrint[expr, n] starts using parenthesization of level n, instead of the Automatic level.";
TexBreak::usage="TexBreak[string] breaks the string (the output of TexPrint) into different lines of TeX code, always before a sum, approximately every 200 characters (or terms, using the option TexBreakBy) of the string. TexBreak[string, n] allows specifying the frequency of characters or terms. TexBreak[string, n, list] allows specifying different lengths for different lines. Other relevant options are TexBreakAt and TexBreakString.";
TexBreakBy::usage="TexBreakBy is an option for TexBreak specifying whether the string of TeX code must be broken by counting characters (value \"Character\") or by counting terms (value \"Term\").";
TexBreakAt::usage="TexBreakAt is an option for TexBreak specifying where to break the string of TeX code.";
TexBreakString::usage="TexBreakString is an option for TexBreak specifying the string to be introduced at the breaking points.";
$TexPrintInitialBracesQ::usage="$TexPrintInitialBracesQ is a Boolean global variable, with default False. If set to True a tensor is formatted as T{}^{ab}{}_{cd}. If set to False the same tensor is formatted as T^{ab}{}_{cd}.";
$TexScalarParentheses::usage="$TexScalarParentheses is a Boolean global variable, with default True. If set to True the Scalar expressions are formatted with wrapping parentheses.";
$TexFraction::usage="$TexFraction is a global variable specifying the Tex command to be used to format fractions, with default \"\\frac\".";
$TexSmallFraction::usage="$TexSmallFraction is a global variable specifying the Tex command to be use to format rational numbers, with default \"\\tfrac\".";
$TexSmallFractionExponent::usage="$TexSmallFractionExponent is a global variable specifying the Tex command to be use to format rational numbers, with default False.";
$TexFractionAsFraction::usage="Option for TexPrint. If True, fractions are printed as fractions, otherwize they are printed as a product with negative exponents.";
$TexParenthesisInitLevel::usage="";
$TexFixExtraRules::usage="";
TexMatrix::usage ="TexMatrix[M] produces TeX code for the matrix M, where all elements are typset by the function Tex. TexMatrix[M, F] uses the function F instead of Tex on the elements.";
TexIndexForm::usage ="Special formatting for indices.";
$TexTmpDirectory::usage ="Directory for placement of the TexActWidthTest.tex file for determining of widths for linebreaking.";
$TexDirectory::usage="Directory for placement of the output .tex file.";
TexInitLatexCode::usage="A function that produces the initial lines of the TexActWidthTest.tex file for determining of widths for linebreaking. Observe that \\begin{document} should not be included. This is constructed from the string $TexInitLatexClassCode, and the lists $TexInitLatexPackages, $TexInitLatexExtraCode.";
$TexInitLatexClassCode::usage="The document class code for the LaTeX output.";
$TexInitLatexPackages::usage="A list of packages for the LaTeX output. This should be a list of strings, where each string has teh form {package}. This is then transformed to \\usepackage{package}";
$TexInitLatexExtraCode::usage="Extra lines for definition of special LaTeX commands. This should be a list of strings.";
TexPrintAlignedEquations::usage ="TexPrintAlignedEquations takes a list of equations and typesets them in an align environment with line breaking so the total length does not exceed $TexPrintPageWidth.";
$TexPrintPageWidth::usage = "Parameter to adjust the line breaking for TexPrintAlignedEquations. This is measured in printer points. Observe that you can use the textwidth variable which is read from the latex environment.";
latextextwidth::usage="A symbol representing the textwidth variable in the current latex environment.";
FormatTexBasis::usage ="FormatTexBasis works the same way as FormatBasis, but for the Tex output.";
EquationMarks::usage ="An option for TexBreak to include \\begin{equation} \\end{equation} or similar constructions. Default is False, but a standard value would be \"equation\". Warning, do not use this on TexPrint if the result is passed to TexBreak.";
AddEquationMarks::usage="Adds \\begin{equation} \\end{equation} or similar constructions to a tex string. The default is Automatic which makes an educated guess.";
TexView::usage="TexView is used to compile and view tex output. The first argument can be a tex string, a list of equations, a single equation or expression. A second optional argument can be given to set the file name without extension. The compiler is set by $LatexExecutable. The file extension of the file to view is set by $TexViewExt.";
TexPort::usage="Does the same thing as TexView, but it does not open the file. A file name must be given as a second argument.";
$LatexExecutable::usage ="Command for compiling LaTeX. The default is pdflatex. Add the path to the file if the default value does not work.";
$TexViewExt::usage = "The file extension for output file to view. The defailt is .pdf. If you want to open the .tex file in your default editor use .tex instead. Observe however that TexView overwrites files without asking so editing this file might not be a good idea.";
TexPrintAlignedExpressions::usage="Takes a list of expressions, and typesets them in an aligned environment.";
EnableTexColor::usage="EnableTexColor[] enables the use of colors in the tex output.";
DisableTexColor::usage="DisableTexColor[] disables the use of colors in the tex output.";
ParenthesisOldStyle::usage="ParenthesisOldStyle can be given as a second argument to TexPrint to recover the old style of counting parenthesis levels.";
TexOverline::usage="TexOverline[str] returns \\overline{str}.";
TexUnderline::usage="TexUnderline[str] returns \\underline{str}";
TexBar::usage="TexBar[str] returns \\bar{str}";
TexTilde::usage="TexTilde[str] returns \\tilde{str}";
TexHat::usage="TexHat[str] returns \\hat{str}";
TexColor::usage="TexColor[str, RGBColor[r, g, b]] adds Tex code to color the string str. Please use EnableTexColor first."


Begin["`Private`"]


$TexParenthesisNewstyle=False;


$TexOpenParChar=FromCharacterCode[23];
$TexCloseParChar=FromCharacterCode[25];


TexOpen[string_String]:=OpenParenthesis[Decrement[level]]<>string;
TexClose[string_String]:=CloseParenthesis[PreIncrement[level]]<>string;


(* Trick to count maximum depth *)
OpenParenthesis[level_Integer?Negative]:=If[$TexParenthesisNewstyle,$TexOpenParChar,
(minlevel=Min[minlevel,level];"")];
CloseParenthesis[level_Integer?Negative]:=If[$TexParenthesisNewstyle,$TexCloseParChar,
""];


OpenParenthesis[0]:="";
CloseParenthesis[0]:="";

OpenParenthesis[1]:="\\bigl";
CloseParenthesis[1]:="\\bigr";

OpenParenthesis[2]:="\\Bigl";
CloseParenthesis[2]:="\\Bigr";

OpenParenthesis[3]:="\\biggl";
CloseParenthesis[3]:="\\biggr";

OpenParenthesis[4]:="\\Biggl";
CloseParenthesis[4]:="\\Biggr";

OpenParenthesis[level_Integer?Positive]:="\\left";
CloseParenthesis[level_Integer?Positive]:="\\right";


(* Main. Private *)
TexMaximumLevel[expr_]:=Block[{level=0,minlevel=0},Tex[expr];-minlevel];


(* Safety definitions for direct examples with Tex *)
level=0;
minlevel=0;


$VerboseParenthesizationLevel=False;
TexParenthesis[expr_,initlevel_:Automatic]:=
If[initlevel===Automatic,
Block[{level=-1,$TexParenthesisNewstyle=True},
PlaceParenthesis@Tex[expr]],
Block[{level=If[initlevel===ParenthesisOldStyle,TexMaximumLevel[expr],initlevel]},If[$VerboseParenthesationLevel,Print["Maximum parenthesization level: ",level]];
Tex[expr]
]];


PlaceParenthesis[texinstr_String]:=Module[{parchars=StringCases[texinstr,Alternatives[$TexOpenParChar,$TexCloseParChar]],substrings,texstring="",i=1,j,parlevel, maxparlevel},
substrings=StringSplit[texinstr,Alternatives[$TexOpenParChar,$TexCloseParChar],All];
While[Length@substrings>0,texstring=StringJoin[texstring,First@substrings];
substrings=Rest@substrings;
If[i<= Length@parchars&&parchars[[i]]===$TexOpenParChar,
j=i+1;
parlevel=1;
maxparlevel=1;
While[j<= Length@parchars&&parlevel>0,
If[parchars[[j]]===$TexOpenParChar,maxparlevel=Max[maxparlevel,++parlevel],parlevel--];
j++];
texstring=StringJoin[texstring,OpenParenthesis[maxparlevel-1]];
];
If[i<= Length@parchars&&parchars[[i]]===$TexCloseParChar,
j=i-1;
parlevel=1;
maxparlevel=1;
While[j>= 1&&parlevel>0,
If[parchars[[j]]===$TexCloseParChar,maxparlevel=Max[maxparlevel,++parlevel],parlevel--];
j--];
texstring=StringJoin[texstring,CloseParenthesis[maxparlevel-1]];
];
i++;
];
texstring
];


(* Just in case *)
Tex[]:="";


$TexFraction="\\frac";
$TexSmallFraction="\\tfrac";
$TexSmallFractionExponent=False;


TexFrac1[numer_, denom_,fracsymbol_]:=If[fracsymbol===False,StringJoin[Tex[numer],"/",Tex[denom]],StringJoin[fracsymbol,"{",Tex[numer],"}{",Tex[denom],"}"]];


TexFracExpression[numer_, denom_,fracsymbol_]:=If[WithMinusQ[numer],
StringJoin[TexOperator[Minus],TexFrac1[-(numer),denom,fracsymbol]],
TexFrac1[numer,denom,fracsymbol]
];


WithMinusQ[expr_String]:=SameQ[StringTake[expr,1],"-"];
WithMinusQ[expr_]:=WithMinusQ[Tex[expr]];


(* Numbers *)
Tex[x_Integer]:=ToString[x];
Tex[x_Real]:=ToString[x];
Tex[x_Rational]:=TexFracExpression[Numerator[x],Denominator[x],$TexSmallFraction];
Tex[Complex[0,1]]="i";
Tex[Complex[0,-1]]="-i";
Tex[Complex[0,im_]]:=StringJoin[Tex[im],Tex[I]];
Tex[Complex[re_,im_]]:=StringJoin[TexOpen["("],Tex[re],"+",Tex[im I],TexClose[")"]];


(* Numeric expressions *)
Tex[E]="e";
Tex[Pi]="\\pi";


(* Strings *)
Removetext[string_String]:=StringDrop[StringDrop[string,6],-1]/;StringMatchQ[string,"\\text{*}"];
Removetext[string_String]:=string;
(* TeXForm does not work on StyleBoxes so we remove them first. *)
RemoveStyleBoxes[string_String]:=StringReplace[string,StringExpression["\!\(\*StyleBox[\"",x___,"\"",y___,"]\)"]:>x]


Tex[str_String]:=StringJoin@@(TexOrnament/@StringSplit[str,a:StringExpression["\!\(",___,"\)"]:>a]);


TexOrnament[str_String]:=TexOverline[Tex@StringDrop[StringDrop[str,2],-3]]/;StringMatchQ[str,StringExpression["\!\(",x___,"\&_\)"]];
TexOrnament[str_String]:=TexOverline[Tex@StringDrop[StringDrop[str,18],-8]]/;StringMatchQ[str,StringExpression["\!\(\*OverscriptBox[\(",x___,"\), \(_\)]\)"]];
TexOrnament[str_String]:=TexTilde[Tex@StringDrop[StringDrop[str,2],-3]]/;StringMatchQ[str,StringExpression["\!\(",x___,"\&~\)"]];
TexOrnament[str_String]:=TexTilde[Tex@StringDrop[StringDrop[str,18],-8]]/;StringMatchQ[str,StringExpression["\!\(\*OverscriptBox[\(",x___,"\), \(~\)]\)"]];
TexOrnament[str_String]:=TexHat[Tex@StringDrop[StringDrop[str,2],-3]]/;StringMatchQ[str,StringExpression["\!\(",x___,"\&^\)"]];
TexOrnament[str_String]:=TexHat[Tex@StringDrop[StringDrop[str,18],-8]]/;StringMatchQ[str,StringExpression["\!\(\*OverscriptBox[\(",x___,"\), \(^\)]\)"]];
TexOrnament[str_String]:=Removetext@ToString@TeXForm@RemoveStyleBoxes@str;


Tex[TexString[string_String]]:=string;


Tex["\[Eth]"]="\\eth";


Tex["\[EmptyDownTriangle]"]:="\\nabla";


TexOverline[str_]:=StringJoin["\\overline{",str,"}"]
TexUnderline[str_]:=StringJoin["\\underline{",str,"}"]
TexBar[str_]:=StringJoin["\\bar{",str,"}"]
TexTilde[str_]:=StringJoin["\\tilde{",str,"}"]
TexHat[str_]:=StringJoin["\\hat{",str,"}"]


(* Functions *)
Tex[Sin]:="\\sin";
Tex[Cos]:="\\cos";
Tex[Sec]:="\\sec";
Tex[Csc]:="\\csc";
Tex[Cot]:="\\cot";
Tex[Tan]:="\\tan";
Tex[Log]:="\\log";
Tex[Sinh]:="\\sinh";
Tex[Cosh]:="\\cosh";
Tex[Tanh]:="\\tanh";


$TexTrigFuncs={Sin,Cos,Tan,Cot,Sec,Csc,Sinh,Cosh,Tanh};
Tex[(trig:Alternatives@@$TexTrigFuncs)[T_?xTensorQ[]]]:=StringReplace[StringJoin[Tex[trig]," ",Tex[T]]," \\"->"\\"];
Tex[Power[(trig:Alternatives@@$TexTrigFuncs)[T_?xTensorQ[]],i_Integer]]:=StringJoin[Tex[trig],"^",Tex[i],Tex[T]]/;And[i>1,i<10];


(* Symbols (including constant-symbols and parameters) *)
Tex[symbol_Symbol]:=Tex@PrintAs[symbol];


ExtraSpaceIfBackslash[str_String]:=If[StringFreeQ[str,"\\"],str,StringJoin[str," "]];


TexIndexForm[index_]:=Tex[IndexForm[index]]


(* One index *)
TexUpIndex[index_]:=ExtraSpaceIfBackslash@TexIndexForm@index;


$TexPrintInitialBracesQ=False;
initbraces[]:=If[$TexPrintInitialBracesQ,"{}",""];
(* Main *)
TexIndices[]:=Sequence[];
TexIndices[first_?UpIndexQ,more___]:=StringJoin[initbraces[],"^{",TexUpIndex[first],TexIndicesFromUp[more],"}"];
TexIndices[first_?DownIndexQ,more___]:=StringJoin[initbraces[],"_{",TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more],"}"];
(* Previous index was up *)
TexIndicesFromUp[]:=Sequence[];
TexIndicesFromUp[first_?UpIndexQ,more___]:=StringJoin[TexUpIndex[first],TexIndicesFromUp[more]];
TexIndicesFromUp[first_?DownIndexQ,more___]:=StringJoin["}{}_{",TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more]];
(* Previous index was down *)
TexIndicesFromDown[]:=Sequence[];
TexIndicesFromDown[first_?DownIndexQ,more___]:=StringJoin[TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more]];
TexIndicesFromDown[first_?UpIndexQ,more___]:=StringJoin["}{}^{",TexUpIndex[first],TexIndicesFromUp[more]];
(* With derivative indices in postfix notation *)
TexCovDIndices[post_][first_?UpIndexQ,more___]:=StringJoin["{}^{",post,TexUpIndex[first],TexIndicesFromUp[more],"}"];
TexCovDIndices[post_][first_?DownIndexQ,more___]:=StringJoin["{}_{",post,TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more],"}"];


OrderedPlus[0,terms__]:=OrderedPlus[terms];
OrderedPlus[terms1__,0,terms2___]:=OrderedPlus[terms1,terms2];


(* Unary minus *)
TexOperator[Minus]="- ";
Tex[(-expr_Plus|-expr_OrderedPlus)]:=StringJoin[TexOperator[Minus],TexOpen["("],Tex[expr],TexClose[")"]];
Tex[-expr_]:=TexOperator[Minus]<>Tex[expr];


(* Product *)
TexOperator[Times]:=" ";
TexFactor[1]:="";
TexFactor[-1]:=TexOperator[Minus];
TexFactor[(expr_Plus|expr_OrderedPlus)]:=StringJoin[TexOpen["("],Tex[expr],TexClose[")"]];
TexFactor[expr_]:=Tex[expr];
TexOrdinaryTimes[expr_Times]:=StringJoin@@Riffle[TexFactor/@List@@expr,TexOperator[Times]];
TexOrdinaryTimes[expr_]:=Tex@expr;


$TexFractionAsFraction=True;


Tex[expr_Times]:=Module[{numer=Numerator[expr],denom=Denominator[expr]},
If[And[!NumberQ[denom],$TexFractionAsFraction],
TexFracExpression[numer,denom,$TexFraction],
TexOrdinaryTimes[expr]
]
];


(* Sum *)
TexOperator[Plus]:=" + ";
Tex[(expr_Plus|expr_OrderedPlus)]:=StringJoin@@Riffle[Tex/@List@@expr,TexOperator[Plus]];


(* Square root of a number *)
Tex[Sqrt[num_?NumberQ]]:=StringJoin["\\sqrt{",Tex[num],"}"];
Tex[Power[num_?NumberQ,-1/2]]:=StringJoin[$TexSmallFraction,"{1}{\\sqrt{",Tex[num],"}}"];


ExtractNumericalFactor[expr_Times]:=Times@@(Select[List@@expr,NumberQ]);
ExtractNumericalFactor[num_?NumberQ]:=num;
ExtractNumericalFactor[___]:=1;


(* Other square roots *)
Tex[expr:Times[Power[num_?NumberQ,-1/2],___]]:=Module[{
numfactor=ExtractNumericalFactor[expr Sqrt[num]],
numer=Numerator[expr Sqrt[num]],
denom1=Denominator[expr Sqrt[num]]
},
If[Or[!$TexFractionAsFraction,NumberQ[denom1]],
StringJoin[TexFracExpression[Numerator[numfactor],Denominator[numfactor]Sqrt[num],$TexSmallFraction],TexFactor[expr Sqrt[num]/numfactor]],
TexFracExpression[numer,denom1 Sqrt[num],$TexFraction]]
];


(* Power *)
TexOperator[Power]:="^";
TexBase[x:(_Symbol|_Integer|_?xTensorQ[___])]:=Tex[x];
TexBase[x:Scalar[expr_]]:=Tex[x]/;$TexScalarParentheses;
TexBase[x_]:=StringJoin[TexOpen["("],Tex[x],TexClose[")"]];
TexExponent[x_]:=Block[{$TexSmallFraction=$TexSmallFractionExponent},With[{tex=Tex[x]},If[StringLength[tex]===1,tex,StringJoin["{",tex,"}"]]]];
(*Tex[Power[x_,-1]]:=StringJoin["\\frac{1}{",Tex[x],"}"]/;ByteCount[x]<200;*)
Tex[Power[x_,-1]]:=TexFracExpression[1,x,$TexFraction]/;$TexFractionAsFraction;
Tex[Power[x_,n_]]:=StringJoin[TexBase[x],TexOperator[Power],TexExponent[n]];


(* Abs *)
Tex[Power[Abs[x_],n_]]:=StringJoin[TexOpen["|"],Tex[x],TexClose["|"],TexOperator[Power],TexExponent[n]];
Tex[Abs[x_]]:=StringJoin[TexOpen["|"],Tex[x],TexClose["|"]];


(* Basis *)


Tex[Basis[a_,b_]]:=TexBasis[a,b]


TexBasis[inds__]:=StringJoin[Tex[Basis],TexIndices[inds]];


FormatTexBasis[{i_Integer,basis_?BasisQ},texstring_String]:=SetDelayed[TexBasis[ind_,{i,basis}],StringJoin[texstring,TexIndices[ind]]];
FormatTexBasis[{i_Integer,basis_?BasisQ}]:=Unset[TexBasis[ind_,{i,basis}]];
FormatTexBasis[{i_Integer,-basis_?BasisQ},texstring_String]:=
SetDelayed[TexBasis[{i,-basis},ind_],StringJoin[texstring,TexIndices[ind]]];


FormatTexBasis[covd_Symbol?CovDQ[{i_Integer,basis_}],texstring_String]:=SetDelayed[TexCovDPrefix[covd,IndexList[{i,basis}]],texstring];
FormatTexBasis[covd_Symbol?CovDQ[{i_Integer,basis_}]]:=Unset[TexCovDPrefix[covd,IndexList[{i,basis}]]]


(* Tensors *)
Tex[tensor_?xTensorQ[indices___]]:=StringJoin[Tex[tensor],TexIndices[indices]];


(* Derivatives of scalar functions *)
deriv[var_,1]:="\\partial "<>Tex[var];
deriv[var_,n_]:="\\partial^{"<>Tex[n]<>"}"<>Tex[var];
withrespectto[vars_List,ders_List]:=Inner[withrespectto,vars,ders,StringJoin];
withrespectto[var_,0]:="";
withrespectto[var_,1]:="\\partial "<>Tex[var];
withrespectto[var_,n_]:="\\partial "<>Tex[var]<>"^{"<>Tex[n]<>"}";
Tex[Derivative[ders__][f_?ScalarFunctionQ][vars__]]:="\\frac{"<>deriv[f[vars],Plus[ders]]<>"}{"<>withrespectto[{vars},{ders}]<>"}";


Tex[Factorial[n_Symbol]]:=StringJoin[Tex[n],"!"]
Tex[Factorial[n_]]:=StringJoin[TexOpen["("],Tex[n],TexClose[")"],"!"]
Tex[Factorial2[n_Symbol]]:=StringJoin[Tex[n],"!!"]
Tex[Factorial2[n_]]:=StringJoin[TexOpen["("],Tex[n],TexClose[")"],"!!"]
Tex[Pochhammer[n_,k_]]:=StringJoin[TexOpen["("],Tex[n],TexClose[")"],"_{",Tex[k],"}"]
Tex[Binomial[n_,k_]]:=StringJoin["\\binom{",Tex[n],"}{",Tex[k],"}"]


(* Other scalar functions *)
Tex[f_?ScalarFunctionQ[args__]]:=StringJoin[Tex[f],TexOpen["("],Sequence@@InsertComma[Tex/@{args}],TexClose[")"]];
InsertComma[arguments_List]:=Insert[arguments,", ",List/@Range[2,Length[arguments]]];


(* Remove the Scalar head *)
$TexScalarParentheses=True;
Tex[Scalar[expr_]]:=If[$TexScalarParentheses,
StringJoin[TexOpen["("],Tex[expr],TexClose[")"]],
Tex[expr]
];


(* Covariant derivatives *)
Tex[covd_Symbol?CovDQ[inds__][expr_]]:=TexCovDCombine[covd,Tex[expr],IndexList[inds],$CovDFormat];
TexCovDCombine[covd_,exprstring_String,list_IndexList,"Prefix"]:=StringJoin[TexCovDPrefix[covd,list],exprstring];
TexCovDPrefix[covd_,list_IndexList]:=StringJoin[Last@TexCovD[covd],TexIndices@@list];
TexCovDCombine[covd_,exprstring_String,list_IndexList,"Postfix"]:=StringJoin[exprstring,TexCovDIndices[First@TexCovD@covd]@@list];
(* If the $CovDFormat only gives one string, use it for both cases. *)
TexCovD[covd_]:=Tex/@SymbolOfCovD[covd];


(* Lie derivatives *)
Tex[LieD[n_Symbol[_]][expr_]]:="\\mathcal{L}_"<>Tex[n]<>" "<>Tex[expr];


(* Brackets *)
Tex[Bracket[expr1_,expr2_]]:=StringJoin[TexOpen["["],Tex[expr1],", ", Tex[expr2],TexClose["]"]];


(* Parametric derivative *)
TexParamD[{ps_}]:="\\partial_"<>Tex[ps]<>" ";
TexParamD[ps:{__}]:="\\partial_"<>Tex[First[ps]]<>"^{"<>ToString[Length[ps]]<>"} ";
Tex[ParamD[ps__][expr_]]:=If[$ParamDFormat=="Postfix",
StringJoin[Tex[expr],"{}_{,",Sequence@@(Tex/@{ps}),"}"],Apply[StringJoin,TexParamD/@Split@Sort[{ps}]]<>Tex[expr]
];
(*
Tex[ParamD[ps__][expr_]]:=Apply[StringJoin,TexParamD/@Split@Sort[ps]]<>TexOpen["["]<>Tex[expr]<>TexClose["]"];
*)


(* Equal *)
Tex[expr_Equal]:=StringJoin[Riffle[Tex/@List@@expr," = "]];


(* Less *)
Tex[expr_Less]:=StringJoin[Riffle[Tex/@List@@expr," < "]];


(* LessEqual *)
Tex[expr_LessEqual]:=StringJoin[Riffle[Tex/@List@@expr," \\leq "]];


(* Less *)
Tex[expr_Greater]:=StringJoin[Riffle[Tex/@List@@expr," > "]];


(* LessEqual *)
Tex[expr_GreaterEqual]:=StringJoin[Riffle[Tex/@List@@expr," \\geq "]];


$TexFixExtraRules={};


(* Note that we remove the dollars! This is because \[Mu]3 is converted into $\mu$3 for instance *)
TexFix[string_String]:=StringReplace[StringReplace[string,"$"->""],Join[{"+-"->"-","+ -"->"- "," _"->"_"," ^"->"^","  "->" ","   "->" ", " }"->"}"},$TexFixExtraRules]];


(* Main. Public *)
TexPrint[expr_,initlevel_:Automatic]:=TexFix@TexParenthesis[ScreenDollarIndices[expr],initlevel];


TexMatrix[M_?MatrixQ,F_: Tex]:=TexFix@Module[{rows=Length[M],cols=Length@First@M},StringJoin["\\left(\\begin{array}{",StringJoin@@ConstantArray["c",{cols}],"}\n",StringJoin[Riffle[StringJoin[Riffle[F/@#," & "]]&/@M,"\\\\\n"]],"\n\\end{array}\\right)"]]


Tex[Hold[expr_]]:=StringJoin[TexOpen["("],Tex[expr],TexClose[")"]];


Tex[sd:HoldPattern[SeriesData[x_,DirectedInfinity[1],coefflist_List,nmin_,nmax_,den_]]]:=Tex[OrderedPlus@@Append[((coefflist[[#]]*x^(-(#-1+nmin)/den))&/@Range@Length@coefflist),TexString@StringJoin["\\mathcal{O}",TexOpen["("],Tex[(x)^(-nmax/den)],TexClose[")"]]]]


Tex[sd:HoldPattern[SeriesData[x_,x0_,coefflist_List,nmin_,nmax_,den_]]]:=Tex[OrderedPlus@@Append[((coefflist[[#]]*OrderedPlus[x,-x0]^((#-1+nmin)/den))&/@Range@Length@coefflist),TexString@StringJoin["\\mathcal{O}",TexOpen["("],Tex[OrderedPlus[x,-x0]^(nmax/den)],TexClose[")"]]]]


Tex[xAct`SymManipulator`SymH[headlist_,sym_,label_]?xTensorQ[inds___]]:=TexSymH[xAct`SymManipulator`SymH[headlist,sym,label][inds]]


Tex[xAct`SymManipulator`CovarD[D1_?CovDQ,T_?xTensorQ,list_]]:=StringJoin[Tex[Last@SymbolOfCovD[D1]],Tex[T]];


TexGroupSymbols[points_,sym_]:=Which[xAct`SymManipulator`SubgroupQ[Symmetric[points],sym],(* Symmetric *)
{"(",")"},
xAct`SymManipulator`SubgroupQ[Antisymmetric[points],sym],(* Antisymmetric *)
{"[","]"},
True,(* Everything else *)
{"Unkown","Unkown"}];


TexSymH[x:(xAct`SymManipulator`SymH[headlist_,sym_,label_][inds___])]:=Module[{texfail=False,n=Length@List[inds],indlist=List@inds,longorbits,orbitgroupsymbols,orbitondowninds,orbitonupinds,downsymorbits,upsymorbits,excludesymdowninds,splitdowninds,splitupinds,downorbitranges,uporbitranges,excludesymupinds,downindexslots,beginsym,endsym,beginexclude,endexclude,preindexsymbolrules,postindexsymbolrules},longorbits=Sort/@Select[Orbits[sym,n],Length[#]>1&];
orbitgroupsymbols=TexGroupSymbols[#,sym]&/@longorbits;
If[Length@Select[orbitgroupsymbols,First[#]==="Unkown"&]>0,texfail=True;
Print["Not a disjoint union of symmetric and antisymmetric groups."];];
downindexslots=Select[Range[1,Length@indlist],DownIndexQ[indlist[[#]]]&];
orbitondowninds=xAct`SymManipulator`Private`subsetQ[#,downindexslots]&/@longorbits;
orbitonupinds=Length[Intersection[#,downindexslots]]==0&/@longorbits;
If[Not[And@@MapThread[Or,{orbitondowninds,orbitonupinds}]],texfail=True;
Print["Not all indices are in good positions."]];
downsymorbits=Pick[longorbits,orbitondowninds];
upsymorbits=Pick[longorbits,orbitonupinds];
If[Not@And[OrderedQ[Join@@downsymorbits],OrderedQ[Join@@upsymorbits]],texfail=True;
Print["The symmetries are overlapping."]];
downorbitranges=Intersection[Range[First@#,Last@#],downindexslots]&/@downsymorbits;
uporbitranges=Intersection[Range[First@#,Last@#],Complement[Range@n,downindexslots]]&/@upsymorbits;
splitdowninds=Sequence@@@Table[SplitBy[Evaluate[downorbitranges[[i]]],MemberQ[Evaluate[downsymorbits[[i]]],#]&],{i,Length@downsymorbits}];
splitupinds=Sequence@@@Table[SplitBy[Evaluate[uporbitranges[[i]]],MemberQ[Evaluate[upsymorbits[[i]]],#]&],{i,Length@upsymorbits}];
excludesymdowninds=Select[splitdowninds,Not@IntersectingQ[Sequence@@@downsymorbits,#]&];
excludesymupinds=Select[splitupinds,Not@IntersectingQ[Sequence@@@upsymorbits,#]&];
beginsym=Join[First/@downsymorbits,First/@upsymorbits];
endsym=Join[Last/@downsymorbits,Last/@upsymorbits];
beginexclude=Join[First/@Select[excludesymdowninds,(Length@#>0)&],First/@Select[excludesymupinds,(Length@#>0)&]];
endexclude=Join[Last/@Select[excludesymdowninds,(Length@#>0)&],Last/@Select[excludesymupinds,(Length@#>0)&]];
preindexsymbolrules=Rule[#,orbitgroupsymbols[[First@First@Position[longorbits,#,2,1],1]]]&/@beginsym;
postindexsymbolrules=Rule[#,orbitgroupsymbols[[First@First@Position[longorbits,#,2,1],2]]]&/@endsym;
preindexsymbolrules=Join[preindexsymbolrules,Rule[#,"|"]&/@beginexclude];
postindexsymbolrules=Join[postindexsymbolrules,Rule[#,"|"]&/@endexclude];
preindexsymbolrules=Rule[#,(#/.preindexsymbolrules)/.Rule[#,""]]&/@Range[n];
postindexsymbolrules=Rule[#,(#/.postindexsymbolrules)/.Rule[#,""]]&/@Range[n];
If[texfail,Print["Could not typset the SymH object nicely."];
StringJoin["\\underset{",label,"}{Sym}(",TexPrint@xAct`SymManipulator`RemoveSym@x,")"],TexKnownSymH[headlist,n,indlist,preindexsymbolrules,postindexsymbolrules]]]


TexKnownSymH[headlist_,n_, indlist_,preindexsymbolrules_, postindexsymbolrules_]:=Module[{numindices=Length/@SlotsOfTensor/@headlist,partitionedslots,internalexpr, indicesoftensor, texstring="",  texstringtensor="", i=1, CovarDs, newheadlist=headlist},
CovarDs=First/@Position[newheadlist,xAct`SymManipulator`CovarD,2];
While[Length@CovarDs>0,
numindices=ReplacePart[numindices,(#->Sequence[Length@newheadlist[[#,3]],numindices[[#]]-Length@newheadlist[[#,3]]])&/@CovarDs];
newheadlist=ReplacePart[newheadlist,(#->Sequence[Last@SymbolOfCovD@newheadlist[[#,1]],newheadlist[[#,2]]])&/@CovarDs];
CovarDs=First/@Position[newheadlist,xAct`SymManipulator`CovarD,2];
];
(* Extract indices belonging to the different tensors. Can this be done in a simpler way? *)
partitionedslots=Last/@Rest@FoldList[{Drop[#1[[1]],#2],Take[#1[[1]],#2]}&,{Range[n],{}},numindices];
indicesoftensor=indlist[[#]]&/@partitionedslots;
While[i<=Length@newheadlist,
texstringtensor= TexTensorWithSym[newheadlist[[i]],indicesoftensor[[i]],partitionedslots[[i]] ,preindexsymbolrules, postindexsymbolrules];
texstring=StringJoin[texstring,texstringtensor];
i=i+1];
texstring]


TexTensorWithSym[head_,inds_,slots_,preindexsymbolrules_, postindexsymbolrules_]:=Module[{texstring=Tex@head, i=1, fromdown,postindexsymbol=""},
While[i<=Length[inds],
texstring=StringJoin[texstring,TexSymIndex[inds[[i]],i==1,fromdown,slots[[i]]/.preindexsymbolrules]];
fromdown=DownIndexQ[inds[[i]]];
postindexsymbol=slots[[i]]/.postindexsymbolrules;
texstring=StringJoin[texstring,postindexsymbol];
i=i+1;];
If[Length@inds>0, texstring=StringJoin[texstring,"}"]];
texstring]


TexSymIndex[index_,firstindexQ_,fromdownQ_,preindexsymbol_]:=
Module[{indexstring},
indexstring=Which[
firstindexQ&&DownIndexQ[index]&&Not[$TexPrintInitialBracesQ],"_{",
firstindexQ&&DownIndexQ[index]&&$TexPrintInitialBracesQ,"{}_{",
firstindexQ&&Not[$TexPrintInitialBracesQ],"^{",
firstindexQ&&$TexPrintInitialBracesQ,"{}^{",
fromdownQ&&DownIndexQ[index],"",
fromdownQ,"}{}^{",
DownIndexQ[index],"}{}_{",
True,""];
StringJoin[indexstring,preindexsymbol,TexUpIndex[UpIndex @index]]]


(* Wedge *)
TexOperator[Wedge]:=" \\wedge ";
Tex[expr_Wedge]:=StringJoin@@Riffle[TexFactor/@List@@expr,TexOperator[Wedge]];


(* Exterior derivative *)
TexOperator[xAct`xTerior`Diff]:=" d ";
Tex[HoldPattern[xAct`xTerior`Diff[expr_Wedge|expr_Plus|expr_Times,covd___]]]:=StringJoin[TexOperator[xAct`xTerior`Diff],If[covd===PD,"",StringJoin["^{",Tex[SymbolOfCovD[covd][[2]]],"}"]],TexOpen["("],Tex[expr],TexClose[")"]];
Tex[HoldPattern[xAct`xTerior`Diff[expr_,covd___]]]:=StringJoin[TexOperator[xAct`xTerior`Diff],If[covd===PD,"",StringJoin["^{",Tex[SymbolOfCovD[covd][[2]]],"}"]],Tex[expr]];


(* Coframe and dx *)
Tex[xAct`xTerior`Coframe[man_]]:="\\theta";
Tex[xAct`xTerior`dx[man_]]:="dx";


Tex[xAct`xTerior`Hodge[met_]]:=StringJoin["{*}_{",Tex[met],"}"];
Tex[xAct`xTerior`Hodge[met_][expr_Wedge|expr_Plus|expr_Times]]:=StringJoin[Tex[xAct`xTerior`Hodge[met]],TexOpen["("],Tex[expr],TexClose[")"]];Tex[xAct`xTerior`Hodge[met_][expr_]]:=StringJoin[Tex[xAct`xTerior`Hodge[met]],Tex[expr]];
Tex[xAct`xTerior`Codiff[met_]]:=StringJoin["\\delta_{",Tex[met],"}"];
Tex[xAct`xTerior`Codiff[met_][expr_Wedge|expr_Plus|expr_Times]]:=StringJoin[Tex[xAct`xTerior`Codiff[met]],TexOpen["("],Tex[expr],TexClose[")"]];
Tex[xAct`xTerior`Codiff[met_][expr_]]:=StringJoin[Tex[xAct`xTerior`Codiff[met]],Tex[expr]];
Tex[xAct`xTerior`CartanD[v_?xTensorQ[a_]][expr_Wedge|expr_Plus|expr_Times,covd_]]:=StringJoin["\\mathcal{L}",If[Or[Length@{covd}==0,covd===xAct`xTensor`PD],"",StringJoin["^{",Tex@Last@SymbolOfCovD[covd],"}{}"]],"_{",Tex[v],"}",TexOpen["("],Tex[expr],TexClose[")"]];
Tex[xAct`xTerior`CartanD[v_?xTensorQ[a_]][expr_,covd___]]:=StringJoin["\\mathcal{L}",If[Or[Length@{covd}==0,covd===xAct`xTensor`PD],"",StringJoin["^{",Tex@Last@SymbolOfCovD[covd],"}{}"]],"_{",Tex[v],"}",Tex[expr]];
Tex[HoldPattern[xAct`xTerior`Int[v_?xTensorQ[a_]][expr_]]]:=StringJoin["\\iota_{",Tex[v],"}",Tex[expr]];
Tex[HoldPattern[form:(xAct`xTerior`ChristoffelForm|xAct`xTerior`ConnectionForm|xAct`xTerior`RiemannForm|xAct`xTerior`CurvatureForm|xAct`xTerior`TorsionForm)[covd_,vb___]]]:=Tex@PrintAs@form;


Options[TexBreak]={TexBreakBy->"Character",TexBreakAt->" + "|" - ",TexBreakString->" \\nonumber \\\\ \n&&",EquationMarks->False};


BreakingFunction[rulelist_,n_]:=With[{best=Select[rulelist,#[[1]]<=n&]},If[Length@best==0,Last@First[rulelist],Last@Last@best]]


TexBreak[string_String,n_,l_List,options___]:=Module[{splittablePositions,breakat,breakby,breakstring,splitat,positions,perLine,splitted,texedwidth,splitstructure,mark,pagewidth},
{breakat,breakby,breakstring,mark}={TexBreakAt,TexBreakBy,TexBreakString, EquationMarks}/.CheckOptions[options]/.Options[TexBreak];

(* Positions where the string can be split: wherever + or - is encountered *)
(* Older code: splittablePositions=First/@StringPosition[string,breakat]; *)

(* Count the bracket level and split only when breakat appears at bracket level 0. *)
(* At which position do we find breakat or brackets? *)
splittablePositions=First/@StringPosition[string,Append[Append[breakat,"{"],"}"]];
(* Construct a structure of the kind {pos, n, notbracketQ}, where pos is the position of the character, n is 1 for opening brackets, -1 for closing brackets and 0 for everything else. *)
splitstructure=Switch[StringTake[string,{#}],"{",{#,1,False},"}",{#,-1,False},_,{#,0,True}]&/@splittablePositions;
(* Compute the bracket level by accumulating the n's. Return a structure {pos, possiblebreakQ}, and extract the possible breaking positions. *)
splitstructure=MapThread[{#1[[1]],And[#2==0,#1[[3]]]}&,{splitstructure,Accumulate[#[[2]]&/@splitstructure]}];
splittablePositions=First/@Select[splitstructure,#[[2]]&];

(* The terms/characters per line that the user specified *)
If[l!={},perLine=SparseArray[l,Automatic,n],perLine={n}];

(* Positions at which the string will be split *)
Switch[breakby,

"Character",
positions={};
Module[{iter,currentPosition=0,nearestPosition,strlen=StringLength[string]},
(* Split parts where lengths are given explicitly *)For[iter=1,(iter<=Length[perLine])&&(currentPosition+perLine[[iter]]<strlen),iter++,

nearestPosition=Nearest[Select[splittablePositions-currentPosition,Positive],perLine[[iter]]];

If[nearestPosition!={},
currentPosition+=First@nearestPosition;
AppendTo[positions,currentPosition],
currentPosition=strlen
];
];

(* Split remainder into strings of length~n) *)While[(currentPosition+n<strlen),nearestPosition=Nearest[Select[splittablePositions-currentPosition,Positive],n];
If[nearestPosition!={},
currentPosition+=First@nearestPosition;
AppendTo[positions,currentPosition],
currentPosition=strlen
];
];
],

"Term",
(* The terms at which we want to split *)
splitat=Accumulate[perLine];

(* Pad out every n terms *)splitat=Flatten[AppendTo[splitat,Range[Last[splitat]+n,Length[splittablePositions],n]]];

(* Remove split points which are past the end of the string *)splitat=Select[splitat,#<=Length[splittablePositions]&];

(* The positions in the string to split at *)
positions=Map[Part[splittablePositions,#]&,splitat];,

"TexPoint",
positions={};
splitted=StringTake[string,Thread[{Prepend[splittablePositions,1],Append[splittablePositions-1,StringLength@string]}]];
texedwidth=TexWidths@@splitted;
pagewidth=First@texedwidth;
texedwidth=Rest@texedwidth;
Module[{nearestTerm},
(* Split parts where lengths are given explicitly *)
While[And[Length@perLine>0,Length@splittablePositions>0],
nearestTerm=BreakingFunction[Thread@Rule[Accumulate@texedwidth, Range@Length@texedwidth],perLine[[1]]/.latextextwidth->pagewidth];
perLine=Rest@Normal@perLine;
If[nearestTerm<=Length@splittablePositions,
AppendTo[positions,splittablePositions[[nearestTerm]]];
splittablePositions=Drop[splittablePositions,nearestTerm];
texedwidth=Drop[texedwidth,nearestTerm],
splittablePositions={};
texedwidth={};];
];
(* Split remainder into strings of length~n) *)
While[Length@splittablePositions>0,
nearestTerm=BreakingFunction[Thread@Rule[Accumulate@texedwidth, Range@Length@texedwidth],n/.latextextwidth->pagewidth];
If[nearestTerm<=Length@splittablePositions,
AppendTo[positions,splittablePositions[[nearestTerm]]];
splittablePositions=Drop[splittablePositions,nearestTerm];
texedwidth=Drop[texedwidth,nearestTerm],
splittablePositions={};
texedwidth={};];
];
],

_,
Throw["Invalid value for option TexBreakBy."]

];

(* Split string *)
AddEquationMarks[StringInsert[string,breakstring,positions],mark]
];
(* Shortcuts and defaults *)
TexBreak[string_String,n_,options___]:=TexBreak[string,n,{},options];
TexBreak[string_String,options___]:=TexBreak[string,200,{},options];


Protect[latextextwidth];


$TexDirectory=$TemporaryDirectory;
$TexTmpDirectory=$TemporaryDirectory;


If[StringMatchQ[System`$Version,"*Linux*"],Module[{latexlist},latexlist=ReadList["!$SHELL -l -c 'which pdflatex'",String];
If[Length@latexlist>0,$LatexExecutable=StringJoin[First@latexlist," -interaction nonstopmode -halt-on-error"],
$LatexExecutable:="pdflatex -interaction nonstopmode -halt-on-error"];],
$LatexExecutable:="pdflatex -interaction nonstopmode -halt-on-error";
];


$TexInitLatexClassCode="\\documentclass[10pt,a4paper]{article}";


$TexInitLatexPackages={"{amssymb}", "{amsmath}", "{amsthm}", "{latexsym}"};


$TexInitLatexExtraCode={};


TexInitLatexCode[]:=StringJoin[$TexInitLatexClassCode,StringJoin[StringJoin["\\usepackage",#,"\n"]&/@$TexInitLatexPackages],StringJoin[StringJoin[#,"\n"]&/@$TexInitLatexExtraCode]]


TexWidthsWriteFile[strs___]:=
Module[{tmpfile=OpenWrite["TexActWidthTest.tex"]},
WriteString[tmpfile,TexInitLatexCode[]];
WriteString[tmpfile,"\\newlength{\\widthofexpr}
\\newcommand{\\testwidth}[1]{\\settowidth{\\widthofexpr}{\\hbox{$\\displaystyle{}#1$}}}
\\newcommand{\\writewidth}[1]{\\settowidth{\\widthofexpr}{\\hbox{$\\displaystyle{}#1$}}
\\immediate\\write0{\\the\\widthofexpr}}
\\begin{document}\n"];
WriteString[tmpfile,StringJoin["\\testwidth{",#,"}\n"]]&/@{strs};WriteString[tmpfile,"\\immediate\\write0{xActWidthStart}\n"];
WriteString[tmpfile,"\\immediate\\write0{\\the\\textwidth}\n"];
WriteString[tmpfile,StringJoin["\\writewidth{",#,"}\n"]]&/@{strs};
WriteString[tmpfile,"\\immediate\\write0{xActWidthEnd}
\\end{document}"];
Close[tmpfile];];


ExtractTexWidths[str1_List]:=With[{str2=Drop[str1,First@First@Position[str1,"xActWidthStart",1,1]]},ToExpression/@(StringReplace[#,"pt"->""]&/@Take[str2,First@First@Position[str2,"xActWidthEnd",1,1]-1])]


TexWidths[strs___]:=
Module[{TexOut,errorpos},
SetDirectory[$TexTmpDirectory];
TexWidthsWriteFile[strs];
TexOut=ReadList["!"<>$LatexExecutable<>" TexActWidthTest.tex",String];
errorpos=DeleteFile[{"TexActWidthTest.tex","TexActWidthTest.log","TexActWidthTest.aux"}];
If[errorpos=!=Null,Print["Tex Error: could not delete temporary files"]];
ResetDirectory[];
If[Length@Position[TexOut,"xActWidthEnd",1,1]==1,
ExtractTexWidths@TexOut,
errorpos=Position[TexOut,str_String?(StringMatchQ[#,StartOfString ~~ "!"~~___]&)];
If[Length@errorpos>0,
Print["Tex Error:\n",Sequence@@Drop[TexOut,First@First@errorpos-1]],
Print["Tex Error:\n",Sequence@@TexOut];
];
Throw["Tex Error"]
]
];


$TexPrintPageWidth=latextextwidth;


TexPrintAlignedEquations[eq_Equal]:=TexPrintAlignedEquations[{eq}]


LHSpart[a_==b_]:=a


RHSpart[a_==b_]:=b


LHSpart[b_]:=""


RHSpart[b_]:=b


TexPrintAlignedEquations[eqlist:{eqs___}]:=Module[{TexLHS=TexPrint[LHSpart@#]&/@eqlist,TexRHS=TexPrint[RHSpart@#]&/@eqlist,LHSWidths,MaxRHSWidth,pagewidth},LHSWidths=xAct`TexAct`Private`TexWidths@@(StringJoin[#," ={}"]&/@TexLHS);
pagewidth=First@LHSWidths;
LHSWidths=Rest@LHSWidths;
MaxRHSWidth=Round[($TexPrintPageWidth/.latextextwidth->pagewidth)-Max@LHSWidths];
TexRHS=TexBreak[#,1,TexBreakBy->"Term",TexBreakString->"\n"]&/@TexRHS;
TexRHS=TexBreak[#,MaxRHSWidth,TexBreakBy->"TexPoint",TexBreakString->"\\nonumber\\\\\n&"]&/@TexRHS;
TexRHS=StringReplace[#,"\n\\nonumber"->"\\nonumber"]&/@TexRHS;
StringJoin["\\begin{align}\n",StringReplace[StringJoin[Riffle[MapThread[StringJoin[#1,"={}&",#2]&,{TexLHS,TexRHS}],",\\\\\n"]],",\\\\\n="-> "\\\\\n="],".\n\\end{align}"]]


TexPrintAlignedExpressions[list_List]:=Module[{Texed=TexPrint/@list},
Texed=TexBreak[#,1,TexBreakBy->"Term",TexBreakString->"\n"]&/@Texed;
Texed=TexBreak[#,$TexPrintPageWidth,TexBreakBy->"TexPoint",TexBreakString->"\\nonumber\\\\\n&"]&/@Texed;
Texed=StringReplace[#,"\n\\nonumber"->"\\nonumber"]&/@Texed;
StringJoin["\\begin{align}\n&",StringJoin[Riffle[Texed,",\\\\\n&"]],".\n\\end{align}"]]


$TexViewExt=".pdf";


AddEquationMarks[string_,mark_:Automatic]:=Switch[mark,
False, string,
Automatic, If[StringTake[string,6]==="\\begin",string,
If[Not@StringMatchQ[string,___~~ "\\\\"~~___],AddEquationMarks[string,"equation"],
With[{firstlinebreak=Last@First@StringPosition[string, "\\\\",1]},
If[StringMatchQ[StringTake[string,firstlinebreak],___~~"&"~~___],
AddEquationMarks[string,"eqnarray"],
If[StringMatchQ[StringTake[string,firstlinebreak],___~~"="~~___],
AddEquationMarks[StringReplace[string,"="->"&=&",1],"eqnarray"],
AddEquationMarks[StringJoin["&&",string],"eqnarray"]]]]]],
_, StringJoin["\\begin{",mark,"}\n", string, "\n\\end{",mark,"}\n"]];


TexWriteFile[str_String,file_String]:=
Module[{outfile=OpenWrite[file]},
WriteString[outfile,TexInitLatexCode[]];
WriteString[outfile,"\\begin{document}\n"];
WriteString[outfile,str];
WriteString[outfile,"\n\\immediate\\write0{TexActFinished}
\\end{document}"];
Close[outfile];];


TexView[texstr_String,file_String:"TexActView",openfileq_:True]:=Module[{TexOut,errorpos},
SetDirectory[$TexDirectory];
TexWriteFile[texstr,StringJoin[file,".tex"]];
TexOut=ReadList[StringJoin["!"<>$LatexExecutable<>" ",file,".tex"],String];
ResetDirectory[];
If[Length@Position[TexOut,"TexActFinished",1,1]==1,
SetDirectory[$TexDirectory];
Print["Typesetting OK."];
If[openfileq,
Print["Opening file: ", file,$TexViewExt];
SystemOpen[StringJoin[file,$TexViewExt]];
];
ResetDirectory[];,
errorpos=Position[TexOut,str_String?(StringMatchQ[#,StartOfString ~~ "!"~~___]&)];
If[Length@errorpos>0,
Print["Tex Error:\n",Sequence@@Drop[TexOut,First@First@errorpos-1]],
Print["Tex Error:\n",Sequence@@TexOut];
];
Throw["Tex Error"]
]
];


TexView[eqlist:{eq_Equal,eqs___ },opt___]:=TexView[TexPrintAlignedEquations[eqlist],opt]
TexView[list_List,opt___]:=TexView[TexPrintAlignedExpressions[list],opt]
TexView[eq_Equal,opt___]:=TexView[TexPrintAlignedEquations[eq],opt]
TexView[expr_,opt___]:=TexView[AddEquationMarks[TexPrint[expr],Automatic],opt]


TexPort[expr_, file_String]:=TexView[expr,file,False];


EnableTexColor[]:=(
TexColor[str_,col_RGBColor]:=StringJoin["\\textcolor[rgb]",ToString[List@@(col)],"{",ToString[str],"}"];
TexColor[str_,RGBColor[1.`,0.`,0.`]|RGBColor[1,0,0]]:=StringJoin["\\red{",ToString[str],"}"];
TexColor[str_,RGBColor[0.`,1.`,0.`]|RGBColor[0,1,0]]:=StringJoin["\\green{",ToString[str],"}"];
TexColor[str_,RGBColor[0.`,0.`,1.`]|RGBColor[0,0,1]]:=StringJoin["\\blue{",ToString[str],"}"];
TexColor2[str_,colrule_Rule]:=TexColor[Removetext@ToString@TeXForm@RemoveStyleBoxes@str,FontColor/.colrule];
TexOrnament[string_String]:=If[StringMatchQ[string,"\!\(\*StyleBox["~~___~~"]\)"],TexColor2@@(ToExpression/@StringSplit[StringDrop[StringDrop[string,12],-2],",",2]),Removetext@ToString@TeXForm@RemoveStyleBoxes@string];
$TexInitLatexPackages=DeleteDuplicates[Append[$TexInitLatexPackages,"{color}"]];
$TexInitLatexExtraCode=DeleteDuplicates[Join[$TexInitLatexExtraCode,{"\\newcommand{\\red}[1]{\\textcolor{red}{#1}}","\\newcommand{\\green}[1]{\\textcolor{green}{#1}}","\\newcommand{\\blue}[1]{\\textcolor{blue}{#1}}"}]];
);


DisableTexColor[]:=(
TexOrnament[string_String]:=Removetext@ToString@TeXForm@RemoveStyleBoxes@string;$TexInitLatexPackages=DeleteCases[$TexInitLatexPackages,"{color}"];
$TexInitLatexExtraCode=DeleteCases[$TexInitLatexExtraCode,Alternatives["\\newcommand{\\red}[1]{\\textcolor{red}{#1}}","\\newcommand{\\green}[1]{\\textcolor{green}{#1}}","\\newcommand{\\blue}[1]{\\textcolor{blue}{#1}}"]];
);


End[]


EndPackage[]


