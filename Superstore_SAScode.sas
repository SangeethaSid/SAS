/*plot*/
symbol value=NONE interpol=l width=1;
proc gplot data=work.import;
plot Sales*OrderDate;
run;


/* Time series regression*/

proc reg data=work.import;
model Sales=OrderDate/noint clm cli clb dw;
output out=results predicted=yhat residual=resid;

/*residual plot*/
symbol value=NONE interpol=l width=1;
proc gplot data=work.results;
plot resid*OrderDate;
run;

/* Applying Transformation to get constant seasonal varaition*/
data work.import1;
set work.import;
ylog=log10(Sales);
ysqrt=sqrt(Sales);
yquad=Sales**2;
run;
symbol value=NONE interpol=l width=1;
proc gplot data=work.import1;
title 'log transformation';
plot ylog* OrderDate/haxis=1 to 48 by 1;

run;

proc gplot data=work.import1;
title 'Squareroot transformation';
plot ysqrt* OrderDate/haxis=1 to 48 by 1;
run;
proc gplot data=work.import1;
title 'Quadratic transformation';
plot yquad* OrderDate/haxis=1 to 48 by 1;
run;

/*Additive Decomposition*/


/*Decomposition Model for Time Series Data*/
Data SalesData_MovingAverage;
Set work.import;
Array SalesLag {12} SalLag0-SalLag11;
SalesLag{1} = Sales;
do i = 2 to 12;
  SalesLag{i} = Lag(SalesLag{i-1});
end;
MovingAverage = 0;
do i = 1 to 12;
  MovingAverage = MovingAverage + SalesLag{i};
end;
MovingAverage = MovingAverage/12;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = SalesData_MovingAverage;
title "Sales (Additive) data = SalesData_MovingAverage";
run;

/* STEP 3 */

Data SalesData_MovingAverage;
Set SalesData_MovingAverage;
Keep CenteredMV;
If _N_ <=6 then delete;

Data SalesData_SeasonalIndex;
Set SalesData_MovingAverage; Set work.import;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = Sales-CenteredMV;
proc print data = SalesData_SeasonalIndex;
run;
title "Sales (Additive) data = SalesData_SeasonalIndex";

/* STEP 4 */

Data SalesData_SeasonalIndex;
set SalesData_SeasonalIndex end=myEOF;
Array SeasonalIndex {12} SeasIndex1-SeasIndex12;
Retain SeasIndex1-SeasIndex12 0;
Time = _N_;
Do i = 1 to 12;
   If Mod(Time, 12)= i then SeasonalIndex{i} = SeasonalIndex{i} + SeasonalIndexInitial;   
end;
If Mod(Time, 12)= 0 then SeasIndex12 = SeasIndex12 + SeasonalIndexInitial;

If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 12;
     SeasonalIndex{i} = (SeasonalIndex{i}/ 3); 
     sum_of_indices = sum_of_indices + SeasonalIndex{i}; 
  End;
End;

If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex12;
run;

proc print data = SalesData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex12;
title "Sales (Additive) Seasonal Indexes";
run;

/* STEP 5 */

Data DeseasonalizedData;
If _N_ =1 then Set SalesData_SeasonalIndex;  Set work.import;
Array SeasonalIndex {12} SeasIndex1-SeasIndex12;
Time = _N_; 
Do i = 1 to 12;
   If Mod(Time, 12)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 12)= 0 then SeasonalEffect  = SeasonalIndex{12};  
DeseasonalizedSales = Sales-SeasonalEffect;
Keep  Time DeseasonalizedSales Sales SeasonalEffect;
proc print data = DeseasonalizedData;
run;
title "Sales (Additive) Deseasonalized Data";

/* STEP 6 */

Proc Reg data=DeseasonalizedData;
model DeseasonalizedSales  = Time ;
output out=tempfile p=Trend;
title " Sales (Additive) DeseasonalizedSales regressed on Time";
run;
proc print data = tempfile;
run;
title "Sales (Additive) Predicted DeseasonalizedSales - Trend ";

/* STEP 7 */

Data Cyclical;
Set tempfile;
CyclicalInitial = DeseasonalizedSales - Trend;

Data Cyclical;
Set Cyclical;
Array CyclicalLag {3} CyclicalLag1-CyclicalLag3;
CyclicalLag{1} = CyclicalInitial;
do i = 2 to 3;
  CyclicalLag{i} = Lag(CyclicalLag{i-1});
end;
CycMovingAverage = 0;
do i = 1 to 3;
  CycMovingAverage = CycMovingAverage + CyclicalLag{i};
end;
CycMovingAverage = CycMovingAverage/3;
Keep CycMovingAverage;
If _N_ = 1 then delete;
Drop i; 

proc print data = Cyclical;
title "Sales (Additive) data = Cyclical";
run;

/* STEP 8 */

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = Sales-(SeasonalEffect+Trend+CycMovingAverage);

proc print data = Decomposition;
Title "Sales (Additive) Decomposition";
 Run;
/****************************/
Proc Reg data=DeseasonalizedData;
	model DeseasonalizedSales  = Time / cli clm;
	title 'Sales (Additive) Predicted Values for New Obs (matching Fig. 7.6)';
run;

proc forecast data = Decomposition lead=4 out=prediction;
var Sales;
title 'Sales (Additive) forecast';
run;

proc print data=prediction;
run;
Quit;

/*Box jenkins seasonal Modeling*/


/*Checking whether our time series is stationary*/
proc arima data=work.import;
identify var=Sales;
identify var=Sales(1);
identify var=Sales(1,1);
run;

/*Arima modelling*/

ods graphics off;
proc arima data=work.import;
identify var=Sales;
run;

/*using scan option*/
proc arima data=work.import;
identify var=Sales nlag=20 scan;
run;

/*Dickey Fuller test*/
proc arima data=work.import;
identify var=Sales nlag=15 stationarity=(adf=2);
run;

/*Final model
ARMA(1,1)*/

/*Model 1-with no constant*/

proc arima data=work.import;
identify var=Sales nlag=20;
estimate p=1 q=1 noconstant printall plot;
forecast lead = 12 out=Superstoreforecast  interval=month ;
run;

/*Model 2-Without no constant*/
proc arima data=work.import;
identify var=Sales nlag = 20;
estimate p=1 q=1 printall plot;
forecast lead = 12 out=Superstoreforecast  interval=month ;
run;
