/* FORECAST ERRORS PRODUCED USING THREE DIFFERENT SALES FORECASTING MODELS
*Sales_ModelA
*Sales_ModelB
*Sales_ModelC
*/

title 'Sales_ModelA';
data Sales_ModelA;
input
period
error
;
datalines;
1 25
2 12
3 7
4 5
5 3
6 0
7 -4
8 -11
9 -17
10 -21
11 -28
12 -34
13 -21
14 -13
15 -7
16 -2
17 5
18 9
19 15
20 19
run;

/*To print the Data*/
proc print data=Sales_ModelA;
run;
/*Time Series Plot*/
/**/
symbol value=none interpol=L width=1;
title "Time Series Plot for sales Model A's error";

/* Error in Y axis and period in X axis*/
proc gplot data=Sales_ModelA;
plot error*period;
run;
title 'Sales_ModelB';

data Sales_ModelB;
input
period
error
;
datalines;
1 15
2 6
3 -10
4 -3
5 12
6 4
7 -7
8 -1
9 9
10 7
11 -12
12 -5
13 17
14 3
15 -9
16 -3
17 13
18 5
19 -10
20 -6

run;

/*To print the Data*/
proc print data=Sales_ModelB;
run;
/*Time Series Plot*/
/**/
symbol value=none interpol=L width=1;
title "Time Series Plot for Model B's error";
proc gplot data=Sales_ModelB;
plot error*period;
run;


title 'Sales_ModelC';

data Sales_ModelC;
input
period
error
;
datalines;
1 -20
2 6
3 15
4 10
5 8
6 -5
7 7
8 -8
9 3
10 10
11 -12
12 4
13 -7
14 9
15 19
16 -7
17 16
18 -6
19 9
20 5

run;

/*To  print the Data*/
proc print data=Sales_ModelC;
run;
/*Time Series Plot*/
/**/
symbol value=none interpol=L width=1;
title "Time Series Plot for Model C's error";
proc gplot data=Sales_ModelC;
plot error*period;
run;


/*Three Sales Model*/

title 'Sales_ModelABC';
 
data Sales_ModelABC;
input
period
errorA
errorB
errorC
;
datalines;
1 25 15 -20
2 12 6 6
3 7 -10	15
4 5 -3 -10
5 3 12 8
6 0	4 -5
7 -4 -7	7
8 -11 -1 -8
9 -17 9	3
10 -21 7 10
11 -28 -12 -12
12 -34 -5 4
13 -21 17 -7
14 -13 3 9
15 -7 -9 19
16 -2 -3 -7
17 5 13	16
18 9 5 -6
19 15 -10 -9
20 19 -6 5
run;

proc sgplot data=Sales_ModelABC;
   series x=period y=errorA / legendlabel="MODEL A";
   series x=period y=errorB / legendlabel="MODEL B";
   series x=period y=errorC / legendlabel="MODEL C";
   yaxis label="Error";
run;



/*Exercise 1.6 MonthlySales*/

title 'Forecast error for each month';

data Monthlysales;

input
Month $/* String variable should have $ in the end*/
ActualSales
PredictedSales;
datalines;

January 270 265
February 263 268
March 275 269
April 262 267
May 250 245
June 278 275
;
run;

 

proc print data=Monthlysales;
run;

 

 
/* Calculating Mean Absolute Deviation(MAD), Mean Squared Error(MSE),
Mean Absolute Percentage Error(MAPE)*/
data Monthlysales;
set Monthlysales;
ForecastError = ActualSales - PredictedSales;
MAD = abs(ForecastError);
MSE = (MAD)**2;
MAPE = 100*(MAD/ActualSales);
run;



proc print data=Monthlysales;
var Month ForecastError MAD MSE MAPE;
run;

title 'Exercise 1.6 MAD,MSE and MAPE';

proc means data=Monthlysales mean maxdec=3;
var ForecastError MAD MSE MAPE;
run;




 
/* US per capita income of certain area*/
title 'Exercise 1.8';

data USPerCapitaIncome;
input
Year
PercapitaIncome
PredictedPercapitaIncome
;
datalines;

1979 3074 3292
1980 3135 3250
1981 3206 3230
1982 3267 3255
1983 3310 3266
1984 3362 3283
1985 3418 3300
1986 3500 3337
;
run;

Proc print data=USPerCapitaIncome;
run;
/* Calculating Mean Absolute Deviation(MAD), Mean Squared Error(MSE),
Mean Absolute Percentage Error(MAPE)*/
 

data USPerCapitaIncome;
set USPerCapitaIncome;
YearlyForecastError = PercapitaIncome - PredictedPercapitaIncome;
MAD = abs(YearlyForecastError);
MSE = (MAD)**2;
MAPE = 100*(MAD/PercapitaIncome);
run;

 

title 'Exercise 1.8 Forecast Error for each year';

proc print data=USPerCapitaIncome;
var Year YearlyForecastError MAD MSE MAPE;
run;

 

title 'Exercise 1.8 MAD,MSE and MAPE';

proc means data=USPerCapitaIncome mean maxdec=3;
var YearlyForecastError MAD MSE MAPE;
run;

 

title 'Exercise 1.8 Plotting errors in time series';
symbol value=none interpol=L width=1;

proc gplot data=USPerCapitaIncome;
plot YearlyForecastError*Year;
run;

 
/* Actual yearly sales of a company*/
 

title 'Exercise 1.9 Model A & B';

data YearlySalesModels;
input
year
ActualSales
ModelAPredictedSales
ModelBPredictedSales
;
datalines;
1998 8.0 9.0 9.5
1999 12.0 11.5 10.5
2000 14.0 14.0 12.0
2001 16.0 16.5 13.0
2002 10.0 19.0 15.0
;
run;

 

proc print data=YearlySalesModels;
run;
/* Calculating Mean Absolute Deviation(MAD), Mean Squared Error(MSE),
Mean Absolute Percentage Error(MAPE) for Model A and Model B*/

 

data YearlySalesModels;
set YearlySalesModels;
ForecastErrorModelA = ActualSales - ModelAPredictedSales;
ForecastErrorModelB = ActualSales - ModelBPredictedSales;
ModelAMAD = abs(ForecastErrorModelA);
ModelBMAD = abs(ForecastErrorModelB);
ModelAMSE = (ModelAMAD)**2;
ModelBMSE = (ModelBMAD)**2;

 

title 'Exercise 1.9 Forecast Error for each year';

proc print data=YearlySalesModels;
var  ModelAMAD ModelAMSE ModelBMAD ModelBMSE;
run;

 

title 'Exercise 1.9 MAD and MSE';

proc means data=YearlySalesModels mean maxdec=3;
var  ModelAMAD ModelAMSE ModelBMAD ModelBMSE;
run;

 /* Plotting errors*/

title 'Exercise 1.9 Plotting errors for Model A ';
symbol value=none interpol=L width=1;

proc gplot data=YearlySalesModels;
plot ForecastErrorModelA*Year;
run;

 

title 'Exercise 1.9 Plotting errors for Model B';

symbol value=none interpol=L width=1;

proc gplot data=YearlySalesModels;
plot ForecastErrorModelB*Year;
run;

