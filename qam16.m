function [QAM]=qam16
% 16-QAM constelation points


QAM = zeros(1,16);

%% Grey mapping
QAM(3)= -3 +3i;  QAM(7)= -1 +3i;  QAM(15)= +1 +3i;  QAM(11)= +3 +3i;  
QAM(4)= -3 +1i;  QAM(8)= -1 +1i;  QAM(16)= +1 +1i;  QAM(12)= +3 +1i;  
QAM(2)= -3 -1i;  QAM(6)= -1 -1i;  QAM(14)= +1 -1i;  QAM(10)= +3 -1i;  
QAM(1)= -3 -3i;  QAM(5)= -1 -3i;  QAM(13)= +1 -3i;  QAM(9 )= +3 -3i;  



% QAM(1) = -3.0+3.0i;QAM(2) = -1.0+3.0i;QAM(3) =  1.0+3.0i;QAM(4) =  3.0+3.0i;
% QAM(5) =  3.0+1.0i;QAM(6) =  1.0+1.0i;QAM(7) = -1.0+1.0i;QAM(8) = -3.0+1.0i;
% QAM(9)= -3.0-1.0i;QAM(10)= -1.0-1.0i;QAM(11)=  1.0-1.0i;QAM(12)=  3.0-1.0i;
% QAM(13)=  3.0-3.0i;QAM(14)=  1.0-3.0i;QAM(15)= -1.0-3.0i;QAM(16)= -3.0-3.0i;

QAM = QAM/sqrt(10);          % so that E{XX*}=1 

% end of function