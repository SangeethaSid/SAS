
/*Ex 7.1*/

/* STEP 1 */

title 'EX 7.1 Tractor Sales';
data salesdata;
input sales;
datalines;
293
392
221
147
388
512
287
184
479
640
347
223
581
755
410
266
.
.
.
.
run;


/* STEP 2 */

Data SalesData_MovingAverage;
Set SalesData;
Array SalesLag {4} SalLag0-SalLag3;
SalesLag{1} = Sales;
do i = 2 to 4;
  SalesLag{i} = Lag(SalesLag{i-1});/*note Lag is a SAS function*/
end;
MovingAverage = 0;
do i = 1 to 4;
  MovingAverage = MovingAverage + SalesLag{i};
end;
MovingAverage = MovingAverage/4;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = SalesData_MovingAverage;
title "EX 7.1 Tractor Sales data = SalesData_MovingAverage";
run;

/* STEP 3 */

Data SalesData_MovingAverage;
Set SalesData_MovingAverage;
Keep CenteredMV;
If _N_ <=2 then delete;

Data SalesData_SeasonalIndex;
Set SalesData_MovingAverage; Set SalesData;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = Sales/CenteredMV;
proc print data = SalesData_SeasonalIndex;
run;
title "EX 7.1 Tractor Sales data = SalesData_SeasonalIndex";

/* STEP 4 */

Data SalesData_SeasonalIndex;
set SalesData_SeasonalIndex end=myEOF;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Retain SeasIndex1-SeasIndex4 0;
Time = _N_;
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalIndex{i} = SeasonalIndex{i} + SeasonalIndexInitial;   
end;
If Mod(Time, 4)= 0 then SeasIndex4 = SeasIndex4 + SeasonalIndexInitial;
/*  Get average on next set of lines */ 
If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 4;
     SeasonalIndex{i} = (SeasonalIndex{i}/3)*0.9998; 
     sum_of_indices = sum_of_indices + SeasonalIndex{i}; 
  End;
End;
/**Only keep last line**/
If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex4;
run;

proc print data = SalesData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex4;
title "EX 7.1 Tractor Sales Seasonal Indexes";
run;

/* STEP 5 */

Data DeseasonalizedData;
If _N_ =1 then Set SalesData_SeasonalIndex;  Set SalesData;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Time = _N_; 
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 4)= 0 then SeasonalEffect  = SeasonalIndex{4};  
DeseasonalizedSales = Sales/SeasonalEffect;
Keep  Time DeseasonalizedSales Sales SeasonalEffect;
proc print data = DeseasonalizedData;
run;
title "EX 7.1 Tractor Sales Deseasonalized Data";

/* STEP 6 */

Proc Reg data=DeseasonalizedData;
model DeseasonalizedSales  = Time ;
output out=tempfile p=Trend;
title "EX 7.1 Tractor Sales DeseasonalizedSales regressed on Time";
run;
proc print data = tempfile;
run;
title "EX 7.1 Tractor Sales Predicted DeseasonalizedSales - Trend ";

/* STEP 7 */

Data Cyclical;
Set tempfile;
CyclicalInitial = DeseasonalizedSales /Trend;

Data Cyclical;
Set Cyclical;
Array CyclicalLag {3} CyclicalLag1-CyclicalLag3;
CyclicalLag{1} = CyclicalInitial;
do i = 2 to 3;
  CyclicalLag{i} = Lag(CyclicalLag{i-1});/*note Lag is a SAS function*/
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
title "EX 7.1 Tractor Sales data = Cyclical";
run;

/* STEP 8 */

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = Sales/(SeasonalEffect*Trend*CycMovingAverage);

proc print data = Decomposition;
Title "EX 7.1 Tractor Sales Decomposition";
 Run;


/* STEP 9 */

Proc Reg data=DeseasonalizedData;
	model DeseasonalizedSales  = Time / cli clm;
	title 'EX 7.1 Tractor Sales Predicted Values for New Obs (matching Fig. 7.6)';
run;

proc forecast data = Decomposition lead=4 out=prediction;
var Sales;
title 'EX 7.1 Tractor Sales forecast';
run;

proc print data=prediction;
run;
Quit;

/*Ex 7.2*/
data salesdata;
input sales;
datalines;
20
25
35
44
28
29
43
48
24
37
39
56
.
.
.
.
;
proc print data=SalesData;
title "data=SalesData";
run;

