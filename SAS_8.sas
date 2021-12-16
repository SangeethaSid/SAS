/*Exercise 8.5-8.9*/
data WeeklyThermostatSales;
input time thermostatsales;
datalines;
1 206
2 245
3 185
4 169
5 162
6 177
7 207
8 216
9 193
10 230
11 212
12 192
13 162
14 189
15 244
16 209
17 207
18 211
19 210
20 173
21 194
22 234
23 156
24 206
25 188
26 162
27 172
28 210
29 205
30 244
31 218
32 182
33 206
34 211
35 273
36 248
37 262
38 258
39 233
40 255
41 303
42 282
43 291
44 280
45 255
46 312
47 296
48 307
49 281
50 308
51 280
52 345
53 .
54 .
55 .
56 .
57 .
;
run;
ods graphics on;
symbol value=NONE interpol=l width=1;
proc gplot data=WeeklyThermostatSales;
plot thermostatsales*time;
run;

proc reg  ;
model thermostatsales = time /p r clm cli clb dw;
run;


proc forecast data=WeeklyThermostatSales lead=12 trend=3  method=expo out=predict outfull outresid outest=est outfitstats ;
var thermostatsales;
run;

proc print data=predict;
run;

proc print data=est;
run;

/* Exercise 8.5 -8.9 with 26 values*/

data WeeklyThermostatSales;
input time thermostatsales;
datalines;

1 206
2 245
3 185
4 169
5 162
6 177
7 207
8 216
9 193
10 230
11 212
12 192
13 162
14 189
15 244
16 209
17 207
18 211
19 210
20 173
21 194
22 234
23 156
24 206
25 188
26 162


;

ods graphics on;
symbol value=NONE interpol=l width=1;
proc gplot data=WeeklyThermostatSales;
plot thermostatsales*time;
run;

proc reg alpha=0.2  ;
model thermostatsales = time /p r clm cli clb dw;
run;


/*lead-number of periods ahead forecast, method=exponential smoothing method
out full-provides OUTACTUAL, OUT1STEP, and OUTLIMIT output control options in addition to the forecast values.
outest-names an output data set to contain the parameter estimates and goodness-of-fit statistics. When the OUTEST= option is not specified, the parameters and goodness-of-fit statistics are not stored. See "OUTEST= Data Set" later in this chapter for details.
out resid=writes the residuals (when available) to the OUT= data set.
out fit stats-writes various R2-type forecast accuracy statistics to the OUTEST= data set.
trend=2 -selects the linear trend model
*/
proc forecast data=WeeklyThermostatSales alpha=0.24684189  lead=12 trend=3	   method=expo out=predict outfull outresid outest=est outfitstats ;
var thermostatsales;
run;

proc print data=predict;
run;

proc print data=est;
run;


/*8.15-8.19
Additive holts winters method
*/
data mountainbike;
input time Actualsales;
datalines;
1 10
2 31
3 43
4 16
5 11
6 33
7 45
8 17
9 14
10 36
11 50
12 21
13 19
14 41
15 55
16 25
;
run;


ods graphics on;
symbol value=NONE interpol=l width=1;
proc gplot data=mountainbike;
plot Actualsales*time;
run;

proc reg   ;
model Actualsales = time /p r clm cli clb dw;
run;

proc forecast data=mountainbike alpha=0.561 lead=12 trend=2 method=addwinters out=predict outfull outresid outest=est outfitstats ;
var Actualsales;
run;


/*8.21-8.24
Multiplicative holts winters method
*/

data coladata;
input time y;
datalines;
1 189
2 229
3 249
4 289
5 260
6 431
7 660
8 777
9 915
10 613
11 485
12 277
13 244
14 296
15 319
16 370
17 313
18 556
19 831
20 960
21 1152
22 759
23 607
24 371
25 298
26 378
27 373
28 443
29 374
30 660
31 1004
32 1153
33 1388
34 904
35 715
36 441

;
run;


ods graphics on;
symbol value=NONE interpol=l width=1;
proc gplot data=coladata;
plot y*time;
run;

proc reg   ;
model y = time /p r clm cli clb dw;
run;

proc forecast data=coladata alpha=0.2 lead=12 trend=2 method=WINTERS out=predict outfull outresid outest=est outfitstats ;
var y;
run;



/*18 observaion*/

data coladata;
input time y;
datalines;
1 189
2 229
3 249
4 289
5 260
6 431
7 660
8 777
9 915
10 613
11 485
12 277
13 244
14 296
15 319
16 370
17 313
18 556
;
run;


ods graphics on;
symbol value=NONE interpol=l width=1;
proc gplot data=coladata;
plot y*time;
run;

proc reg   ;
model y = time /p r clm cli clb dw;
run;

proc forecast data=coladata alpha=0.2 lead=12 trend=2 method=WINTERS out=predict outfull outresid outest=est outfitstats ;
var y;
run;





