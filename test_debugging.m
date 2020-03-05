clear all

warning off all

addpath('./spgl1-1.7');

N = 32;          % number of code vectors per user
C = 4;           % number of active codes ie N choose C
K = 10;          % number of users
M = 250;         % number of tranmissions (length of codewords)
m = 25;           % constant weight of codewords

L = 24;          % channel length for each pair

SNR = 10;        % signal to noise ratio
SNR_E = 10;       % eavesdropper SNR

M_all = [150:50:400];
SNR_all = [0:4:20];
M_all = 400;
SNR_all = 10;
corr = [0.1:0.1:0.5];
run_times = 100;

alpha = 0.5;


verbosity=0;

PSK  = 4;               % modulation alphabeth for weights
PSKc = 2; 
W = 2*floor(M/L);       % weight of each constituent codeword 

Q  = qpsk;              % modulation symbols;
Qc = [-1, 1];           % symbols to construct code waveforms

sigmaN = 10^(-SNR/10);
sigmaNE = 10^(-SNR_E/10);

% message - pick any from (N choose C) for each K users
X0 = zeros(N,K);
for k = 1:K
    q  = randperm(N);
    ms = randi(PSK,1,C);
    X0(q(1:C),k) = Q(ms);  
end
xsignal = X0(:);

% construct codebooks

CB = zeros(M,N*K);      % codebook
CM = zeros(M,N*K);      % codebook mask
CBe = zeros(M,N*K);     % eavesdropper codebook
CMe = zeros(M,N*K);

%AA = CB;

for k=1:K               % for each legitimate user
    
    CBi = zeros(M,N);   %
    CMi = zeros(M,N);
    CBei = zeros(M,N);
    CMei = zeros(M,N);
    
    h   = (randn(L,1) + 1i*randn(L,1))/sqrt(2*L);     % channel between Alice and user k
    int = ([real(h); imag(h)])*sqrt(2*L);             % undo the power scaling, so that can use fixed quantisation intervals Q
    q = zeros(1,2*L);                                 % quantised channel vector 

    corv = alpha.^(0:L-1);
    C = toeplitz(corv,corv);
    Lch = chol(C);
    h_e = Lch*h;
    h_e = (randn(L,1) + 1i*randn(L,1))/sqrt(2*L);
    int_e = ([real(h_e); imag(h_e)])*sqrt(2*L);             % undo the power scaling, so that can use fixed quantisation intervals Q
    q_e = zeros(1,2*L);                                 % quantised channel vector 
    
        % quantise
        for j = 1:2*L
            q(j) = (int(j)>0);
            q_e(j) = (int_e(j)>0);
        end
        % find constant weight codeword
        qq = num2str(q);
        c = cwc_codegen(q,M,m);
        [~,perm] = sort(randn(1,M));   
        
        qq_e = num2str(q_e);
        c_e = cwc_codegen(q_e,M,m);
        [~,perm_e] = sort(randn(1,M));
        
        % create codebook by permuting c
        % create random permutation
        CMi(:,1) = c;
        CBi(:,1) = filter(h,1,c);
        CMei(:,1) = c_e;
        CBei(:,1) = filter(h_e,1,c_e);
        
        for j = 2:N                      % for each codeword
            perm = randperm(M,M);
            cc = c(perm);
            CMi(:,j) = cc;
            hc = filter(h,1,cc);
            CBi(:,j) = hc;
            % eavesdropper codebook
            perm_e = randperm(M,M);
            cc_e = c_e(perm);
            CMei(:,j) = cc_e;
            hc_e = filter(h_e,1,cc_e);
            CBei(:,j) = hc_e;
        end
    
   CB(:, N*(k-1)+1 : (N*k)) = CBi;
   CM(:, N*(k-1)+1 : (N*k)) = CMi;
   CBe(:,N*(k-1)+1 : (N*k)) = CBei;
   CMe(:,N*(k-1)+1 : (N*k)) = CMei;
end



% h_E = (randn(L,1) + 1i*randn(L,1))/sqrt(2*L);        % channel between Alice and Eve


% OBSERVATIONS
u = CB*xsignal;
noise = (randn(M,1) + 1i*randn(M,1))*sqrt(sigmaN/2);
u = u + noise;


%%%% for receiver 1 remove the erasures %%%%
mask = CreateMask(CM,X0,1,N);                          % receiver mask: 0-receive; 1-transmit 
% removes erasures
A   = CB(~mask,N+1:N*K);                               % matrix as seen by user 1     
y   = u(~mask);                                        % received signal as seen by user 1 

% A = CB(N+1:N*K);
% y = u;

L1X0  = C*(K-1); 
x_las = spg_lasso(A, y, L1X0, spgSetParms('verbosity',verbosity));

% pick C largest for each user
X_new = reshape(x_las,N,K-1);
errors = zeros(K-1,1);

for k = 1:K-1
    XX_n = zeros(N,1);
    [temp didx] = sort(abs(X_new(:,k)), 'descend'); 
    XX_n(didx(1:C)) = sign(X_new(didx(1:C),k));
    
    X_new(:,k) = XX_n;
    errors(k) = any( sign(real(X0(:,k+1))) ~= sign(real(XX_n))) ...
        ||  any( sign(imag(X0(:,k+1))) ~= sign(imag(XX_n)) ) ;
end

errors1 = sum(errors);


%% eavesdropper observations
% no puncturing

u_e = CB*xsignal;
noise_e = (randn(M,1) + 1i*randn(M,1))*sqrt(sigmaNE/2);
u_e = u_e + noise_e;
E = CBe;                               % matrix as seen by eve    
y_e = u_e;                   


x_las_e = spg_lasso(E, y_e, L1X0, spgSetParms('verbosity',verbosity));

% pick C largest for each user
X_new_e = reshape(x_las_e,N,K);
errors_e = zeros(K,1);

for k = 1:K
    XX_n_e = zeros(N,1);
    [temp didx] = sort(abs(X_new_e(:,k)), 'descend'); 
    XX_n_e(didx(1:C)) = sign(X_new_e(didx(1:C),k));
    
    X_new_e(:,k) = XX_n_e;
    errors_e(k) = any( sign(real(X0(:,k))) ~= sign(real(XX_n_e))) ...
        ||  any( sign(imag(X0(:,k))) ~= sign(imag(XX_n_e)) ) ;
end

errors1_e = sum(errors_e);