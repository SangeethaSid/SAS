title 'Exercise 4.2';

proc reg data=hospital;
Model Hours=Xray BedDays Length;
run;


title "Hospital labor needs plot";

proc sgplot data=hospital;
title "Monthly Xray exposures(x1)";
reg y=hours x=Xray;
run;


proc sgplot data=hospital;
title "Monthly occupied BedDays(x2)";
reg y=hours x=BedDays;
run;


proc sgplot data=hospital;
title "Average length of stay(x3)";
reg y=hours x=Length;
run;

proc gplot data=hospital;
plot hours*BedDays;
run;

proc gplot data=hospital;
plot hours*Length;
run;


proc gplot data=hospital;
plot hours*Xray;
run;


title"Exercise 4.4";

Proc reg data=hospital;
Model hours = Xray BedDays Length/ clm cli clb;
run;

/*Exercise 4.4 part b*/
data work.partb;
set work.hospital end=eof;
if eof then do;
output;
Xray=56194;BedDays=14077.88;Length=6.89;hours=.;
end;
output;
run;

proc reg data=partb;
Model hours =Xray BedDays Length / clm cli clb;
run;

Proc reg data=hospital;
Model hours = Xray BedDays Length/ clm cli clb;
run;

/*Exercise 4.4 part c*/
data work.partc;
set work.hospital end=eof;
if eof then do;
output;
Xray=56194;BedDays=14077.88;Length=6.89;hours=17207.31;
end;
output;
run;

proc reg data=partb;
Model hours =Xray BedDays Length / clm cli clb;
run;

title "Exercise 4.6";


proc reg data=hospital alpha=0.10;
Model Hours=Xray BedDays Length;
run;


proc reg data=hospital alpha=0.05;
Model Hours=Xray BedDays Length/clm cli clb;
run;


proc reg data=hospital alpha=0.01;
Model Hours=Xray BedDays Length/clm cli clb;
run;


proc reg data=hospital alpha=0.001;
Model Hours=Xray BedDays Length;
run;



proc reg data=HOSP;
Model hours =Xray BedDays Length / clm cli clb;
run;




title 'Exercise 4.20';

/*A part*/

proc reg data=work.insurance;
model y=x ds/clm cli clb;
run;

proc sgscatter data=insurance;
plot y*x/group=ds reg;
run;

/* c part*/
proc reg data=insurance alpha=0.05;
model y=x ds /clm clb cli;
run;


proc reg data=insurance alpha=0.01;
model y=x ds /clm clb cli;
run;
/*D part*/

data work.fixed;
set work.insurance;
xds=x*ds;
run;

proc reg data=work.fixed;
model y=x ds xds;
run;


title 'Exercise 4.22';
/*a*/

data work.FrD;
set work.fresh;

x3sq=x3*x3;
x43=x4*x3;
x3DB=x3*DB;
x3DC=x3*DC;
run;
proc reg data=work.FrD;
model y=x4 x3 x3sq  x43 DB DC/p clm cli clb;
run;

/*b*/
data work.FDATA;
set work.fresh end = eof;
if eof then do;
output;
x4=0.20;x3=6.50;DC=1;DB=0;y=.;
end;
output;
run;
data work.FDATA1;
set work.FDATA;
x3sq=x3*x3;
x43=x4*x3;
x3DB=x3*DB;
x3DC=x3*DC;
run;
proc reg data=work.FDATA1 alpha=0.05;
Model y=x4 x3 x3sq x43 DB DC/p clm cli clb;
run;

/*C*/
proc reg data=work.FrD alpha=0.05;
model y= x4 x3 x3sq x43 DA DC/p cli clm clb;
run;



