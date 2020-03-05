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
run_times = 10000;


error_count_e = 0;
error_count = 0;
corr = [0.05:0.05:0.95];
results_choleve = zeros(numel(corr),3);
for i = 1:numel(corr)
error_count_e = 0;
error_count = 0;

    parfor j = 1:run_times
    [errors1,errors1_e] = runpart_choleve(N,C,K,M,m,L,SNR,SNR_E,corr(i));
    error_count = error_count + errors1;
    error_count_e = error_count_e + errors1_e;
    j
    end
results_choleve(i,:) = [corr(i), error_count/(run_times*(K-1)), error_count_e/(run_times*K)]
end




% uncomment to vary M
% massive_output_matrix = zeros(length(M_all),length(SNR_all));
% 
% run_times = 10000;
% 
% for M_idx = 1:length(M_all)
%     for SNR_idx = 1:length(SNR_all)
%         SNR = SNR_all(SNR_idx)
%         M = M_all(M_idx)
%         error_count = 0;
%         for count = 1:run_times
%             [errors1,errors1_e] =  runpart_correlatedeve(N,C,K,M,m,L,SNR,SNR_E,corr);
%             error_count = error_count + errors1;
%             count
%         end
%         results_correlated(M_idx,SNR_idx) = error_count/(run_times*(K-1));
%     end
% end
% 
% figure;
% hold on;
% for M_idx = 1:length(M_all)
%     massive_output_matrix(M_idx,:)
%     plot(SNR_all,results_correlated(M_idx,:));
% end
% legend( num2str(M_all'))