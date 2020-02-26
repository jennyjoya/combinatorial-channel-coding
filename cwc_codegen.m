function [c] = cwc_codegen(q,M,m)


P = zeros(2,M);
bounds = zeros(2,M);
P(1,1) = (M-m)/M;   % probability the first symbol is 0
P(2,1) = m/M;       % probability the first sybbol is 1
Chat  = zeros(1,M);          % decoded source 
FX = [0;cumsum(P(:,1))];     % calculate CDF 

d = length(q);
expf = 2.^(-(1:d));
shif = 2^(-d);

qq = num2str(q);

L_bin = 0;
for i=1:length(q)
if q(i) == 0
incr = 0;
else incr = 1;
end
L_bin = L_bin + incr*2^-(i+1);
end
%L_bin = shif*bin2dec(encoded);
U_bin = L_bin + shif;


L=0;
U=1;


if L_bin >= FX(2)
    c(1)=1;
else
    c(1)=0;
end

Ln = L + ((U - L)*FX(c(1)+1));
Un = L + ((U - L)*FX(c(1)+2));
L = Ln;
U = Un;
W = U-L; 

for j=1:M-1
    
    if ~(sum(P(:,j+1))==1 || sum(P(:,j+1))==2)
    pw = sum(c(1:j));              % partial code weight
    P(2,j+1) = (m-pw)/(M-j);
    P(1,j+1) = 1-(m-pw)/(M-j);
    
    FX = [0;cumsum(P(:,j+1))];     % calculate CDF
    end
    
    if L_bin >= (L+FX(2)*W) && sum(c)<m
         c(j+1) = 1;
    else
        c(j+1) = 0;
    end
    
    c;

    if(~(sum(FX) == 1 || sum(FX) == 2 )) % hit the end so don't change values again
        Ln = L + ((U - L)*FX(c(j+1)+1));
        Un = L + ((U - L)*FX(c(j+1)+2));
    end
    
    L = Ln;
    U = Un;
    W = U-L;

end


end

