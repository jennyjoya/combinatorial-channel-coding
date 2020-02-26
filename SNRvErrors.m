% cwc 
% encoder and decoder for constant weight codes based on arithmetic coding
% takes constant weight code to binary representation and then decodes
% loopable over SNR, channel length, transmission length etc

clear all
close all

warning off all

addpath('.\spgl1-1.7');

N = 64;          % number of code vectors per user
C = 12;           % number of active codes ie N choose C
K = 5;          % number of users
M = 250;         % number of tranmissions (length of codewords)
m = 20;           % constant weight of codewords

L = 24;          % channel length for each pair


% loop over SNR
e = zeros(20,100);

for i=0:1:20
    SNR = i;
    errors = 0;
    for j=1:100
        errors = errors + mainchannel(N,C,K,M,m,L,SNR);
        
    end
    
end