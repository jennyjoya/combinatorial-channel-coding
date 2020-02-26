clear all
close all

warning off all

addpath('.\spgl1-1.7');

N = 8;          % number of code vectors per user
C = 4;           % number of active codes ie N choose C
K = 10;          % number of users
M = 100;         % number of tranmissions (length of codewords)
m = 5;           % constant weight of codewords

L = 24;          % channel length for each pair


SNR = 10;        % signal to noise ratio
SNR_E = 5;       % eavesdropper SNR
sigmaN = 10^(-SNR/10);
sigmaNE = 10^(-SNR_E/10);
% noise_h = (randn(L,1) + 1i*randn(L,1))*sqrt(sigma_N/2);
% noise_hE = (randn(L,1) + 1i*randn(L,1))*sqrt(sigma_NE/2);


% message - pick any from (N choose C) for each K users
X0 = zeros(N,K);
for k=1:K
    q = randperm(N);
    X0(q(1:C),k) = 1;    
end

xsignal = X0(:);

% construct codebooks

CB = zeros(M,N*K);      % codebook
CM = zeros(M,N*K);      % codebook mask


for k=1:K               % for each legitimate user
    
    CBi = zeros(M,N);   %
    CMi = zeros(M,N);
    
    h   = (randn(L,1) + 1i*randn(L,1))/sqrt(2*L);     % channel between Alice and user k
    int = ([real(h); imag(h)])*sqrt(2*L);             % undo the power scaling, so that can use fixed quantisation intervals Q
    q = zeros(1,2*L);                                 % quantised channel vector 

    % quantise
        for j = 1:2*L
            q(j) = (int(j)>0);
        end
        
    % find constant weight codeword
    qq = num2str(q);
    c = cwc_codegen(q,M,m);

    % create codebook by permuting c
    [~,perm] = sort(randn(1,M));                     % create random permutation
    CMi(:,1) = c;
    CBi(:,1) = filter(h,1,c);
    
        for j=2:N                                    % for each codeword
            perm = randperm(M,M);
            cc = c(perm);
            CMi(:,j) = cc;
            hc = filter(h,1,cc);
            CBi(:,j) = hc;
        end
    
   CB(:, N*(k-1)+1 : (N*k)) = CBi;
   CM(:, N*(k-1)+1 : (N*k)) = CMi;
end
