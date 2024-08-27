 function [EVAL] = PerformanceMeasure(ACTUAL,PREDICTED)
idx = (ACTUAL()==1);
p = length(ACTUAL(idx));
n = length(ACTUAL(~idx));
N = p+n;
tp = sum(ACTUAL(idx)==PREDICTED(idx));
Truepositives =tp
tn = sum(ACTUAL(~idx)==PREDICTED(~idx));
Truenegative=tn
fp = n-tn;
Falsepositive=fp
fn = p-tp;
Falsenegative=fn
tp_rate = tp/p;
tn_rate = tn/n;
Accuracy = ((tp+tn)/N) 
% Accuracy = Accuracy+3.5
Sensitivity = tp_rate
% Sensitivity = Sensitivity + 3
Specificity = tn_rate
Precision = tp/(tp+fp)
Recall = Sensitivity
F_measure = 2*((Precision*Recall)/(Precision + Recall))
gmean = sqrt(tp_rate*tn_rate)
EVAL = [Accuracy Sensitivity Specificity Precision Recall F_measure gmean Truepositives Truenegative Falsepositive Falsenegative];
end