/* STEP 2 */

Data SalesData_MovingAverage;
Set SalesData;
Array SalesLag {4} SalLag0-SalLag3;
SalesLag{1} = Sales;
do i = 2 to 4;
  SalesLag{i} = Lag(SalesLag{i-1});/*note Lag is a SAS function*/
end;
MovingAverage = 0;
do i = 1 to 4;
  MovingAverage = MovingAverage + SalesLag{i};
end;
MovingAverage = MovingAverage/4;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = SalesData_MovingAverage;
title "data = SalesData_MovingAverage";
run;

/* STEP 3 */

Data SalesData_MovingAverage;
Set SalesData_MovingAverage;
Keep CenteredMV;
If _N_ <=2 then delete;
proc print data = SalesData_MovingAverage;
title "Updated"
run;

Data SalesData_SeasonalIndex;
Set SalesData_MovingAverage; Set SalesData;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = Sales/CenteredMV;
proc print data = SalesData_SeasonalIndex;
title "data = SalesData_SeasonalIndex";

/* STEP 4 */

Data SalesData_SeasonalIndex;
set SalesData_SeasonalIndex end=myEOF;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Retain SeasIndex1-SeasIndex4 0;
Time = _N_;
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalIndex{i} = (SeasonalIndex{i} + SeasonalIndexInitial);   
end;
If Mod(Time, 4)= 0 then SeasIndex4 = (SeasIndex4 + SeasonalIndexInitial);
/*  Get average on next set of lines */ 
If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 4;
     SeasonalIndex{i} = (SeasonalIndex{i}/ 2)*0.9888; 
     sum_of_indices = ((sum_of_indices + SeasonalIndex{i})); 
  End;
End;
/**Only keep last line**/
If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex4 ;
run;

proc print data = SalesData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex4;
title "Seasonal Indexes";
run;

/* STEP 5 */

Data DeseasonalizedData;
If _N_ =1 then Set SalesData_SeasonalIndex;  Set SalesData;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Time = _N_; 
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 4)= 0 then SeasonalEffect  = SeasonalIndex{4};  
DeseasonalizedSales = Sales/SeasonalEffect;
Keep  Time DeseasonalizedSales Sales SeasonalEffect;
proc print data = DeseasonalizedData;
title "Deseasonalized Data";

/* STEP 6 */

Proc Reg data=DeseasonalizedData;
model DeseasonalizedSales  = Time ;
output out=tempfile p=Trend;
title "DeseasonalizedSales regressed on Time";

proc print data = tempfile;
title "Predicted DeseasonalizedSales - Trend ";

/* STEP 7 */

Data Cyclical;
Set tempfile;
Trend1 = Trend * SeasonalEffect;
CyclicalInitial = Sales / Trend1;
proc print data = Cyclical;
title " Cyclical";
run;

Data Cyclical;
Set Cyclical;
Array CyclicalLag {3} CyclicalLag0-CyclicalLag2;
CyclicalLag{1} = CyclicalInitial;
do i = 2 to 3;
  CyclicalLag{i} = Lag(CyclicalLag{i-1});/*note Lag is a SAS function*/
end;
CycMovingAverage = 0;
do i = 1 to 3;
  CycMovingAverage = CycMovingAverage + CyclicalLag{i};
end;
CycMovingAverage = CycMovingAverage/3;
Keep CycMovingAverage;
If _N_ = 1 then delete;
Drop i; 
title "data = Cyclical";
run;

/* STEP 8 */

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = Sales/(SeasonalEffect*Trend*CycMovingAverage);

proc print data = Decomposition;
Title "Decomposition";
 Run;


/* STEP 9 */
Proc Reg data=DeseasonalizedData;
	model DeseasonalizedSales  = Time / cli clm;
	run;
proc forecast data = DeseasonalizedData lead=7 out=prediction;
var Sales;
run;

proc print data=prediction;
title "Sales forecasts for the next 7 days";
run;
Quit;

/*Ex 7.3
Multiplicative model is more appropriate */
title 'EX 7.3 Tractor Sales (Additive)';
data salesdata;
input sales;
datalines;
293
392
221
147
388
512
287
184
479
640
347
223
581
755
410
266
.
.
.
.
run;

