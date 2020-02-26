function [ Chat ] = cwc_decoder( encoded,n,m )
% takes encoded binary string and outputs a constant weight codeword

M = zeros(length(encoded),1);

% take encoded msg from ASCII to string of 0s and 1s
for i=1:length(encoded)
    M(i) = encoded(i)-48;
end

%decoder starts with probability distn on symbol 1

P = zeros(2,n);
bounds = zeros(2,n);
P(1,1) = (n-m)/n;   % probability the first symbol is 0
P(2,1) = m/n;       % probability the first sybbol is 1
Chat  = zeros(1,n);          % decoded source 
FX = [0;cumsum(P(:,1))];     % calculate CDF 

d = length(M);
expf = 2.^(-(1:d));
shif = 2^(-d);

L_bin = shif*bin2dec(encoded);
U_bin = shif*(bin2dec(encoded)+1);


L=0;
U=1;


if L_bin >= FX(2)
    Chat(1)=1;
else
    Chat(1)=0;
end

Ln = L + ((U - L)*FX(Chat(1)+1));
Un = L + ((U - L)*FX(Chat(1)+2));
L = Ln;
U = Un;
W = U-L; 

for j=1:n-1
    
    if ~(sum(P(:,j+1))==1 || sum(P(:,j+1))==2)
    pw = sum(Chat(1:j));              % partial code weight
    P(2,j+1) = (m-pw)/(n-j);
    P(1,j+1) = 1-(m-pw)/(n-j);
    
    FX = [0;cumsum(P(:,j+1))];     % calculate CDF
    end
    
    if L_bin >= (L+FX(2)*W) && sum(Chat)<m
         Chat(j+1) = 1;
    else
        Chat(j+1) = 0;
    end
    
    Chat;

    if(~(sum(FX) == 1 || sum(FX) == 2 )) % hit the end so don't change values again
        Ln = L + ((U - L)*FX(Chat(j+1)+1));
        Un = L + ((U - L)*FX(Chat(j+1)+2));
    end
    
    L = Ln;
    U = Un;
    W = U-L;

end
end

