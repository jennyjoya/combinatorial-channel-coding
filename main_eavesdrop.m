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


massive_output_matrix = zeros(length(M_all),length(SNR_all));

run_times = 10000;

for M_idx = 1:length(M_all)
    for SNR_idx = 1:length(SNR_all)
        SNR = SNR_all(SNR_idx)
        M = M_all(M_idx)
        error_count = 0;
        for count = 1:run_times
            [errors1,errors1_e] =  run_cwc_eavesdrop(N,C,K,M,m,L,SNR,SNR_E);
            error_count = error_count + errors1;
            count
        end
        massive_output_matrix(M_idx,SNR_idx) = error_count/(run_times*(K-1));
    end
end

figure;
hold on;
for M_idx = 1:length(M_all)
    massive_output_matrix(M_idx,:)
    plot(SNR_all,massive_output_matrix(M_idx,:));
end
legend( num2str(M_all'))