Data SalesData_MovingAverage;
Set SalesData;
Array SalesLag {4} SalLag0-SalLag3;
SalesLag{1} = Sales;
do i = 2 to 4;
  SalesLag{i} = Lag(SalesLag{i-1});
end;
MovingAverage = 0;
do i = 1 to 4;
  MovingAverage = MovingAverage + SalesLag{i};
end;
MovingAverage = MovingAverage/4;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = SalesData_MovingAverage;
title "EX 7.3 Tractor Sales (Additive) data = SalesData_MovingAverage";
run;

Data SalesData_MovingAverage;
Set SalesData_MovingAverage;
Keep CenteredMV;
If _N_ <=2 then delete;

Data SalesData_SeasonalIndex;
Set SalesData_MovingAverage; Set SalesData;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = Sales-CenteredMV;
proc print data = SalesData_SeasonalIndex;
run;
title "EX 7.3 Tractor Sales (Additive) data = SalesData_SeasonalIndex";

Data SalesData_SeasonalIndex;
set SalesData_SeasonalIndex end=myEOF;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Retain SeasIndex1-SeasIndex4 0;
Time = _N_;
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalIndex{i} = SeasonalIndex{i} + SeasonalIndexInitial;   
end;
If Mod(Time, 4)= 0 then SeasIndex4 = SeasIndex4 + SeasonalIndexInitial;

If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 4;
     SeasonalIndex{i} = ((SeasonalIndex{i}/ 3)-7.20); 
     sum_of_indices = sum_of_indices + SeasonalIndex{i}; 
  End;
End;

If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex4;
run;

proc print data = SalesData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex4;
title "EX 7.3 Tractor Sales (Additive) Seasonal Indexes";
run;

Data DeseasonalizedData;
If _N_ =1 then Set SalesData_SeasonalIndex;  Set SalesData;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Time = _N_; 
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 4)= 0 then SeasonalEffect  = SeasonalIndex{4};  
DeseasonalizedSales = Sales-SeasonalEffect;
Keep  Time DeseasonalizedSales Sales SeasonalEffect;
proc print data = DeseasonalizedData;
run;
title "EX 7.3 Tractor Sales (Additive) Deseasonalized Data";

Proc Reg data=DeseasonalizedData;
model DeseasonalizedSales  = Time ;
output out=tempfile p=Trend;
title "EX 7.3 Tractor Sales (Additive) DeseasonalizedSales regressed on Time";
run;
proc print data = tempfile;
run;
title "EX 7.3 Tractor Sales (Additive) Predicted DeseasonalizedSales - Trend ";

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
title "EX 7.3 Tractor Sales (Additive) data = Cyclical";
run;

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = Sales-(SeasonalEffect+Trend+CycMovingAverage);

proc print data = Decomposition;
Title "EX 7.3 Tractor Sales (Additive) Decomposition";
 Run;

Proc Reg data=DeseasonalizedData;
	model DeseasonalizedSales  = Time / cli clm;
	title 'EX 7.3 Tractor Sales (Additive) Predicted Values for New Obs (matching Fig. 7.6)';
run;

proc forecast data = Decomposition lead=4 out=prediction;
var Sales;
title 'EX 7.3 Tractor Sales (Additive) forecast';
run;

proc print data=prediction;
run;
Quit;



/*Ex 7.4 both are appropriate*/
title 'EX 7.4 Oligopoly Sales (Additive method)';
data salesdata;
input sales;
datalines;
20
25
35
44
28
29
43
48
24
37
39
56
.
.
.
.
run;



Data SalesData_MovingAverage;
Set SalesData;
Array SalesLag {4} SalLag0-SalLag3;
SalesLag{1} = Sales;
do i = 2 to 4;
  SalesLag{i} = Lag(SalesLag{i-1});/*note Lag is a SAS function*/
end;
MovingAverage = 0;
do i = 1 to 4;
  MovingAverage = MovingAverage + SalesLag{i};
end;
MovingAverage = MovingAverage/4;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = SalesData_MovingAverage;
title "EX 7.4 Oligopoly Sales (Additive) data = SalesData_MovingAverage";
run;

Data SalesData_MovingAverage;
Set SalesData_MovingAverage;
Keep CenteredMV;
If _N_ <=2 then delete;

Data SalesData_SeasonalIndex;
Set SalesData_MovingAverage; Set SalesData;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = Sales-CenteredMV;
proc print data = SalesData_SeasonalIndex;
run;
title "EX 7.4 Oligopoly Sales (Additive) data = SalesData_SeasonalIndex";

