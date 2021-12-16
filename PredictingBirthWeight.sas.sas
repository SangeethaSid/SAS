 /*Predictive Project1
Author: Manvi Lather, Sangeetha Gunasekaran*/

  /*Exploring the data*/
  
  /* Number of missing values in numeric*/
proc means data=work.BWEIGHT1 n nmiss max min mean std;
var _numeric_;
run;

/* Number of missing values in character. WE are going to drop the varaibles as  it is not significant*/
proc freq data=work.import;
tables hispmom hispdad;
run;

/*Missing value pattern*/

ods select MissPattern;
proc mi data=work.import nimpute=0;
run;

%let NumericVariables=MARITAL	GAINED	VISITS	MAGE	MEDUC	BDEAD	WEEKS	CIGNUM	DRINKNUM	DIABETES	HEMOGLOB	HYPERCH	HYPERPR	ECLAMP	CERVIX	PRETERM	UTERINE	;


/*imputing missing values*/
proc stdize data=work.import reponly method=median out=Bweight1 outstat=med;
var &NumericVariables;
run;

/*Creating dummy variables */
/*Dummy variable for Racemom */
data work.BWEIGHT2;
    set work.BWEIGHT1;
    if RACEMOM=1 then RACEMOM_1=1;
    else RACEMOM_1=0;
    if RACEMOM=2 then RACEMOM_2=1;
    else RACEMOM_2=0;
     if RACEMOM=3 then RACEMOM_3=1;
    else RACEMOM_3=0;
     if RACEMOM=4 then RACEMOM_4=1;
    else RACEMOM_4=0;
     if RACEMOM=5 then RACEMOM_5=1;
    else RACEMOM_5=0;
     if RACEMOM=6 then RACEMOM_6=1;
    else RACEMOM_6=0;
     if RACEMOM=7 then RACEMOM_7=1;
    else RACEMOM_7=0;
    if RACEMOM=8 then RACEMOM_8=1;
    else RACEMOM_8=0;
    
run;

/*Dummy variable for Racedad */
data work.BWEIGHT3;
    set work.BWEIGHT2;
    if RACEDAD=1 then RACEDAD_1=1;
    else RACEDAD_1=0;
    if RACEDAD=2 then RACEDAD_2=1;
    else RACEDAD_2=0;
     if RACEDAD=3 then RACEDAD_3=1;
    else RACEDAD_3=0;
     if RACEDAD=4 then RACEDAD_4=1;
    else RACEDAD_4=0;
     if RACEDAD=5 then RACEDAD_5=1;
    else RACEDAD_5=0;
     if RACEDAD=6 then RACEDAD_6=1;
    else RACEDAD_6=0;
     if RACEDAD=7 then RACEDAD_7=1;
    else RACEDAD_7=0;
     if RACEDAD=8 then RACEDAD_8=1;
    else RACEDAD_8=0;
    if RACEDAD=9 then RACEDAD_9=1;
    else RACEDAD_9=0;
    run;
/*sex*/
data work.BWEIGHT4;
    set work.BWEIGHT3;
    if sex=1 then sex_B=1;
    else sex_B=0;
    if sex=2 then sex_G=1;
    else sex_B=0;
    
run;   
data work.BWEIGHT5;
    set work.BWEIGHT4;
    if MARITAL=1 then MARITAL_M=1;
    else MARITAL_M=0;
    if MARITAL=2 then MARITAL_NM=1;
    else MARITAL_M=0;
    run;
/*Removing invalid data
Listing invlaid data in sex column there was one invalid data*/
title 'Listing invalid data';
data work.BWEIGHT6;
set work.BWEIGHT5;
file print; * Send output to output window;
if sex not in ('1' '2') then delete;
run;

/*checking Number of missing values in numeric*/
proc means data=work.BWEIGHT6 n nmiss max min mean std;
var _numeric_;
run;




/*Deleting this feature becasue it is not a good variable to predict birthweight
var25 and var26 are extra variables added automatically from excel. So deleting that aswell*/
data work.BWEIGHT7; 
	set work.BWEIGHT6;
	drop HISPMOM; 
	drop HISPDAD;
	drop var25;
	drop var26;
run;
  
 
 
  
  
