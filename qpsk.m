function [QAM]=qpsk
% 16-QAM constelation points


QAM = [-1-i, 1-i, -1+i, 1+i];

QAM = QAM/sqrt(2);          % so that E{XX*}=1 

% end of function