M = 100;
m = 5;
L = 24;


c = cwc(M,m);

cc = cwc_encoder(c);

chat = cwc_decoder(cc,M,m);

test = randi([0 1], 1, 24);

codeword = cwc_decoder(test,M,m);