%% script to create signal examples


clear all

PSK = 4;

N = 6;          % number of code vectors per user
C = 2;           % number of active codes ie N choose C
K = 1;          % number of users
M = 100;         % number of tranmissions (length of codewords)
m = 2;           % constant weight of codewords

L = 24;          % channel length for each pair

Q  = qpsk;              % modulation symbols;
Qc = [-1, 1];           % symbols to construct code waveforms



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
        [~,perm] = sort(randn(1,M));   
        
        % create codebook by permuting c
        % create random permutation
        CMi(:,1) = c;
        CBi(:,1) = filter(h,1,c);
        
        for j = 2:N                      % for each codeword
            perm = randperm(M,M);
            cc = c(perm);
            CMi(:,j) = cc;
            hc = filter(h,1,cc);
            CBi(:,j) = hc;
        end
    
   CB(:, N*(k-1)+1 : (N*k)) = CBi;
   CM(:, N*(k-1)+1 : (N*k)) = CMi;
end

signal1 = CM(:,1);

signal2 = CM(:,2);

signal3 = CM(:,3);

signal4 = CM(:,4);

signal5 = CM(:,5);

signal6 = CM(:,6);

transmit = signal1 + signal5;

filter1 = rand(1,10)-0.5;

transmit_conv = (conv(filter1,transmit));
transmit_conv(transmit_conv==NaN)= 0;
transmit_conv = transmit_conv(1:length(transmit));

%% FIRST FIGURE FOR CODEBOOK AT USER 1

fh = figure;

sfh1 = subplot(9,1,1);

sfh1.Position = sfh1.Position + [-0.125 0 0.175 0];

plot(CM(:,1),'color','magenta')

axis('off')

sfh2 = subplot(9,1,2);

sfh2.Position = sfh2.Position + [-0.125 0 0.175 0];

plot(CM(:,2),'color','[0, 0.4470, 0.7410]')

axis('off')

sfh3 = subplot(9,1,3);

sfh3.Position = sfh3.Position + [-0.125 0 0.175 0];

plot(signal3,'color','[0, 0.4470, 0.7410]')

axis('off')

sfh4 = subplot(9,1,4);

sfh4.Position = sfh4.Position + [-0.125 0 0.175 0];

plot(CM(:,4),'color','[0, 0.4470, 0.7410]')

axis('off')

sfh5 = subplot(9,1,5);

sfh5.Position = sfh5.Position + [-0.125 0 0.175 0];

plot(signal5,'color','magenta')

axis('off')

sfh6 = subplot(9,1,6);

sfh6.Position = sfh6.Position + [-0.125 0 0.175 0];

plot(signal6,'color','[0, 0.4470, 0.7410]')

axis('off')

sfh7 = subplot(9,1,7);

sfh7.Position = sfh7.Position + [-0.125 0 0.175 0];

axis('off')

sfh8 = subplot(9,1,8);

sfh8.Position = sfh8.Position + [-0.125 0 0.175 0];

plot(transmit,'color','[0.4940, 0.1840, 0.5560]')

axis('off')

sfh9 = subplot(9,1,9);

sfh9.Position = sfh9.Position + [-0.125 0 0.175 0];

plot(transmit_conv,'color','[0.4940, 0.1840, 0.5560]')

axis('off')

set(gcf, 'Color', 'White')


%% DEFINE RECEIVED

rsignal1 = (conv(filter1,signal1));
rsignal1(rsignal1==NaN)= 0;

rsignal2 = (conv(filter1,signal2));
rsignal2(rsignal2==NaN)= 0;

rsignal3 = (conv(filter1,signal3));
rsignal3(rsignal3==NaN)= 0;

rsignal4 = (conv(filter1,signal4));
rsignal4(rsignal4==NaN)= 0;

rsignal5 = (conv(filter1,signal5));
rsignal5(rsignal5==NaN)= 0;

rsignal6 = (conv(filter1,signal6));
rsignal6(rsignal6==NaN)= 0;


%% SECOND FIGURE FOR RECEIVED CODEBOOK

rfh = figure;

srfh1 = subplot(6,1,1);

srfh1.Position = srfh1.Position + [-0.125 0 0.175 0];

plot(rsignal1,'color','magenta')

axis('off')

srfh2 = subplot(6,1,2);

srfh2.Position = srfh2.Position + [-0.125 0 0.175 0];

plot(rsignal2,'color','[0, 0.4470, 0.7410]')

axis('off')

srfh3 = subplot(6,1,3);

srfh3.Position = srfh3.Position + [-0.125 0 0.175 0];

plot(rsignal3,'color','[0, 0.4470, 0.7410]')

axis('off')

srfh4 = subplot(6,1,4);

srfh4.Position = srfh4.Position + [-0.125 0 0.175 0];

plot(rsignal4,'color','[0, 0.4470, 0.7410]')

axis('off')

srfh5 = subplot(6,1,5);

srfh5.Position = srfh5.Position + [-0.125 0 0.175 0];

plot(rsignal5,'color','magenta')

axis('off')

srfh6 = subplot(6,1,6);

srfh6.Position = srfh6.Position + [-0.125 0 0.175 0];

plot(rsignal6,'color','[0, 0.4470, 0.7410]')

axis('off')


set(gcf, 'Color', 'White')