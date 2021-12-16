/*Exercise 6.1*/
/*a*/
symbol1 interpol=join
        value=dot;
proc gplot data=work.lumber;
plot y* t/haxis=1 to 30 by 1;
/*b*/
data work.lumber1;
set work.lumber end=eof;
if eof then do;
output;
t=31;y=.;
end;
output;
run;

data lumber2;
set work.lumber1;
one=1;
run;
symbol1 interpol=join
        value=dot;
proc gplot data=work.lumber2;
plot y*t;

proc reg data=work.lumber2;
model y=one/noint clm cli clb dw;
output out=results predicted=yhat residual=resid;

/*c*/
symbol1 interpol=join
        value=dot;
proc gplot data=work.results;
plot resid*t;
run;


/*Exercise 6.4*/

/*a*/
symbol1 interpol=join
        value=dot;
proc gplot data=work.energybill;
plot y* t/haxis=1 to 40 by 1;


/* applying transformation*/
data work.ebill1;
set work.energybill;
ylog=log10(y);
ysqrt=sqrt(y);
yquad=y**2;
run;
proc 
symbol1 interpol=join
        value=dot;
proc gplot data=work.ebill1;
title 'log transformation';
plot yquad* t/haxis=1 to 40 by 1;


proc reg data=work.ebill1;
model yquad=t/cli clm clb;
plot Residual.*Predicted.;
output out=residu Predicted=Predicted Residual=Residual;
run;

/*Exercise 6.4 c*/
 
data energybill;
input y t;
datalines;
344.39 1
246.63 2
131.53 3
288.87 4
313.45 5
189.76 6
179.10 7
221.10 8
246.84 9
209.00 10
51.21 11
133.89 12
277.01 13
197.98 14
50.68 15
218.08 16
365.10 17
207.51 18
54.63 19
214.09 20
267.00 21
230.28 22
230.32 23
426.41 24
467.06 25
306.03 26
253.23 27
279.46 28
336.56 29
196.67 30
152.15 31
319.67 32
440.00 33
315.04 34
216.42 35
339.78 36
434.66 37
399.66 38
330.80 39
539.78 40
. 41 
. 42
. 43 
. 44
;
run;

data energybill2;
      set energybill;
      if mod(t,4)=1 then Q1=1; else Q1=0;
      if mod(t,4)=2 then Q2=1; else Q2=0;
      if mod(t,4)=3 then Q3=1; else Q3=0;
 timesq=t**2;
 
proc gplot data=energybill;
	plot y*t;
symbol color=bib value=dot interpol=spline; 	
/*c2*/	
proc reg data = work.energybill2;
      model y = t timesq  Q1 Q2 Q3/CLM CLI clb DW;
run;

/*d*/

proc arima data = work.energybill2; 
	identify var = y 
	crosscor = (t timesq Q1 Q2 Q3 ) noprint; 
	estimate input = (t timesq Q1 Q2 Q3 ) printall plot; 
	
proc arima data = work.energybill2; 
	identify var = y 
	crosscor = (t timesq Q1 Q2 Q3 ) noprint; 
	estimate input = (t timesq Q1 Q2 Q3 ) p=(1) printall plot; 
	forecast lead = 4 out = work.fcast1; 
	
data fcast2; 
	set work.fcast1; 
	Forecasty = Exp(Forecast); 
	L95CI = Exp(L95); 
	U95CI = Exp(U95); 
proc print data = work.fcast2; 
	var Forecasty L95CI U95CI; 
run; 
