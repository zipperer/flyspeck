/* ========================================================================== */
/* FLYSPECK - GLPK                                              */
/*                                                                            */
/* Linear Programming, AMPL format (non-formal)    */
/* Chapter: Packing                                                     */
/* Lemma: OXLZLEZ  */
/* Author: Thomas C. Hales                                                    */
/* Date: 2009-09-19, checked 2010-06-03                    */
/* ========================================================================== */


/* 

The model considers the set of leaves around a spine.
Nonlinear inequalities have all been entered into the formal list.

QU index set for quarters.
QX non quarter 4-cells.
QY 2&3 cell combinations.

Removed y vars on Nov 13, 2012.  svn 2877 has the old version.

*/

# data provides the following.
param CBLADE 'number of leaves' >= 2, <= 4; 

# constants.
#param pi := 3.1415926535897932;
param piL := 3.14159;
param piU := 3.1416;
param lb := -0.00569;  # quarter lower bound.


#param hmin:= 1.2317544220903185;
#param hminL:= 1.2317;
#param hminU:= 1.2318;
#param h0:= 1.26;
#param hmax:= 1.3254;


# sets.
set FACE := 0..(CBLADE -1);
#set BLADE within FACE cross FACE; # adjacent (increasingly) ordered pairs of faces, cyclic order.
set BLADE := {(i,j) in  FACE cross FACE : 0 = (i + 1 +CBLADE -j) mod CBLADE  }; # adjacent  pairs
set EFACE := {(i1,i2,i3) in FACE cross FACE cross FACE : 
   (i1,i2) in BLADE and
   (i2,i3) in BLADE};

# data supplied branching sets.  
# There is the "unbranched" state, branching in direction "Z", branching in direction "not-Z"
# SBLADE/NONSBLADE, branch on leaves.
# QU/QX/QY : QUARTER,NONQUARTER-4CELL,23-CELL. 
# QXD,NONQXD: branch on QX.
# NEGQU/POSQU branch on QU
# HALFWT/FULLWT branch on QX inter HASSMALL.
# SHORTY4/LONGY4 branch on QY inter HASSMALL. SHORTY4 means y4<=2.1.

# FACE 0 goes with raw leaves 0 and 1, with leaves (3,0) and (0,1).
set SBLADERAW within FACE;  #non-spine edges are between 2 and 2*hmin.
set NONSBLADERAW within  FACE diff SBLADERAW;
set SBLADE := {(i,j) in BLADE : j in SBLADERAW};  # SBLADERAW j <-> SBLADE (j-1,j)
set NONSBLADE := {(i,j) in BLADE : j in NONSBLADERAW};
set HASSMALL := setof {(i1,i2,i3) in EFACE : (i1,i2) in SBLADE and (i2,i3) in SBLADE} i2;
set QU within HASSMALL;
set QX within FACE diff QU; 
set QY within FACE diff (QX union QU);
set NEGQU within QU; #precisely the set of quarters where gg<0.
set POSQU within QU; 
set QXD within QX;  # those with dih > 2.3.
set NONQXD within QX diff QXD;
set HALFWT within HASSMALL inter QX; # those QX with y1,y4 critical and HASSMALL leaves
set FULLWT within (HASSMALL inter QX) diff HALFWT;  #those QX with y4>= 2*hmax and HASSMALL leaves.
set SHORTY4 within (HASSMALL inter QY);
set LONGY4 within (HASSMALL inter QY) diff SHORTY4;

#
set ONESMALLa := setof {(i1,i2,i3) in EFACE : (i1,i2) in SBLADE and (i2,i3) in NONSBLADE} i2;
set ONESMALLb := setof {(i1,i2,i3) in EFACE : (i1,i2) in NONSBLADE and (i2,i3) in SBLADE} i2;
set I10 := {(i,j) in BLADE : i in (QX inter HASSMALL) and j in QY};
set I11 := {(i,j) in BLADE : j in (QX inter HASSMALL) and i in QY};

