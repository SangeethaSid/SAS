

title 'Exercise 2.1 Gasolinesample';
data gasolinesample;
input mileages;
datalines;
32.3
30.5
31.7
31.6
31.4
32.6
run;
/* To compute descriptive statistics*/
proc means data=gasolinesample n mean var std;
run;



title 'Exercise 2.2 Amount owed by customers';
data sevendolloramounts;
input charges;
datalines;
99
123
75
138
105
65
116
run;

proc means data=sevendolloramounts n mean var std;
run;


title 'Exercise 2.3 StrawberryPreserves';
data Strawberry;
input percentBerryConent;
datalines;
65.4
64.9
65.2
65.7
65
65.7
65.3
64.7
run;

proc means data=Strawberry n mean var std;
run;


title 'Exercise 2.4 Engines tested for pollution';
data pollution;
input particulateMatter;
datalines;
72
74
75
75
79
81
70
77
85
run;

proc means data=pollution n mean var std;
run;




/* first 30 observation in table 2.3*/


title 'Exercise 2.5 Gasoline mileages';
data gasolinesample2;
input mileages @@;
datalines;

30.8 30.9 32.0
31.7 30.4 31.4
30.1 32.5 30.8
31.6 30.3 32.8
32.1 31.3 30.6
33.3 32.1 31.5
31.3 32.5 32.4
31.0 31.8 31.0
32.0 30.4 29.8
32.4 30.5 31.1
;

run;
/* To provide a statistics that summarize the data distribution*/
proc univariate data=gasolinesample2;
histogram mileages / normal; 
run;

title 'Exercise 2.5 Stem Leaf Display';
data gasolinesample3;
input mileages @@;/*holds an i/p record across iterations
several observation in same line*/
datalines;

30.8 30.9 32.0
31.7 30.4 31.4
30.1 32.5 30.8
31.6 30.3 32.8
32.1 31.3 30.6
33.3 32.1 31.5
31.3 32.5 32.4
31.0 31.8 31.0
32.0 30.4 29.8
32.4 30.5 31.1
;
/*  Steam -leaf display will provide a qunatitative data into graphical format*/
ods listing;

ods graphics off;

proc univariate data=gasolinesample3 plots;
var mileages;
run;




/*Bag weights*/


title 'Exercise 2.6 Industrial bagging operation';
data IndustrialBaggingOperation;
input bagWeights @@ ;
datalines;
50.6 49.8 50.8 50.5 50.2 50.4
50.6 51.4 50.4 50.3 49.9 50.1
50.8 50.8 50.6 50.8 52.2 50.7
50.8 50.6 50.7 50.6 50.3 49.8
50.8 50.6 49.1 51.2 50.2 52.0
49.8 50.8 49.0 51.1 46.8 50.5
;

run;

title 'Exercise 2.6 a,b,c Calculating sample mean, variance, standard deviation';
Proc means data=bagweights n mean var std;
run;

title 'Exercise 2.6 Industrial bagging';
proc univariate data=IndustrialBaggingOperation;
histogram bagWeights / normal; 
run;

title 'Exercise 2.6 stem - leaf display';

data IndustrialBaggingOperation;
input bagWeights @@;
datalines;
50.6 49.8 50.8 50.5 50.2 50.4
50.6 51.4 50.4 50.3 49.9 50.1
50.8 50.8 50.6 50.8 52.2 50.7
50.6 50.6 50.7 50.6 50.3 49.8
50.8 50.6 49.1 51.2 50.2 52.0
49.8 50.8 49.0 51.1 46.8 50.5
;


ods listing ;/* describing two dimensional vector graphics*/
ods graphics off;/* produce plots for exploratory data analysis and used for customized statistical displays */
proc univariate data=IndustrialBaggingOperation plots;
VAR bagWeights;
run;



/*
Mean =31.5
standard deviation=0.8
Standardization= observedvalue - mean / standardeviation

 P(30.7<=y<=32.3)==> 
 30.7-31.5/0.8=-1 
 32.3-31.5/0/8=+1
 
P(y<=29.5)
p(y>=29.5) ==> 29.5-31.5/0.8=-2.5
p(y>=33.4)
p(y<=33.4) ==> 33.4-31.5/0.8=2.375

Standardization

https://stats.idre.ucla.edu/sas/faq/how-do-i-standardize-variables-in-sas/
finding the probability of normal distribution for standardized variable

*/

title 'Exercise 2.7';
data gasolineMileages;

a = probnorm(1) - probnorm(-1);
b = probnorm(3) - probnorm(-3);
c = probnorm(1) - probnorm(-2.5);
d = probnorm(-0.25) - probnorm(-0.63);
e = probnorm(-2.5);
f = 1 - probnorm(-2.5);
g = 1 - probnorm(2.38);
h = probnorm(2.38);

run;

proc print data=gasolineMileages ;
run;

/*Water consumption in ohio community*/

title 'Exercise 2.12';
data WaterConsumptionOhio;

stddev = 20000;
mean = 300000;

x1 = 250000;
x2 = 260000;
x3 = 330000;
x4 = 346000;
/*Normal probability distribution
1. less than 250000 gallons
standardize the variable
z1=Observedvalue-mean/SD  => 250000-300000/200000=-0.025
P(-0.025)

2.between 260000 and 330000


3.greater than 346000
1-prob(2.3)
*/

