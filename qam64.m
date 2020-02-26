function [QAM]=qam64
% constelation points of 256-QAM modulation 

x = 1:2:8;

Q = zeros(4);

for I  = 1:4;
   Q(I,:) = x + j*x(5-I);
end
QAM = [Q-8, Q; Q-8-j*8, Q-j*8];

% prepare for standard mapping
QAM(:,2:2:8) = QAM(8:-1:1,2:2:8);
QAM = QAM(:);


QAM = QAM/sqrt(42);                  % so that E{XX*}=1 


%plot(QAM,'-*')