# basic variables
# (betabump and weights included in gg variable)
# gg = gamma4Lbwt on 4-cell, = gamma23Lwt on 2&3-cell. 
# if gg > 0.1, then ggsum > 0.1 + 4 *lb > 0.	
var azim{FACE} >= 0, <= 2*piU;
var gg{FACE} >= lb, <= 0.1; #lower 9455898160;  
var gg3a{QY} >= 0, <= 0.1;  #lower bound in GLFVCVK.
var gg3b{QY} >= 0, <= 0.1;

#report variables
var ggsum;

## objective
minimize objective:  ggsum;

## equality constraints
gamma_sum: sum {i in FACE} gg[i] <= ggsum;
azim_sumU:  sum {i in FACE} azim[i] <= 2.0*piU;
azim_sumL:  sum {i in FACE} azim[i] >= 2.0*piL;
gamma2{i in QY}: gg3a[i]+gg3b[i]<=gg[i];

##inequalities by definition of branch.
azim_qxd{i in QXD}: azim[i] >= 2.3;
azim_nqxd{i in NONQXD}: azim[i] <= 2.3;
#g_negqu {i in NEGQU} : gg[i] <= 0;   # useless in determining lower bounds.
g_posqu{i in POSQU} : gg[i] >=0;

## computer generated inequality constraints

## QU

# 4-cells QU 
#gamma_qu 'ID[9455898160]' {i in QU}: gg[i] >= -0.00569;  # redundant: see var bound.
gaz4 '6206775865' {i in QU}: gg[i] + 0.0142852 - 0.00609451 * azim[i] >= 0;
gaz5 '5814748276' {i in QU}: gg[i] - 0.00127562 + 0.00522841 * azim[i] >= 0;
gaz6 '3848804089' {i in QU}: gg[i] - 0.161517 + 0.119482* azim[i] >= 0;
azim1 '5653753305' {i in QU}: gg[i] + 0.0659 - azim[i]*0.042 >= 0; 
#azim_nqu{i in NEGQU}: azim[i] <= 1.65;  #ID[2300537674] # removed 11/2012, consequence of azim1.

# 3/4-cells combined QU/QY
g_quqya{(i,j) in BLADE : i in QU and j in QY} : gg[i] + gg3a[j] >= 0; #ID[FHBVYXZ]
g_quqyb{(i,j) in BLADE : j in QU and i in QY} : gg[j] + gg3b[i] >= 0; #ID[FHBVYXZ]

## QX:

# 4-cells QX
gamma_qx{i in QX}: gg[i] >= 0; #ID[2477216213], ID[8328676778], 
g_qxd{i in QXD}:  gg[i] >= 0.0057;  #ID[7274157868] (wt1)  cf.  ID[7080972881], ID[1738910218] (reduce to wt1)
gaz7 'ID[3803737830]' {i in QX}: gg[i] - 0.0105256 + 0.00522841*azim[i] >= 0;
gamma8 'ID[9063653052]' {i in (ONESMALLa union ONESMALLb) inter QX}: gg[i] >= 0.0057; 
gaz9 'ID[2134082733]' {i in HASSMALL inter QX}: gg[i] - 0.213849 + 0.119482*azim[i] >= 0;
azim2 '9939613598' {i in FULLWT}: gg[i] - 0.00457511 - 0.00609451*azim[i] >= 0;
azim_c4{i in QU union QX}: azim[i] <= 2.8; #ID[6652007036]

# 3/4-cells combined QX/QY
gamma10 'ID[5400790175a]' {(i,j) in I10}: gg[i]+gg3a[j] >= 0.0057;
gamma11 'ID[5400790175b]' {(i,j) in I11}:  gg[j]+gg3b[i] >= 0.0057;


## QY:

#2/3-cells QY
# corrected June 3, 2010. svn 1761 has the old version.  
# Nov 2012. ineq.hl:4003532128 changed. LONGY4 not needed. Subcases not needed?
gaz3a '4003532128' {i in QY inter HASSMALL inter LONGY4} : gg[i] - 0.00457511 - 0.00609451 * azim[i] >= 0;
azim3b '3725403817'  {i in QY inter HASSMALL inter SHORTY4}: azim[i] <= 1.56;





solve;
display ggsum;
