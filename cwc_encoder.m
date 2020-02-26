function [ encoded ] = cwc_encoder( c )
% Takes a constant weight codeword, length n and weight m
% Uses arithmetic coding to produce a binary string

n=length(c);
m=sum(c);
% probability model
% ENCODER
tot_L=0;
tot_U=1;

P = zeros(2,n);

P(1,1) = (n-m)/n;   % probability the first symbol is 0
P(2,1) = m/n;       % probability the first sybbol is 1

% table with ("proportional") conditional forward probabilities 

L = 0;  % lower interval 
U = 1;  % upper interval

for I = 1:n
    
    pw = sum(c(1:I));              % partial code weight
    P(2,I+1) = (m-pw)/(n-I);
    P(1,I+1) = 1-(m-pw)/(n-I);
    
    FX = [0;cumsum(P(:,I))];     % calculate CDF 

    Ln = L + (U - L)*FX(c(I)+1);
    Un = L + (U - L)*FX(c(I)+2);
    U = Un;
    L = Ln;

    if(~(sum(FX) == 1 || sum(FX) == 2 )) %Hit the end so don't change values again
        tot_L = tot_L + ((tot_U - tot_L)*FX(c(I)+1));
        tot_U = tot_L + ((tot_U - tot_L)*FX(c(I)+2));
    else
        break;
    end

end

Bound_L=tot_U;
Bound_U=tot_L;


% finds the largest binary interval fitting in (L,U)
W = tot_U - tot_L;
power = floor(log2(W));
binarylength = -1*power;
int_size = 2^power;
N_intervals = 1/int_size;

L_bin = ceil(tot_L/int_size)*int_size;

% checks the binary interval fits in probability interval
    if L_bin + int_size <= tot_U
        U_bin = L_bin + int_size;
    else int_size = 0.5*int_size;  % else looks for smaller interval
        U_bin = L_bin + int_size;
        binarylength = binarylength + 1;
    end
    
    
bin_bound_U = U_bin;
bin_bound_L = L_bin;
encoded = dec2bin(L_bin/int_size,binarylength);

end