probability_a = probnorm((x1-mean)/stddev);
probability_b = probnorm((x3-mean)/stddev) - probnorm((x2-mean)/stddev);
probability_c = 1- probnorm((x4-mean)/stddev);
proc print data=waterconsumptionohio;
run;

/*Population of all Hawk mileages*/

title 'Exercise 2.13';
data HawkPopulation;
input HawkMileagesample;
datalines;
32.3 
30.5 
31.7 
31.4 
32.6
;
run;
/*specifies the confidence level to compute the confidence limits for the mean. 
Percentage of the confidence limits is (1-value)×100. For example, ALPHA=.05 results in a 95% confidence limit
Confidence intervals are computed with lclm and uclm*/
title 'Confidence intervals for 90% confidence limits';
proc means data=HawkPopulation alpha=0.1 n mean lclm uclm;
var HawkMileagesample;
run;
title 'Confidence intervals for 95% confidence limits';

proc means data=hawkpopulation alpha=0.05 n mean lclm uclm;
var HawkMileagesample;
run;
title 'Confidence intervals for 98% confidence limits';

proc means data=HawkPopulation alpha=0.02 n mean lclm uclm;
var HawkMileagesample;
run;
title 'Confidence intervals for 99% confidence limits';

proc means data=HawkPopulation alpha=0.01 n mean lclm uclm;
var HawkMileagesample;
run;

/*Population of all mileages*/
title 'Exercise 2.14';
data SampleA;
input mileages @@;
datalines;
30.7 31.8 30.2 32.0 31.3
;
run;
/*99% confidence level corresponds to 0.01 alpha value*/
title 'SampleA';
proc means data=SampleA alpha=0.01 lclm uclm;
run;

data SampleB;
input mileages @@;
datalines;
32.2 30.6 31.7 31.3 32.7
;
run;
title 'SampleB';
proc means data=SampleB alpha=0.01 lclm uclm;
run;

data SampleC;
input mileages @@;
datalines;
33.7 31.6 33.3 32.3 32.6
;
run;
title 'SampleC';
proc means data=SampleC alpha=0.01 lclm uclm;
run;



/* Zenex Radio Corporation Manufacturing unit*/

title 'Exercise 2.15';
%Let n = 6;/* Set the sample*/
%Let mu = 14.29;/* Set mean value*/
%Let stddev = 2.19;/* Set standard deviation*/
%Let norm = rand('normal',&mu, &stddev);/* generate random numbers for continuous and discrete variations*/
data ZenexRadio;
do x=1 to &n;
a=&norm;
output;
end;
proc means data=ZenexRadio alpha=0.01 lclm uclm;
var a;
run;	

proc ttest data=ZenexRadio alpha=0.01;
var a;
run;


/*National motors*/

title 'Example 2.16';
%Let n = 81;/*Set the sample*/
%Let mu = 57.8;/*Set the mean value*/
%Let stddev = 6.02;/*Set standard deviation*/
%Let norm = rand('normal',&mu, &stddev);
data NationalMotors;
do x=1 to &n;
a=&norm;
output;
end;
proc means data=NationalMotors alpha=0.1 lclm uclm;
var a;
run;
proc means data=NationalMotors alpha=0.05 lclm uclm;
var a;
run;	
proc means data=NationalMotors alpha=0.02 lclm uclm;
var a;
run;	
proc means data=NationalMotors alpha=0.01 lclm uclm;
var a;
run;

proc ttest data=NationalMotors alpha=0.05;
var a;
run;

proc ttest data=NationalMotors alpha=0.02;
var a;
run;




title 'Example 2.17';
%Let n = 6;
%Let mu = 15.7665;
%Let stddev = 0.1524;
%Let norm = rand('normal',&mu, &stddev);
data GemShampoo;
do x=1 to &n;
ans=&norm; 
output;
end;
/*

proc ttest data=gemshampoo sides=2 alpha=0.05  h0=16;
var ans;
run;
*/
proc ttest data=gemshampoo sides=2 alpha=0.01  h0=16;
var ans;
run;	


title 'Exercise 2.18';
%Let  n = 6;
%Let mu = 14.29;
%Let stddev = 2.19;
%Let norm = rand('normal',&mu, &stddev);
data Zenex1;
do x=1 to &n;
ans=&norm;
output;
end;
proc ttest data=zenex1 sides=l alpha=0.05  h0=20;
var ans;
run;	

title 'Example 2.19';
%Let n = 81;
%Let mu = 57.8;
%Let stddev = 6.02;
%Let norm = rand('normal',&mu, &stddev);
data NationalMotors1;
do x=1 to &n;
ans=&norm;
output;
end;
proc ttest data=NationalMotors1 sides=l alpha=0.05  h0=60;
var ans;
run;



title 'Example 2.20';
data FinancialInstitution;
input debtRatio;
datalines;
7 
4 
6 
7 
5 
4 
9
ods graphics on;

proc ttest data=FinancialInstitution sides=u alpha=0.05 h0=3.5 plots(showh0);
      var debtRatio;
   run;
   

proc ttest data=FinancialInstitution sides=u alpha=0.01 h0=3.5 plots(showh0);
      var debtRatio;
   run;















