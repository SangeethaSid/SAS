  title 'Exercise 3.11';
  
  proc reg data=work.Freshdetergent;
  Model demand=pricedif / clm cli clb
  run;
  
  
  title 'Exercise 3.18';
  
  proc reg data=work.Freshdetergent alpha=0.01;
  Model demand=pricedif / clm cli clb;
  run;
   proc reg data=work.Freshdetergent alpha=0.001;
  Model demand=pricedif / clm cli clb;
  run;
  proc reg data=work.Freshdetergent alpha=0.10;
  Model demand=pricedif / clm cli clb;
  run;
  proc reg data=work.Freshdetergent alpha=0.01;
  Model demand=pricedif / clm cli clb;
  run;
 
 
 
 proc anova data=work.Freshdetergent ;
 class pricedif;
  Model demand=pricedif;
  run;
  
  title "Exercise 3.22";
 proc reg data=work.Freshdetergent;
  Model demand=pricedif / clm cli clb;
  output out=predictedvalues predicted=	predicteddemand;
  run;
  proc glm data=work.freshdetergent;
  Model demand =pricedif;
  run;
  
  proc reg data=work.Freshdetergent alpha=0.01;
  Model demand=pricedif / clm cli clb;
  run;
 
 
 title "Exercise 3.35";
 proc reg data=work.taxation;
 Model Time=experience /clm cli clb;
 
 
  
 
  
  