xAct`SymManipulator`$Version={"0.9.3",{2015,8,12}}


xAct`SymManipulator`$xTensorVersionExpected = {"1.1.0", {2013, 9, 1}};


(* SymManipulator: Symmetrized tensor expressions *)

(* Copyright (C) 2011-2015 Thomas B\[ADoubleDot]ckdahl *)

(* This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License,or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA. 
*)


(* :Title: SymManipulator *)

(* :Author: Thomas B\[ADoubleDot]ckdahl *)

(* :Summary: Symmetrized tensor expressions and irreducible decomposition 
    of spinor expressions *)

(* :Brief Discussion:
   - Handles symmetrized tensor expressions. It also handles irreducible decompositions of spinor expressions, and fundamental spinor operators. *)
  
(* :Context: xAct`SymManipulator` *)

(* :Package Version: 0.9.3 *)

(* :Copyright: Thomas B\[ADoubleDot]ckdahl (2011-2015) *)

(* :History: See SymManipulator.History *)

(* :Keywords: *)

(* :Source: SymManipulator.nb *)

(* :Warning: *)

(* :Mathematica Version: 8.0 and later *)

(* :Limitations:
	- Only abstract indices can be used. *)
	
(* :Acknowledgements:
	This work was partly funded by scholarships from the Albert Einstein 
	Institut and the Wenner-Gren foundarions. Furthermore the autor would like to 
	thank J. M. Mart\[IAcute]n-Garc\[IAcute]a, A. Garc\[IAcute]a-Parrado, Teake Nutma, Leonard Soicher 
	and Peter Cameron for helpful comments. *)


If[Unevaluated[xAct`xCore`Private`$LastPackage]===xAct`xCore`Private`$LastPackage,xAct`xCore`Private`$LastPackage="xAct`SymManipulator`"];


BeginPackage["xAct`SymManipulator`",{"xAct`xTensor`","xAct`xPerm`","xAct`xCore`"}]


Print[xAct`xCore`Private`bars]
Print["Package xAct`SymManipulator`  version ",$Version[[1]],", ",$Version[[2]]];
Print["CopyRight (C) 2011-2015, Thomas B\[ADoubleDot]ckdahl, under the General Public License."];


If[Not@OrderedQ@Map[Last, {xAct`SymManipulator`$xTensorVersionExpected, xAct`xTensor`$Version}], 
	Message[General::versions, "xTensor", xAct`xTensor`$Version, xAct`SymManipulator`$xTensorVersionExpected];
	Abort[]
];


Off[General::shdw]
xAct`SymManipulator`Disclaimer[]:=Print["These are points 11 and 12 of the General Public License:\n\nBECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM `AS IS\.b4 WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.\n\nIN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."]
On[General::shdw]


If[xAct`xCore`Private`$LastPackage==="xAct`SymManipulator`",
Unset[xAct`xCore`Private`$LastPackage];
Print[xAct`xCore`Private`bars];
Print["These packages come with ABSOLUTELY NO WARRANTY; for details type Disclaimer[]. This is free software, and you are welcome to redistribute it under certain conditions. See the General Public License for details."];
Print[xAct`xCore`Private`bars]]


$PrePrint=ScreenDollarIndices;


SymH::usage="SymH[headlist, sym, label][indices] represents a symmetrized tensor expression if the product of the tensors in headlist. The imposed symmetry is sym, and label displayed under the symbol. Observe that traces are taken after the symmetrization. These operations do not generally commute unless they work on disjoint sets of indices.";
ImposeSym::usage="ImposeSym[expr, inds, sym] creates a symmetrized expression equivalent to ImposeSymmetry[expr, inds, sym]. The result is displayed as SymH objects. If expr, already has the symmetry sym, expr is returned as is is. The output is 0 if the result due to single terms symmetries can be reduced to zero. Warning if expr contains traces, the resulting expression will be an expression where the traces are taken after the symmetization. The trace and symmetriation operations do not generally commute unless they work on disjoint sets of indices. The user needs to check that symmetrizations are not taken on contracted indices. Warning, ImposeSym requires expr to be expanded. For general expressions use ImposeSym[Expand@expr, inds, sym]";
ExpandSym::usage ="ExpandSym[expr] expands the SymH objects in expr. If the option SmartExpand is used, a smaller number of terms are produced by using the interplay between the internal symmetry and the imposed symmetry.";
RemoveSym::usage ="RemoveSym[expr] removes the SymH objects in the sence that the first term of ExpandSym[expr] is computed. Observe that traces of the symmetrized expressions are taken after the symmetrization. The trace and symmetriation operations do not generally commute unless they work on disjoint sets of indices. The user needs to check that symmetrizations are not taken on contracted indices.";
RemoveSuperfluousSym::usage ="RemoveSuperfluousSym[expr] if an expression inside a SymH object already has the imposed symmetry, the extra symmetrization will be removed.";
RemoveSuperfluousInnerSym::usage ="RemoveSuperfluousInnerSym[expr] if an expression has nested SymH symbols, and an inner symmetrization is a part of an outer symmetrization, the inner symmetrization will be removed. For instance if an expression is symmetrized over slot 1 and 2, and then symmetrized over slots 1, 2, and 3, then the symmetrization over slot 1 and 2 can be removed.";
RemoveTrivialSym::usage = "RemoveTrivialSym[expr] replaces SymH objects in expr with 0 if they vanish due to single terms symmetries.";
MoveTensorsOutsideSym::usage ="MoveTensorsOutSideSym[expr] moves all tensors that are not part of the symmetry outside the SymH object.";
MoveTensorsInsideSym::usage = "MoveTensorsInsideSym[expr] moves all tensors that inside the SymH object.";
CanonicalizeGroupInSym::usage ="CanonicalizeGroupInSym[expr] finds a canonical representaion of all SymH objects. Observe that the indices are not canonicalized, so the correct usage for complete canonicalization is ToCanonical@CanonicalizeGroupInSym[expr].";
SubgroupQ::usage ="SubgroupQ[sym1, sym2] returns true iff sym1 is a subgroup of sym2.";
CompatibleSymmetric::usage ="CompatibleSymmetric[inds] splits inds into sets accoring to vbundle. The result is then the disjoint union of the symmetric groups on these sets.";
ExpandSymOneIndex::usage ="ExpandSymOneIndex[expr, ExpansionIndex] expands expr so that ExpansionIndex is not part of the symmetry.";
InertHeadHead::usage="InertHeadHead[inerthead, tensorh] a representaiton of a tensor head such that InertHeadHead[H1,T][inds]=H1[T[inds]].";
CovarD::usage ="CovarD[CD, tensorh ,slotlist] a representaiton of a tensor head such that CovarD[CD,T,{-a,-b,...}][inds]=CD[-a, -b,...][T[inds]]].";
ZeroTensor::usage ="ZeroTensor[slotlist_] is a representation of the zero tensor with slots defined by slotlist. That is ZeroTensor[{TangentM, ...}][-a, ...]=0.";
TensorToZeroRule::usage="TensorToZeroRule[tensorhead] makes a replacement rule tensorhead->ZeroTensor[slotlist] with the aproproate slotlist.";
MoveSymIndicesDown::usage ="MoveSymIndicesDown[expr] moves the indices in the SymH objects so that the symmetrized indices are in a down position. This position is required for a good TexPrint output. Warning, this function requires that all indices can be moved with the metric. This check is not done automatically.";
SortTensorsInSym::usage = "SortTensorsInSym[expr] sorts the tensors in the SymH objects alphabetically.";
IrrDecompose::usage = "IrrDecompose[expr] computes the irreducible decomposition of over all spinor indices.";
CompleteIrrDecompose::usage = "CompleteIrrDecompose[expr] computes the irreducible decomposition of over all spinor indices. The symmetries of expr is then imposed on the resulting expression. This can also be done with the option UseSym in IrrDecompose.";
UseSym::usage="UseSym is an option for IrrDecompose. If this option is set to True, then the symmetries of the expression is omposed on the decomposed expression. This often simplifies the expression.";
IrrDecImposeNewMethod::usage ="An option for IrrDecompose.";
ResultType::usage="An option for IrrDecompose. The default is\"Expression\". Other possibilities are \"Equation\", \"Rule\" or \"CompareRule\".";
InternalCommutingSymmetry::usage = "InternalCommutingSymmetry is a tag that describes the part of the internal symmetry of a SymH object that commutes with the imposed symmetry.";
SmartExpand::usage ="An option for ExpandSym.";
ImposeLargerSym::usage ="An option for ImposeSym.";
ImposeSuperfluousSym::usage ="An option for ImposeSym.";
deltaH::usage ="deltaH[vbundle] is the delta on the vector bundle vbundle.";
ContractMetricsInsideSym::usage ="ContractMetricsInsideSym[expr] checks if any SymH object has a metric inside that can be contracted, and contracting this.";
SmartSymmetrize::usage ="Does the same thing as Symmetrize, but reducing the number of terms due to the internal symmetry.";
SmartAntisymmetrize::usage ="Does the same thing as Antisymmetrize, but reducing the number of terms due to the internal symmetry.";
ExpandInternalSym::usage="Applies ExpandSym to the internal expression of a SymH object.";
ToCanonicalSym::usage="Runs CanonicalizeGroupInSym followed by ToCanonical.";
RuleInSym::usage ="Applies a rule inside a SymH object. Observe that this can decanonicalize all SymH objects.";
FunctionInSym::usage="Applies a function inside a SymH object. Observe that this can decanonicalize all SymH objects.";
$MixedSymSpecialCode::usage = "Default True, General code False. Old behaviour SetStabilizer. Observe that SetStabilizer gives only a subgroup of the correct group, but it is faster.";
TransversalInSymmetricGroup::usage ="TransversalInSymmetricGroup[H_StrongGenSet,G_Symmetric] computes the transversal of H in G. If H is not a subgroup, an error is thrown. (Not tested well.)";
$MixedSymVerbose::usage ="Display timing info from MixedSymmetry calculations.";
SymmetryOfExpression::usage ="SymmetryOfExpression[expr] computes the symmetry group of the free indices of expr and returns a strong generating set and a list of the free indices.";
MakeCompareRule::usage = "MakeCompareRule is used in the same way as MakeRule, but only one rule is generated. When applied to an expression, it is compared to the LHS. If a match is found it is replaced by the corresponding RHS. At the moment the LHS can only be a single tensor, a product of tensors, or a covariant derivative of a single tensor.";
CompatibleSymQ::usage ="CompatibleSymQ[vbundles, sym] returns true if the total symmetry is a subgroup of sym. Each vbundle gives a symmetric group. The total symmetry if the union of these groups. Signs of vbundles are dropped before the rest of the computation.";
RemoveSuperfluousPartialSym::usage = "Tries to factor the imposed group, and remove superfluous factors. It is also an option for ToCanonicalSym.";
IrrDecSpinBundles::usage ="An option for IrrDecompose and CompleteIrrDecompose.";
ExpandBox::usage ="ExpandBox[expr,CDe] converts the BoxCDe in expr to curvature.";
DefFundSpinOperators::usage ="DefFundSpinOperators[CDe] defines the operators DivCDe, CurlCDe, CurlDgCDe and TwistCDe what acts on symmetric spinors. Also commutator rules like CommuteDivCurlCDe are defined.";
HideCovDSymbolReference::usage="HideCovDSymbolReference is an option for DefFundSpinOperators. If set to True, the default PrintAs command for the derived symbols will not contain a bracket with the covd symbol.";
ShowValenceInfo::usage="ShowValenceInfo is an option for DefFundSpinOperators. If set to True, the default PrintAs command for the operators will contain numbers indicating the valence of the spinor it acts on.";
UndefFundSpinOperators::usage ="UndefFundSpinOperators[CDe] undefines all objects defined by DefFundSpinOperators[CDe].";
FundSpinOpQ::usage="FundSpinOpQ[op] returns True if the symbol op is a fundamental spinor operator.";
CovDOfFundSpinOp::usage="CovDOfFundSpinOp[op] returns the covariant derivative associated with the fundamental spinor operator op.";
ImposeFundSpinOp::usage="ImposeFundSpinOp[expr, op, {inds}] applies the fundamental spinor operator op to expr and gives the result the indices inds.";
ExpandFundSpinOp::usage="ExpandFundSpinOp[expr, covd] expands the fundamental spinor operators related to covd into symmetrized derivatives.";
FunctionInFundSpinOp::usage="FunctionInFundSpinOp[expr, func, l, outerfunc] applies the function func, inside the fundamental spinor operators at level l. The optional function outerfunc is applied to the results at all lower levels. The default level is 1 and the default outerfunc is Identity.";
IrrDecomposeCovD::usage="IrrDecomposeCovD[covd[...]@T[...]] produces the irreducible decomposition of covd[...]@T[...] using the corresponding fundamental operators.
IrrDecomposeCovD[T, covd] does the same, but you do not have to give any indices.";
ToFundSpinOp::usage="ToFundSpinOp[expr, covd] tries to represent all covariant spinor derivatives in expr in terms of the fundamental spinor operators. When several nested derivatives appear, one might need to apply the function several times.";
CommuteFundSpinOp::usage="CommuteFundSpinOp[op1,op2] gives the commutator rule for the fundamental spinor operators op1, op2. Observe that this function only gives the proper commutator relations. There are other commutator like relations with two derivative terms in the right hand side. CommuteFundSpinOp[op1,op2,op3,op4] gives a commutator like rule where op1[op2[expr]] is turned into an expression with a term op3[op4[expr]] if possible.";
GetIndexRange::usage="GetIndexRange[k, vbundle] gives the first k indices of vbundle. New indices are constructed if needed.";
GiveIndicesToTensor::usage ="GiveIndicesToTensor[TT] gives the tensor TT down indices in the correct vbundles. A list of vbundles can be given as a second argument. Indices in these vbundles will then be up indices.";
ChangeFreeIndicesToDefault::usage ="ChangeFreeIndicesToDefault[expr] changes the free indices of expr. The indices are taken from the beginning of the list of indices for the corresponding VBundle. A list of VBundles can be given as a second argument. Free indices belonging to these VBundles are given up indices. The default is that all new free indices are down. The dummy indices are also changed.";
MoveCovDInsideSym::usage=="MoveCovDInsideSym is a rule that moves covariant derivatives inside SymH objects.";
FindTensorCoefficients::usage=="FindTensorCoefficients[expr,{T1[...], T2[...]T3[...]}] finds the coefficients of the tensor expressions T1[...] and T2[...]T3[...] in expr. The result is a list of the form {{rest, 1},{c1, T1[...]},{c2, T2[...]T3[...]}}. Plus@@Times@@@FindTensorCoefficients[expr, {...}] is equivalent to expr, but with tensors collected." ;
SpatialSpinCovDQ::usage ="SpatialSpinCovDQ Reserved for spatial spinors.";


Begin["`Private`"]


$ContextPath


MathLinkBaseChangeStabilizerChain[sgs_,newbase_]:=MathLinkBaseChangeStabilizerChain[sgs,newbase,Max[PermLength@sgs,Max@newbase]]


MathLinkBaseChangeStabilizerChain[sgs_,newbase_,len_]:=
Module[{tmp},
tmp=Drop[xAct`xPerm`Private`TMPHead[
len+2,
xAct`xPerm`Private`tosgslist[sgs,len,False],
newbase
],{2}];
TranslatePerm[xAct`xPerm`Private`ToSign[#,len],NotationOfPerm[sgs]]&/@Apply[xAct`xPerm`Private`MLBaseChangeStabilizerChain,tmp]];


MathLinkBaseChange[sgs_,newbase_,len_,options___]:=
Module[{tmp},
tmp=Drop[xAct`xPerm`Private`TMPHead[
len+2,
xAct`xPerm`Private`tosgslist[sgs,len,False],
newbase
],{2}];
TranslatePerm[xAct`xPerm`Private`ToSign[Apply[xAct`xPerm`Private`MLBaseChange,tmp],len],NotationOfPerm[sgs]]
];


