function [mask] = CreateMask(C,X,i,N)
%creates the erasure mask for user i
%   Given a users codebook and the signal, creates a mask
%   which is 0 when user i receives, 1 when they transmit

CM = C(:,(i-1)*N+1:N*i);
Xsig = X(:,i);

WU1 = abs(CM*X);
WU1 = abs( CM(:,1:N)* X(:,1));                        % to create mask sent by user 1

mask = logical(WU1);

end