/*Description statistics for categorical & numerical variables*/
   
   Proc freq data=work.BWEIGHT7;
   tables SEX RACEMOM RACEDAD DIABETES HYPERCH HYPERPR ECLAMP HEMOGLOB MEDUC UTERINE;
   run;
   Proc freq data=work.BWEIGHT7;
   tables PRETERM CERVIX MARITAL;
   run;
   
   proc sgplot data=work.BWEIGHT7;
   vbar HYPERCH;
   histogram HYPERCH;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar Hemoglob;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar HYPERPR;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar ECLAMP;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar diabetes;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar CERVIX;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar PRETERM;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar MARITAL;
   run;
   
   
   proc sgplot data=work.BWEIGHT7;
   vbar RACEMOM;
   run;
    proc sgplot data=work.BWEIGHT7;
   vbar RACEDAD;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar MEDUC;
   run;
   proc sgplot data=work.BWEIGHT7;
   vbar UTERINE;
   run;
   
   
   
   proc sgscatter data=work.BWEIGHT7;
   plot BWEIGHT*MAGE/group=sex;
   run;
   
   proc sgscatter data=work.BWEIGHT7;
   plot BWEIGHT*Gained;
   run;
   
   proc sgscatter data=work.BWEIGHT7;
   plot BWEIGHT*WEEKS;
   run;
   
   proc sgscatter data=work.BWEIGHT7;
   plot BWEIGHT*BDEAD;
   run;
   
   proc sgscatter data=work.BWEIGHT7;
   plot BWEIGHT*Visits;
   run;
   
   
    proc sgscatter data=work.BWEIGHT7;
   plot BWEIGHT*Cignum;
   run;
    proc sgscatter data=work.BWEIGHT7;
   plot BWEIGHT*Drinknum;
   run;
   
PROC SGSCATTER DATA=work.BWEIGHT7;
MATRIX  BWEIGHT WEEKS GAINED VISITS/Diagonal=(Histogram normal); 
RUN;
PROC SGSCATTER DATA=BWEIGHT7;
MATRIX  BWEIGHT MAGE CIGNUM DRINKNUM/Diagonal=(Histogram normal); 
RUN;
 
 
 /* Box plot*/
proc sgplot data=work.BWEIGHT8;
vbox WEEKS;
run;

proc sgplot data=work.BWEIGHT8;
vbox GAINED;
run;

proc sgplot data=work.BWEIGHT8;
vbox VISITS;
run;
proc sgplot data=work.BWEIGHT7;
vbox BDEAD;
run;
proc sgplot data=work.BWEIGHT8;
vbox cignum;
run;
proc sgplot data=work.BWEIGHT7;
vbox DRINKNUM;
run;

proc sgplot data=work.BWEIGHT7;
vbox MAGE;
run;

 
 
 
 
 
/*Creating dummy variables for CIGNUM*/
data work.BWEIGHT8;
    set work.BWEIGHT7;
    if CIGNUM=0 then SMOKE=0;
    else SMOKE=1;
run;

/*Correlation plot*/



proc corr data=work.BWEIGHT8 plots = matrix(histogram) plots(maxpoints=none);
var bweight WEEKS MAGE GAINED VISITS CIGNUM DRINKNUM; 
run; 

/*finding correlation using VIF*/
proc reg data=work.BWEIGHT8 ; 
	model BWEIGHT= WEEKS MAGE GAINED VISITS CIGNUM DRINKNUM/vif; 
	title"collinearity Diagnostics"; 
run; 
/* finding correlation between continuous variables*/
proc corr data=work.bweight8 pearson spearman;
var BWEIGHT WEEKS GAINED VISITS MAGE BDEAD;
run;

/*finding correlation using chisq for categorical data*/
proc freq data=work.BWEIGHT8;
tables BWEIGHT*sex / chisq;
run;
proc freq data=work.BWEIGHT8;
tables BWEIGHT*MARITAL / chisq;
run;
proc freq data=work.BWEIGHT8;
tables BWEIGHT*RACEMOM/ chisq;
run;
proc freq data=work.BWEIGHT8;
tables BWEIGHT*RACEDAD/ chisq;
run;
proc freq data=work.BWEIGHT8;
tables BWEIGHT*BDEAD/ chisq;
run;

proc freq data=work.BWEIGHT8;
tables BWEIGHT*HYPERPR/ chisq;
run;

/*STUDENTIZED RESIDUAL -CHECKING OUTLIERS*/

ods graphics on;
proc reg data=work.BWEIGHT8;
	model BWEIGHT= WEEKS GAINED VISITS MAGE BDEAD CIGNUM DRINKNUM/ stb clb;
	output out=stdres predicted=predicted residual=residual rstudent=r h=leverage cookd=cookd dffits=dffits;
	run;
quit;
ods graphics off;
/*Student residual greater than 3*/
proc print data= stdres;
var r BWEIGHT WEEKS GAINED VISITS MAGE BDEAD CIGNUM DRINKNUM;
where abs(r)>=3;
run;

/*percentile capping to replace outliers with min and max*/

