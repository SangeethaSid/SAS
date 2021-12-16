/* Exercise 5.13 Part-a 
Determining heteroscadasticity
*/
proc reg data = WORK.QHIC;
	model upkeep = value / cli clm clb ;
	plot residual.*Predicted.;
	output out=QHIC1 Residual=Residual Predicted=Predicted;
	/*Add predicted adn residual values*/
	run;
	
/*univariate to examine the variable*/
proc univariate data=QHIC1 plot normal;
var residual upkeep;
run;


/*Detecting curve linear effect*/

proc reg data=work.qhic;
Model upkeep=value/ PARTIAL;
plot Residual.*Predicted. upkeep*value;
output out=Resid Predicted=Predicted Residual=Residual;
run;


/*Quadratic term*/
Data fixed;
set work.qhic1;
SQval=(value)**2;
run;


proc reg data=work.fixed;
Model upkeep=value SQval/partial STB;/* standard regression coefficient -useful to assess the contributionof a predictor*/
plot Residual.*Predicted.;
output out=residu Predicted=Predicted Residual=Residual;
run;



/*Transforming the model*/

Data work.Tmodel;
set work.fixed;
TransformedModelUpkeep=Upkeep/value;
TransformedModelValue=1/value;
run;

proc reg data=work.Tmodel;
Model upkeep=value;
plot Residual.*value;
run;

Proc reg data=work.Tmodel;
Model upkeep=value SQval;
Plot residual.*value;
run;

Proc reg data=work.Tmodel;
Model TransformedModelUpkeep=TransformedModelValue value/cli clm clb;
plot residual.*value;
run;





/*Exercise 5.13 Part b*/
data work.partb;
set work.qhic end=eof;
if eof then do;
output;
value=220;upkeep=.;
end;
output;
run;
data work.partb1;
set work.partb;
valueSQ=value**2;
UpkeepTM=upkeep/value;
valueTM=1/value;
run;

proc reg data=work.partb1;
model upkeepTM=valueTM value/cli clm clb;
run;



/*Exercise 5.16 part a*/


/*data set With Dummy Variable*/ 
proc reg data= work.hospital; 
	Model Hours = Xray BedDays Length Dummy/r influence;
run;



 
/*Data set without Dummy Variable*/ 
proc reg data= work.hospital; 
	Model Hours = Xray BedDays Length/r influence;
run; 


/*Exercise 5.16 part e)*/
proc reg data= parte; 
	Model Hours = Xray BedDays Length/clm cli;
output out = results predicted =yhat residual=residu;
proc gplot data = results;
plot residu*(Hours yhat);
proc univariate data= work.results normal plot; 
var residu;
run; 

/*plotting data with dummy variable*/
proc reg data= hospital; 
	Model Hours = Xray BedDays Length Dummy/clm cli;
output out = results predicted =yhat residual=resid;
proc gplot data = results;
plot resid*(Hours yhat);
proc univariate data= work.results normal plot; 
var resid;
run; 