Options[BaseChange2]={MathLink->MemberQ[LinkPatterns[$xpermLink]/.HoldForm->Head,xAct`xPerm`Private`MLBaseChange]};


BaseChange2[sgs_StrongGenSet,newbase_]:=BaseChange2[sgs,newbase,Max[PermLength@sgs,Max@newbase]]


BaseChange2[StrongGenSet[base_, gs_],base_,len_]:=StrongGenSet[base, gs];


BaseChange2[sgs_,newbase_,len_,options:OptionsPattern[]]:=If[OptionValue[MathLink],MathLinkBaseChange,BaseChange][sgs,newbase,len,options];


MathLinkStabilizerSGS[pts_,sgs_,len_]:=
Module[{tmp},
tmp=Drop[xAct`xPerm`Private`TMPHead[
len+2,
xAct`xPerm`Private`tosgslist[sgs,len,False],
pts
],{2}];
TranslatePerm[xAct`xPerm`Private`ToSign[Apply[xAct`xPerm`Private`MLStabilizerSGS,tmp],len],NotationOfPerm[sgs]]
];


Options[StabilizerSGS]={MathLink->MemberQ[LinkPatterns[$xpermLink]/.HoldForm->Head,xAct`xPerm`Private`StabilizerSGS]};


StabilizerSGS[points_List,SGS_,options:OptionsPattern[]]:=StabilizerSGS[points,SGS,PermLength[SGS],options];
StabilizerSGS[ps_List,Symmetric[list_],options:OptionsPattern[]]:=Symmetric[Complement[list,ps]];
StabilizerSGS[ps_List,Antisymmetric[list_],options:OptionsPattern[]]:=Antisymmetric[Complement[list,ps]];
StabilizerSGS[points_List,SGS:StrongGenSet[base_,GS_],len_Integer,options:OptionsPattern[]]:=If[OptionValue[MathLink],MathLinkStabilizerSGS[points,SGS,len],Stabilizer[points,SGS,len]];


oldPartitionRagged[l_,p_]:=Last/@Rest@FoldList[{Drop[#1[[1]],#2],Take[#1[[1]],#2]}&,{l,{}},p];

If[System`$VersionNumber<8.,partitionRagged=oldPartitionRagged,partitionRagged=Internal`PartitionRagged];


If[System`$VersionNumber<10.,subsetQ[inds1_,inds2_]:=And@@(MemberQ[List@@inds2,#]&/@(List@@inds1)),subsetQ[inds1_,inds2_]:=SubsetQ[inds2,inds1]];


SubgroupQ[sym1:(_Symmetric|_Antisymmetric),sym2_StrongGenSet]:=SubgroupQ[GenSet@sym1,sym2]


SubgroupQ[sym1_,sym2:(_Symmetric|_Antisymmetric)]:=SubgroupQ[sym1,Append[sym2,Cycles]]


SubgroupQ[sym1_StrongGenSet,sym2_StrongGenSet]:=SubgroupQ[Last@sym1,sym2]


SubgroupQ[gs1_GenSet,sym2_StrongGenSet]:=And@@(PermMemberQ[#,sym2]&/@List@@gs1)


GroupSupport[sym:(_Symmetric|_Antisymmetric)]:=Sort@First@sym


GroupSupport[gs1_GenSet]:=xAct`xTensor`Private`support[gs1]


GroupSupport[SGS1_StrongGenSet]:=xAct`xTensor`Private`support[Last@SGS1]


GroupSupport[sym_]:=xAct`xTensor`Private`support[Last@xAct`xTensor`Private`SGSofsym@sym]


TidySGS[sym_]:=DeleteSomeRedundantGenerators@BaseChange2[xAct`xTensor`Private`SGSofsym@sym,GroupSupport@sym]


TidyGroup[sym_]:=Module[{unstablepoints=GroupSupport@sym},
Which[
Length@unstablepoints==0,StrongGenSet[{},GenSet[]],
SubgroupQ[Symmetric@unstablepoints,sym],Symmetric@unstablepoints,
SubgroupQ[Antisymmetric@unstablepoints,sym],Antisymmetric@unstablepoints,
True,TidySGS@sym]]


GroupFactorization1[SGS_StrongGenSet]:=Module[{orbits=Orbits@SGS,factors,prodgroup},
factors=Stabilizer[Flatten@Delete[orbits,#],SGS]&/@Range@Length@orbits;
prodgroup=JoinSGS@@factors;
(* If the group factors completely into ints orbits, return the factorization, otherwise return the group as it is. If we have several orbits the second case can be improved... *)
If[And[SubgroupQ[SGS,prodgroup],SubgroupQ[prodgroup,SGS]],factors,{SGS}]
]


StabilizerChain2[StrongGenSet[base_List,GS_GenSet]]:=Thread@StrongGenSet[Drop[base,#]&/@Range[0,Length@base],FoldList[Stabilizer[{#2},#1]&,GS,base]]


BasicOrbitStabChain[j_Integer,k_Integer,chain_List]:=Orbit[chain[[1,1,j]],chain[[k+1]]]/;k<j;


InterchangeStabChain[chain_List,j_Integer,len_Integer]:=
With[{base=First@First@chain},Module[{Deltaj,Deltajp1,LDeltaBarjp1,T,Gamma,Delta,gamma,p,g1,g2,newT, newbase,newGSj},
Deltaj=BasicOrbitStabChain[j,j-1,chain];
Deltajp1=BasicOrbitStabChain[j+1,j,chain];
LDeltaBarjp1=Length[Deltajp1]Length[Deltaj]/Length[BasicOrbitStabChain[j+1,j-1,chain]];
T=chain[[j+2,2]];
Gamma=Complement[Deltaj,base[[{j,j+1}]]];
Delta={base[[j]]};
While[Length[Delta]!=LDeltaBarjp1,
gamma=First[Gamma];
g1=TraceSchreier[gamma,SchreierOrbit[base[[j]],chain[[j]],len]];
p=OnPoints[base[[j+1]],InversePerm[g1]];
If[MemberQ[Deltajp1,p],
g2=TraceSchreier[p,SchreierOrbit[base[[j+1]],chain[[j+1]],len]];
(* Do we need to check if PermProduct[g2,g1] is already in T before we add it? *)
AppendTo[T,PermProduct[g2,g1]];
Delta=Orbit[base[[j]],T];
Gamma=Complement[Gamma,Delta],
Gamma=Complement[Gamma,Orbit[gamma,T]]
]
];
newT=DeleteCases[Drop[T,Length@chain[[j+2,2]]],Alternatives@@chain[[j,2]]];
newGSj=Stabilizer[{base[[j+1]]},Union[chain[[j,2]],newT]];
newbase=Join[Take[base,j-1],{base[[j+1]],base[[j]]},Drop[base,j+1]];
Join[Thread@StrongGenSet[Drop[newbase,#]&/@Range[0,j],Append[Join[#,newT]&/@chain[[1;;j,2]],newGSj]],Drop[chain,j+1]]
]]


ConjugateStabChain[chain_List,g_?PermQ]:=Module[{newbase=OnPoints[First@First@chain,g],oldGS=Last@First@chain,newGS,l=Length@chain},
newGS=PermProduct[InversePerm[g],#,g]&/@oldGS;
Thread@StrongGenSet[Drop[newbase,#]&/@Range[0,l-1],(#[[2]]&/@chain)/.Thread@Rule[List@@oldGS,List@@newGS]]]


AppendBasePointStabChain[chain_List,p_]:=Append[MapAt[Append[#,p]&,chain,{#,1}&/@Range@Length@chain],StrongGenSet[{},GenSet[]]]


Options[BaseChangeStabChain]={MathLink->MemberQ[LinkPatterns[$xpermLink]/.HoldForm->Head,xAct`xPerm`Private`MLBaseChangeStabilizerChain]};


BaseChangeStabChain[SGS_StrongGenSet,base_,options:OptionsPattern[]]:=BaseChangeStabChain[SGS,base,PermLength[SGS],options];
BaseChangeStabChain[SGS_StrongGenSet,newbase_List,len_,options:OptionsPattern[]]:=If[OptionValue[MathLink],MathLinkBaseChangeStabilizerChain[SGS,newbase,len],BaseChangeStabChain2[StabilizerChain2[SGS],newbase,len]];
BaseChangeStabChain[chain_List,base_,options:OptionsPattern[]]:=BaseChangeStabChain[chain,base,PermLength@First[chain],options];
BaseChangeStabChain[{StrongGenSet[{},GenSet[]]},base_,len_,options:OptionsPattern[]]:=StrongGenSet[#,GenSet[]]&/@(Drop[base,#]&/@Range[0,Length[base]]);
BaseChangeStabChain[chain_List,newbase_List,len_,options:OptionsPattern[]]:=If[OptionValue[MathLink],MathLinkBaseChangeStabilizerChain[First@chain,newbase,len],BaseChangeStabChain2[chain,newbase,len]];


BaseChangeStabChain2[chain_List,newbase_List,len_]:=Module[{i=0,j,g=ID,more,B=First@First@chain,newchain=chain,pos,sorbits={}},
more=If[Length[newbase]>0,
MemberQ[BasicOrbitStabChain[1,0,chain],newbase[[1]]],
False];
If[more,sorbits=SchreierOrbits[Last@First@chain,len]];
While[more,
i=i+1;
g=PermProduct[TraceSchreier[OnPoints[newbase[[i]],InversePerm[g]],sorbits],g];
more=(i+1)<=Min[Length[B],Length[newbase]];
If[more,more=MemberQ[OnPoints[newbase[[i+1]],InversePerm[g]],BasicOrbitStabChain[i+1,i,chain]]]
];
If[Not@PermEqual[g,ID],
newchain=ConjugateStabChain[chain,g];
B=First@First@newchain];
For[j=i+1,j<=Length[newbase],j++,
If[MemberQ[B,newbase[[j]]],pos=Position[B,newbase[[j]]][[1,1]],AppendTo[B,newbase[[j]]];newchain=AppendBasePointStabChain[newchain,newbase[[j]]];pos=Length[B]];
While[pos!=j &&pos>1,newchain=InterchangeStabChain[newchain,pos-1,len];B=First@First@newchain;pos=pos-1];
];
newchain
];


DeleteSomeRedundantGenerators[StrongGenSet[base_,GS_GenSet]]:=Module[{Si,Sip1,i,T=GenSet[],orbit,gens,check,toadd},
Sip1=GenSet[];
check[i_,gen_,t_]:=FreeQ[Orbit[base[[i]],t],OnPoints[base[[i]],gen]];
toadd[i_,gs_,T_]:=Module[{TT=T},If[check[i,#,TT],AppendTo[TT,#]]&/@gs;Complement[TT,T]];
For[i=Length[base],i>=1,i--,
Si=Stabilizer[Take[base,i-1],GS];
gens=Complement[Si,Sip1];
T=Join[T,toadd[i,gens,T]];
Sip1=Si;
];
StrongGenSet[base,T]
];


FindSmallestImage[Delta_List,G_StrongGenSet,n_]:=Module[{MinOrbit,FindFirstAndAppend,MapPoints,GpChain=StabilizerChain2@G,Cands={{{},Delta}},Pass,Mp={},k=Length@Delta,m,i,MRs,FirstSchreierOrbit,xs,gs,DRjs,DRgs},
MinOrbit[expr_]:=Min@Orbit[#,First@GpChain]&/@expr;
FindFirstAndAppend[elements_,cand_]:=Append[cand[[1]],First@First@Position[cand[[2]],#,1,1]]&/@elements;
MapPoints[DR_,gs_]:=OnPoints[DR,#]&/@gs;
For[i=1,i<=k,i+=1,
m=n+1;
MRs=Min[MinOrbit[#]]&/@(Part[#[[2]],Complement[Range[1,k],#[[1]]]]&/@Cands);
While[Length@MRs>0,
If[First@MRs<m,
  {Pass={First@Cands},m=First@MRs},
If[First@MRs==m,Pass=Append[Pass,First@Cands]]];
MRs=Rest@MRs;
Cands=Rest@Cands;];
GpChain=BaseChangeStabChain[GpChain,{m}];
FirstSchreierOrbit=SchreierOrbit[m,First@GpChain,n];
xs=Intersection[First@FirstSchreierOrbit,#[[2]]]&/@Pass;
gs=InversePerm@TraceSchreier[#,FirstSchreierOrbit]&/@#&/@xs;
DRjs=MapThread[FindFirstAndAppend,{xs,Pass}];
DRgs=MapThread[MapPoints[#1[[2]],#2]&,{Pass,gs}];
Cands=MapThread[List,{Flatten[DRjs,1],Flatten[DRgs,1]}];
GpChain=Rest@GpChain;
Mp=Append[Mp,m];
];
Mp]


FindSmallestImageAndMapping[Delta_List, G_StrongGenSet, n_] := Module[{MinOrbit, FindFirstAndAppend, MapPoints, PermProducts, Gp = G, Cands = {{{}, Delta, ID}}, Pass, Mp = {}, k = Length@Delta, m, i, MRs, FirstSchreierOrbit, gs, CandFromPass},
MinOrbit[expr_] := Min@Orbit[#, Gp] & /@ expr;CandFromPass[{JR_, DR_, gperm_}] :=With[{xs = Intersection[First@FirstSchreierOrbit, DR]},gs = InversePerm@TraceSchreier[#, FirstSchreierOrbit] & /@ xs;Sequence @@ MapThread[List, {Append[JR, First@First@Position[DR, #, 1, 1]] & /@ xs, OnPoints[DR, #] & /@ gs, PermProduct[gperm, #] & /@ gs}]
];
For[i = 1, i <= k, i += 1,
m = n + 1;MRs = Min[MinOrbit[#]] & /@ (Part[#[[2]], Complement[Range[1, k], #[[1]]]] & /@ Cands);While[Length@MRs > 0,
If[First@MRs < m,
Pass = {First@Cands}; m = First@MRs,If[First@MRs == m, Pass = Append[Pass, First@Cands]]];
MRs = Rest@MRs;
Cands = Rest@Cands;];
Gp = BaseChange2[Gp, {m}];
FirstSchreierOrbit = SchreierOrbit[m, Gp, n];
Cands = CandFromPass /@ Pass;Gp = StrongGenSet[Rest@First@Gp, Stabilizer[{m}, Gp[[2]]]];
Mp = Append[Mp, m];
];
{Mp, Cands[[1, 3]]}]


FindSmallestImageAndMapping2[Delta_List, G_StrongGenSet, n_] := Module[{MinOrbit, FindFirstAndAppend, MapPoints, PermProducts, GpChain = StabilizerChain2@G, Cands = {{{}, Delta, ID}}, Pass, Mp = {}, k = Length@Delta, m, i, MRs, FirstSchreierOrbit, gs, CandFromPass},
      MinOrbit[expr_] := Min@Orbit[#, First@GpChain] & /@ expr;
      CandFromPass[{JR_, DR_, gperm_}] := With[{xs = Intersection[First@FirstSchreierOrbit, DR]},
            gs = InversePerm@TraceSchreier[#, FirstSchreierOrbit] & /@ xs;
Sequence @@ MapThread[List, {Append[JR, First@First@Position[DR, #, 1, 1]] & /@ xs,OnPoints[DR, #] & /@ gs, PermProduct[gperm, #] & /@ gs}]
];
For[i = 1, i <= k, i += 1,
m = n + 1;MRs = Min[MinOrbit[#]] & /@ (Part[#[[2]], Complement[Range[1, k], #[[1]]]] & /@ Cands);While[Length@MRs > 0,
If[First@MRs < m,
Pass = {First@Cands}; 
m = First@MRs,
If[First@MRs == m, Pass = Append[Pass, First@Cands]]];
MRs = Rest@MRs;
Cands = Rest@Cands;];
GpChain = BaseChangeStabChain[GpChain, {m}];
        FirstSchreierOrbit = SchreierOrbit[m, First@GpChain, n];
        Cands = CandFromPass /@ Pass;
        GpChain = Rest@GpChain;
        Mp = Append[Mp, m];
];
{Mp, Cands[[1, 3]]}]


SmallestGenSet[G_StrongGenSet]:=SmallestGenSet[SmallestBaseStabChain@G]


SmallestGenSet[SmallBaseStabChainG_List]:=Module[{n=PermLength[First@SmallBaseStabChainG],L={},i, Gi,betai,orbbetai,orb,t,x},
i=Length[SmallBaseStabChainG]-1;
While[i>0,
Gi=SmallBaseStabChainG[[i]];
betai=First@First@Gi;
orbbetai=SchreierOrbit[betai,Gi[[2]]];
orb=Complement[First@orbbetai,Orbit[betai,GenSet@@L]];
While[Length[orb]>0,
t=TraceSchreier[Min[orb],orbbetai];
x=SmallestCoset[t,SmallBaseStabChainG[[i+1;;Length[SmallBaseStabChainG]]]];
L=Append[L,x];
orb=Complement[First@orbbetai,Orbit[betai,GenSet@@L]];
];
i=i-1;];
L]


SmallestCoset[p_,G_StongGenSet]:=SmallestCoset[p,SmallestBaseStabChain@G]


SmallestCoset[p_,StabChainG_List]:=Module[{i=1,rep=p, Gi,betai,orb, img, mu, omega,t,x},
While[i< Length[StabChainG],
Gi=StabChainG[[i]];
betai=First@First@Gi;
(* Print["i, betai, rep: ",i,", ",betai,", ",rep];*)
orb=SchreierOrbit[betai,Gi[[2]]];
img=OnPoints[First@orb,rep];
mu=Min[img];
omega=OnPoints[mu,InversePerm[rep]];
t=TraceSchreier[omega,orb];
(* Print["img, mu, omega, omegatest, t: ",img, ", ",mu,", ",omega,", ",OnPoints[betai,t],", ",t ];*)
rep=PermProduct[t,rep];
i=i+1;];
rep]


LargestElementInGroup[G_StongGenSet]:=LargestElementInGroup[SmallestBaseStabChain@G]


LargestElementInGroup[StabChainG_List]:=Module[{i=1,rep=ID, Gi,betai,orb, img, mu, omega,t,x},
While[i< Length[StabChainG],
Gi=StabChainG[[i]];
betai=First@First@Gi;
orb=SchreierOrbit[betai,Gi[[2]]];
img=OnPoints[First@orb,rep];
mu=Max[img];
omega=OnPoints[mu,InversePerm[rep]];
t=TraceSchreier[omega,orb];
rep=PermProduct[t,rep];
i=i+1;];
rep]


RemoveSuperfluousBasePointInStabChain[StabChain_List]:=Module[{firstelem=First@StabChain,tempchain},
If[Length[StabChain]==1,
StabChain,
If[firstelem[[2]]=== StabChain[[2,2]],
RemoveSuperfluousBasePointInStabChain[Rest@StabChain],
tempchain=RemoveSuperfluousBasePointInStabChain[Rest@StabChain];
Prepend[tempchain,StrongGenSet[Prepend[tempchain[[1,1]],firstelem[[1,1]]],firstelem[[2]]]]]]]


SmallestBaseStabChain[G_StrongGenSet]:=RemoveSuperfluousBasePointInStabChain@BaseChangeStabChain[G,Range[PermLength[G]]]


GroupLessOrEqualQ[U_StrongGenSet,V_StrongGenSet]:=Module[{
SmallChainU=SmallestBaseStabChain@U,
SmallChainV=SmallestBaseStabChain@V,
SmallGenSetU,SmallGenSetV,lenU,lenV,MaxElem,n},
n=Max[PermLength[U],PermLength[V]];
SmallGenSetU=SmallestGenSet@SmallChainU;
SmallGenSetV=SmallestGenSet@SmallChainV;
lenU=Length[SmallGenSetU];
lenV=Length[SmallGenSetV];
Which[lenU<lenV,
MaxElem=LargestElementInGroup@SmallChainU;
SmallGenSetU=Join[SmallGenSetU,Table[MaxElem,{lenV-lenU}]],
lenU>lenV,
MaxElem=LargestElementInGroup@SmallChainV;
SmallGenSetV=Join[SmallGenSetV,Table[MaxElem,{lenU-lenV}]],
True,Null];
SmallGenSetU=xAct`xPerm`Private`FromSign[TranslatePerm[#,{Images,n}],n]&/@SmallGenSetU;
SmallGenSetV=xAct`xPerm`Private`FromSign[TranslatePerm[#,{Images,n}],n]&/@SmallGenSetV;
(*Print["SmallGenSetU: ",SmallGenSetU];
Print["SmallGenSetV: ",SmallGenSetV];*)
OrderedQ[{SmallGenSetU,SmallGenSetV}]]


SmallestGroup[GroupList_List]:=Module[{
SmallChains=SmallestBaseStabChain/@GroupList,
SmallGenSets,SetLenths,MaxLength,MaxElem,i=1,n, SmallestIndex,SmallestCanonicalGroup},
n=Max@@(PermLength/@GroupList);
SmallGenSets=SmallestGenSet/@SmallChains;
SetLenths=Length/@SmallGenSets;
MaxLength=Max@@SetLenths;
While[i<=Length@GroupList,
If[SetLenths[[i]]<MaxLength,
MaxElem=LargestElementInGroup[SmallChains[[i]]];
SmallGenSets[[i]]=Join[SmallGenSets[[i]],Table[MaxElem,{MaxLength-SetLenths[[i]]}]]];
i=i+1;];
SmallGenSets=Map[xAct`xPerm`Private`FromSign[TranslatePerm[#,{Images,n}],n]&,SmallGenSets,{2}];
SmallestIndex=First@Ordering[SmallGenSets,1];
SmallestCanonicalGroup=GenSet@@Take[SmallGenSets[[SmallestIndex]],SetLenths[[SmallestIndex]]];
(* TranslatePerm[#,Cycles] *)
SmallestCanonicalGroup=Map[xAct`xPerm`Private`ToSign[#,n]&,SmallestCanonicalGroup,{1}];
{SmallestIndex,StrongGenSet[ SmallChains[[SmallestIndex,1,1]],SmallestCanonicalGroup]}]


Sifting[perm_,StrongGenSet[base_List,GS1_GenSet],StrongGenSet[base_List,GS2_GenSet],word1_List:{},word2_List:{}]:=
If[Length[base]===0,
{PermEqual[perm,ID],word1,word2},
Module[{
Sorbit1=SchreierOrbit[First[base],GS1,Max[PermDeg[perm],PermDeg[GS1],PermDeg[GS2]]],
Sorbit2=SchreierOrbit[First[base],GS2,Max[PermDeg[perm],PermDeg[GS1],PermDeg[GS2]]],
mappedorbit2,possiblepoints,
point1,u1,u2,newperm, foundID=False,newword1={},newword2={}},
mappedorbit2=OnPoints[First@Sorbit2,perm];
possiblepoints=Cases[First@Sorbit1,Alternatives@@mappedorbit2];
While[(Length[possiblepoints]>0) && Not[foundID],
point1=First@possiblepoints;
possiblepoints=Rest@possiblepoints;
u1=TraceSchreier[point1,Sorbit1];
u2=InversePerm@TraceSchreier[OnPoints[point1,InversePerm[perm]],Sorbit2];
newperm=PermProduct[InversePerm[u2],perm,InversePerm[u1]];
{foundID,newword1,newword2}=Sifting[newperm,StrongGenSet[Rest[base],Stabilizer[{First[base]},GS1]],StrongGenSet[Rest[base],Stabilizer[{First[base]},GS2]],
Append[word1,u2],Prepend[word2,u1]];
];
{foundID,newword1,newword2}
]];


Sifting2[perm_,base_List,GS1_GenSet,GS2_GenSet,n_]:=
If[Length[base]===0,
PermEqual[perm,ID],
Module[{
(* Compute the Schreierorbits of the first base point *)
Sorbit1=SchreierOrbit[First[base],GS1,n],
Sorbit2=SchreierOrbit[First[base],GS2,n],
mappedorbit2,possiblepoints1,
foundID=False, possibleu1,possibleu2,possiblenewperm},
(* Which points does perm map Sorbit2 to? *)
mappedorbit2=OnPoints[First@Sorbit2,perm];
(* point1 must be in orbit1 and in mappedorbit2. *)
possiblepoints1=Cases[First@Sorbit1,Alternatives@@mappedorbit2];
(* Compute the corresponding u1 and u2 for the points in possiblepoints1 *)
possibleu1=TraceSchreier[#,Sorbit1]&/@possiblepoints1;
possibleu2=TraceSchreier[OnPoints[#,InversePerm[perm]],Sorbit2]&/@possiblepoints1;
(* Compute all possible newperm, remove duplicates and sort the list, so we find ID as quickly as possible.*)
possiblenewperm=PermSort@Union@Inner[PermProduct[#2,perm,InversePerm[#1]]&,possibleu1,possibleu2,List];
While[(Length[possiblenewperm]>0) && Not[foundID],
foundID=Sifting2[First@possiblenewperm,Rest[base],Stabilizer[{First[base]},GS1],Stabilizer[{First[base]},GS2],n];
possiblenewperm=Rest@possiblenewperm;
];
foundID
]];


Sifting2b[perm_,base_List,StabChainSchOrbitsG1_List,StabChainSchOrbitsG2_List,n_]:=
If[Length[base]===0,
PermEqual[perm,ID],
Module[{
(* Compute the Schreierorbits of the first base point *)
Sorbit1=First@StabChainSchOrbitsG1,
Sorbit2=First@StabChainSchOrbitsG2,
mappedorbit2,possiblepoints1,
foundID=False, possibleu1,possibleu2,possiblenewperm},
(* Which points does perm map Sorbit2 to? *)
mappedorbit2=OnPoints[First@Sorbit2,perm];
(* point1 must be in orbit1 and in mappedorbit2. *)
possiblepoints1=Cases[First@Sorbit1,Alternatives@@mappedorbit2];
(* Compute the corresponding u1 and u2 for the points in possiblepoints1 *)
possibleu1=TraceSchreier[#,Sorbit1]&/@possiblepoints1;
possibleu2=TraceSchreier[OnPoints[#,InversePerm[perm]],Sorbit2]&/@possiblepoints1;
(* Compute all possible newperm, remove duplicates and sort the list, so we find ID as quickly as possible.*)
possiblenewperm=PermSort@Union@Inner[PermProduct[#2,perm,InversePerm[#1]]&,possibleu1,possibleu2,List];
While[(Length[possiblenewperm]>0) && Not[foundID],
foundID=Sifting2b[First@possiblenewperm,Rest[base],Rest@StabChainSchOrbitsG1,Rest@StabChainSchOrbitsG2,n];
possiblenewperm=Rest@possiblenewperm;
];
foundID
]];


Sifting3[perm_,SGS1_StrongGenSet,SGS2_StrongGenSet]:=Sifting3[perm,SGS1,SGS2,Max[PermDeg@perm,PermLength@SGS1,PermLength@SGS2]]


Sifting3[perm_,SGS1_StrongGenSet,SGS2_StrongGenSet, len_]:=Module[{base=Join[First@SGS1,Complement[First@SGS2,First@SGS1]],movedpoints,GS1,GS2},
movedpoints:=Complement[Range[1,PermDeg@perm],StablePoints@perm];
base=Join[movedpoints,Complement[base,movedpoints]];
GS1=Last@BaseChange2[SGS1,base];
GS2=Last@BaseChange2[SGS2,base];
Sifting2[perm,base,GS1,GS2,len]
]


MinusIDInProductQ[H0_Symmetric,G0_Symmetric]:=False


MinusIDInProductQ[H0_Antisymmetric,G0_Antisymmetric]:=False


MinusIDInProductQ[H0_Symmetric,G0_Antisymmetric]:=Length@Intersection[First@H0,First@G0]>=2


MinusIDInProductQ[H0_Antisymmetric,G0_Symmetric]:=Length@Intersection[First@H0,First@G0]>=2


MinusIDInProductQ[H0_StrongGenSet,G0_Symmetric]:=Not@FreeQ[sign/@List@@Stabilizer[Complement[GroupSupport@H0,First@G0],H0[[2]]],-1]


MinusIDInProductQ[H0_Symmetric,G0_StrongGenSet]:=Not@FreeQ[sign/@List@@Stabilizer[Complement[GroupSupport@G0,First@H0],G0[[2]]],-1]


MinusIDInProductQold[H0_StrongGenSet,G0_StrongGenSet]:=
Module[{G1,H1},
(* Arrange so that the groups have the same bases and cycle notation *)
H1=BaseChange2[H0,First@G0];
G1=BaseChange2[G0,First@H1];
Sifting2[-ID,G1[[1]],G1[[2]],H1[[2]],Max[PermLength@G1,PermLength@H1]]
];


MinusIDInProductQ[H0_StrongGenSet,G0_StrongGenSet]:=
Module[{G1,H1,n},
(* Arrange so that the groups have the same base *)
H1=BaseChange2[H0,First@G0];
G1=ReplacePart[G0,1-> First@H1];
n=Max[PermLength@G1,PermLength@H1];
Sifting2b[-ID,G1[[1]],SchreierOrbit[First@First@#,#,n]&/@(Most@StabilizerChain2[G1]),SchreierOrbit[First@First@#,#,n]&/@(Most@StabilizerChain2[H1]),n]
];


MinusIDInProductQ[H0_,G0_]:=MinusIDInProductQ[xAct`xTensor`Private`SGSofsym@H0,xAct`xTensor`Private`SGSofsym@G0]


GpinHGQBruteForceOld[p_,G_,H_,n_,Gelements_]:=
If[Sifting2[p,First@G,Last@G,Last@H,n],
Module[
{TestList=Gelements,
result=True},
While[(Length[TestList]>0)&&result,
result=And@@(Sifting2[PermProduct[First@TestList,p],First@G,Last@G,Last@H,n]);
TestList=Rest@TestList;];
result
],
False]


SymmetryOfProductOfGroupsBruteForceOld[G0_StrongGenSet,H0_StrongGenSet]:=
Module[{G1,H1,permdeg,K1,F1, GElements, unstablepoints,time},
(* Arrange so that the groups have the same bases and cycle notation *)
 (* Print["SymmetryOfProductOfGroupsBruteForce[",G0,",",H0,"]"];*)
If[Length@Last@H0===0,{G0,H0},
H1=BaseChange2[H0,First@G0];
G1=BaseChange2[G0,First@H1];
permdeg=Max[Max@@First[H1],PermDeg[Last@G1],PermDeg[Last@H1]];
(*Print["H1: ",H1];
Print["G1: ",G1];
Print["permdeg: ",permdeg];*)
(* GElements=Rest[List@@Dimino[G1]];*)
(* It should be enough to test one from each coset H.p where p is in G *)
{time,GElements}=AbsoluteTiming@Rest[Union[First[RightCosetRepresentative[#,permdeg,H1]]&/@List@@Dimino@G1]];
(* Print["GElements timing: ",time, " length: ", Length@GElements];*)
(*Print["GElements: ",GElements];*)
K1=Search[H1,GpinHGQBruteForce[#,G1,H1,permdeg,GElements]&,1,StrongGenSet[{},GenSet[]]];
(* Print["K1: ",K1];*)
F1=SchreierSims[Range@permdeg,Join[Last@K1,Last@G1]];
F1=DeleteSomeRedundantGenerators[F1];
unstablepoints=Complement[Range@permdeg,StablePoints[Last@F1,permdeg]];
F1=ReplacePart[F1,1->unstablepoints];
(*Print["F1: ",F1];*)
{F1,K1}]]


GpinHGQBruteForce[p_,base_,StabChainSchOrbG_,StabChainSchOrbH_,n_,Gelements_]:=
If[xAct`SymManipulator`Private`Sifting2b[p,base,StabChainSchOrbG,StabChainSchOrbH,n],
Module[
{TestList=Gelements,
result=True},
While[(Length[TestList]>0)&&result,
result=xAct`SymManipulator`Private`Sifting2b[PermProduct[First@TestList,p],base,StabChainSchOrbG,StabChainSchOrbH,n];
TestList=Rest@TestList;];
result
],
False]


SymmetryOfProductOfGroupsBruteForce[G0_StrongGenSet,H0_StrongGenSet]:=
Module[{G1,H1,permdeg,K1,F1, GElements, unstablepoints,time,StabChainSchOrbG, StabChainSchOrbH },
(* Arrange so that the groups have the same bases and cycle notation *)
 (* Print["SymmetryOfProductOfGroupsBruteForce[",G0,",",H0,"]"];*)
If[Length@Last@H0===0,{G0,H0},
H1=BaseChange2[H0,First@G0];
G1=ReplacePart[G0,1-> First@H1];
permdeg=Max[Max@@First[H1],PermDeg[Last@G1],PermDeg[Last@H1]];
StabChainSchOrbG=SchreierOrbit[First@First@#,#,permdeg]&/@(Most@StabilizerChain2[G1]);
StabChainSchOrbH=SchreierOrbit[First@First@#,#,permdeg]&/@(Most@StabilizerChain2[H1]);
(*Print["H1: ",H1];
Print["G1: ",G1];
Print["permdeg: ",permdeg];*)
(* GElements=Rest[List@@Dimino[G1]];*)
(* It should be enough to test one from each coset H.p where p is in G *)
{time,GElements}=AbsoluteTiming@Rest[Union[First[RightCosetRepresentative[#,permdeg,H1]]&/@List@@Dimino@G1]];
(* Print["GElements timing: ",time, " length: ", Length@GElements];*)
(*Print["GElements: ",GElements];*)
K1=Search[H1,GpinHGQBruteForce[#,First@G1,StabChainSchOrbG,StabChainSchOrbH,permdeg,GElements]&,1,StrongGenSet[{},GenSet[]]];
(* Print["K1: ",K1];*)
F1=SchreierSims[Range@permdeg,Join[Last@K1,Last@G1]];
F1=xAct`SymManipulator`Private`DeleteSomeRedundantGenerators[F1];
unstablepoints=Complement[Range@permdeg,StablePoints[Last@F1,permdeg]];
F1=ReplacePart[F1,1->unstablepoints];
(*Print["F1: ",F1];*)
{F1,K1}]]


SymmetryOfProductOfGroupsBruteForce[G0_,H0_]:=SymmetryOfProductOfGroupsBruteForce[xAct`xTensor`Private`SGSofsym@G0,xAct`xTensor`Private`SGSofsym@H0]


SchreierTransversal[x_,base_]:=TraceSchreier[#,x]&/@(SortB[First@x,base])


SchreierTransversals[SGS_]:=
Module[{Gchain=StabilizerChain2@SGS,SchreierOrbits1},
SchreierOrbits1=SchreierOrbit[Gchain[[#,1,1]],Gchain[[#]],
PermLength@Gchain[[#]]]&/@Range[Length[Gchain]-1];
SchreierTransversal[#,First@SGS]&/@SchreierOrbits1
]


TransversalComputation[H0_,G0_]:=
Module[{base=First@G0,baselength=Length@First@G0,StabChainG0=StabilizerChain2@G0,
StabChainH0=StabilizerChain2@H0,
STransG0=SchreierTransversals@G0,
TransversalLengths,RestBaseOrbitsH,TList,TBar,i,j,Checku,ElementsNeeded},
Checku[u_,n_]:=
Module[{tuList=PermProduct[#,u]&/@TList,FirstBaseImageUnderu=OnPoints[StabChainH0[[n,1,1]],u],
SelectionList},
(*Print["Checku[",u,",",n,"]"];*)
SelectionList=And@@@Outer[Not[xAct`xPerm`Private`LessB[{OnPoints[#2,#1],FirstBaseImageUnderu},base]]&,tuList,RestBaseOrbitsH[[n]]];
(*Print["SelectionList:",SelectionList];*)
Pick[tuList,SelectionList]
];
TransversalLengths=(OrderOfGroup[StabChainG0[[#]]]/OrderOfGroup[StabChainH0[[#]]])&/@Range[baselength+1];
RestBaseOrbitsH=Rest@Orbit[StabChainH0[[#,1,1]],StabChainH0[[#]]]&/@Range[baselength];
TList={ID};
i=baselength;
While[i>=1,
TBar={};
j=2;
ElementsNeeded=TransversalLengths[[i]]-Length[TList];
While[And[Length[TBar]<ElementsNeeded,
j<=Length[STransG0[[i]]]],
TBar=Join[TBar,Checku[STransG0[[i,j]],i]];
j=j+1;
];
TList=Join[TList,TBar];
i=i-1;];
TList
]


TransversalInSymmetricGroup[H0_StrongGenSet,G0_Symmetric]:=
Module[{suppH0=GroupSupport@H0,H0partofbase, newbase,G1},If[Not@subsetQ[suppH0,First@G0],Throw[Message[General::error,"TransversalInSymmetricGroup: Not a subgroup."]]];
(* Arrange so both groups have the same base. *)
(* Elliminate points in the base that is not in G0.*)
H0partofbase=DeleteCases[First@H0,Not@MemberQ[#,First@G0]&];
(* construct the new base. *)
newbase=Join[H0partofbase,Complement[First@G0,H0partofbase]];
(* Construct symmetric group with correct base. *)
G1=StrongGenSet[newbase,GenSet@@(Cycles/@Partition[DeleteCases[newbase,Not@MemberQ[#,First@G0]&],2,1])];
(* Compute the transversal. *)
TransversalComputation[ReplacePart[H0,1->newbase],G1]
]


TransversalInCompatibleSymmGroup[H0_StrongGenSet,G0_Symmetric]:=TransversalInSymmetricGroup[H0,G0]


TransversalInCompatibleSymmGroup[H0_StrongGenSet,G0_StrongGenSet]:=
Module[{suppH0=GroupSupport@H0,suppG0=GroupSupport@G0,H0partofbase, newbase,G1},If[Not@subsetQ[suppH0,suppG0],Throw[Message[General::error,"TransversalInCompatibleSymmGroup: Not a subgroup."]]];
(* Arrange so both groups have the same base. *)
(* Elliminate points in the base that is not in G0.*)
H0partofbase=DeleteCases[First@H0,Not@MemberQ[#,suppG0]&];
(* construct the new base. *)
newbase=Join[H0partofbase,Complement[suppG0,H0partofbase]];
(* Construct symmetric group with correct base. *)
G1=BaseChange2[G0,newbase];
(* Compute the transversal. *)
TransversalComputation[ReplacePart[H0,1->newbase],G1]
]


xTensorQ[ZeroTensor[slotlist_]]^:=True;
PrintAs[ZeroTensor[slotlist_]]^:="0";
SlotsOfTensor[ZeroTensor[slotlist_]]^:=slotlist;
DependenciesOfTensor[ZeroTensor[slotlist_]]^:={};
DefInfo[ZeroTensor[slotlist_]]^:={"tensor",StringJoin["ZeroTensor with slots ",ToString/@slotlist," ."]};
HostsOf[ZeroTensor[slotlist_]]^:={};
TensorID[ZeroTensor[slotlist_]]^:={};
Dagger[ZeroTensor[slotlist_List]]^:=ZeroTensor[Dagger/@slotlist]


ZeroTensor[slotlist_][___]:=0


TensorToZeroRule[T_?xTensorQ]:=T->ZeroTensor[SlotsOfTensor@T]


xTensorQ[deltaH[vbundle_]]^:=True;
PrintAs[deltaH[vbundle_]]^:="\[Delta]";
SlotsOfTensor[deltaH[vbundle_]]^:={-vbundle,vbundle};
SymmetryGroupOfTensor[deltaH[vbundle_]]^=StrongGenSet[{},GenSet[]];
DependenciesOfTensor[deltaH[vbundle_]]^:={};
DefInfo[deltaH[vbundle_]]^:={"tensor",StringJoin[" delta on ",ToString/@vbundle," ."]};
HostsOf[deltaH[vbundle_]]^:={};
TensorID[deltaH[vbundle_]]^:={};


deltaHTodelta=deltaH[vbundle_]:>delta;


MetricOrdeltaHOfVBundle[vbundle_]:=
Module[{metrics=MetricsOfVBundle[vbundle]},
If[Length@metrics>0,First@metrics,deltaH[vbundle]]];


nosign[-x_]:=x;
nosign[x_]:=x;
sign[-x_]:=-1;
sign[x_]:=1;


slot=xAct`xTensor`Private`slot;


xTensorQ[SymH[headlist_,sym_,label_]]^:=True;
PrintAs[SymH[headlist_,sym_,label_]]^:=RowBox[{UnderscriptBox["Sym",StyleBox[label,Tiny]],"[",Sequence@@(PrintAs/@headlist),"]"}];
SlotsOfTensor[SymH[headlist_,sym_,label_]]^:=Join@@(SlotsOfTensor/@headlist);
DependenciesOfTensor[SymH[headlist_,sym_,label_]]^:=Union@@(DependenciesOfTensor/@headlist);
DefInfo[SymH[headlist_,sym_,label_]]^:={"tensor",StringJoin["Symmetrized ",Sequence@@(ToString/@headlist)," ."]};
(* JMM: These two should also be generalized, but are not relevant for us *)
HostsOf[SymH[headlist_,sym_,label_]]^:={};
TensorID[SymH[headlist_,sym_,label_]]^:={};


SymH[headlist:{___,ZeroTensor[_],___},sym_,label_]:=ZeroTensor[Join@@(SlotsOfTensor/@headlist)]


InternalExprSym[SymH[headlist_,sym_,label_]]:=
Module[{numindices=Length/@SlotsOfTensor/@headlist,slotlist,partitionedslots,internalexpr},
slotlist=IndexList@@slot/@Range[Plus@@numindices];
(* Extract indices belonging to the different tensors. Can this be done in a simpler way? *)
(* partitionedslots=IndexList@@@Last/@Rest@FoldList[{Drop[#1[[1]],#2],Take[#1[[1]],#2]}&,{List@@slotlist,{}},numindices];*)
partitionedslots=IndexList@@@partitionRagged[List@@slotlist,numindices];
internalexpr=Inner[(#1@@#2)&,headlist,partitionedslots,Times]]


InternalSymmetrySym[x:(SymH[headlist_,sym_,label_])]:=
Module[{internalexpr=InternalExprSym[x],tempinds,internalsym,slotrules,inverseslotrules, n,tmpinternal,internalslotrules, slotpermutations},
tempinds=DummyIn/@SlotsOfTensor[x];
slotrules=Thread@Rule[slot/@Range[Length@tempinds],tempinds];
inverseslotrules=Thread@Rule[tempinds,slot/@Range[Length@tempinds]];
{n,tmpinternal,internalslotrules,internalsym}=List@@SymmetryOf[internalexpr/.slotrules];
slotpermutations=(internalslotrules/.inverseslotrules);
internalsym/.(slotpermutations/.slot[nn_]:>nn)
]


ExpandSym1[x:(SymH[headlist_,sym_,label_][inds___])]:=Module[{indlist=List[inds],slotlist=slot/@Range@Length@List[inds],internalexpr, slotexpansion},
internalexpr=InternalExprSym[Head@x];
slotexpansion=ImposeSymmetry[internalexpr,IndexList@@slotlist,sym];
slotexpansion/.Thread@Rule[slotlist,indlist]]


ExpandSym2[x:(SymH[headlist_,sym_,label_][inds___])]:=Module[{indlist=List[inds],slotlist=slot/@Range@Length@List[inds],internalexpr, slotexpansion, bigsym,smallsym,transversal},
internalexpr=xAct`SymManipulator`Private`InternalExprSym[Head@x];
bigsym=SymmetryGroupOfTensor[Head@x];
smallsym=ReplacePart[BaseChange2[xAct`xTensor`Private`SGSofsym@InternalCommutingSymmetry[Head@x],First@bigsym],1->First@bigsym];
(* If[Not@SubgroupQ[smallsym,bigsym],Print["Not a subgroup..."]]; *)
transversal=InversePerm/@TransversalComputation[smallsym,bigsym];
slotexpansion=Plus@@(PermuteIndices[internalexpr,IndexList@@slotlist,#]&/@transversal)/Length[transversal];
slotexpansion/.Thread@Rule[slotlist,indlist]]


RemoveSym1[x:(SymH[headlist_,sym_,label_][inds___])]:=Module[{indlist=List[inds],slotlist=IndexList@@slot/@Range@Length@List[inds]},
InternalExprSym[Head@x]/.Thread@Rule[List@@slotlist,indlist]]


Options[ExpandSym]={SmartExpand->False};


ExpandSym[expr_,options:OptionsPattern[]]:=ExpandCovarDAndInertHeadHead[
If[OptionValue[SmartExpand],
expr/.x:(SymH[___][inds___]):>ExpandSym2[x],
expr/.x:(SymH[___][inds___]):>ExpandSym1[x]]]


RemoveSym[expr_]:=ExpandCovarDAndInertHeadHead[expr/.x:(SymH[___][inds___]):>RemoveSym1[x]]


DefaultOrbitLabel[points_,sym_]:=
Module[{orbitlabel=StringJoin[ToString/@points]},
Which[SubgroupQ[Symmetric[points],sym],(* Symmetric *)
StringJoin["(",orbitlabel,")"],
SubgroupQ[Antisymmetric[points],sym],(* Antisymmetric *)
StringJoin["[",orbitlabel,"]"],
True,(* Everything else *)
orbitlabel]]


DefaultLabelSym[sym_StrongGenSet]:=Module[{n=PermLength@Last[sym], longorbits,unstableslots, orbitlabels},
longorbits=Sort/@Select[Orbits[sym,n],Length[#]>1&];
orbitlabels=DefaultOrbitLabel[#,sym]&/@longorbits;
StringJoin[ToString/@orbitlabels]]


DefaultLabelSym[sym_Symmetric]:=StringJoin["(",StringJoin[ToString/@First@sym],")"]


DefaultLabelSym[sym_Antisymmetric]:=StringJoin["[",StringJoin[ToString/@First@sym],"]"]


$MixedSymSpecialCode=True;
$MixedSymVerbose=False;


SymmetryGroupOfTensor[x : SymH[headlist_, sym_, label_]] ^:=SymmetryGroupOfTensor[x]^=Module[{n=Plus@@(Length/@SlotsOfTensor/@headlist),unstableslots,newlabel,symmetrygroup, internalcommutingsym},
unstableslots=GroupSupport@sym;
(* In the special cases when the symmetry is 
Symmetric[unstableslots], or Antysymmetric[unstableslots], we compute the mixed symmetry. *)
{symmetrygroup, internalcommutingsym}=
Which[And[$MixedSymSpecialCode===True,Head@sym===Symmetric],(* Symmetric *)
SymmetryOfProductOfGroupsSymmetricCase2[unstableslots,InternalSymmetrySym[SymH[headlist, sym, label]],False],
And[$MixedSymSpecialCode===True,Head@sym===Antisymmetric],(* Antisymmetric *)
SymmetryOfProductOfGroupsSymmetricCase2[unstableslots,InternalSymmetrySym[SymH[headlist, sym, label]],True],
And[$MixedSymSpecialCode===SetStabilizer,Head@sym===Symmetric],(* Symmetric *)
SymmetricMixedSymmetry[unstableslots,InternalSymmetrySym[SymH[headlist, sym, label]],sym,n],
And[$MixedSymSpecialCode===SetStabilizer,Head@sym===Antisymmetric],(* Antisymmetric *)
AntisymmetricMixedSymmetry[unstableslots,InternalSymmetrySym[SymH[headlist, sym, label]],sym,n],
True,(* Everything else *)
GeneralMixedSymmetry[unstableslots,InternalSymmetrySym[SymH[headlist, sym, label]],sym,n]];
InternalCommutingSymmetry[x]^= internalcommutingsym;
symmetrygroup]


ClearRememberedSymHSymmetry[tensor_]:=UpValues[SymH]=DeleteCases[UpValues[SymH],_?((#[[1,0]]==HoldPattern)&&Or[#[[1,1,0]]==SymmetryGroupOfTensor,#[[1,1,0]]==InternalCommutingSymmetry]&&(#[[1,1, 1,0]]==SymH)&&MemberQ[#[[1,1,1,1]],tensor,Infinity]&)];


xTension["SymManipulator`",UndefTensor,"Beginning"]=ClearRememberedSymHSymmetry;


Unprotect[InertHeadHead];


xTensorQ[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:=True;
PrintAs[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:=RowBox[{PrintAs[H1],PrintAs[T]}];
SlotsOfTensor[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:=SlotsOfTensor[T];
DependenciesOfTensor[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:=DependenciesOfTensor[T];
SymmetryGroupOfTensor[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:=SymmetryGroupOfTensor[T];
DefInfo[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:={"tensor",StringJoin[ToString[H1],ToString[T]]};
HostsOf[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:={};
TensorID[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ]]^:={};


Unprotect[CovarD];


xTensorQ[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:=True;
PrintAs[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:=RowBox[{Last@SymbolOfCovD[D1],PrintAs[T]}];
SlotsOfTensor[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:=Join[list,SlotsOfTensor[T]];
(* Is this correct? *)
DependenciesOfTensor[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:=DependenciesOfTensor[T];
SymmetryGroupOfTensor[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:=
JoinSGS[SymmetryGroupOfCovD[D1],SymmetryGroupOfTensor[T]/.Thread@Rule[Range@Length@SlotsOfTensor[T],Range[1+Length[list],Length[list]+Length@SlotsOfTensor[T]]]];
DefInfo[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:={"tensor",StringJoin[ToString[D1],ToString[T]]};
(* These two should also be generalized... *)
HostsOf[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:={};
TensorID[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]^:={};


CovarD[D1_?CovDQ,ZeroTensor[slotlist_],list_]:=ZeroTensor[Join[list,slotlist]]


InertHeadHead[H1_?InertHeadQ,ZeroTensor[slotlist_]]:=ZeroTensor[slotlist]


ExpandInertHeadHead[InertHeadHead[H1_?InertHeadQ,T_?xTensorQ][inds___]]:=H1[T[inds]]


ExpandCovarD[CovarD[D1_?CovDQ,T_?xTensorQ,list_][inds___]]:=D1[Sequence@@Take[List[inds],Length@list]][T[Sequence@@Drop[List[inds],Length@list]]]


ExpandCovarDAndInertHeadHead[expr_]:=expr//.{x:(InertHeadHead[___][inds___]):>ExpandInertHeadHead[x],(x:CovarD[___][inds___]):>ExpandCovarD[x]}


ToInertHeadHead[H1_?InertHeadQ[T_?xTensorQ[inds___]]]:=InertHeadHead[H1,T][inds]


ToInertHeadHead[H1_?InertHeadQ[H2_?InertHeadQ[expr_]]]:=ToInertHeadHead[H1@ToInertHeadHead[H2[expr]]]


ToInertHeadHead[H1_?InertHeadQ[D1_?CovDQ[covdinds___][expr_]]]:=ToInertHeadHead[H1@ToCovarD[D1[covdinds][expr]]]


ToCovarD[D1_?CovDQ[covdinds___][T_?xTensorQ[tensorinds___]]]:=
CovarD[D1,T,(-VBundleOfIndex[#])&/@List[covdinds]][Sequence@@Join[List[covdinds],List[tensorinds]]]


ToCovarD[D1_?CovDQ[covdinds___][D2_?CovDQ[covdinds2___][expr_]]]:=ToCovarD[D1[covdinds]@ToCovarD[D2[covdinds2][expr]]]


ToCovarD[D1_?CovDQ[covdinds___][H1_?InertHeadQ[expr_]]]:=ToCovarD[D1[covdinds]@ToInertHeadHead[H1[expr]]]


Unprotect[Dagger];


Dagger[x:(SymH[headlist_,sym_,label_]?xTensorQ[inds___])]:=Module[{tempinds=DummyAs/@IndexList[inds]},
ImposeSym[Dagger@RemoveSym1[Apply[Head@x,tempinds]],DaggerIndex/@tempinds,sym]/.Thread@Rule[DaggerIndex/@(List@@tempinds),DaggerIndex/@List[inds]]]


Dagger[CovarD[D1_?CovDQ,T_?xTensorQ,list_]]:=CovarD[D1,Dagger[T],Dagger/@list]


Protect[Dagger];


SeparateVBundles[inds_IndexList]:=Module[{VBundleOfIndexQ,VBlist,sepatatedinds},
(* Temporary function for checking if an index belongs to VBundle1 *)
VBundleOfIndexQ[VBundle1_]:=VBundle1==VBundleOfIndex[#]&;
(* List the VBundles in inds *)
VBlist=List@@Union@Sort[VBundleOfIndex/@inds];
(* Separate the indices according to VBundles *)
sepatatedinds=Select[List@@inds,VBundleOfIndexQ[#]]&/@VBlist;
(* Find the corresponding position in the list inds and retun that.*)
First@First@Position[inds,#,1]&/@#&/@sepatatedinds
]


CompatibleSymmetric[inds_IndexList]:=Module[{VBundles,SGSlist},
(* Compute the strong generating sets for the separate symmetries *)
VBundles=Select[SeparateVBundles[inds],(Length[#]>=2)&];
If[Length@VBundles==1,SGSlist=Symmetric/@VBundles,
SGSlist=Symmetric[#,Cycles]&/@VBundles;
(* Join the symmetries *)
While[Length[SGSlist]>=2,
SGSlist[[2]]=JoinSGS[SGSlist[[1]],SGSlist[[2]]];
SGSlist=Delete[SGSlist,1];
];];
(* Return the remaining SGS or the trivial SGS if the list is empty. *)
If[Length[SGSlist]==1,First@SGSlist,StrongGenSet[{}, GenSet[]]]
]


CompatibleSym[vbundles_List]:=With[{sgs=JoinSGS@@(Symmetric[#,Cycles]&/@GatherBy[Range@Length@vbundles,(UpIndex/@vbundles)[[#]]&])},
If[Last@sgs===GenSet[],
StrongGenSet[{},GenSet[]],
sgs]];


CompatibleSym[vbundles_List,selectionVBs_List]:=With[{sgs=JoinSGS@@(Symmetric[#,Cycles]&/@(Select[GatherBy[Range@Length@vbundles,(UpIndex/@vbundles)[[#]]&],MemberQ[selectionVBs,UpIndex@vbundles[[First[#]]]]&]))},
If[Last@sgs===GenSet[],
StrongGenSet[{},GenSet[]],
sgs]];


CompatibleSymQ[{},sym_]:=OrderOfGroup@sym==1


CompatibleSymQ[vbundles_List,sym_]:=Module[{n=Length@vbundles,upvbundles=UpIndex/@vbundles,disjsubgroups},disjsubgroups=Symmetric/@GatherBy[Range@n,upvbundles[[#]]&];
SubgroupQ[Join@@(GenSet/@disjsubgroups),sym]]


CompatibleSymQ[vbundles_List,sym_,selectionVBs_List]:=Module[{n=Length@vbundles,disjsubgroups},disjsubgroups=(Symmetric[#]&/@(Select[GatherBy[Range@n,(UpIndex/@vbundles)[[#]]&],MemberQ[selectionVBs,UpIndex@vbundles[[First[#]]]]&]));
If[Length@disjsubgroups==0,True,
SubgroupQ[Join@@(GenSet/@disjsubgroups),sym]]]


TimesToList[expr_Times]:=List@@expr


TimesToList[xAct`xTensor`Private`VerbatimProduct[Times][expr__]]:=(List[expr]/.xAct`xTensor`Private`Scalar1[Scalarexpr_]:>Scalarexpr)


TimesToList[T_?xTensorQ[tensorinds__]]:=List[T[tensorinds]]


Options[ImposeSym]={ImposeLargerSym->False,ImposeSuperfluousSym->False};


ImposeSym[0]:=0
ImposeSym[expr_,options___?OptionQ]:=ImposeSym[expr,FindFreeIndices[expr],options]


ImposeSym[expr_,inds_,options___?OptionQ]:=ImposeSym[expr,inds,CompatibleSymmetric[inds],options] 


ImposeSym[expr_,imposedinds_,sym_GenSet,options___?OptionQ]:=Module[{n=PermLength[sym],unstableslots,SGS},
unstableslots=Complement[Range@n,StablePoints[sym,n]];
SGS=SchreierSims[unstableslots,sym];
ImposeSym[expr,imposedinds,SGS,options]]


ImposeSym[expr_,IndexList[___],StrongGenSet[{___},GenSet[]],other___]:=expr


ImposeSym[expr_,inds_,sym_,options___?OptionQ]:=ImposeSym1[xAct`xTensor`Private`MathInputExpand@expr,inds,sym,options]


ImposeSym1[expr_Plus,other__]:=ImposeSym1[#,other]&/@expr
ImposeSym1[0,other__]:=0


ImposeSym1[x_?ConstantQ y_,other__]:=x ImposeSym1[y,other]
ImposeSym1[Scalar[x_] y_,other__]:=Scalar[x] ImposeSym1[y,other]
ImposeSym1[(F_?ScalarFunctionQ)[Scalar[x_]]y_,other__]:=F[Scalar[x]] ImposeSym1[y,other]
ImposeSym1[(F_?ScalarFunctionQ)[x_?xTensorQ[]]y_,other__]:=F[x[]] ImposeSym1[y,other]
ImposeSym1[x_?ScalarQ y_,other__]:=x ImposeSym1[y,other]
ImposeSym1[Times[x___,y_?xTensorQ[],z___],other__]:=y[]ImposeSym1[Times[x,z],other]
ImposeSym1[Times[x___,Power[y_?xTensorQ[],n_],z___],other__]:=Power[y[],n]ImposeSym1[Times[x,z],other]
ImposeSym1[Times[x___,Power[Scalar[y_],n_],z___],other__]:=Power[Scalar[y],n]ImposeSym1[Times[x,z],other]
ImposeSym1[Times[x___,Power[y_?ScalarQ ,n_],z___],other__]:=Power[y,n]ImposeSym1[Times[x,z],other]


ImposeSym1[z:(x_?InertHeadQ[___]),other__]:=ImposeSym1[ToInertHeadHead[z],other] 


ImposeSym1[z:(x_?CovDQ[__][y_]),other__]:=ImposeSym1[ToCovarD[z],other] 


ImposeSym1[LieD[dir_][expr_],other___]:=LieD[dir]@ImposeSym1[expr,other]


ImposeSym1[Times[z___,x:(_?InertHeadQ[___]),y___],other__]:=ImposeSym1[Times[z,ToInertHeadHead[x],y],other]


ImposeSym1[Times[z___,x:(_?CovDQ[___][___]),y___],other__]:=ImposeSym1[Times[z,ToCovarD[x],y],other]


ImposeSym1[expr:Times[_?xTensorQ[__],_?xTensorQ[__]...],other__]:=ImposeSym2[expr,other]


ImposeSym1[T_?xTensorQ[tensorinds__],other__]:=ImposeSym2[T[tensorinds],other]


ImposeSym1[other__]:=Throw@Message[ImposeSym::error,"Unable to impose symmetry: ImposeSym[",StringJoin@@Riffle[ToString/@{other},","],"]"]


ImposeSym2[expr_,imposedinds_,sym:(_StrongGenSet|_Symmetric|_Antisymmetric),options___?OptionQ]:=
Module[{LargerSymOption,SuperfluousSymOption,n,slotexpr,slotrules,internalsym,slotexprlist, slotlist1, slotlist2,HeadList, tensorinds,imposedorderinds,extendedtensorinds,perm1,perm2,newsym,newlabel, deltapos, deltareplacements},
{LargerSymOption,SuperfluousSymOption}={ImposeLargerSym,ImposeSuperfluousSym}/.CheckOptions[options]/.Options[ImposeSym];
If[And[Length@GroupSupport@sym==0,Not@SuperfluousSymOption],
expr//.{x:(CovarD[__][___]):>ExpandCovarD[x],x:(InertHeadHead[__][___]):>ExpandInertHeadHead[x]},
{n,slotexpr,slotrules,internalsym}=List@@SymmetryOf[expr];
(* Sort the tensors *)
slotexprlist=Sort@TimesToList[slotexpr];
slotlist1=Join@@List@@@slotexprlist; 
(* Remove slots that does not contain abstract indices *)
slotlist2=Select[slotlist1,Head[#]===xAct`xTensor`Private`slot&];
HeadList=Head/@slotexprlist;
(* We need to replace deltas with metrics or deltaH that carries its VBundle *)
deltapos=First/@Position[HeadList,delta,1];
If[Length@deltapos>0,
deltareplacements=MetricOrdeltaHOfVBundle/@VBundleOfIndex/@((First/@Part[slotexprlist,deltapos])/.slotrules);
HeadList=ReplacePart[HeadList,Thread@Rule[deltapos,  deltareplacements]];
];
tensorinds=slotlist1/.slotrules;
(* If we have indices in the sym that are not in tensorinds *)
extendedtensorinds=Join[tensorinds,Complement[List@@imposedinds,tensorinds]];
imposedorderinds=Join[List@@imposedinds,Cases[tensorinds,Except[Alternatives@@imposedinds]]];
perm1=TranslatePerm[PermutationFromTo[imposedorderinds,extendedtensorinds],Rules];
newsym=sym/.List@@perm1;
(* The extra indices in the sym that are not in tensorinds, does not act on anything so stabilize these points.*) 
(* Changed to StabilizerSGS instead of Stabilizer *)
newsym=StabilizerSGS[Range[1+Length@tensorinds,Length@extendedtensorinds],newsym];
newsym=TidyGroup@newsym;
perm2=TranslatePerm[PermutationFromTo[slot/@Range@n,slotlist2],Rules];internalsym=internalsym/.List@@perm2;
internalsym=TidyGroup@internalsym;
(* Simplify if possible *)
If[MinusIDInProductQ[newsym,internalsym],
0,
If[And[Not@SuperfluousSymOption,SubgroupQ[newsym,internalsym]],
ExpandCovarDAndInertHeadHead[expr],
If[LargerSymOption,
Module[{LargerGroup, tempsymhead=SymH[HeadList,newsym,DefaultLabelSym[newsym]]},
LargerGroup=SymmetryGroupOfTensor@tempsymhead;
newlabel=DefaultLabelSym[LargerGroup];
SymH[HeadList,LargerGroup,newlabel][Sequence@@tensorinds]],
SymH[HeadList,newsym,DefaultLabelSym[newsym]][Sequence@@tensorinds]]]]]]


SmartSymmetrize[expr_]:=SmartSymmetrize[expr,FindFreeIndices[expr]];


SmartSymmetrize[expr_,inds_]:=ExpandSym[ImposeSym[expr,IndexList@@inds,Symmetric@Range@Length@inds,ImposeSuperfluousSym->True],SmartExpand->True];


SmartAntisymmetrize[expr_]:=SmartAntisymmetrize[expr,FindFreeIndices[expr]];


SmartAntisymmetrize[expr_,inds_]:=ExpandSym[ImposeSym[expr,IndexList@@inds,Antisymmetric@Range@Length@inds,ImposeSuperfluousSym->True],SmartExpand->True];


SortTensorsInSym1[SymH[headlist_,sym_,label_][inds___]]:=
Module[{sortedheads=Sort[headlist],
slotlist=IndexList@@slot/@Range@Length@List[inds],
numindices=Length/@SlotsOfTensor/@headlist,partitionedslots,symbolpermutation, newslots,slotpermutation,newinds,newsym,newlabel},
partitionedslots=IndexList@@@partitionRagged[List@@slotlist,numindices];(*partitionedslots=IndexList@@@Last/@Rest@FoldList[{Drop[#1[[1]],#2],Take[#1[[1]],#2]}&,{List@@slotlist,{}},numindices];*)
symbolpermutation=PermutationFromTo[headlist,sortedheads];
newslots=Flatten[List@@@PermuteList[partitionedslots,symbolpermutation]];
slotpermutation=PermutationFromTo[List@@slotlist,newslots];
newinds=PermuteList[List[inds],slotpermutation];
newsym=sym/.List@@TranslatePerm[slotpermutation,Rules];
(* Also sort the base of the sym *)
newsym=TidyGroup@newsym;
(* One should probably change the label too. *)
newlabel=DefaultLabelSym[newsym];
SymH[sortedheads,newsym,newlabel][Sequence@@newinds]]


SortTensorsInSym[expr_]:=
(expr/.x:SymH[___][___]:>SortTensorsInSym1[x])


SuperfluousSymQ[x:(SymH[headlist_,sym_,label_])]:=
SubgroupQ[sym,InternalSymmetrySym[x]]


RemoveSuperfluousSym[expr_]:=(expr/.x:(SymH[headlist_,sym_,label_][inds___]):>ExpandCovarDAndInertHeadHead[InternalExprSym[Head@x]/.Thread@Rule[slot/@Range[Length@List[inds]],List[inds]]]/;SuperfluousSymQ[Head@x])


RemoveSuperfluousInnerSym[expr_]:=ExpandCovarDAndInertHeadHead[expr/.SymH[{SymH[headlist_,innersym_,innerlabel_]},outersym_,outerlabel_]:> Module[{},
If[SubgroupQ[innersym,outersym],
RemoveTrivialSym@SymH[headlist,outersym,outerlabel],
SymH[{SymH[headlist,innersym,innerlabel]},outersym,outerlabel]]]]


RemoveTrivialSym[expr_]:=expr/.x:(SymH[headlist_,sym_,label_]):>ZeroTensor[SlotsOfTensor@x]/;MinusIDInProductQ[sym,InternalSymmetrySym@x]


ExpandSymOneIndex1[SymH[headlist_,sym_,label_][inds___],ExpansionIndex_]:=
If[Length@Position[List[inds],ExpansionIndex,1,1]==0,
SymH[headlist,sym,label][inds],
Module[{ExpansionSlot=First@First@Position[List[inds],ExpansionIndex,1,1], newsym},
newsym=BaseChange2[xAct`xTensor`Private`SGSofsym@sym,{ExpansionSlot}];
Module[{IndexSOrbit=SchreierOrbit[ExpansionSlot,newsym,PermLength@newsym],
PermsForOrbit,SlotChanges,GroupList,SignList,LabelList,SymHHeads,PermutedIndices,SymHList,FF},
PermsForOrbit=TraceSchreier[#,IndexSOrbit]&/@First[IndexSOrbit];
SignList=sign/@PermsForOrbit;
SlotChanges=List@@@TranslatePerm[nosign/@PermsForOrbit,Rules];
GroupList=TidyGroup/@(StabilizerChain2[newsym][[2]]/.SlotChanges);
SymHHeads=SymH[headlist,#,DefaultLabelSym@#]&/@GroupList;
PermutedIndices=FF@@PermuteList[List[inds],#]&/@PermsForOrbit;
SymHList=MapThread[(#1@@#2)&,{SymHHeads,PermutedIndices},1];
RemoveSuperfluousSym[Inner[Times,SignList,SymHList,Plus]/Length[First[IndexSOrbit]]]
]]]


ExpandSymOneIndexInternal[y:SymH[headlist_,sym_,label_][inds___],ExpansionIndex_]:=
Module[{SymHpositions, return=y},
SymHpositions=Position[headlist,SymH];
If[Length[SymHpositions]>0,
Module[{internalexpr=InternalExprSym@Head@y,expandedinternalexpr, dummylist,dummiestoinds,indstodummies},
dummylist=DummyAs/@List[inds];
dummiestoinds=Thread@Rule[dummylist,List[inds]];
indstodummies=Thread@Rule[List[inds],dummylist];
internalexpr=internalexpr/.Thread@Rule[slot/@Range@Length@List[inds],dummylist];
expandedinternalexpr=internalexpr/.x:SymH[___][___]:>ExpandSymOneIndex1[x,ExpansionIndex/.indstodummies]/.x:SymH[___][___]:>ExpandSymOneIndexInternal[x,ExpansionIndex/.indstodummies];
return=RemoveSuperfluousInnerSym[ImposeSym[Expand@expandedinternalexpr,IndexList@@dummylist,sym]/.dummiestoinds];
]];
return]


ExpandSymOneIndex[expr_,ExpansionIndex_]:=Module[{result},
result=(expr/.x:SymH[___][___]:>ExpandSymOneIndex1[x,ExpansionIndex]/.y:SymH[___][___]:>ExpandSymOneIndexInternal[y,ExpansionIndex]);
result]


ExpandSymOneSlot[SymH[headlist_,sym_,label_][inds___],ExpansionSlot_]:=
Module[{newsym=BaseChange2[xAct`xTensor`Private`SGSofsym@sym,{ExpansionSlot}]},
Module[{IndexSOrbit=SchreierOrbit[ExpansionSlot,newsym,PermLength@newsym],
PermsForOrbit,stabsym=TidyGroup[StabilizerChain2[newsym][[2]]], newinds, newlabel},
PermsForOrbit=InversePerm/@(TraceSchreier[#,IndexSOrbit]&/@First[IndexSOrbit]);
newinds=PermuteList[List[inds],#]&/@PermsForOrbit;
newlabel=DefaultLabelSym[stabsym];
1/Length[First[IndexSOrbit]]*Plus@@(SymH[headlist,stabsym,newlabel]@@@newinds)]]


MoveCovDInsideSym=covd_?CovDQ[covdinds___]@SymH[headlist_, sym_, label_][inds___]:>Module[{indlist=List[inds],slotlist=xAct`SymManipulator`Private`slot/@Range@Length@List[inds],internalexpr,tempinds=DummyAs/@List[inds],newinternalexpr},
internalexpr=xAct`SymManipulator`Private`InternalExprSym[SymH[headlist,sym,label]];
newinternalexpr=Expand@xAct`SymManipulator`Private`ExpandCovarDAndInertHeadHead[internalexpr/.Thread@Rule[slotlist,tempinds]];
ImposeSym[covd[covdinds]@newinternalexpr,IndexList@@tempinds,sym]/.Thread@Rule[tempinds,indlist]];


MoveTensorsOutsideSym[expr_, onlymetrics_:False]:=
(expr/.x:(SymH[headlist_,sym_,label_][inds___]):>
Module[{stableslots,newlabel,tensornotinsymQ,
numindices=Length/@SlotsOfTensor/@headlist,slotlist,partitionedslots, tensornotinsymQpos,
symbolpermutation,newslots,slotpermutation, newinds,innerinds, innersym,innerheads, outerheads, newsym, newpartitionedslots, newnumindices, partitionednewinds,tensorinsymQpos},
slotlist=Range[Plus@@numindices];
(* Extract indices belonging to the different tensors. Can this be done in a simpler way? *)
(*partitionedslots=Last/@Rest@FoldList[{Drop[#1[[1]],#2],Take[#1[[1]],#2]}&,{slotlist,{}},numindices];*)
partitionedslots=partitionRagged[slotlist,numindices];
stableslots=Complement[Range@Length@List[inds],GroupSupport@sym];
tensornotinsymQ = subsetQ[#,stableslots]&/@partitionedslots;
(* If the flag onlymetrics is set we only move metrics outside. *)
If[onlymetrics,
tensornotinsymQ=Thread@And[tensornotinsymQ,MetricQ/@headlist];];
tensornotinsymQpos=Select[Range@Length@headlist,tensornotinsymQ[[#]]&];
outerheads=headlist[[tensornotinsymQpos]];
tensorinsymQpos=Complement[Range@Length@headlist,tensornotinsymQpos];
innerheads=headlist[[tensorinsymQpos]];
symbolpermutation=PermutationFromTo[Range@Length@headlist,Join[tensorinsymQpos, tensornotinsymQpos]];
newpartitionedslots=PermuteList[partitionedslots,symbolpermutation];
newslots=Flatten[newpartitionedslots];
slotpermutation=PermutationFromTo[slotlist,newslots];
newinds=PermuteList[List[inds],slotpermutation];
newnumindices=Length/@Take[newpartitionedslots, -Length@outerheads];
newnumindices=Prepend[newnumindices,Length[newinds]-Plus@@newnumindices];
partitionednewinds=IndexList@@@Last/@Rest@FoldList[{Drop[#1[[1]],#2],Take[#1[[1]],#2]}&,{List@@newinds,{}},newnumindices];
newsym=sym/.List@@TranslatePerm[slotpermutation,Rules];
(* Also sort the base of the sym *)
newsym=TidyGroup@newsym;
(* One should probably change the label too. *)
newlabel=DefaultLabelSym[newsym];
outerheads=Prepend[outerheads,SymH[innerheads,newsym,newlabel]];
Inner[(#1@@#2)&,outerheads,partitionednewinds,Times]]
)//.y:(CovarD[___][___]):>ExpandCovarD[y]


MoveTensorsInsideSym1[SymH[headlist_,sym_,label_][sinds___],hllist_List,indlist_List]:=
SymH[Join[headlist,hllist],sym,label][sinds,Sequence@@indlist]


MoveTensorsInsideSym[expr_]:=Module[{TempFF, intermediateexpr},
intermediateexpr=expr/.y:SymH[headlist_,sym_,label_][sinds___]:> TempFF[y,{},{}];
intermediateexpr=intermediateexpr//.Times[TT_?xTensorQ[tinds___],TempFF[y_,hllist_List,indlist_List],z___]:> Times[z,TempFF[y,Append[hllist,TT],Join[indlist,{tinds}]]];
intermediateexpr=intermediateexpr/.TempFF->MoveTensorsInsideSym1;
intermediateexpr/.x:SymH[___][___]:>SortTensorsInSym[x]]


RemoveDummiesFromSym[expr_Plus]:=RemoveDummiesFromSym/@expr


RemoveDummiesFromSym[expr_]:=Module[{dummies=FindDummyIndices[expr]},
dummies=Join[Times[-1,#]&/@dummies,dummies];
Fold[ExpandSymOneIndex,expr,dummies]]


MoveSymIndicesDown1[x:(SymH[headlist_,sym_,label_][sinds___]),expr2_]:= Module[{n=Length@List[sinds],unstableslots,unstableindices,needtomoveindices, metricfactors,indexchanges},
unstableslots=GroupSupport[sym];
unstableindices=List[sinds][[unstableslots]];
needtomoveindices=Select[unstableindices,DownIndex[#]=!=#&];
metricfactors=(First[MetricsOfVBundle@VBundleOfIndex[#]][#,DummyAs[#]])&/@needtomoveindices;
indexchanges=Rule[#[[1]],ChangeIndex[#[[2]]]]&/@metricfactors;
Times[ReplaceIndex[x,indexchanges],ContractMetric@Times[Times@@metricfactors,expr2]]
];


MoveSymIndicesDown[expr_]:=Module[{TempFF, intermediateexpr},
(* Derivatives *)
intermediateexpr=expr//.x:(D1_?CovDQ[___,-(A_Symbol),___][SymH[headlist_,sym_,label_][___,(A_Symbol),___]]):>xAct`xTensor`Private`SymmetryOfIndex[A]*ReplaceIndex[x,{A->-A,-A->A}];
(* Tensors *)
intermediateexpr=intermediateexpr/.x:SymH[headlist_,sym_,label_][sinds___]:> TempFF[x,1];
intermediateexpr=intermediateexpr//.Times[TempFF[x_,y_],z___]:> TempFF[x,Times[y,z]];
intermediateexpr=intermediateexpr/.TempFF->MoveSymIndicesDown1]


ContractMetricsInsideSym[expr_]:=
expr//.x:(SymH[(headlist:{___,TT_?MetricQ,___}),sym_,label_][inds___]):>
Module[{stableslots,newlabel,removetensor=0,
numindices=Length/@SlotsOfTensor/@headlist,slotlist,partitionedslots,
indlist=List[inds],metricpositions,metricslots,slottoind,contractionpos1,contractionpos2,firstcontractedmetric1,firstcontractedmetric2,contractionslots,contractionindex, stablecontraction,slotchange1,contractionsign=1,
symbolpermutation,newslots,slotpermutation, newinds,innerheads, newsym, newpartitionedslots},
slotlist=Range[Plus@@numindices];
metricpositions=First/@Position[MetricQ/@headlist,True];
(* If we have no metric just return *)
If[Length@metricpositions==0,x,
slottoind=Thread@Rule[slotlist,List[inds]];
(* Extract indices belonging to the different tensors. Can this be done in a simpler way? *)
partitionedslots=partitionRagged[slotlist,numindices];
stableslots=Complement[Range@Length@List[inds],GroupSupport@sym];
metricslots=Part[partitionedslots,metricpositions];
(* At which slot do we find an index contracted with the index in metricslots[[n,1]]? *)
contractionpos1=(First/@Position[indlist,-((#1)[[1]]/.slottoind),1])&/@metricslots ;
(* At which slot do we find an index contracted with the index in metricslots[[n,2]]? *)
contractionpos2=(First/@Position[indlist,-((#1)[[2]]/.slottoind),1])&/@metricslots ;
firstcontractedmetric1=First/@Position[(Length[#]>0)&/@contractionpos1,True,1];
firstcontractedmetric2=First/@Position[(Length[#]>0)&/@contractionpos2,True,1];
newpartitionedslots=partitionedslots;
If[Length@firstcontractedmetric1>0,
contractionslots={metricslots[[First@firstcontractedmetric1,1]],First@contractionpos1[[First@firstcontractedmetric1]]};
(* Print["Found contraction between the first index (at slot ",contractionslots[[1]],") of metric tensor ", headlist[[metricpositions[[First@firstcontractedmetric1]]]]," with the index at slot ", contractionslots[[2]]]; *)
stablecontraction=subsetQ[contractionslots,stableslots];
If[stablecontraction,
(* Print["Stable"]; *)
removetensor=metricpositions[[First@firstcontractedmetric1]];
slotchange1=partitionedslots[[removetensor,2]]->contractionslots[[2]];
contractionindex=contractionslots[[1]]/.slottoind;
contractionsign=If[UpIndexQ[contractionindex],xAct`xTensor`Private`SymmetryOfIndex[contractionindex],1];
If[contractionslots[[2]]==partitionedslots[[removetensor,2]],
(* Print["Self contraction"];*)
contractionsign=contractionsign*DimOfVBundle@VBundleOfIndex[contractionindex];]
,
(* Print["Not stable: ", x];*)
removetensor=0;
];
];
If[And[removetensor==0,Length@firstcontractedmetric2>0], 
contractionslots={metricslots[[First@firstcontractedmetric2,2]],First@contractionpos2[[First@firstcontractedmetric2]]};
(* Print["Found contraction between the second index (at slot ",contractionslots[[1]],") of metric tensor ", headlist[[metricpositions[[First@firstcontractedmetric2]]]]," with the index at slot ", contractionslots[[2]]]; *)
stablecontraction=subsetQ[contractionslots,stableslots];
If[stablecontraction,
(* Print["Stable"];*)
removetensor=metricpositions[[First@firstcontractedmetric2]];
slotchange1=partitionedslots[[removetensor,1]]->contractionslots[[2]];
contractionindex=contractionslots[[1]]/.slottoind;
contractionsign=If[UpIndexQ[contractionindex],1,xAct`xTensor`Private`SymmetryOfIndex[contractionindex]];
If[contractionslots[[2]]==partitionedslots[[removetensor,1]],Print["Self contraction"];
contractionsign=contractionsign*DimOfVBundle@VBundleOfIndex[contractionindex];]
,
(* Print["Not stable: ", x]; *)
removetensor=0;
];
];
If[removetensor==0,x,
innerheads=Delete[headlist,removetensor];
symbolpermutation=PermutationFromTo[Range@Length@headlist,Append[Delete[Range@Length@headlist,removetensor],removetensor]];
newpartitionedslots=PermuteList[partitionedslots,symbolpermutation];
newslots=Flatten[newpartitionedslots];
slotpermutation=PermutationFromTo[slotlist/.{slotchange1,Reverse@slotchange1},newslots];
newinds=Drop[PermuteList[List[inds],slotpermutation],-2];
newsym=sym/.List@@TranslatePerm[slotpermutation,Rules];
(* Also sort the base of the sym *)
newsym=TidyGroup@newsym;
(* One should probably change the label too. *)
newlabel=DefaultLabelSym[newsym];
RemoveSuperfluousSym[contractionsign*SymH[innerheads,newsym,newlabel][Sequence@@newinds]]]]]


ExpandInternalSym[expr_,options___]:=
expr/.x:(SymH[___][inds___]):>ExpandInternalSym1[x,options]


ExpandInternalSym1[x:(SymH[headlist_,sym_,label_][inds___]),options___]:=Module[{indlist=List[inds],slotlist=IndexList@@slot/@Range@Length@List[inds],slotrules},
slotrules=Thread@Rule[List@@slotlist,indlist];
ImposeSym[Expand@ExpandSym[InternalExprSym[Head@x]/.slotrules,options],indlist,sym,options]]


RuleInSym1[SymH[headlist_,sym_,label_][inds___],rule_]:=Module[{indlist=List[inds],slotlist=slot/@Range@Length@List[inds],internalexpr,tempinds=DummyAs/@List[inds],newinternalexpr},
internalexpr=InternalExprSym[SymH[headlist,sym,label]];
newinternalexpr=Expand[Expand@ExpandCovarDAndInertHeadHead[internalexpr/.Thread@Rule[slotlist,tempinds]]/.rule];
ImposeSym[newinternalexpr,IndexList@@tempinds,sym]/.Thread@Rule[tempinds,indlist]]


RuleInSym[expr_,rule_]:=expr/.x:(SymH[___][inds___]):>RuleInSym1[x,rule]


FunctionInSym1[SymH[headlist_,sym_,label_][inds___],func_]:=Module[{indlist=List[inds],slotlist=slot/@Range@Length@List[inds],internalexpr,tempinds=DummyAs/@List[inds],newinternalexpr},
internalexpr=InternalExprSym[SymH[headlist,sym,label]];
newinternalexpr=Expand@func[Expand[ExpandCovarDAndInertHeadHead[internalexpr/.Thread@Rule[slotlist,tempinds]]]];
ImposeSym[newinternalexpr,IndexList@@tempinds,sym]/.Thread@Rule[tempinds,indlist]]


FunctionInSym[expr_,func_]:=expr/.x:(SymH[___][inds___]):>FunctionInSym1[x,func]


RemoveSuperfluousPartialSym1[x:(SymH[headlist_,sym_,label_])]:=
With[{intsym=InternalSymmetrySym[x],symfactors=GroupFactorization1@xAct`xTensor`Private`SGSofsym@sym},
With[{newsym=TidyGroup[JoinSGS@@(Select[symfactors,Not@SubgroupQ[#,intsym]&])]},
SymH[headlist,newsym,DefaultLabelSym@newsym]
]]


RemoveSuperfluousPartialSym[expr_]:=
(expr/.x:SymH[___]:>RemoveSuperfluousPartialSym1[x])


SymmetricMixedSymmetry[unstableslots_,internalsym_,sym_,n_]:=Module[{internalstabilizer, newsym},
internalstabilizer=SetStabilizer[unstableslots,internalsym];
newsym=TidySGS@SchreierSims[{},Union[internalstabilizer[[2]],Append[sym,Cycles][[2]]]];
{newsym,internalstabilizer}]


SymmetryOfProductOfGroupsSymmetricCase[Delta0_List,H0_StrongGenSet,antisym_:False]:=
Module[{Delta=Sort@Delta0,Deltacompl,G1,H1, chainH1,permdeg, mm,alpham,Hmm1,Kmm1,K1,F1, GElements, unstablepoints,time,testfunc},
(* Arrange so that the groups have the same bases and cycle notation *)
(* Print["SymmetryOfProductOfGroupsBruteForce[",G0,",",H0,"]"]; *)
If[subsetQ[GroupSupport@H0,Delta],{If[antisym,
Antisymmetric[Delta,Cycles],
Symmetric[Delta,Cycles]],H0},
permdeg=Max[Max@@First[H0],Max@Delta,PermDeg[Last@H0]];
mm=permdeg-Length@Delta;
Deltacompl=Complement[Range@permdeg,Delta];
H1=DeleteSomeRedundantGenerators@BaseChange2[H0,Join[Deltacompl,Delta]];
If[antisym,
G1=ReplacePart[Antisymmetric[Delta,Cycles],1->First@H1],
G1=ReplacePart[Symmetric[Delta,Cycles],1->First@H1]];
(*Print["H1: ",H1];
Print["G1: ",G1];*)
chainH1=StabilizerChain2[H1];
Hmm1=chainH1[[mm]];
alpham=Hmm1[[1,1]];
(*Print["permdeg: ",permdeg];
Print["mm: ",mm];
Print["Hm: ",StabilizerChain[H1][[1+mm]]];
Print["Hm-1: ",Hmm1];
Print["alpham: ",alpham];*)
If[Intersection[Orbit[alpham,Hmm1[[2]]],Delta]===Delta,Kmm1=Hmm1,Kmm1=ReplacePart[chainH1[[1+mm]],1->chainH1[[mm,1]]]];
 (*Print["Kmm1: ",Kmm1];*)
If[mm==1,K1=Kmm1,
testfunc=Length@Complement[Deltacompl,StablePoints[First@SpecialPermWord[#,H1,Length@Delta],permdeg]]==0&;
(* GElements=Rest[List@@Dimino[G1]];*)
(* It should be enough to test one from each coset Hm.p where p is in G1 *)
{time,GElements}=AbsoluteTiming[InversePerm/@Rest[TransversalComputation[chainH1[[1+mm]],ReplacePart[G1,1->chainH1[[1+mm,1]]]]]]; If[$MixedSymVerbose,Print["GElements timing: ",time, " length: ", Length@GElements]];
(*Print["GElements: ",GElements];
Print["testfunc: ",testfunc];
Print["Search ",{H1,GpinHGQBruteForceSymmetric[#,testfunc,GElements]&,1,Kmm1}];*)
K1=SearchSym1[chainH1,GpinHGQBruteForceSymmetric[#,testfunc,GElements]&,1,mm+1,Kmm1,Delta];];
(*Print["K1: ",K1];*)
F1=StrongGenSet[H1[[1]],Join[Complement[K1[[2]],StabilizerChain2[H1][[1+mm,2]]],G1[[2]]]];
F1=DeleteRedundantGenerators[F1];
unstablepoints=GroupSupport@F1;
(*Print["F1: ",F1];*)
{DeleteSomeRedundantGenerators@ReplacePart[BaseChange2[F1,unstablepoints],1->unstablepoints],DeleteSomeRedundantGenerators@ReplacePart[BaseChange2[K1,unstablepoints],1->unstablepoints]}]]


SymmetryOfProductOfGroupsSymmetricCase2[Delta0_List,H0_StrongGenSet,antisym_:False]:=
Module[{Delta=Sort@Delta0,Deltacompl,G1,H1, chainH1,permdeg, mm,alpham,Hmm1,Kmm1,K1,F1, GElements, unstablepoints,time},
(* Arrange so that the groups have the same bases and cycle notation *)
(* Print["SymmetryOfProductOfGroupsBruteForce[",G0,",",H0,"]"]; *)
If[subsetQ[GroupSupport@H0,Delta],{If[antisym,
Antisymmetric[Delta,Cycles],
Symmetric[Delta,Cycles]],H0},
permdeg=Max[Max@@First[H0],Max@Delta,PermDeg[Last@H0]];
mm=permdeg-Length@Delta;
Deltacompl=Complement[Range@permdeg,Delta];
H1=DeleteSomeRedundantGenerators@BaseChange2[H0,Join[Deltacompl,Delta]];
If[antisym,
G1=ReplacePart[Antisymmetric[Delta,Cycles],1->First@H1],
G1=ReplacePart[Symmetric[Delta,Cycles],1->First@H1]];
(*Print["H1: ",H1];
Print["G1: ",G1];*)
chainH1=StabilizerChain2[H1];
Hmm1=chainH1[[mm]];
alpham=Hmm1[[1,1]];
(*Print["permdeg: ",permdeg];
Print["mm: ",mm];
Print["Hm: ",chainH1[[1+mm]]];
Print["Hm-1: ",Hmm1];
Print["alpham: ",alpham];*)
If[Intersection[Orbit[alpham,Hmm1[[2]]],Delta]===Delta,Kmm1=Hmm1,Kmm1=ReplacePart[chainH1[[1+mm]],1->chainH1[[mm,1]]]];
(* Print["Kmm1: ",Kmm1];*)
If[mm==1,K1=Kmm1,
(* GElements=Rest[List@@Dimino[G1]];*)
(* It should be enough to test one from each coset Hm.p where p is in G1 *)
{time,GElements}=AbsoluteTiming[InversePerm/@Rest[TransversalComputation[chainH1[[1+mm]],ReplacePart[G1,1->chainH1[[1+mm,1]]]]]]; If[$MixedSymVerbose,Print["GElements timing: ",time, " length: ", Length@GElements]];
(* Print["GElements: ",GElements];
Print["Search ",{chainH1,1,mm+1,Kmm1,Delta,GElements}]; *)
K1=SearchSym2[chainH1,SchreierOrbits[#,permdeg]&/@chainH1,1,mm+1,Kmm1,Delta,GElements];];
 (* Print["K1: ",K1];*)
F1=StrongGenSet[H1[[1]],Join[Complement[K1[[2]],chainH1[[1+mm,2]]],G1[[2]]]];
F1=DeleteSomeRedundantGenerators[F1];
unstablepoints=GroupSupport@F1;
(* Print["F1: ",F1];*)
{DeleteSomeRedundantGenerators@ReplacePart[BaseChange2[F1,unstablepoints],1->unstablepoints],DeleteSomeRedundantGenerators@ReplacePart[BaseChange2[K1,unstablepoints],1->unstablepoints]}]]


SearchSym1[chain_List,property_,s_Integer, l_Integer,SGSK_,Delta_,options___]:=Module[{base=chain[[1,1]],newSGSK=SGSK,k=Length[chain]-1,Deltas,gammas,Korbit,verb},
verb=xPermVerbose/.CheckOptions[options]/.Options[Search];
If[verb, Print["SearchSym1[",chain,",",property,",",s,",", l,",",SGSK,",",Delta,"]"]];
If[s==l-1,
newSGSK=SGSK,
newSGSK=SearchSym1[chain,property,s+1,l,SGSK,Delta,options];
Deltas=Orbit[base[[s]],chain[[s,2]]];
If[Intersection[Deltas,Delta]=!=Delta,Deltas=Complement[Deltas,Delta]];
If[verb,Print["Branching over points ",Deltas, " s=",s]];
(* Avoid rechecking permutations. Not in Butler's algorithm *)
(*If[s=!=k,Deltas=Drop[Deltas,1]];*)
If[s=!=l-2,Deltas=Drop[Deltas,1]];
Do[
gammas=Deltas[[j]];
Korbit=Orbit[gammas,newSGSK[[2]]];
If[verb,Print["gammas ", gammas, " Korbit ", Korbit]];
If[gammas===MinB[Korbit,base],
newSGSK=GenerateSym1[chain,property,s,l,s+1,Append[Take[base,s-1],gammas],newSGSK,Delta,verb];
If[Head[newSGSK]===Times,newSGSK=-newSGSK]]
,{j,1,Length[Deltas]}];
];
If[verb,Print["Return SGSK: ", newSGSK]];
newSGSK
];


GenerateSym1[chain_List,property_,s_,l_,i_,list_,SGSK_,Delta_,verb_]:=Module[{base=chain[[1,1]],k=Length[chain]-1,g,newSGSK=SGSK,Deltag,gammai,otherSGSK,schvecs=SchreierOrbits[#,PermLength[chain[[1]]]]&/@chain},
(* If[verb, Print["GenerateSym1[",chain,",",property,",",s,",",l,",",i,",",list,",",SGSK,",",Delta,",",verb,"]"]];*)
g=First@FromBaseImage2[list,schvecs];
If[verb,Print["Pregenerate at level ",s," with i=",i,". We have list ",list," and permutation ",g]];
If[i==l,
If[verb,Print["Generate at level ",s," with i=",i,". We have list ",list," and permutation ",g]];
If[Not@PermEqual[g,ID]&&Or[Length@Intersection[Delta,list]==0,property[g]]&&Not@PermMemberQ[g,SGSK],
newSGSK=-StrongGenSet[chain[[s,1]],Append[Last[SGSK],g]];
If[verb,Print["  Added permutation ",g," New SGSK: ", newSGSK]]],
Deltag=OnPoints[Orbit[base[[i]],chain[[i,2]]],g];
(* Here we should check if a point in Deltag is in Delta, 
then the entire Delta has to be in the orbit in chain[[s]]. 
Otherwise g can not be in the group. 
Can we refine this to the orbit in chain[[i]]??? *)
Deltag=Select[Deltag,Or[FreeQ[Delta,#],subsetQ[Delta,Orbit[#,chain[[s,2]]]]]&];
If[verb,Print["Generating over points ",Deltag, ", s=", s, ", i=",i,", list ",list]];
Do[
gammai=Deltag[[j]];
newSGSK=GenerateSym1[chain,property,s,l,i+1,Append[list,gammai],newSGSK,Delta,verb];
If[Head[newSGSK]===Times,Break[]],
{j,1,Length[Deltag]}];
];
newSGSK
];


SearchSym2[chain_List,schvecs_,s_Integer, l_Integer,SGSK_,Delta_,GElements_,options___]:=Module[{base=chain[[1,1]],newSGSK=SGSK,k=Length[chain]-1,Deltas,gammas,Korbit,verb},
verb=xPermVerbose/.CheckOptions[options]/.Options[Search];
If[verb, Print["SearchSym2[",chain,",",schvecs,",",s,",", l,",",SGSK,",",Delta,",",GElements,"]"]];
If[s==l-1,
newSGSK=SGSK,
newSGSK=SearchSym2[chain,schvecs,s+1,l,SGSK,Delta,GElements,options];
Deltas=Orbit[base[[s]],chain[[s,2]]];
If[Intersection[Deltas,Delta]=!=Delta,Deltas=Complement[Deltas,Delta]];
If[verb,Print["Branching over points ",Deltas, " s=",s]];
(* Avoid rechecking permutations. Not in Butler's algorithm *)
(*If[s=!=k,Deltas=Drop[Deltas,1]];*)
If[s=!=l-2,Deltas=Drop[Deltas,1]];
Do[
gammas=Deltas[[j]];
Korbit=Orbit[gammas,newSGSK[[2]]];
If[verb,Print["gammas ", gammas, " Korbit ", Korbit]];
If[gammas===MinB[Korbit,base],
newSGSK=GenerateSym2[chain,schvecs,s,l,s+1,Append[Take[base,s-1],gammas],newSGSK,Delta,GElements,verb];
If[Head[newSGSK]===Times,newSGSK=-newSGSK]]
,{j,1,Length[Deltas]}];
];
If[verb,Print["Return SGSK: ", newSGSK]];
newSGSK
];


GenerateSym2[chain_List, schvecs_,s_,l_,i_,list_,SGSK_,Delta_,GElements_,verb_]:=Module[{base=chain[[1,1]],k=Length[chain]-1,g,newSGSK=SGSK,Deltag,gammai,otherSGSK,Deltacompl},
(* If[verb, Print["GenerateSym1[",chain,",",property,",",s,",",l,",",i,",",list,",",SGSK,",",Delta,",",verb,"]"]];*)
Deltacompl=Drop[base,-Length@Delta];
g=First@FromBaseImage2[list,schvecs];
If[verb,Print["Pregenerate at level ",s," with i=",i,". We have list ",list," and permutation ",g]];
If[i==l,
If[verb,Print["Generate at level ",s," with i=",i,". We have list ",list," and permutation ",g]];
If[Not@PermEqual[g,ID]&&Or[Length@Intersection[Delta,list]==0,GpinHGQBruteForceSymmetric2[list,Deltacompl, schvecs,GElements]]&&Not@PermMemberQ[g,SGSK],
newSGSK=-StrongGenSet[chain[[s,1]],Append[Last[SGSK],g]];
If[verb,Print["  Added permutation ",g," New SGSK: ", newSGSK]]],
Deltag=OnPoints[Orbit[base[[i]],chain[[i,2]]],g];
(* Here we should check if a point in Deltag is in Delta, 
then the entire Delta has to be in the orbit in chain[[s]]. 
Otherwise g can not be in the group. 
Can we refine this to the orbit in chain[[i]]??? *)
Deltag=Select[Deltag,Or[FreeQ[Delta,#],subsetQ[Delta,Orbit[#,chain[[s,2]]]]]&];
If[verb,Print["Generating over points ",Deltag, ", s=", s, ", i=",i,", list ",list]];
Do[
gammai=Deltag[[j]];
newSGSK=GenerateSym2[chain,schvecs,s,l,i+1,Append[list,gammai],newSGSK,Delta,GElements,verb];
If[Head[newSGSK]===Times,Break[]],
{j,1,Length[Deltag]}];
];
newSGSK
];


SpecialPermWord[perm_,StrongGenSet[base_List,GS_GenSet],Deltalength_,word_List:{}]:=If[Length[base]<=Deltalength,
Prepend[word,perm],
Module[{
Sorbit=SchreierOrbit[First[base],GS,Max[PermDeg[perm],PermDeg[GS],Max[base]]],
point=OnPoints[First[base],perm],
u},
If[MemberQ[First[Sorbit],point],
u=TraceSchreier[point,Sorbit];
SpecialPermWord[PermProduct[perm,InversePerm[u]],StrongGenSet[Rest[base],Stabilizer[{First[base]},GS]],Deltalength,Prepend[word,u]],
Prepend[word,perm]]
]
];


SpecialPermMemberQ[p_,H_,Delta_,n_]:=Length@Complement[Complement[Range@n,Delta],StablePoints[First@SpecialPermWord[p,H,Length@Delta],n]]==0


GpinHGQBruteForceSymmetric[p_,testfunc_,Gelements_]:=
Module[
{TestList=Gelements,
result=True},
While[(Length[TestList]>0)&&result,
result=testfunc@PermProduct[p,First@TestList];
TestList=Rest@TestList;];
result
]


GpinHGQBruteForceSymmetric2[list_,deltacompl_, schvecs_,Gelements_]:=
Module[
{TestList=Gelements,
result=True},
While[(Length[TestList]>0)&&result,
result=deltacompl==Last@FromBaseImage2[OnPoints[list,First@TestList],schvecs];
(* Print["Tested ", First@TestList, ": ", result];*)
TestList=Rest@TestList;];
result
]


FromBaseImage2[images_List,schvecs_]:=Module[{i,u,g=ID,imgs=images},
For[i=1,i<=Length[imgs],i++,
If[MemberQ[schvecs[[i,1]],imgs[[i]]],
u=TraceSchreier[imgs[[i]],schvecs[[i]]];
g=PermProduct[u,g];
imgs=OnPoints[imgs,InversePerm[u]]
]];
{g,imgs}
]


AntisymmetricMixedSymmetry[unstableslots_,internalsym_,sym_,n_]:=Module[{internalstabilizer, newsym},
internalstabilizer=SetStabilizer[unstableslots,internalsym];
newsym=TidySGS@SchreierSims[{},Union[internalstabilizer[[2]],Append[sym,Cycles][[2]]]];
{newsym,internalstabilizer}]


GeneralMixedSymmetry[unstableslots_,internalsym_,sym_,n_]:=Module[{time,result,longorbits,joinedsymmetric},
If[SubgroupQ[internalsym,sym],{xAct`xTensor`Private`SGSofsym@sym,internalsym},
{time,result}=AbsoluteTiming@SymmetryOfProductOfGroupsBruteForce[sym,internalsym];
If[$MixedSymVerbose,
Print["GeneralMixedSymmetry: ", time, "s."]
];
result]]


FindInternalCanonicalSymGroupAndPerm[SymH[headlist:{SymH[intheadlist_, intsym_, intlabel_]},sym_,label_]]:=Module[{newinternalSymH, intcanonperm,newsym,newSymH, canonicalizingperm, tmpexpr},
{newinternalSymH, intcanonperm}=FindInternalCanonicalSymGroupAndPerm[SymH[intheadlist, intsym, intlabel]];
newsym=sym/.List@@(TranslatePerm[nosign@intcanonperm,Rules]);
newsym=TidyGroup@newsym;
tmpexpr=SymH[{newinternalSymH},newsym,""];
{newSymH, canonicalizingperm}=FindCanonicalSymGroupAndPerm[tmpexpr];
{newSymH, PermProduct[intcanonperm,canonicalizingperm]}]


FindInternalCanonicalSymGroupAndPerm[SymH[headlist_,sym_,label_]]:=FindCanonicalSymGroupAndPerm[SymH[headlist,sym,label]]


FindCanonicalSymGroupAndPerm[SymH[headlist_,sym_,label_]]:=Module[{n=Plus@@(Length/@SlotsOfTensor/@headlist),unstableslots, newsymh, perm},
unstableslots=GroupSupport@sym;
{newsymh,perm}=Which[Head@sym===Symmetric,(* Symmetric *)
CanonicalizeSymmetricGroupInSym[SymH[headlist,sym,label],n,unstableslots],
Head@sym===Antisymmetric,(* Antisymmetric *)
CanonicalizeAntisymmetricGroupInSym[SymH[headlist,sym,label],n,unstableslots],
True,(* Everything else *)
CanonicalizeGeneralGroupInSym[SymH[headlist,sym,label],n]]]


CanonicalizeGroupInSym[expr_]:=expr/.SymH[headlist_,sym_,label_][inds___]:>Module[
{newSymH, canonicalizingperm},
{newSymH,canonicalizingperm}=FindInternalCanonicalSymGroupAndPerm[SymH[headlist,sym,label]];
sign[canonicalizingperm]*newSymH@@PermuteList[{inds},canonicalizingperm]]


Options[ToCanonicalSym]={RemoveSuperfluousPartialSym->False}


ToCanonicalSym[expr_,options:OptionsPattern[]]:=ToCanonical@With[{remsuppartsym=OptionValue[RemoveSuperfluousPartialSym]},If[remsuppartsym,CanonicalizeGroupInSym@RemoveSuperfluousPartialSym@RemoveSuperfluousSym@expr,CanonicalizeGroupInSym@expr]]


CanonicalizeSymmetricGroupInSym[SymH[headlist_,sym_,label_],n_,unstableslots_]:=
Module[
{CanonicalSym=sym,newlabel=label,InternalSym, canonicalslots,canonicalizingperm},
InternalSym=InternalSymmetrySym[SymH[headlist,sym,label]];
 {canonicalslots,canonicalizingperm}=FindSmallestImageAndMapping[unstableslots,InternalSym,n];
CanonicalSym=Symmetric@Sort@canonicalslots;
newlabel=StringJoin["(",ToString/@canonicalslots,")"];
{SymH[headlist,CanonicalSym,newlabel],canonicalizingperm}]


CanonicalizeAntisymmetricGroupInSym[SymH[headlist_,sym_,label_],n_,unstableslots_]:=
Module[
{CanonicalSym=sym,newlabel=label,InternalSym, canonicalslots,canonicalizingperm},
InternalSym=InternalSymmetrySym[SymH[headlist,sym,label]];
 {canonicalslots,canonicalizingperm}=FindSmallestImageAndMapping[unstableslots,InternalSym,n];
CanonicalSym=Antisymmetric@Sort@canonicalslots;
newlabel=StringJoin["[",ToString/@canonicalslots,"]"];
{SymH[headlist,CanonicalSym,newlabel],canonicalizingperm}]


CanonicalizeGeneralGroupInSym[SymH[headlist_,sym_,label_],n_]:=
Module[{time,result},
{time,result}=AbsoluteTiming@Module[{newlabel=label, newsym, InternalSym, InternalSymElements, PermIndex,newunstableslots,reverserule=Thread@Rule[Range@n,Reverse@Range@n],intsymel,reversesym},
(* Find a short representation of the reversed version of sym. This makes the following computations faster. *)
reversesym=StrongGenSet[#[[1,1]],GenSet@@xAct`SymManipulator`Private`SmallestGenSet@#]&@xAct`SymManipulator`Private`SmallestBaseStabChain[sym/.reverserule];
InternalSym=InternalSymmetrySym[SymH[headlist,sym,label]]/.reverserule;
InternalSymElements=List@@Dimino@InternalSym;
{PermIndex, newsym}=SmallestGroup[reversesym/.List@@@TranslatePerm[nosign/@InternalSymElements,Rules]];
newsym=TranslatePerm[StrongGenSet[#[[1,1]],GenSet@@xAct`SymManipulator`Private`SmallestGenSet@#]&@xAct`SymManipulator`Private`SmallestBaseStabChain[TranslatePerm[newsym,Cycles]/.reverserule],Cycles];
(*newsym=TranslatePerm[TranslatePerm[newsym,Rules]/.reverserule,Cycles];*)
newsym=MapAt[Sort,newsym,{2}];
intsymel=(InternalSymElements[[PermIndex]])/.reverserule;
newlabel=DefaultLabelSym[newsym];
newunstableslots=Complement[Range@n,StablePoints[Last@newsym,n]];
newunstableslots=DeleteDuplicates@Join[First@newsym,newunstableslots];
newsym=ReplacePart[newsym,1->newunstableslots];
{SymH[headlist,newsym,newlabel],intsymel}];
(*Print["CanonicalizeGeneralGroupInSym: ", time, "s."];*)
result]


FindCanonicalGroup[G1_,H1_,n_,perm_:Cycles[]]:=Module[{G2=StrongGenSet[#[[1,1]],GenSet@@xAct`SymManipulator`Private`SmallestGenSet@#]&@xAct`SymManipulator`Private`SmallestBaseStabChain[G1],longorbits=Select[Sort/@Orbits@H1,Length@#>1&],firstorbitpoint, firstschreierorbit, firstperms,PermIndex,G3},
If[Length@longorbits==0,{G2,perm},
firstorbitpoint=First@Sort[First/@longorbits];
firstschreierorbit=SchreierOrbit[firstorbitpoint,Last@H1,n];
firstperms=TraceSchreier[#,firstschreierorbit]&/@First@firstschreierorbit;
{PermIndex, G3}=xAct`SymManipulator`Private`SmallestGroup[G2/.List@@@TranslatePerm[xAct`SymManipulator`Private`nosign/@firstperms,Rules]];
FindCanonicalGroup[TranslatePerm[G3,Cycles],Stabilizer[{firstorbitpoint},H1],n,PermProduct[perm,firstperms[[PermIndex]]]]]]


CanonicalizeGeneralGroupInSym2[SymH[headlist_,sym_,label_],n_]:=
Module[{time,result},
{time,result}=AbsoluteTiming@Module[{newlabel=label, newsym, InternalSym, InternalSymElements, PermIndex,newunstableslots,reverserule=Thread@Rule[Range@n,Reverse@Range@n],intsymel,reversesym, firstorbitpoint},
(* Find a short representation of the reversed version of sym. This makes the following computations faster. *)
reversesym=StrongGenSet[#[[1,1]],GenSet@@xAct`SymManipulator`Private`SmallestGenSet@#]&@xAct`SymManipulator`Private`SmallestBaseStabChain[sym/.reverserule];
InternalSym=xAct`SymManipulator`Private`InternalSymmetrySym[SymH[headlist,sym,label]]/.reverserule;
{newsym,intsymel}=FindCanonicalGroup[reversesym,InternalSym,n];
newsym=TranslatePerm[TranslatePerm[newsym,Rules]/.reverserule,Cycles];
newsym=MapAt[Sort,newsym,{2}];
intsymel=intsymel/.reverserule;
newlabel=xAct`SymManipulator`Private`DefaultLabelSym[newsym];
newunstableslots=Complement[Range@n,StablePoints[Last@newsym,n]];
newunstableslots=DeleteDuplicates@Join[First@newsym,newunstableslots];
newsym=ReplacePart[newsym,1->newunstableslots];
{SymH[headlist,newsym,newlabel],intsymel}];
(* Print["CanonicalizeGeneralGroupInSym2: ", time, "s."];*)
result]


Options[IrrDecompose]^={Verbose->False,IrrDecSpinBundles->All, UseSym->True,IrrDecImposeNewMethod->False,TimeVerbose->False, ResultType->"Expression"};


IrrDecompose[expr_,options:OptionsPattern[]]:=Module[{verb,AllIrrDecSpinBundles,spinbundlesoption,SpinVBs,expandedexpr=Expand[expr], irrdecexpr1,MethodOption,TimeVerboseOption, usesymoption,time,resulttype},
If[Not@MemberQ[$ContextPath,"xAct`Spinors`"],
Throw@Message[IrrDecompose::error,"The Spinors package is needed for this. Please load the packages Spinors first."]];
{MethodOption,TimeVerboseOption,spinbundlesoption,usesymoption,resulttype,verb}=OptionValue[{IrrDecImposeNewMethod,TimeVerbose,IrrDecSpinBundles, UseSym, ResultType,Verbose}];
AllIrrDecSpinBundles=xAct`Spinors`VBundleOfSolderingForm/@xAct`Spinors`$SolderingForms;AllIrrDecSpinBundles=Union[AllIrrDecSpinBundles,Dagger/@AllIrrDecSpinBundles];
SpinVBs=AllIrrDecSpinBundles;
If[Not[spinbundlesoption===All],
SpinVBs=Intersection[AllIrrDecSpinBundles,spinbundlesoption]];
{time, irrdecexpr1} = AbsoluteTiming@IrrDecompose2[expandedexpr,{SpinVBs,verb}];
If[TimeVerboseOption,Print["IrrDecompose step 1 timing:", time]];
If[And[usesymoption,Head@expandedexpr=!=Plus],
Module[{freeinds, freesym},
{freeinds, freesym}=SymmetryOfFreeIndices[expandedexpr,SpinVBs];
If[MethodOption,
{time, irrdecexpr1} = AbsoluteTiming@ToCanonical@ImposeSymmetryOnIrrdecTerms[irrdecexpr1,freeinds, freesym,SpinVBs],
{time, irrdecexpr1} = AbsoluteTiming@ToCanonical@ImposeSymmetry[irrdecexpr1,freeinds,freesym]];
If[TimeVerboseOption,Print["IrrDecompose step 2 timing:", time]];
]];
Switch[resulttype,
"Expression",irrdecexpr1,
"Equation",Equal[expr,irrdecexpr1],
"Rule",MakeRule[Evaluate[{expr,irrdecexpr1},MetricOn->All,ContractMetrics->True]],
"CompareRule",MakeCompareRule[Evaluate[{expr,irrdecexpr1}]],
_,Null]]


CompleteIrrDecompose[expr_,opt___]:=IrrDecompose[expr,UseSym->True,opt]


IrrDecompose2[expr_Plus,opt_]:=IrrDecompose2[#,opt]&/@expr


IrrDecompose2[s_?ScalarQ,opt_]:=s


IrrDecompose2[expr_,{SpinVBs_,verb_}]:=
Module[{frees=FindFreeIndices@expr,n,slotexpr,slotrules,sym,freeslots,totalsymoffrees,return},
(* Finds the free indices that are in SpinVBs *)
frees=Select[frees,MemberQ[SpinVBs,VBundleOfIndex@#]&];
{n,slotexpr,slotrules,sym}=List@@SymmetryOf[expr];
(* Which slots contains the free indices *)
freeslots=First/@List@@Replace[List@@frees, Reverse/@slotrules, {1}];
totalsymoffrees=CompatibleSymmetric[frees]/.Thread@Rule[Range@Length@frees,freeslots];
(* Check if expr is already irreducible, that is if it has maximal symmetry on its free indices *)
If[verb,Print["IrrDecompose2[",expr,",{",SpinVBs,",",verb,"}]"]];
return=If[SubgroupQ[totalsymoffrees,sym],
expr,
(* If it is not irreducible, rewrite ImposeSym[expr,frees] with DecomposeStep2[expr,frees]
  After that metrics are moved outside the sym if they are not symmetrized upon. *)
ToCanonical[
(expr+ToCanonicalSym@RemoveSuperfluousInnerSym@MoveTensorsOutsideSym[ImposeSym[expr,frees],True]-DecomposeStep2[expr,frees,{SpinVBs,verb}])]];
return]


DecomposeStep2[expr_, inds_,{SpinVBs_,verb_}] := Module[{frees = FindFreeIndices[expr], splitindices},
If[verb,Print["DecomposeStep2[",expr,",",inds,",{",SpinVBs,",",verb,"}]"]];
  If[Length[inds] < 2,
(* If we have less than two indices we can not rewrite the expression *)
expr,
splitindices = Select[inds, VBundleOfIndex[#] == VBundleOfIndex@First@inds &];
If[Length[splitindices] < 2,
(* If we only have one index in this VBundle, then we can not do anything with this index,
   so we continue the procedure with the rest of the indices. *)
DecomposeStep2[expr, Rest@inds,{SpinVBs,verb}],
(* If we more indices in this VBundle, then we do something more complicated. *)
Module[{tmpexpr, tmpexpr2, tmpexpr3, tmpexpr4, tmpexpr4b, tmpexpr5, tmpexpr6, finaltmpexpr, dummyindex, permutationrules},
(* First, make a recursive call to guarantee that tmpexpr represents ImposeSym[expr,Rest@inds]
   written as expr + epsilon times traces *)
tmpexpr = DecomposeStep2[expr, Rest@inds,{SpinVBs,verb}];
(* Let tmpexpr2 be the same thing but represented as a SymH object *)
tmpexpr2 = ImposeSym[expr, Rest@inds, CompatibleSymmetric[Rest@inds]];
(* We want to take a trace between splitindices[[1]] and splitindices[[2]].
 First we remove these two indices from the symmetry, 
   and move possible metrics outside the SymH object. *)
If[verb,Print["DecomposeStep2[",expr,",",inds,"...]: tmpexpr=",tmpexpr];
Print["DecomposeStep2[",expr,",",inds,"...]: tmpexpr2=",tmpexpr2]];
tmpexpr3 =MoveTensorsOutsideSym[Expand@ExpandSymOneIndex[ExpandSymOneIndex[tmpexpr2, splitindices[[1]]], splitindices[[2]]],True];
(* Generate a new dummy index for the trace. *)
dummyindex =DownIndex@DummyIn@VBundleOfIndex[splitindices[[2]]];
(* Make the contraction. *)
tmpexpr4 = ReplaceIndex[Evaluate@tmpexpr3, {splitindices[[1]] -> -dummyindex, splitindices[[2]] -> dummyindex}];
If[verb,Print["DecomposeStep2[",expr,",",inds,"...]: tmpexpr4=",tmpexpr4]];
(* If we now got a metric with one index contracted and the other in the symmetry,
   we can contract this metric. After that, the expression is canonicalized. *)
tmpexpr4b = ToCanonicalSym@ContractMetricsInsideSym@tmpexpr4;
(* Find the Irreducible decomposition of this symmetrized and contracted expression. *)
tmpexpr5 = IrrDecompose2[tmpexpr4b,{SpinVBs,verb}];
(* Multiply this with the epsilon of the first two splitindices *)
tmpexpr6 = Expand[(First@MetricsOfVBundle@VBundleOfIndex[splitindices[[1]]])[splitindices[[1]], splitindices[[2]]]*tmpexpr5];
(* The idea is now that expr can be written as tmpexpr + c*ImposeSym[tmpexpr6, Rest@splitindices].
The problem is that the second term will contain epsilons with symmetrizations. 
We want to avoid that. We notive that tmpexpr6 is symmetric in Rest@Rest@splitinices.
The symmetrization can therefore be represented by the permutations that interchange 
 splitindices[[2]] with Rest@splitindices *)
(* Construct the rules that interchange splitindices[[2]] with Rest@splitindices. *)
permutationrules = {Rule[splitindices[[2]], splitindices[[#]]], Rule[splitindices[[#]], splitindices[[2]]]}& /@ Range[2, Length[splitindices]];
(* The final expression therefore has this form. *)
finaltmpexpr = Expand[tmpexpr + 1/Length[splitindices]*Plus @@ (tmpexpr6 /. permutationrules)];
finaltmpexpr]]]]


SymmetryOfFreeIndices[expr_,SpinVBs_]:=Module[{freeinds=FindFreeIndices@expr, 
freeinvbslots, restslots, slotexpr,slotrules,sym,n,freefirstperm, freesym,freeinvb,restfrees},
{n,slotexpr,slotrules,sym}=List@@SymmetryOf[expr];
freeinvb=Select[freeinds,MemberQ[SpinVBs,UpIndex@VBundleOfIndex[#]]&];
freeinvbslots=First/@List@@Replace[List@@freeinvb, Reverse/@slotrules, {1}];
restslots=Complement[Range@n,freeinvbslots];
freefirstperm=List@@TranslatePerm[PermutationFromTo[Range@n,Join[freeinvbslots,restslots]],Rules];
(* The stabilizer only gives a subset of the symmetry, but might be good enough. *)
freesym=StabilizerSGS[restslots,sym];
freesym[[1]]=Complement[freesym[[1]],restslots];
freesym=freesym/.freefirstperm;
{IndexList@@freeinvb, freesym}]


FreeIndsOfIrrDecPart[expr_,spinmetrics_]:=With[{vbPMQs=xAct`xTensor`Private`VBundleIndexPMQ/@VBundleOfMetric/@spinmetrics},
FindFreeIndices@Evaluate[expr/.((#[A_,B_]->1)&/@spinmetrics)/.((delta[A_?#,B_?#]->1)&/@vbPMQs)]]


ImposeSymmetryOnIrrdecTerms[expr_,freeinds_, freesym_,SpinVBs_]:=Module[{spinmetrics},
spinmetrics=First/@MetricsOfVBundle/@SpinVBs;ImposeSymmetryOnIrrdecTerm[Expand@expr,spinmetrics,freeinds, freesym]]


ImposeSymmetryOnIrrdecTerm[expr_Plus,spinmetrics_,freeinds_, freesym_]:=ImposeSymmetryOnIrrdecTerm[#,spinmetrics,freeinds, freesym]&/@expr


ImposeSymmetryOnIrrdecTerm[expr_,spinmetrics_,freeinds_, freesym_]:=Module[{irrdecpartfrees,stabpoints,newfreesym,permlist},
irrdecpartfrees=FreeIndsOfIrrDecPart[expr,spinmetrics];
stabpoints=Select[Range@Length@freeinds,FreeQ[irrdecpartfrees,freeinds[[#]],1]&];
newfreesym=BaseChange2[freesym,stabpoints];
permlist=InversePerm/@xAct`SymManipulator`Private`TransversalComputation[StrongGenSet[newfreesym[[1]],Stabilizer[stabpoints,newfreesym[[2]]]],newfreesym];
Expand@ImposeSymmetry[expr,freeinds,Group@@permlist,Identity]
]


SymmetryOfExpression[expr_]:=Module[{frees=FindFreeIndices@expr,HasSym,completesymmetricSGS},
With[{n=Length@frees},
HasSym[p_]:=ToCanonical[PermuteIndices[expr,frees,xAct`xPerm`Private`ToSign[p,n]]-expr]===0;
completesymmetricSGS=JoinSGS[Symmetric[Range@n,Cycles],Symmetric[{n+1,n+2},Cycles]];
completesymmetricSGS=ReplacePart[completesymmetricSGS,1->Append[Range[n-1],n+1]];
{xAct`xPerm`Private`ToSign[Search[completesymmetricSGS,HasSym,1,StrongGenSet[{},GenSet[]]],n],frees}]]


SpecialEqualExpressionsQ[0,expr2_]:={expr2===0,1,{},{}};


SpecialEqualExpressionsQ[expr1_,expr2_]:=
    Module[{inds1,frees1,frees2,dummies1,dummies2,sortedfrees1,sortedfrees2, sortrule1,dummies1slots, frees1slots,slotrules1, expr1SGS, stabilizerSGS, compatiblesymfrees1, transversal1, indstoslotnumbers,freesym1,perms1,arrexpr2,newexpr2,
        count,result=False,perm={},xxx,equation,solution=0},
      (* Indices of expr1 *)
(* Print["SpecialEqualExpressionsQ[",expr1,",",expr2,"]"];*)
inds1=FindIndices[expr1];
dummies1=List@@xAct`xTensor`Private`TakeEPairs@inds1;
frees1=List@@xAct`xTensor`Private`TakeFrees@inds1;
(* Indices of expr2 *)
{frees2,dummies2}=List@@xAct`xTensor`Private`FindFreeAndDummyIndices[expr2];
sortedfrees2=List@@(Last/@Sort[{VBundleOfIndex[#],#}&/@IndexSort[frees2]]);
sortedfrees1=List@@(Last/@Sort[{VBundleOfIndex[#],#}&/@IndexSort[frees1]]);
If[And[Length[frees1]==Length[frees2],
(VBundleOfIndex/@sortedfrees1)===(VBundleOfIndex/@sortedfrees2)],
dummies2=List@@dummies2;
inds1=List@@inds1;
{slotrules1,expr1SGS}=List@@Take[SymmetryOf@expr1,-2];
indstoslotnumbers=(Reverse/@slotrules1)/.xAct`xTensor`Private`slot[x_]->x;
sortrule1=Thread@Rule[Range@Length@frees1,sortedfrees1/.indstoslotnumbers];
dummies1slots=dummies1/.indstoslotnumbers;
frees1slots=frees1/.indstoslotnumbers;
xAct`xTensor`Private`checkChangeFreeIndices[sortedfrees1,sortedfrees2];
(* Computing permutations of the free indices of expr1 *)
(* One could use perms1=Permutations[List@@frees1], 
  but this can be reduced by considering the symmetries of the free indices of expr1 *)
(* The stabilizer of the dummies for the symmetry of expr1 gives a subset of the symmetry on dummies1. 
The numbers in the group correspond to the position of the index in frees1. *)
stabilizerSGS=StabilizerSGS[dummies1slots,expr1SGS]/.Reverse/@sortrule1;
compatiblesymfrees1=CompatibleSymmetric[IndexList@@sortedfrees1];
(* If the stabilizer is trivial, we will have all permutations. *)
If[stabilizerSGS[[2]]===GenSet[],
transversal1 =List@@Dimino@compatiblesymfrees1,
(* The code for the transversal is probably not optimal. *)
transversal1 =TransversalInCompatibleSymmGroup[stabilizerSGS,compatiblesymfrees1];
];
(* Translate this to permutations of the same kind as Permutations[List@@frees1] gives. *)
perms1=TranslatePerm[transversal1,{Perm,Length@frees1}]/.Perm[{x___}]->{x}/.Thread@Rule[Range@Length@frees1,sortedfrees1];
(* Remove collisions between frees1 and dummies2 *)
arrexpr2=xAct`xTensor`Private`arrangedummies[expr2,dummies2,frees1];
DefConstantSymbol[xxx,DefInfo->False];
Do[
newexpr2=xAct`xTensor`Private`changeFreeIndices[arrexpr2,sortedfrees2,perms1[[count]]];
equation=ToCanonical[expr1-xxx newexpr2];
solution=First[xxx/.Solve[equation==0,xxx]];
If[ConstantQ[solution],result=True;
perm=Inner[Rule,perms1[[count]],sortedfrees2,List];Break[]],
{count,Length[perms1]}]];
{result,solution,sortedfrees2,perm}
      ];


SetNumberOfArguments[SpecialEqualExpressionsQ,2];
Protect[SpecialEqualExpressionsQ];


SetAttributes[MakeCompareRule,HoldFirst];


MakeCompareRule[{tensora_?xTensorQ[indsaeq___],RHS_},___]:=With[{dummieseq=xAct`xTensor`Private`TakeEPairs[{indsaeq}]},With[{numdummiesaeq=Length@Intersection[dummieseq,{indsaeq}]},RuleDelayed[HoldPattern@tensora[indsa___],With[{dummies=xAct`xTensor`Private`TakeEPairs[{indsa}],frees=xAct`xTensor`Private`TakeFrees[{indsa}]},Module[{equalexpr,sign,sortedfrees,perm},{equalexpr,sign,sortedfrees,perm}=SpecialEqualExpressionsQ[tensora[indsaeq],tensora[indsa]];With[{arrexpr2=ReplaceDummies[RHS]},ReplaceIndex[Evaluate[sign*arrexpr2],perm]]/;equalexpr]/;Length@Intersection[dummies,{indsa}]==numdummiesaeq]]]];


MakeCompareRule[{LHS:Times[_?xTensorQ[___],_?xTensorQ[___]...],RHS_},___]:=
With[{indslist=ToExpression[StringJoin["tinds",ToString[#]]&/@Range[Length@LHS]]},
With[{rulelhs=MapIndexed[#1[[0]][First@indslist[[#2]]]&,LHS],rulelhspattern=MapIndexed[#1[[0]][With[{patterninds=First@indslist[[#2]]},Pattern[patterninds,BlankNullSequence[]]]]&,LHS]},
RuleDelayed[HoldPattern@rulelhspattern,
With[{rulelhsinds=FindIndices[rulelhs]},
With[{dummieslhs=xAct`xTensor`Private`TakeEPairs[rulelhsinds],freeslhs=xAct`xTensor`Private`TakeFrees[rulelhsinds]},
Module[{equalexpr,sign,sortedfrees,perm},{equalexpr,sign,sortedfrees,perm}=SpecialEqualExpressionsQ[LHS,rulelhs];
Module[{arrexpr2=ReplaceDummies[RHS]},ReplaceIndex[Evaluate[sign*arrexpr2],perm]]/;equalexpr]]]]]];


MakeCompareRule[{covd_?CovDQ[indscdeq___][tensora_?xTensorQ[indsaeq___]],RHS_},___]:=With[{dummieseq=xAct`xTensor`Private`TakeEPairs[{indscdeq,indsaeq}]},With[{numdummiesaeq=Length@Intersection[dummieseq,{indscdeq,indsaeq}]},RuleDelayed[HoldPattern@covd[indscd___][tensora[indsa___]],With[{dummies=xAct`xTensor`Private`TakeEPairs[{indscd,indsa}],frees=xAct`xTensor`Private`TakeFrees[{indscd,indsa}]},Module[{equalexpr,sign,sortedfrees,perm},{equalexpr,sign,sortedfrees,perm}=SpecialEqualExpressionsQ[covd[indscdeq][tensora[indsaeq]],covd[indscd][tensora[indsa]]];With[{arrexpr2=ReplaceDummies[RHS]},ReplaceIndex[Evaluate[sign*arrexpr2],perm]]/;equalexpr]/;Length@Intersection[dummies,{indscd,indsa}]==numdummiesaeq]]]];


GetIndexRange[k_,vbundle_]:=Module[{n=Length@Flatten[IndicesOfVBundle[vbundle]]},NewIndexIn[vbundle]&/@Range[k-n];Take[Flatten[IndicesOfVBundle[vbundle]],k]]


GiveIndicesToTensor[TT_?xTensorQ,upvbundles_:{}]:=Module[{n=Length@SlotsOfTensor@TT,vbundles=UpIndex/@SlotsOfTensor@TT,gatheredslots,inds,slotrules},gatheredslots=GatherBy[Range@n,vbundles[[#]]&];
inds=Flatten[GetIndexRange@@@({Length@#,vbundles[[First@#]]}&/@gatheredslots)];
inds=If[MemberQ[upvbundles,VBundleOfIndex[#]],#,DownIndex[#]]&/@inds;
slotrules=Thread@Rule[Flatten@gatheredslots,inds];
TT@@(Range@n/.slotrules)]


ChangeFreeIndicesToDefault[expr_,upvbundles_:{}]:=
With[{freeinds=List@@FindFreeIndices@Evaluate[expr]},Module[{n=Length@freeinds,vbundles=UpIndex/@VBundleOfIndex/@freeinds,gatheredslots,inds,slotrules,indsrule},gatheredslots=GatherBy[Range@n,vbundles[[#]]&];
inds=Flatten[GetIndexRange@@@({Length@#,vbundles[[First@#]]}&/@gatheredslots)];
inds=If[MemberQ[upvbundles,VBundleOfIndex[#]],#,DownIndex[#]]&/@inds;
slotrules=Thread@Rule[Flatten@gatheredslots,inds];
indsrule=Thread@Rule[freeinds,Range@n/.slotrules];
ScreenDollarIndices[ReplaceIndex[Evaluate[ReplaceDummies@expr],indsrule]]]];


$IndexConfigs={};


AddToIndexConfigRule[tensora_?xTensorQ[indsaeq___]]:=With[{dummieseq=xAct`xTensor`Private`TakeEPairs[{indsaeq}]},With[{numdummiesaeq=Length@Intersection[dummieseq,{indsaeq}]},RuleDelayed[HoldPattern@tensora[indsa___],With[{dummies=xAct`xTensor`Private`TakeEPairs[{indsa}],frees=xAct`xTensor`Private`TakeFrees[{indsa}]},Module[{equalexpr,sign,sortedfrees,perm},{equalexpr,sign,sortedfrees,perm}=xAct`SymManipulator`Private`SpecialEqualExpressionsQ[tensora[indsaeq],tensora[indsa]];
If[equalexpr,AppendTo[$IndexConfigs,tensora[indsa]]];
tensora[indsa]/;equalexpr]/;Length@Intersection[dummies,{indsa}]==numdummiesaeq]]]];


AddToIndexConfigRule[LHS:Times[_?xTensorQ[___],_?xTensorQ[___]...]]:=
With[{indslist=ToExpression[StringJoin["tinds",ToString[#]]&/@Range[Length@LHS]]},
With[{rulelhs=MapIndexed[#1[[0]][First@indslist[[#2]]]&,LHS],rulelhspattern=MapIndexed[#1[[0]][With[{patterninds=First@indslist[[#2]]},Pattern[patterninds,BlankNullSequence[]]]]&,LHS]},
RuleDelayed[HoldPattern@rulelhspattern,
With[{rulelhsinds=FindIndices[rulelhs]},
With[{dummieslhs=xAct`xTensor`Private`TakeEPairs[rulelhsinds],freeslhs=xAct`xTensor`Private`TakeFrees[rulelhsinds]},
Module[{equalexpr,sign,sortedfrees,perm},{equalexpr,sign,sortedfrees,perm}=xAct`SymManipulator`Private`SpecialEqualExpressionsQ[LHS,rulelhs];
If[equalexpr,AppendTo[$IndexConfigs,rulelhs]];
rulelhs/;equalexpr]]]]]];


FullSymmetryOfFreeIndices[expr_]:=Module[{freeinds=FindFreeIndices@expr,abstractfree,actractfreeslots, restslots, slotexpr,slotrules,reverseslotrules,sym,n,freefirstperm, freesym,restfrees, tmpsym,inds,HasSym,completesymmetricSGS},
{n,slotexpr,slotrules,sym}=List@@SymmetryOf[expr];
If[And[OrderOfGroup[sym]==1, Length@freeinds==n],{StrongGenSet[{},GenSet[]],freeinds},
inds=(xAct`xTensor`Private`slot/@Range[n])/.slotrules;
reverseslotrules=Reverse/@slotrules;
abstractfree=Select[freeinds,AIndexQ];
actractfreeslots=First/@List@@Replace[List@@abstractfree,reverseslotrules , {1}];
restslots=Complement[Range@n,actractfreeslots];
(* Find a permutation that moves the free indices first. *)
freefirstperm=List@@TranslatePerm[PermutationFromTo[Range@n,Join[actractfreeslots,restslots]],Rules];
(* Change the base of sym so it begins with the dummy indices. *)
tmpsym=StabilizerSGS[restslots,sym]/.freefirstperm;
n=Length@freeinds;
If[CompatibleSymQ[List@@(UpIndex/@VBundleOfIndex/@freeinds),tmpsym],
freesym=tmpsym,
HasSym[p_]:=ToCanonical[PermuteIndices[expr,freeinds,xAct`xPerm`Private`ToSign[p,n]]-expr]===0;
completesymmetricSGS=JoinSGS[CompatibleSymmetric[freeinds],Symmetric[{n+1,n+2},Cycles]];
completesymmetricSGS=ReplacePart[completesymmetricSGS,1->Append[Range[n-1],n+1]];
freesym=xAct`xPerm`Private`ToSign[Search[completesymmetricSGS,HasSym,1,tmpsym],n]];
{freesym,freeinds}]]


FindTensorHeads[TT_?xTensorQ[inds___]]:={TT}


FindTensorHeads[expr_Times]:=FindTensorHeads/@(List@@expr)


FindTensorCoefficients[expr_?ScalarQ,tensors_List]:=Module[{AddToIndexConfigR1=AddToIndexConfigRule/@tensors,TensorHeads,canonicalizedexpr,tensorsasinexpr,ImposeCorrectSym, oldxsortprecendence, coefflist},
TensorHeads=Flatten[FindTensorHeads/@tensors];
ImposeCorrectSym[expr1_,expr2_]:=With[{fullsym=FullSymmetryOfFreeIndices[expr2]},ImposeSym[expr1,ChangeIndex/@fullsym[[2]],fullsym[[1]]]];
oldxsortprecendence=xSortPrecedence/@TensorHeads;
(xSortPrecedence[#]^=2)&/@TensorHeads;
$IndexConfigs={};
canonicalizedexpr=ScreenDollarIndices[ToCanonical[expr]]/.AddToIndexConfigR1;
tensorsasinexpr=Union@$IndexConfigs;
(xSortPrecedence[TensorHeads[[#]]]^=oldxsortprecendence[[#]])&/@Range@Length@TensorHeads;
 coefflist={ImposeCorrectSym[Coefficient[canonicalizedexpr,#],#],#}&/@tensorsasinexpr;
Join[{{ToCanonical@ExpandSym[expr-Plus@@Times@@@coefflist],1}},coefflist]
]


FindTensorCoefficients[___]:=Throw@Message[FindTensorCoefficients::error, "Only scalar expressions are allowed."]


DivName[covd_?xAct`Spinors`SpinCovDQ]:=Symbol[StringJoin["Div",SymbolName[covd]]]; CurlName[covd_?xAct`Spinors`SpinCovDQ]:=Symbol[StringJoin["Curl",SymbolName[covd]]]; CurlDgName[covd_?xAct`Spinors`SpinCovDQ]:=Symbol[StringJoin["CurlDg",SymbolName[covd]]]; TwistName[covd_?xAct`Spinors`SpinCovDQ]:=Symbol[StringJoin["Twist",SymbolName[covd]]];
BoxName[covd_?xAct`Spinors`SpinCovDQ]:=Symbol[StringJoin["Box",SymbolName[covd]]];


ExtractUnprimedAndPrimedIndsGivenCovD[inds_List,covd_?xAct`Spinors`SpinCovDQ]:=With[{spin=VBundlesOfCovD[covd][[2]],spindg=VBundlesOfCovD[covd][[3]]},{Select[inds,xAct`xTensor`Private`VBundleIndexPMQ@spin],Select[inds,xAct`xTensor`Private`VBundleIndexPMQ@spindg],Select[inds,Not@Or[(xAct`xTensor`Private`VBundleIndexPMQ@spin)[#],(xAct`xTensor`Private`VBundleIndexPMQ@spindg)[#]]&]}];


SpatialSpinCovDQ[_]:=False;


SpacetimeSpinCovDQ=And[xAct`Spinors`SpinCovDQ[#],Not@SpatialSpinCovDQ[#]]&;


FundSpinOpQ[_]:=False;
CommuteFundSpinOp[__]:={};


$FundSpinOpCovDs={};
$FundSpinVBundles={};


SymFromOtherVBs[TT_,spin_,spindg_]:=Module[{slotsTT=SlotsOfTensor@TT,spinpositions,oVBpositions},
spinpositions=Flatten@Select[GatherBy[Range@Length@slotsTT,(UpIndex/@slotsTT)[[#]]&],MemberQ[{spin,spindg},UpIndex@slotsTT[[First[#]]]]&];
oVBpositions=Complement[Range@Length@slotsTT,spinpositions];
StabilizerSGS[spinpositions,TranslatePerm[SymmetryGroupOfTensor@TT,Cycles]]/.Thread@Rule[oVBpositions,Range@Length@oVBpositions]
]


SlotRulesOtherVBs[slotsTT_,inds_,spin_,spindg_]:=Module[{gatheredinds=Prepend[#,(xAct`xTensor`Private`SignedVBundleOfIndex@First@#)]&/@GatherBy[inds,xAct`xTensor`Private`SignedVBundleOfIndex],otherinds,otherpos},
otherinds=Select[gatheredinds,And[First@#=!=-spin,First@#=!=-spindg,First@#=!=spin,First@#=!=spindg]&];
otherpos=Flatten[Position[slotsTT,#,1]]&/@First/@otherinds;
Flatten[MapThread[Thread[Rule[#1,#2]]&,{otherpos,Rest/@otherinds}]]
]


Options[DefFundSpinOperators]^={HideCovDSymbolReference->True,ShowValenceInfo->True};


DefFundSpinOperators[covd_?SpacetimeSpinCovDQ,options:OptionsPattern[]]:=
If[Not@And[MemberQ[$ContextPath,"xAct`Spinors`"],MemberQ[$ContextPath,"xAct`TexAct`"]],Throw@Message[DefFundSpinOperators::error,"Please load the packages Spinors and TexAct first."],
If[Not@xAct`Spinors`SpinCovDQ@covd,Throw@Message[DefFundSpinOperators::error,"Not a SpinCovD."],
With[{
(* Names of the operators *)
divcd=DivName@covd, curlcd=CurlName@covd, curldgcd=CurlDgName@covd, twistcd=TwistName@covd,boxcd=BoxName@covd,
(* Names of lists *)
$irrdecrulescd=Symbol[StringJoin["$IrrDecRules",SymbolName[covd]]],
$expandfundspinoprulescd=Symbol[StringJoin["$ExpandFundSpinOpRules",SymbolName[covd]]],
(* Extract the spin bundles *)
spin=VBundlesOfCovD[covd][[2]],spindg=VBundlesOfCovD[covd][[3]]},
If[Not[Dagger@spin==spindg],Throw@Message[DefFundSpinOperators::error,"VBundles are not conjugated."]];
With[{
(* The spin metrics *)
eps=First@MetricsOfVBundle@spin,
epsdg=First@MetricsOfVBundle@spindg,
(* Functions for extraction of unprimed and primed indices and their numbers. *)
ExtractUnprimedAndPrimed={Select[#,xAct`xTensor`Private`VBundleIndexPMQ@spin],Select[#,xAct`xTensor`Private`VBundleIndexPMQ@spindg]}&,ExtractOtherInds=Select[#,Not@Or[(xAct`xTensor`Private`VBundleIndexPMQ@spin)[#],(xAct`xTensor`Private`VBundleIndexPMQ@spindg)[#]]&]&,
NumOfUnprimedVBundles=Length@Cases[UpIndex/@#,spin]&,
NumOfPrimedVBundles=Length@Cases[UpIndex/@#,spindg]&,
OtherVBundles=DeleteCases[#,Alternatives[spin,-spin,spindg,-spindg]]&,
EnoughIndsQ=Function[{TTT,k,l},And[Length@Cases[UpIndex/@SlotsOfTensor@TTT,spin]>=k,Length@Cases[UpIndex/@SlotsOfTensor@TTT,spindg]>=l]]},
Module[{expanddivcd,expandcurlcd,expandcurldgcd,expandtwistcd,printfunc},
(* Add to the list $FundSpinOpCovDs and $FundSpinVBundles *)
AppendTo[$FundSpinOpCovDs,covd];
$FundSpinVBundles=Union[{spin,spindg},$FundSpinVBundles];

(* FundSpinOpQ *)

FundSpinOpQ[divcd]^=True;
FundSpinOpQ[curlcd]^=True;
FundSpinOpQ[curldgcd]^=True;
FundSpinOpQ[twistcd]^=True;

(* Linking *)
CovDOfFundSpinOp[divcd]^=covd;
CovDOfFundSpinOp[curlcd]^=covd;
CovDOfFundSpinOp[curldgcd]^=covd;
CovDOfFundSpinOp[twistcd]^=covd;

(* Tensor definitions. *)
xTensorQ[divcd[TT_?xTensorQ]]^= True;
xTensorQ[curlcd[TT_?xTensorQ]]^= True;
xTensorQ[curldgcd[TT_?xTensorQ]]^= True;
xTensorQ[twistcd[TT_?xTensorQ]]^= True;

(* Links to other symbols *)
VisitorsOf[covd]^=Union[VisitorsOf[covd],{divcd,curlcd,curldgcd,twistcd}];

(* How to undefine *)
Undef[divcd]^:=UndefFundSpinOperators@covd;
Undef[curlcd]^:=UndefFundSpinOperators@covd;
Undef[curldgcd]^:=UndefFundSpinOperators@covd;
Undef[twistcd]^:=UndefFundSpinOperators@covd;

(* Usage messages *)
$expandfundspinoprulescd::usage=StringJoin@@(ToString/@{$expandfundspinoprulescd,"contains rules for expansion of the fundamental operators ", divcd, ", ", curlcd,", ", curldgcd," and ", twistcd," of expr in terms of symmetrized derivatives."});
$irrdecrulescd::usage=StringJoin@@(ToString/@{$irrdecrulescd," is a list of rules that are used by the function ", ToFundSpinOp," to convert derivatives to fundamental operators. Both the functions ", AddToIrrdecRules," and ",ToFundSpinOp ," adds rules to this list."});

(* Calculation of the slots of the tensors. *)
SlotsOfTensor[divcd[TT_?xTensorQ]]^:=Module[{k,l,slotsTT=SlotsOfTensor@TT,ovb},
k=NumOfUnprimedVBundles@slotsTT;
l=NumOfPrimedVBundles@slotsTT;
ovb=OtherVBundles@slotsTT;
If[Or[k<1, l<1],Throw@Message[divcd::error,StringJoin["Wrong VBundles: ", ToString[slotsTT]]],
Join[ovb,Table[-spin,{k-1}],Table[-spindg,{l-1}]]]];
SlotsOfTensor[curlcd[TT_?xTensorQ]]^:=Module[{k,l,slotsTT=SlotsOfTensor@TT,ovb},
k=NumOfUnprimedVBundles@slotsTT;
l=NumOfPrimedVBundles@slotsTT;
ovb=OtherVBundles@slotsTT;
If[Or[k<0, l<1],Throw@Message[curlcd::error,StringJoin["Wrong VBundles: ", ToString[slotsTT]]],
Join[ovb,Table[-spin,{k+1}],Table[-spindg,{l-1}]]]];
SlotsOfTensor[curldgcd[TT_?xTensorQ]]^:=Module[{k,l,slotsTT=SlotsOfTensor@TT,ovb},
k=NumOfUnprimedVBundles@slotsTT;
l=NumOfPrimedVBundles@slotsTT;
ovb=OtherVBundles@slotsTT;
If[Or[k<1, l<0],Throw@Message[curldgcd::error,StringJoin["Wrong VBundles: ", ToString[slotsTT]]],
Join[ovb,Table[-spin,{k-1}],Table[-spindg,{l+1}]]]];
SlotsOfTensor[twistcd[TT_?xTensorQ]]^:=Module[{k,l,slotsTT=SlotsOfTensor@TT,ovb},
k=NumOfUnprimedVBundles@slotsTT;
l=NumOfPrimedVBundles@slotsTT;
ovb=OtherVBundles@slotsTT;
If[Or[k<0, l<0],Throw@Message[twistcd::error,StringJoin["Wrong VBundles: ", ToString[slotsTT]]],
Join[ovb,Table[-spin,{k+1}],Table[-spindg,{l+1}]]]];

(* Calculation of the symmetry groups of the tensors *)

SymmetryGroupOfTensor[divcd[TT_?xTensorQ]]^:=If[Length@OtherVBundles@SlotsOfTensor@TT<=1, CompatibleSym@SlotsOfTensor[divcd[TT]],
JoinSGS[SymFromOtherVBs[TT,spin,spindg],CompatibleSym[SlotsOfTensor[divcd[TT]],{spin,spindg}]]];
SymmetryGroupOfTensor[curlcd[TT_?xTensorQ]]^:=If[Length@OtherVBundles@SlotsOfTensor@TT<=1, CompatibleSym@SlotsOfTensor[curlcd[TT]],
JoinSGS[SymFromOtherVBs[TT,spin,spindg],CompatibleSym[SlotsOfTensor[curlcd[TT]],{spin,spindg}]]];
SymmetryGroupOfTensor[curldgcd[TT_?xTensorQ]]^:=If[Length@OtherVBundles@SlotsOfTensor@TT<=1, CompatibleSym@SlotsOfTensor[curldgcd[TT]],
JoinSGS[SymFromOtherVBs[TT,spin,spindg],CompatibleSym[SlotsOfTensor[curldgcd[TT]],{spin,spindg}]]];
SymmetryGroupOfTensor[twistcd[TT_?xTensorQ]]^:=If[Length@OtherVBundles@SlotsOfTensor@TT<=1, CompatibleSym@SlotsOfTensor[twistcd[TT]],
JoinSGS[SymFromOtherVBs[TT,spin,spindg],CompatibleSym[SlotsOfTensor[twistcd[TT]],{spin,spindg}]]];

(* Interaction with the ZeroTensor *)
divcd[ZeroTensor[vbundles_]]:=With[{k=NumOfUnprimedVBundles@vbundles,l=NumOfPrimedVBundles@vbundles,ovb=OtherVBundles@vbundles},
ZeroTensor[Join[ovb,Table[-spin,{k-1}],Table[-spindg,{l-1}]]]];
curlcd[ZeroTensor[vbundles_]]:=With[{k=NumOfUnprimedVBundles@vbundles,l=NumOfPrimedVBundles@vbundles,ovb=OtherVBundles@vbundles},
ZeroTensor[Join[ovb,Table[-spin,{k+1}],Table[-spindg,{l-1}]]]];
curldgcd[ZeroTensor[vbundles_]]:=With[{k=NumOfUnprimedVBundles@vbundles,l=NumOfPrimedVBundles@vbundles,ovb=OtherVBundles@vbundles},
ZeroTensor[Join[ovb,Table[-spin,{k-1}],Table[-spindg,{l+1}]]]];
twistcd[ZeroTensor[vbundles_]]:=With[{k=NumOfUnprimedVBundles@vbundles,l=NumOfPrimedVBundles@vbundles,ovb=OtherVBundles@vbundles},
ZeroTensor[Join[ovb,Table[-spin,{k+1}],Table[-spindg,{l+1}]]]];

(* Printing *)
 printfunc[TT4_,symbstringstart_, symbstringend_,simplesymb_]:=StringJoin[If[OptionValue[ShowValenceInfo],StringJoin[\!\(\*
TagBox[
StyleBox["symbstringstart",
ShowSpecialCharacters->False,
ShowStringCharacters->True,
NumberMarks->True],
FullForm]\),ToString@NumOfUnprimedVBundles@SlotsOfTensor[TT4],",",ToString@NumOfPrimedVBundles@SlotsOfTensor[TT4],symbstringend],simplesymb],If[OptionValue[HideCovDSymbolReference],"",StringJoin["[",Last@SymbolOfCovD@covd,"]"]]];
PrintAs[divcd[TT_?xTensorQ]]^:=RowBox[{printfunc[TT,\!\(\*
TagBox[
StyleBox["\"\<\\!\\(\\*SubscriptBox[\\(\\[ScriptCapitalD]\\), \\(\>\"",
ShowSpecialCharacters->False,
ShowStringCharacters->True,
NumberMarks->True],
FullForm]\),"\)]\)","\[ScriptCapitalD]"],PrintAs[TT]}];
PrintAs[curlcd[TT_?xTensorQ]]^:=RowBox[{printfunc[TT,\!\(\*
TagBox[
StyleBox["\"\<\\!\\(\\*SubscriptBox[\\(\\[ScriptCapitalC]\\), \\(\>\"",
ShowSpecialCharacters->False,
ShowStringCharacters->True,
NumberMarks->True],
FullForm]\),"\)]\)","\[ScriptCapitalC]"],PrintAs[TT]}];
PrintAs[curldgcd[TT_?xTensorQ]]^:=RowBox[{printfunc[TT,\!\(\*
TagBox[
StyleBox["\"\<\\!\\(\\*SubsuperscriptBox[\\(\\[ScriptCapitalC]\\), \\(\>\"",
ShowSpecialCharacters->False,
ShowStringCharacters->True,
NumberMarks->True],
FullForm]\),"\),\[Dagger]]\)",\!\(\*
TagBox[
StyleBox["\"\<\\!\\(\\*SuperscriptBox[\\(\\[ScriptCapitalC]\\), \\[Dagger]]\\)\>\"",
ShowSpecialCharacters->False,
ShowStringCharacters->True,
NumberMarks->True],
FullForm]\)],PrintAs[TT]}];
PrintAs[twistcd[TT_?xTensorQ]]^:=RowBox[{printfunc[TT,\!\(\*
TagBox[
StyleBox["\"\<\\!\\(\\*SubscriptBox[\\(\\[ScriptCapitalT]\\), \\(\>\"",
ShowSpecialCharacters->False,
ShowStringCharacters->True,
NumberMarks->True],
FullForm]\),"\)]\)","\[ScriptCapitalT]"],PrintAs[TT]}];

(* Tex output. *)
xAct`TexAct`$TexInitLatexPackages=DeleteDuplicates@Join[xAct`TexAct`$TexInitLatexPackages,{"{mathrsfs}","{eucal}"}];
xAct`TexAct`$TexInitLatexExtraCode=DeleteDuplicates@Join[xAct`TexAct`$TexInitLatexExtraCode,{"\\def\\sDiv{\\mathscr{D}}","\\def\\sCurl{\\mathscr{C}}","\\def\\sCurlDagger{\\mathscr{C}^\\dagger}","\\def\\sTwist{\\mathscr{T}}"}];
TexFundOp[divcd[TT_?xTensorQ]]^:=StringJoin["\\sDiv",If[OptionValue[ShowValenceInfo],StringJoin["_{",ToString@NumOfUnprimedVBundles@SlotsOfTensor[TT],",",ToString@NumOfPrimedVBundles@SlotsOfTensor[TT],"} "]," "],TexFundOp[TT]];
TexFundOp[curlcd[TT_?xTensorQ]]^:=StringJoin["\\sCurl",If[OptionValue[ShowValenceInfo],StringJoin["_{",ToString@NumOfUnprimedVBundles@SlotsOfTensor[TT],",",ToString@NumOfPrimedVBundles@SlotsOfTensor[TT],"} "]," "],TexFundOp[TT]];
TexFundOp[curldgcd[TT_?xTensorQ]]^:=StringJoin["\\sCurlDagger",If[OptionValue[ShowValenceInfo],StringJoin["_{",ToString@NumOfUnprimedVBundles@SlotsOfTensor[TT],",",ToString@NumOfPrimedVBundles@SlotsOfTensor[TT],"} "]," "],TexFundOp[TT]];
TexFundOp[twistcd[TT_?xTensorQ]]^:=StringJoin["\\sTwist",If[OptionValue[ShowValenceInfo],StringJoin["_{",ToString@NumOfUnprimedVBundles@SlotsOfTensor[TT],",",ToString@NumOfPrimedVBundles@SlotsOfTensor[TT],"} "]," "],TexFundOp[TT]];
TexFundOp[expr_]:=xAct`TexAct`Tex@expr;
xAct`TexAct`Tex[x:((divcd|curlcd|curldgcd|twistcd)[_])]:=StringJoin[xAct`TexAct`Private`TexOpen["("],TexFundOp@x,xAct`TexAct`Private`TexClose[")"]];

(* Complex conjugates. *)
HermitianQ[divcd[TT_?xTensorQ]]^:=HermitianQ[TT];
HermitianQ[twistcd[TT_?xTensorQ]]^:=HermitianQ[TT];
Dagger[divcd[TT_?xTensorQ]]^:=If[HermitianQ[TT],divcd[TT],divcd[Dagger[TT]]];
Dagger[curlcd[TT_?xTensorQ]]^:=If[HermitianQ[TT],curldgcd[TT],curldgcd[Dagger[TT]]];
Dagger[curldgcd[TT_?xTensorQ]]^:=If[HermitianQ[TT],curlcd[TT],curlcd[Dagger[TT]]];
Dagger[twistcd[TT_?xTensorQ]]^:=If[HermitianQ[TT],twistcd[TT],twistcd[Dagger[TT]]];
Dagger[divcd[TT_?xTensorQ][inds___]]^:=Dagger[divcd[TT]][Sequence@@ExtractOtherInds[DaggerIndex/@{inds}],Sequence@@(Join@@ExtractUnprimedAndPrimed[DaggerIndex/@{inds}])];
Dagger[curlcd[TT_?xTensorQ][inds___]]^:=Dagger[curlcd[TT]][Sequence@@ExtractOtherInds[DaggerIndex/@{inds}],Sequence@@(Join@@ExtractUnprimedAndPrimed[DaggerIndex/@{inds}])];
Dagger[curldgcd[TT_?xTensorQ][inds___]]^:=Dagger[curldgcd[TT]][Sequence@@ExtractOtherInds[DaggerIndex/@{inds}],Sequence@@(Join@@ExtractUnprimedAndPrimed[DaggerIndex/@{inds}])];
Dagger[twistcd[TT_?xTensorQ][inds___]]^:=Dagger[twistcd[TT]][Sequence@@ExtractOtherInds[DaggerIndex/@{inds}],Sequence@@(Join@@ExtractUnprimedAndPrimed[DaggerIndex/@{inds}])];

(* Expansion of the operators. *)
expanddivcd[divcd[TT_?xTensorQ][inds___]]:=Module[{slotsTT=SlotsOfTensor@TT,primedinds,unprimedinds,A=DummyIn@spin,Adg=DummyIn@spindg,primedpos,unprimedpos,TTinds},
{unprimedinds,primedinds}=ExtractUnprimedAndPrimed[{inds}];
unprimedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spin)&];
primedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spindg)&];
TTinds=Range@Length@slotsTT/.Thread[primedpos->Append[primedinds,-Adg]]/.Thread[unprimedpos->Append[unprimedinds,-A]]/.SlotRulesOtherVBs[slotsTT,{inds},spin,spindg];
covd[A,Adg][TT@@TTinds]];
expandcurlcd[curlcd[TT_?xTensorQ][inds___]]:=Module[{slotsTT=SlotsOfTensor@TT,primedinds,unprimedinds,Adg=DummyIn@spindg,primedpos,unprimedpos,TTinds},
{unprimedinds,primedinds}=ExtractUnprimedAndPrimed[{inds}];
unprimedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spin)&];
primedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spindg)&];
TTinds=Range@Length@slotsTT/.Thread[primedpos->Append[primedinds,-Adg]]/.Thread[unprimedpos->Rest@unprimedinds]/.SlotRulesOtherVBs[slotsTT,{inds},spin,spindg];
ToCanonicalSym@ImposeSym[covd[First@unprimedinds,Adg][TT@@TTinds],IndexList@@unprimedinds]];
expandcurldgcd[curldgcd[TT_?xTensorQ][inds___]]:=Module[{slotsTT=SlotsOfTensor@TT,primedinds,unprimedinds,A=DummyIn@spin,primedpos,unprimedpos,TTinds},
{unprimedinds,primedinds}=ExtractUnprimedAndPrimed[{inds}];
unprimedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spin)&];
primedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spindg)&];
TTinds=Range@Length@slotsTT/.Thread[primedpos->Rest@primedinds]/.Thread[unprimedpos->Append[unprimedinds,-A]]/.SlotRulesOtherVBs[slotsTT,{inds},spin,spindg];
ToCanonicalSym@ImposeSym[covd[A,First@primedinds][TT@@TTinds],IndexList@@primedinds]];
expandtwistcd[twistcd[TT_?xTensorQ][inds___]]:=Module[{slotsTT=SlotsOfTensor@TT,primedinds,unprimedinds,primedpos,unprimedpos,TTinds},
{unprimedinds,primedinds}=ExtractUnprimedAndPrimed[{inds}];
unprimedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spin)&];
primedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spindg)&];
TTinds=Range@Length@slotsTT/.Thread[primedpos->Rest@primedinds]/.Thread[unprimedpos->Rest@unprimedinds]/.SlotRulesOtherVBs[slotsTT,{inds},spin,spindg];
ToCanonicalSym@ImposeSym[covd[First@unprimedinds,First@primedinds][TT@@TTinds],IndexList@@Join[unprimedinds,primedinds]]];
$expandfundspinoprulescd={x:(divcd[TT_?xTensorQ][inds___]):>expanddivcd[x],x:(curlcd[TT_?xTensorQ][inds___]):>expandcurlcd[x],x:(curldgcd[TT_?xTensorQ][inds___]):>expandcurldgcd[x],x:(twistcd[TT_?xTensorQ][inds___]):>expandtwistcd[x]};

(* Imposing Twist *)
ImposeFundSpinOp[expr1_,twistcd, iinds_]:=
Module[{primedinds1,unprimedinds1,irrdecexpr,k,l, (* If the expression is an expanded symmetry, it is important that we do the contractions with the same index on all terms. Therefore, we sort the free indices so the contraction is done with the same index on all terms.*)
frees=Sort[List@@FindFreeIndices@Evaluate[expr1]], primedfrees, unprimedfrees,indexrules={}, intexpr},
{unprimedinds1,primedinds1}=ExtractUnprimedAndPrimed[iinds];
{unprimedfrees,primedfrees}=ExtractUnprimedAndPrimed[frees];
indexrules=Join[Thread@Rule[unprimedfrees,Rest@unprimedinds1],Thread@Rule[primedfrees,Rest@primedinds1]];
intexpr=covd[First@unprimedinds1,First@primedinds1][ReplaceIndex[expr1,indexrules]];
intexpr=ToFundSpinOp[intexpr,covd];
ImposeSym[intexpr,IndexList@@Join[unprimedinds1,primedinds1]]];

(* Imposing Curl *)
ImposeFundSpinOp[expr1_,curlcd, iinds_]:=
Module[{primedinds1,unprimedinds1,irrdecexpr,k,l, (* If the expression is an expanded symmetry, it is important that we do the contractions with the same index on all terms. Therefore, we sort the free indices so the contraction is done with the same index on all terms.*)
frees=Sort[List@@FindFreeIndices@Evaluate[expr1]], primedfrees, unprimedfrees,indexrules={}, intexpr,Adg=DummyIn@spindg},
{unprimedinds1,primedinds1}=ExtractUnprimedAndPrimed[iinds];
{unprimedfrees,primedfrees}=ExtractUnprimedAndPrimed[frees];
indexrules=Join[Thread@Rule[unprimedfrees,Rest@unprimedinds1],Thread@Rule[primedfrees,Append[primedinds1,-Adg]]];
intexpr=covd[First@unprimedinds1,Adg][ReplaceIndex[expr1,indexrules]];
intexpr=ToFundSpinOp[intexpr,covd];
ImposeSym[intexpr,IndexList@@Join[unprimedinds1,primedinds1]]];

(* Imposing CurlDg *)
ImposeFundSpinOp[expr1_,curldgcd, iinds_]:=Module[{primedinds1,unprimedinds1,irrdecexpr,k,l, (* If the expression is an expanded symmetry, it is important that we do the contractions with the same index on all terms. Therefore, we sort the free indices so the contraction is done with the same index on all terms.*)
frees=Sort[List@@FindFreeIndices@Evaluate[expr1]], primedfrees, unprimedfrees,indexrules={}, intexpr,A=DummyIn@spin},
{unprimedinds1,primedinds1}=ExtractUnprimedAndPrimed[iinds];
{unprimedfrees,primedfrees}=ExtractUnprimedAndPrimed[frees];
indexrules=Join[Thread@Rule[unprimedfrees,Append[unprimedinds1,-A]],Thread@Rule[primedfrees,Rest@primedinds1]];
intexpr=covd[A,First@primedinds1][ReplaceIndex[expr1,indexrules]];
intexpr=ToFundSpinOp[intexpr,covd];
ImposeSym[intexpr,IndexList@@Join[unprimedinds1,primedinds1]]];

(* Imposing Div *)
ImposeFundSpinOp[expr1_,divcd, iinds_]:=
Module[{primedinds1,unprimedinds1,irrdecexpr,k,l, (* If the expression is an expanded symmetry, it is important that we do the contractions with the same index on all terms. Therefore, we sort the free indices so the contraction is done with the same index on all terms.*)
frees=Sort[List@@FindFreeIndices@Evaluate[expr1]], primedfrees, unprimedfrees,indexrules={}, intexpr,A=DummyIn@spin,Adg=DummyIn@spindg},
{unprimedinds1,primedinds1}=ExtractUnprimedAndPrimed[iinds];
{unprimedfrees,primedfrees}=ExtractUnprimedAndPrimed[frees];
indexrules=Join[Thread@Rule[unprimedfrees,Append[unprimedinds1,-A]],Thread@Rule[primedfrees,Append[primedinds1,-Adg]]];
intexpr=covd[A,Adg][ReplaceIndex[expr1,indexrules]];
intexpr=ToFundSpinOp[intexpr,covd];
ImposeSym[intexpr,IndexList@@Join[unprimedinds1,primedinds1]]];

$irrdecrulescd={};

(* Commutators *)
(* DivCurl *)
CommuteFundSpinOp[divcd,curlcd]^=
divcd[curlcd[TT_?xTensorQ]][inds___]:>Module[{Bdg=DummyIn@spindg,Cdg=DummyIn@spindg,k=NumOfUnprimedVBundles@SlotsOfTensor@TT},k/(k+1)curlcd[divcd[TT]][inds]-boxcd[-Bdg,-Cdg]@TT[inds,Bdg,Cdg]]/;EnoughIndsQ[TT,0,2];
CommuteFundSpinOp[divcd,curlcd,curlcd,divcd]^=CommuteFundSpinOp[divcd,curlcd];
(* CurlDiv *)
CommuteFundSpinOp[curlcd,divcd]^=curlcd[divcd[TT_?xTensorQ]][inds___]:>Module[{Bdg=DummyIn@spindg,Cdg=DummyIn@spindg,k=NumOfUnprimedVBundles@SlotsOfTensor@TT},(k+1)/k*divcd[curlcd[TT]][inds]+(k+1)/k*boxcd[-Bdg,-Cdg]@TT[inds,Bdg,Cdg]]/;EnoughIndsQ[TT,1,2];
CommuteFundSpinOp[curlcd,divcd,divcd,curlcd]^=CommuteFundSpinOp[curlcd,divcd];
(* CurlTwist *)
CommuteFundSpinOp[curlcd,twistcd]^=curlcd[twistcd[TT_?xTensorQ]][inds___]:>With[{l=NumOfPrimedVBundles@SlotsOfTensor@TT,unprimedinds=First@ExtractUnprimedAndPrimed[{inds}]},
l/(l+1)twistcd[curlcd[TT]][inds]-ToCanonicalSym@ImposeSym[(boxcd@@Take[unprimedinds,2])[TT@@DeleteCases[{inds},Alternatives@@Take[unprimedinds,2]]],IndexList@@unprimedinds]];
CommuteFundSpinOp[curlcd,twistcd,twistcd,curlcd]^=CommuteFundSpinOp[curlcd,twistcd];
(* TwistCurl *)
CommuteFundSpinOp[twistcd,curlcd]^=twistcd[curlcd[TT_?xTensorQ]][inds___]:>With[{l=NumOfPrimedVBundles@SlotsOfTensor@TT,unprimedinds=First@ExtractUnprimedAndPrimed[{inds}]},(l+1)/l*curlcd[twistcd[TT]][inds]+(l+1)/l*ToCanonicalSym@ImposeSym[(boxcd@@Take[unprimedinds,2])[TT@@DeleteCases[{inds},Alternatives@@Take[unprimedinds,2]]],IndexList@@unprimedinds]]/;EnoughIndsQ[TT,0,1];
CommuteFundSpinOp[twistcd,curlcd,curlcd,twistcd]^=CommuteFundSpinOp[twistcd,curlcd];
(* DivCurlDg *)
CommuteFundSpinOp[divcd,curldgcd]^=divcd[curldgcd[TT_?xTensorQ]][inds___]:>Module[{B=DummyIn@spin,C=DummyIn@spin,l=NumOfPrimedVBundles@SlotsOfTensor@TT,k=NumOfUnprimedVBundles@SlotsOfTensor@TT},
l/(l+1)curldgcd[divcd[TT]][inds]-boxcd[-B,-C]@TT[Sequence@@Drop[{inds},-k-l+2],B,C,Sequence@@Take[{inds},-k-l+2]]]/;EnoughIndsQ[TT,2,0];
CommuteFundSpinOp[divcd,curldgcd,curldgcd,divcd]^=CommuteFundSpinOp[divcd,curldgcd];
(* CurlDgDiv *)
CommuteFundSpinOp[curldgcd,divcd]^=curldgcd[divcd[TT_?xTensorQ]][inds___]:>Module[{B=DummyIn@spin,C=DummyIn@spin,l=NumOfPrimedVBundles@SlotsOfTensor@TT,k=NumOfUnprimedVBundles@SlotsOfTensor@TT},(l+1)/l*divcd[curldgcd[TT]][inds]+(l+1)/l*boxcd[-B,-C]@TT[Sequence@@Drop[{inds},-k-l+2],B,C,Sequence@@Take[{inds},-k-l+2]]]/;EnoughIndsQ[TT,2,1];
CommuteFundSpinOp[curldgcd,divcd,divcd,curldgcd]^=CommuteFundSpinOp[curldgcd,divcd];
(* CurlDgTwist *)
CommuteFundSpinOp[curldgcd,twistcd]^=curldgcd[twistcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT},k/(k+1)twistcd[curldgcd[TT]][inds]-ToCanonicalSym@ImposeSym[(boxcd@@Take[{inds},-2])[TT@@Drop[{inds},-2]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]];
CommuteFundSpinOp[curldgcd,twistcd,twistcd,curldgcd]^=CommuteFundSpinOp[curldgcd,twistcd];
(* TwistCurlDg *)
CommuteFundSpinOp[twistcd,curldgcd]^=twistcd[curldgcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT},(k+1)/k*curldgcd[twistcd[TT]][inds]+(k+1)/k*ToCanonicalSym@ImposeSym[(boxcd@@Take[{inds},-2])[TT@@Drop[{inds},-2]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]]/;EnoughIndsQ[TT,1,0];
CommuteFundSpinOp[twistcd,curldgcd,curldgcd,twistcd]^=CommuteFundSpinOp[twistcd,curldgcd];
(* CurlCurlDgToCurlDgCurl *)
CommuteFundSpinOp[curlcd,curldgcd,curldgcd,curlcd]^=
curlcd[curldgcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT,l=NumOfPrimedVBundles@SlotsOfTensor@TT,B=DummyIn@spin,Bdg=DummyIn@spindg},
curldgcd[curlcd[TT]][inds]+
(1/(k+1)-1/(l+1))*twistcd[divcd[TT]][inds]-ToCanonicalSym@ImposeSym[(boxcd[First[Take[{inds},-k-l]],B])[TT[Sequence@@Drop[{inds},-k-l],Sequence@@Prepend[Rest[Take[{inds},-k-l]],-B]]],IndexList@@First@ExtractUnprimedAndPrimed[{inds}]]+ToCanonicalSym@ImposeSym[(boxcd[Bdg,Last[{inds}]])[TT@@Append[Most[{inds}],-Bdg]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]
]/;EnoughIndsQ[TT,1,1];
(* CurlDgCurlToCurlCurlDg *)
CommuteFundSpinOp[curldgcd,curlcd,curlcd,curldgcd]^=curldgcd[curlcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT,l=NumOfPrimedVBundles@SlotsOfTensor@TT,B=DummyIn@spin,Bdg=DummyIn@spindg},
curlcd[curldgcd[TT]][inds]-
(1/(k+1)-1/(l+1))*twistcd[divcd[TT]][inds]+ToCanonicalSym@ImposeSym[(boxcd[First[Take[{inds},-k-l]],B])[TT[Sequence@@Drop[{inds},-k-l],Sequence@@Prepend[Rest[Take[{inds},-k-l]],-B]]],IndexList@@First@ExtractUnprimedAndPrimed[{inds}]]-ToCanonicalSym@ImposeSym[(boxcd[Bdg,Last[{inds}]])[TT@@Append[Most[{inds}],-Bdg]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]
]/;EnoughIndsQ[TT,1,1];
(* DivTwistToCurlCurlDg *)
CommuteFundSpinOp[divcd,twistcd,curlcd,curldgcd]^=divcd[twistcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT,l=NumOfPrimedVBundles@SlotsOfTensor@TT,B=DummyIn@spin,Bdg=DummyIn@spindg},
-(1/(k+1)+1/(l+1))*curlcd[curldgcd[TT]][inds]+
l*(l+2)/(l+1)^2*twistcd[divcd[TT]][inds]-(l+2)/(l+1)*ToCanonicalSym@ImposeSym[(boxcd[First[Take[{inds},-k-l]],B])[TT[Sequence@@Drop[{inds},-k-l],Sequence@@Prepend[Rest[Take[{inds},-k-l]],-B]]],IndexList@@First@ExtractUnprimedAndPrimed[{inds}]]-l/(l+1)*ToCanonicalSym@ImposeSym[(boxcd[Bdg,Last[{inds}]])[TT@@Append[Most[{inds}],-Bdg]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]
]/;EnoughIndsQ[TT,1,0];
(* DivTwistToCurlDgCurl *)
CommuteFundSpinOp[divcd,twistcd,curldgcd,curlcd]^=divcd[twistcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT,l=NumOfPrimedVBundles@SlotsOfTensor@TT,B=DummyIn@spin,Bdg=DummyIn@spindg},
-(1/(k+1)+1/(l+1))*curldgcd[curlcd[TT]][inds]+
k*(k+2)/(k+1)^2*twistcd[divcd[TT]][inds]-k/(k+1)*ToCanonicalSym@ImposeSym[(boxcd[First[Take[{inds},-k-l]],B])[TT[Sequence@@Drop[{inds},-k-l],Sequence@@Prepend[Rest[Take[{inds},-k-l]],-B]]],IndexList@@First@ExtractUnprimedAndPrimed[{inds}]]-(k+2)/(k+1)*ToCanonicalSym@ImposeSym[(boxcd[Bdg,Last[{inds}]])[TT@@Append[Most[{inds}],-Bdg]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]
]/;EnoughIndsQ[TT,0,1];
(* CurlCurlDgToDivTwist *)
CommuteFundSpinOp[curlcd,curldgcd,divcd,twistcd]^=curlcd[curldgcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT,l=NumOfPrimedVBundles@SlotsOfTensor@TT,B=DummyIn@spin,Bdg=DummyIn@spindg},
-divcd[twistcd[TT]][inds]/(1/(k+1)+1/(l+1))+
((1+k)*l*(2+l))/((1+l)*(2+k+l))*twistcd[divcd[TT]][inds]-((1+k)*(2+l))/(2+k+l)*ToCanonicalSym@ImposeSym[(boxcd[First[Take[{inds},-k-l]],B])[TT[Sequence@@Drop[{inds},-k-l],Sequence@@Prepend[Rest[Take[{inds},-k-l]],-B]]],IndexList@@First@ExtractUnprimedAndPrimed[{inds}]]-((1+k)*l)/(2+k+l)*ToCanonicalSym@ImposeSym[(boxcd[Bdg,Last[{inds}]])[TT@@Append[Most[{inds}],-Bdg]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]
]/;EnoughIndsQ[TT,1,0];
CommuteFundSpinOp[curlcd,curldgcd,twistcd,divcd]^=CommuteFundSpinOp[curlcd,curldgcd,divcd,twistcd];
(* CurlDgCurlToDivTwist *)
CommuteFundSpinOp[curldgcd,curlcd,divcd,twistcd]^=curldgcd[curlcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT,l=NumOfPrimedVBundles@SlotsOfTensor@TT,B=DummyIn@spin,Bdg=DummyIn@spindg},
-divcd[twistcd[TT]][inds]/(1/(k+1)+1/(l+1))+
(k*(2+k)*(1+l))/((1+k)*(2+k+l))*twistcd[divcd[TT]][inds]-(k*(1+l))/(2+k+l)*ToCanonicalSym@ImposeSym[(boxcd[First[Take[{inds},-k-l]],B])[TT[Sequence@@Drop[{inds},-k-l],Sequence@@Prepend[Rest[Take[{inds},-k-l]],-B]]],IndexList@@First@ExtractUnprimedAndPrimed[{inds}]]-((2+k)*(1+l))/(2+k+l)*ToCanonicalSym@ImposeSym[(boxcd[Bdg,Last[{inds}]])[TT@@Append[Most[{inds}],-Bdg]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]
]/;EnoughIndsQ[TT,0,1];
CommuteFundSpinOp[curldgcd,curlcd,twistcd,divcd]^=CommuteFundSpinOp[curldgcd,curlcd,divcd,twistcd];
(* TwistDivToCurlCurlDg *)
CommuteFundSpinOp[twistcd,divcd,curlcd,curldgcd]^=twistcd[divcd[TT_?xTensorQ]][inds___]:>With[{k=NumOfUnprimedVBundles@SlotsOfTensor@TT,l=NumOfPrimedVBundles@SlotsOfTensor@TT,B=DummyIn@spin,Bdg=DummyIn@spindg},
+(1+l)^2/(l*(2+l))*divcd[twistcd[TT]][inds]
+((1+l)*(2+k+l))/((1+k)*l*(2+l))*curlcd[curldgcd[TT]][inds]+(1+l^(-1))*ToCanonicalSym@ImposeSym[(boxcd[First[Take[{inds},-k-l]],B])[TT[Sequence@@Drop[{inds},-k-l],Sequence@@Prepend[Rest[Take[{inds},-k-l]],-B]]],IndexList@@First@ExtractUnprimedAndPrimed[{inds}]]+(1+l)/(2+l)*ToCanonicalSym@ImposeSym[(boxcd[Bdg,Last[{inds}]])[TT@@Append[Most[{inds}],-Bdg]],IndexList@@Last@ExtractUnprimedAndPrimed[{inds}]]
]/;EnoughIndsQ[TT,1,1];
]]]]];


UndefFundSpinOperators[covd_?CovDQ]:=
With[{
(* Names of the operators *)
divcd=DivName@covd, curlcd=CurlName@covd, curldgcd=CurlDgName@covd, twistcd=TwistName@covd,
(* Names of lists *)
$irrdecrulescd=StringJoin["$IrrDecRules",SymbolName[covd]],
$expandfundspinoprulescd=StringJoin["$ExpandFundSpinOpRules",SymbolName[covd]]},

(* Removing special code *)
ImposeFundSpinOp[expr1_,twistcd, iinds_]=.;
ImposeFundSpinOp[expr1_,curlcd, iinds_]=.;
ImposeFundSpinOp[expr1_,curldgcd, iinds_]=.;
ImposeFundSpinOp[expr1_,divcd, iinds_]=.;

(* Unlinking *)
VisitorsOf[covd]^=DeleteCases[VisitorsOf[covd],Alternatives[divcd,curlcd,curldgcd,twistcd]];

(* Undefining objects *)
Remove@$irrdecrulescd;
Remove@$expandfundspinoprulescd;

Remove@divcd;
Remove@curlcd;
Remove@curldgcd;
Remove@twistcd;

$FundSpinOpCovDs=DeleteCases[$FundSpinOpCovDs,covd];
];


(* Converting the box to curvature *)
ExpandBox[expr_,covd_?SpacetimeSpinCovDQ]:=ToCanonical@ContractMetric[xAct`Spinors`Decomposition[xAct`Spinors`BoxToCurvature[expr,BoxName@covd],xAct`Spinors`Chi]];
ExpandBox[expr_,_]:=expr;
ExpandBox[expr_]:=If[Head@xAct`Spinors`Private`$SpinCovDs==List,Fold[ExpandBox,expr,xAct`Spinors`Private`$SpinCovDs],expr];


(* Expanding the fundamental spin operators *)
ExpandFundSpinOp[expr_,covd_?xAct`Spinors`SpinCovDQ]:=expr/.Symbol[StringJoin["$ExpandFundSpinOpRules",SymbolName[covd]]];
ExpandFundSpinOp[expr_]:=Fold[ExpandFundSpinOp,expr,$FundSpinOpCovDs];


(* Imposing the fundamental operators. These functions are general for all operators. Special code is added at the definition of the operators.*)
ImposeFundSpinOp[expr_Plus,op_?FundSpinOpQ, iinds_]:=ImposeFundSpinOp[#,op, iinds]&/@expr;
ImposeFundSpinOp[0,op_?FundSpinOpQ, iinds_]:=0;
ImposeFundSpinOp[c_?ConstantQ*expr_,op_?FundSpinOpQ, iinds_]:=c*ImposeFundSpinOp[expr,op, iinds];
ImposeFundSpinOp[TT_?xTensorQ[tinds___],op_?FundSpinOpQ, iinds_]:=(op[TT]@@Join[Select[{tinds},Not@MemberQ[$FundSpinVBundles,UpIndex@VBundleOfIndex@#]&],iinds])/;CompatibleSymQ[SlotsOfTensor[TT],SymmetryGroupOfTensor@TT,$FundSpinVBundles];


(* Applying a function inside a fundamental operator *)
FunctionInFundSpinOp[expr1_,func1_]:=FunctionInFundSpinOp[expr1,func1,1];
FunctionInFundSpinOp[expr1_,func1_,1,extrafunc_:Identity]:=expr1/.(op1_Symbol?FundSpinOpQ)[TT2_?xTensorQ][tinds1___]:>
Module[{unprimedinds,primedinds,otherinds},
{unprimedinds,primedinds,otherinds}=ExtractUnprimedAndPrimedIndsGivenCovD[{tinds1},CovDOfFundSpinOp@op1];
ImposeFundSpinOp[func1[TT2[Sequence@@otherinds,Sequence@@Drop[List@@GiveIndicesToTensor@TT2,Length@otherinds]]],op1,Join[unprimedinds,primedinds]]];
FunctionInFundSpinOp[expr1_,func1_,level_Integer,extrafunc_:Identity]:=FunctionInFundSpinOp[expr1,extrafunc@FunctionInFundSpinOp[#,func1,level-1]&,1];


Options[IrrDecomposeCovD]^={ResultType->"Expression",ExpandSym->False};


(* Needs fixing for other VBundles -- Check that the order is right *)
IrrDecomposeCovD[covd_?SpacetimeSpinCovDQ[A_,Adg_]@TT_?xTensorQ[inds___],options:OptionsPattern[]]:=If[CompatibleSymQ[SlotsOfTensor@TT,SymmetryGroupOfTensor@TT]=!=True,Throw@Message[IrrDecomposeCovD::error,"Only decompositions of derivatives of symmetric tensors are implemented."],
With[{eps=First@MetricsOfVBundle@VBundlesOfCovD[covd][[2]],
epsdg=First@MetricsOfVBundle@VBundlesOfCovD[covd][[3]]},
Module[{primedinds,unprimedinds,irrdecexpr,k,l, resulttype,expandsym,otherinds},
{resulttype,expandsym}=OptionValue[{ResultType,ExpandSym}];
{unprimedinds,primedinds,otherinds}=ExtractUnprimedAndPrimedIndsGivenCovD[{inds},covd];
k=Length@unprimedinds;
l=Length@primedinds;
irrdecexpr=TwistName[covd][TT][Sequence@@otherinds,A,Sequence@@unprimedinds,Adg,Sequence@@primedinds];
If[l>0,irrdecexpr=irrdecexpr-l/(l+1)*ImposeSym[epsdg[Adg,First@primedinds]*CurlName[covd][TT][Sequence@@otherinds,A,Sequence@@unprimedinds,Sequence@@Rest@primedinds],IndexList@@primedinds]];
If[k>0,irrdecexpr=irrdecexpr-k/(k+1)*ImposeSym[eps[A,First@unprimedinds]*CurlDgName[covd][TT][Sequence@@otherinds,Sequence@@Rest@unprimedinds,Adg,Sequence@@primedinds],IndexList@@unprimedinds]];
If[And[k>0,l>0],irrdecexpr=irrdecexpr+l*k/(l+1)/(k+1)*ImposeSym[epsdg[Adg,First@primedinds]*eps[A,First@unprimedinds]*DivName[covd][TT][Sequence@@otherinds,Sequence@@Rest@unprimedinds,Sequence@@Rest@primedinds],IndexList@@Join[unprimedinds,primedinds]]];
If[expandsym,irrdecexpr=ToCanonical@ExpandSym[irrdecexpr,SmartExpand->True]];
Switch[resulttype,
"Expression",irrdecexpr,
"Equation",Equal[covd[A,Adg]@TT[inds],irrdecexpr],
"Rule",MakeRule[Evaluate[{covd[A,Adg]@TT[inds],irrdecexpr},MetricOn->All,ContractMetrics->True]],
"CompareRule",MakeCompareRule[Evaluate[{covd[A,Adg]@TT[inds],irrdecexpr}]],
_,Null]
]]];


IrrDecomposeCovD[TT_?xTensorQ,covd_?SpacetimeSpinCovDQ,options:OptionsPattern[]]:=Module[{numindsinvb,generatedinds,unprimedinds,primedinds,cdeexpr,slotsTT=SlotsOfTensor@TT,spin=VBundlesOfCovD[covd][[2]],spindg=VBundlesOfCovD[covd][[3]],unprimedpos,primedpos,otherinds,otherpos,otherrules,TTinds},numindsinvb=Tally[UpIndex/@SlotsOfTensor@TwistName[covd][TT]];
generatedinds=Rule[#1,GetIndexRange[#2,#1]]&@@@(numindsinvb);
unprimedinds=DownIndex/@(spin/.generatedinds);
primedinds=DownIndex/@(spindg/.generatedinds);
unprimedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spin)&];
primedpos=Select[Range@Length@slotsTT,(UpIndex[slotsTT[[#]]]==spindg)&];
otherinds=List@@@Select[generatedinds,And[First@#=!=spin,First@#=!=spindg]&];
otherpos=Flatten[Position[UpIndex/@slotsTT,#,1]]&/@First/@otherinds;
otherrules=Flatten[MapThread[Thread[Rule[#1,#2]]&,{otherpos,Last/@otherinds}]];
otherrules=Rule[#1,#2*sign@slotsTT[[#1]]]&@@@otherrules;
TTinds=Range@Length@slotsTT/.Thread[primedpos->Rest@primedinds]/.Thread[unprimedpos->Rest@unprimedinds]/.otherrules;
cdeexpr=covd[First@unprimedinds,First@primedinds][TT@@TTinds];
IrrDecomposeCovD[cdeexpr,options]];


IrrDecomposeCovD[TT_?xTensorQ,options:OptionsPattern[]]:=IrrDecomposeCovD[TT,First@Select[$CovDs,SpinCovDQ],options]


Options[AddToIrrDecRules]^={ExpandSym->True};


AddToIrrDecRules[TT_?xTensorQ, covd_?xAct`Spinors`SpinCovDQ,options:OptionsPattern[]]:=
With[{$irrdecrulescd=StringJoin["$IrrDecRules",SymbolName[covd]]},
ToExpression[StringJoin["$IrrDecRules",SymbolName[covd]],InputForm,Function[name,name=DeleteDuplicates@Join[Evaluate@Symbol[$irrdecrulescd],IrrDecomposeCovD[TT,covd,ExpandSym->OptionValue[ExpandSym],ResultType->"Rule"]],HoldAll]]];


Options[ToFundSpinOp]^={ExpandSym->True};


ToFundSpinOp[expr_,covd_?xAct`Spinors`SpinCovDQ,options:OptionsPattern[]]:=Module[{newtensors={},intermexpr},intermexpr=ToCanonical@ContractMetric[expr//.Symbol[StringJoin["$IrrDecRules",SymbolName[covd]]]]/.x:(covd[A_,Adg_][TTT_?xTensorQ[inds___]]):>Module[{},AppendTo[newtensors,TTT];x];
newtensors=DeleteDuplicates@newtensors;
newtensors=Select[newtensors,CompatibleSymQ[SlotsOfTensor@#,SymmetryGroupOfTensor@#]&];
If[Length@newtensors>0,Print["Adding rules for ", newtensors]];
AddToIrrDecRules[#,covd,ExpandSym->OptionValue[ExpandSym]]&/@newtensors;
ToCanonical@ContractMetric[expr//.Symbol[StringJoin["$IrrDecRules",SymbolName[covd]]]]
];
ToFundSpinOp[expr_]:=Fold[ToFundSpinOp,expr,$FundSpinOpCovDs];


Protect[InertHeadHead];


End[];
EndPackage[];



