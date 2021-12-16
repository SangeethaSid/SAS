/*Ex 10.1-10.6*/
data tooth;
input y;
time=_n_;
datalines;
235
239
244.09
252.731
264.377
277.934
286.687
295.629
310.444
325.112
336.291
344.459
355.399
367.691
384.003
398.042
412.969
422.901
434.96
445.853
455.929
465.584
477.894
491.408
507.712
517.237
524.349
532.104
538.097
544.948
551.925
557.929
564.285
572.164
582.926
595.295
607.028
617.541
622.941
633.436
647.371
658.23
670.777
685.457
690.992
693.557
700.675
712.71
726.513
736.429
743.203
751.227
764.265
777.852
791.07
805.844
815.122
822.905
830.663
839.6
846.962
853.83
860.84
871.075
877.792
881.143
884.226
890.208
894.966
901.288
913.138
922.511
930.786
941.306
950.305
952.373
960.042
968.1
972.477
977.408
977.602
979.505
982.934
985.833
991.35
996.291
1003.1
1010.32
1018.42
1029.48
;
run;

/*10.1,10.2,10.3,10.4,10.5,10.6*/

proc arima data=work.tooth;
identify var=y(1);
estimate p=(1) printall plot;
forecast lead=10;
run;
title1 'EX 10.11 Shimmer Shampoo Sales';
data ex11;
input y @@;
time = _n_;
z = dif1(y);
datalines;
339
319	
352	
330	
378	
392
390	
395	
386	
383	
396	
396
412	
387	
382	
423	
386	
420
417	
474	
450	
444	
456	
449
428	
444	
389	
447	
395	
417
run;

title2 'EX 10.11 Model 1';
proc arima data = ex11;
	identify var = y;
	estimate p = (1,2) printall plot;
run;
	
title2 'EX 10.11 Model 2';
proc arima data = ex11;
	identify var = y(1);
	estimate p = (1) noconstant printall plot;
run;
proc print data=ex11;
run;

title 'EX 10.13 Weekly Thermostat Sales';
data ex1013;
input y @@;
time = _n_;
z = dif1(y);
datalines;
206
245
185
169
162
177
207
216
193
230
212
192
162
189
244
209
207
211
210
173
194
234
156
206
188
162
172
210
205
244
218
182	
206
211
273
248
262
258
233
255
303
282
291
280
255
312
296
307
281
308
280
345	
run;
proc arima data = ex1013;
	identify var = y;
	identify var=y(1);
	identify var =y(1,1);
	title2 'EX 10.13 a Original values';
run;

proc arima data = ex1013;
	identify var = y(1);
	estimate q = (1) noconstant printall plot;
	forecast lead = 4;
	title 'EX 10.13 a Model 1';
run;

proc arima data = ex1013;
	identify var = y(1);
	estimate q = (1,2) noconstant printall plot;
	forecast lead = 4;
	title 'EX 10.13 a Model 2';
run;
proc print data=ex1013;
run;