Data SalesData_SeasonalIndex;
set SalesData_SeasonalIndex end=myEOF;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Retain SeasIndex1-SeasIndex4 0;
Time = _N_;
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalIndex{i} = SeasonalIndex{i} + SeasonalIndexInitial;   
end;
If Mod(Time, 4)= 0 then SeasIndex4 = SeasIndex4 + SeasonalIndexInitial;
If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 4;
     SeasonalIndex{i} = ((SeasonalIndex{i}/ 2)-0.25); 
     sum_of_indices = sum_of_indices + SeasonalIndex{i}; 
  End;
End;
If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex4;
run;

proc print data = SalesData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex4;
title "EX 7.4 Oligopoly Sales (Additive) Seasonal Indexes";
run;

Data DeseasonalizedData;
If _N_ =1 then Set SalesData_SeasonalIndex;  Set SalesData;
Array SeasonalIndex {4} SeasIndex1-SeasIndex4;
Time = _N_; 
Do i = 1 to 4;
   If Mod(Time, 4)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 4)= 0 then SeasonalEffect  = SeasonalIndex{4};  
DeseasonalizedSales = Sales-SeasonalEffect;
Keep  Time DeseasonalizedSales Sales SeasonalEffect;
proc print data = DeseasonalizedData;
run;
title "EX 7.4 Oligopoly Sales (Additive) Deseasonalized Data";

Proc Reg data=DeseasonalizedData;
model DeseasonalizedSales  = Time ;
output out=tempfile p=Trend;
title "EX 7.4 Oligopoly Sales (Additive) DeseasonalizedSales regressed on Time";
run;
proc print data = tempfile;
run;
title "EX 7.4 Oligopoly Sales (Additive) Predicted DeseasonalizedSales - Trend ";

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
title "EX 7.4 Oligopoly Sales (Additive) data = Cyclical";
run;

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = Sales-(SeasonalEffect+Trend+CycMovingAverage);

proc print data = Decomposition;
Title "EX 7.4 Oligopoly Sales (Additive) Decomposition";
 Run;

Proc Reg data=DeseasonalizedData;
	model DeseasonalizedSales  = Time / cli clm;
	title 'EX 7.4 Oligopoly Sales (Additive) Predicted Values for New Obs (matching Fig. 7.6)';
run;

proc forecast data = Decomposition lead=4 out=prediction;
var Sales;
title 'EX 7.4 Oligopoly Sales (Additive) forecast';
run;

proc print data=prediction;
run;
Quit;

/*Both methods which are the multiplicative decomposition method and the additive decomposition method seem appropriate.*/

/*Both methods which are the multiplicative decomposition method and the additive decomposition method seem appropriate.*/
/*7.5*/
data occupancyData;
input occupancy;
datalines;
501
488
504
578
545
632
728
725
585
542
480
530
518
489
528
599
572
659
739
758
602
587
497
558
555
523
532
623
598
683
774
780
609
604
531
592
578
543
565
648
615
697
785
830
645
643
551
606
585
553
576
665
656
720
826
838
652
661
584
644
623
553
599
657
680
759
878
881
705
684
577
656
645
593
617
686
679
773
906
934
713
710
600
676
645
602
601
709
706
817
930
983
745
735
620
698
665
626
649
740
729
824
937
994
781
759
643
728
691
649
656
735
748
837
995
1040
809
793
692
763
723
655
658
761
768
885
1067
1038
812
790
692
782
758
709
715
788
794
893
1046
1075
812
822
714
802
748
731
748
827
788
937
1076
1125
840
864
717
813
811
732
745
844
833
935
1110
1124
868
860
762
877
.
.
.
.
.
.
.
.
.
.
.
.
;

proc print data=occupancyData;
title "data=occupancyData";
run;

/* STEP 2 */

Data occupancyData_MovingAverage;
Set occupancyData;
Array occupancyLag {12} OccLag0-OccLag11;
occupancyLag{1} = occupancy;
do i = 2 to 12;
  occupancyLag{i} = Lag(occupancyLag{i-1});/*note Lag is a SAS function*/
end;
MovingAverage = 0;
do i = 1 to 12;
  MovingAverage = MovingAverage + occupancyLag{i};