proc means data=work.BWEIGHT8 stackods n qrange p1 p99;
var WEEKS GAINED VISITS MAGE BDEAD CIGNUM DRINKNUM;
ods output summary=ranges;
run;

%macro cap(dset=,var=, lower=, upper=);

data &dset;
set &dset;
if &var>&upper then &var=&upper;
if &var<&lower then &var=&lower;
run;

%mend;


*create cutoffs and execute macro for each variable;
data cutoffs;
set ranges;
lower=p1;
upper=p99;
string = catt('%cap(dset=work.BWEIGHT8, var=',variable, ", lower=", lower, ", upper=", upper ,");");
call execute(string);
run;



/*Scatter plot*/
ods graphics on;
proc reg data=work.BWEIGHT8;
model BWEIGHT=WEEKS GAINED VISITS MAGE BDEAD CIGNUM DRINKNUM;
output out=diag predicted=pred residual=resid;
run;
quit;
ods graphics off;
proc gplot data=diag;
plot resid*cignum;
run;




/*Counting missing values using graph*/
proc iml;
vars={FAGE TOTALP WEEKS RACEMOM DRINKNUM ANEMIA CARDIAC};
use work.import;
read all var vars into X;/*create numeric data matrix ,X*/
close work.import;
Count=countmiss(X,"row");/*counting rows containing missing values*/
call Bar(Count); /*creating bar chart*/
missRows =loc(Count>0);/*Which rows are missing*/
call histogram(missRows) scale="count"/*plot distribution*/
rebin={125,250}/*binwidth=250*/
label="Row number";/*lable for x axis*/

/*influential observation using glm select and proc reg*/
%let Babyrecords=WEEKS GAINED SEX MARITAL CIGNUM RACEDAD HYPERPR PRETERM VISITS;
ods select none;
proc glmselect data=work.import plots=all;
STEPWISE:Model BWEIGHT= &Babyrecords/selection=stepwise details=steps select=SL slentry=0.05 slstay=0.05;
run;
quit;
ods select all;
ods graphics on;
ods output RSTUDENTBYPREDICTED =Rstud COOKSDPLOT=cook DFFITSPLOT=Dffits DFBETASPANEL=Dfbs;
proc reg data=work.import 
plots(only label)=(RSTUDENTBYPREDICTED COOKSD DFFITS DFBETAS);
Siglimit: model BWEIGHT=&_GLSIND;
run;
quit;

proc print data=cook;
run;
proc print data=Rstud;
run;
proc print data=dffits;
run;


/*Residual normality check*/
proc sql;
select name into :ivars separated by ' '
from dictionary.columns
where libname eq 'WORK'      /*library name        */
  and memname eq 'BWEIGHT8'  /*data set name       */
  and name    ne 'BWEIGHT' /*exlude dep variable */ ;
quit;

proc reg data=work.BWEIGHT8;
  model BWEIGHT = WEEKS GAINED VISITS MAGE BDEAD MEDUC DIABETES HYPERCH HYPERPR ECLAMP CERVIX PRETERM  
  UTERINE SMOKE /stb clb;
  output out=diagr predicted=pred residual=residu;
run;

proc univariate normal plot data=diagr;
var residu;
run;

/*Transformation of dependent variable*/

/*log transformation*/
data newlog;
set work.BWEIGHT8;
BWEIGHTlog=log10(BWEIGHT);
run;
proc reg data=work.newlog plots(only)=(CooksD(label) DFFits(label));
model BWEIGHTlog=WEEKS GAINED VISITS MAGE BDEAD MEDUC DIABETES HYPERCH HYPERPR ECLAMP CERVIX PRETERM  
  UTERINE smoke/stb clb;
run;


/*White test*/
proc reg data= work.BWEIGHT8;
model BWEIGHT=WEEKS GAINED VISITS MAGE BDEAD MEDUC DIABETES HYPERCH HYPERPR ECLAMP CERVIX PRETERM  
  UTERINE / SPEC;
run;


/*Plotting residuals*/
proc reg data= work.BWEIGHT8;
model BWEIGHT=WEEKS GAINED VISITS MAGE BDEAD MEDUC DIABETES HYPERCH HYPERPR ECLAMP CERVIX PRETERM UTERINE;
plot R.*predicted.;
output predicted=predicted residual=resid;
run;
quit;







proc reg data=work.BWEIGHT8;
model BWEIGHT=WEEKS GAINED VISITS MAGE BDEAD /stb clb;
output out=diag predicted=pred residual=resid;
run;


/*multicollinearity check*/
proc reg data= work.BWEIGHT8;
model BWEIGHT=WEEKS GAINED VISITS MAGE BDEAD MEDUC DIABETES HYPERCH HYPERPR ECLAMP CERVIX PRETERM  
  UTERINE / VIF;
run;


/*Error term independence*/
/*multicollinearity check*/
proc reg data= work.BWEIGHT8;
model BWEIGHT=WEEKS GAINED VISITS MAGE BDEAD MEDUC DIABETES HYPERCH HYPERPR ECLAMP CERVIX PRETERM  
  UTERINE / dw;
run;


/*Dropping variables which are not significant*/
data work.BWEIGHT9; 
	set work.BWEIGHT8;
	drop DRINKNUM;
	drop RACEDAD;
	drop CIGNUM;
	drop HEMOGLOB;
	drop MARITAL;
	drop MARITAL_M;
	drop MARITAL_NM;
	drop SEX;
	drop RACEMOM;
	drop MEDUC;
	drop ID;
	drop MAGE;
	drop RACEDAD_5;
run;
	


/*Final multiple linear regression model*/
proc sql;
select name into :ivars separated by ' '
from dictionary.columns
where libname eq 'WORK'      /*library name        */
  and memname eq 'BWEIGHT9'  /*data set name       */
  and name    ne 'BWEIGHT' /*exlude dep variable */ ;
quit;

proc reg plots(maxpoints=none);
  model BWEIGHT = &ivars;
run;


proc reg plots(maxpoints=none);
  model BWEIGHT = &ivars/slstay=0.05 slentry=0.05 selection=stepwise;
run;






/*Stepwise regression*/

proc sql;
select name into :ivars separated by ' '
from dictionary.columns
where libname eq 'WORK'      /*library name        */
  and memname eq 'BWEIGHT7'  /*data set name       */
  and name    not in ('ID' 'BWEIGHT' 'DRINKNUM' 'CIGNUM' 'RACEDAD' 'RACEMOM' 'SEX' 'MARITAL'	) /*exlude dep variable */ ;
quit;

proc reg ;
  model BWEIGHT = &ivars/ slstay=0.05 slentry=0.05 selection=stepwise;
run;


/*log transformation of dependent variable with stepwise*/
data work.LOGTRANS;
set work.BWEIGHT7;
BWEIGHTlog=log10(BWEIGHT);
run;
proc sql;
select name into :ivars separated by ' '
from dictionary.columns
where libname eq 'WORK'      /*library name        */
  and memname eq 'LOGTRANS'  /*data set name       */
  and name    not in ('ID' 'BWEIGHT' 'BWEIGHTlog' 'DRINKNUM' 'CIGNUM' 'RACEDAD' 'RACEMOM' 'SEX' 'MARITAL' 'sex_G' 'sex_B' 'MARITAL_M' 'MARITAL_NM' 'RACEDAD_5'	) /*exlude dep variable */ ;
quit;
proc reg ;
  model BWEIGHT = &ivars/selection=stepwise;
run;

data work.LOGTRANS;
set work.BWEIGHT7;
BWEIGHTlog=log10(BWEIGHT);
run;
proc sql;
select name into :ivars separated by ' '
from dictionary.columns
where libname eq 'WORK'      /*library name        */
  and memname eq 'LOGTRANS'  /*data set name       */
  and name    not in ('ID' 'BWEIGHT' 'BWEIGHTlog' 'DRINKNUM' 'CIGNUM' 'RACEDAD' 'RACEMOM' 'SEX' 'MARITAL' 'sex_G' 'sex_B' 'MARITAL_M' 'MARITAL_NM' 'RACEDAD_5'	) /*exlude dep variable */ ;
quit;
proc reg ;
  model BWEIGHTlog = &ivars;
run;


/*logistic regression*/

data work.BWEIGHT8;
set work.BWEIGHT7;
If(BWEIGHT<5.5) then BWEIGHT_Logistic='A';
else if(BWEIGHT>5.5 & BWEIGHT<8.8) then BWEIGHT_Logistic='B';
else if (BWEIGHT>8.8) then BWEIGHT_Logistic='C';
else BWEIGHT_Logistic='Blank';
run;

proc sql;
select name into :ivars separated by ' '
from dictionary.columns
where libname eq 'WORK'      /*library name        */
  and memname eq 'BWEIGHT8'  /*data set name       */
  and name    not in ('ID' 'DRINKNUM' 'BWEIGHT_Logistic' 'BWEIGHT' 'CIGNUM' 'RACEDAD' 'RACEMOM' 'SEX' 'MARITAL' 'sex_G' 'sex_B' 'MARITAL_M' 'MARITAL_NM' 'RACEDAD_5'	) /*exlude variable */ ;
quit;
proc logistic data=work.BWEIGHT8;
Model BWEIGHT_Logistic=&ivars;
run;