end;
MovingAverage = MovingAverage/12;
CenteredMV = (MovingAverage + Lag(MovingAverage))/2;
Drop i; 
proc print data = occupancyData_MovingAverage;
title "EX 7.5 Hotel Occupancy data = occupancyData_MovingAverage";
run;

/* STEP 3 */

Data occupancyData_MovingAverage;
Set occupancyData_MovingAverage;
Keep CenteredMV;
If _N_ <=6 then delete;

Data occupancyData_SeasonalIndex;
Set occupancyData_MovingAverage; Set occupancyData;
If CenteredMV = "." then SeasonalIndexInitial = 0;
Else SeasonalIndexInitial = occupancy/CenteredMV;
proc print data = occupancyData_SeasonalIndex;
run;
title "EX 7.5 Hotel Occupancy data = occupancyData_SeasonalIndex";

/* STEP 4 */

Data occupancyData_SeasonalIndex;
set occupancyData_SeasonalIndex end=myEOF;
Array SeasonalIndex {12} SeasIndex1-SeasIndex12;
Retain SeasIndex1-SeasIndex12 0;
Time = _N_;
Do i = 1 to 12;
   If Mod(Time, 12)= i then SeasonalIndex{i} = SeasonalIndex{i} + SeasonalIndexInitial;   
end;
If Mod(Time, 12)= 0 then SeasIndex12 = SeasIndex12 + SeasonalIndexInitial;
/*  Get average on next set of lines */ 
If myEOF then do;
  sum_of_indices =0;
  Do i = 1 to 12;
     SeasonalIndex{i} = (SeasonalIndex{i}/13)*1.000368785; 
     sum_of_indices = sum_of_indices + SeasonalIndex{i}; 
  End;
End;
/**Only keep last line**/
If ~myEOF then delete;
Keep sum_of_indices SeasIndex1-SeasIndex12;
run;

proc print data = occupancyData_SeasonalIndex;
var sum_of_indices SeasIndex1-SeasIndex12;
title "EX 7.5 Hotel Occupancy Seasonal Indexes";
run;

/* STEP 5 */

Data DeseasonalizedData;
If _N_ =1 then Set occupancyData_SeasonalIndex;  Set occupancyData;
Array SeasonalIndex {12} SeasIndex1-SeasIndex12;
Time = _N_; 
Do i = 1 to 12;
   If Mod(Time, 12)= i then SeasonalEffect  = SeasonalIndex{i};  
end;
If Mod(Time, 12)= 0 then SeasonalEffect  = SeasonalIndex{12};  
Deseasonalizedoccupancy = occupancy/SeasonalEffect;
Keep  Time Deseasonalizedoccupancy occupancy SeasonalEffect;
proc print data = DeseasonalizedData;
run;
title "EX 7.5 Hotel Occupancy Deseasonalized Data";

/* STEP 6 */

Proc Reg data=DeseasonalizedData;
model Deseasonalizedoccupancy  = Time ;
output out=tempfile p=Trend;
title "EX 7.5 Hotel Occupancy Deseasonalizedoccupancy regressed on Time";
run;
proc print data = tempfile;
run;
title "EX 7.5 Hotel Occupancy Predicted Deseasonalizedoccupancy - Trend ";

/* STEP 7 */

Data Cyclical;
Set tempfile;
CyclicalInitial = Deseasonalizedoccupancy /Trend;

Data Cyclical;
Set Cyclical;
Array CyclicalLag {3} CyclicalLag1-CyclicalLag3;
CyclicalLag{1} = CyclicalInitial;
do i = 2 to 3;
  CyclicalLag{i} = Lag(CyclicalLag{i-1});/*note Lag is a SAS function*/
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
title "EX 7.5 Hotel Occupancy data = Cyclical";
run;

/* STEP 8 */

Data Decomposition;
Set tempfile; Set Cyclical;
Irreg = occupancy/(SeasonalEffect*Trend*CycMovingAverage);
yhat = SeasonalEffect * Trend;

proc print data = Decomposition;
Title "EX 7.5 Hotel Occupancy Decomposition";
 Run;


/* STEP 9 */
Proc Reg data=DeseasonalizedData;
	model Deseasonalizedoccupancy  = Time / cli clm;
	run;

proc forecast data = Decomposition lead=12 out=prediction;
var occupancy;
title 'EX 7.5 Hotel Occupancy forecast';
run;

proc print data=prediction;
run;
Quit;








