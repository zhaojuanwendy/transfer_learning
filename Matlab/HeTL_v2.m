function [e,step,VS,VT] = HeTL_v2(S_x,S_y,T_x,T_y,beta,k,r,alpha,steps)
% HeTL - HeTL v2 function \\
%
% d = HeTL_v2(S_x,S_y,T_x,T_y,b)
%
%    S_x source data feature matrix
%    S_y source data label vector
%    T_x target data feature matrix
%    T_y target data label vector
%    beta  beta
%    r, alpha
%    steps of iteration
%    k values of eig vector
% Returns:
%    [VS,VT] - projected source data and target data respectively
%
% Author   : Juan Zhao
%            Vanderbilt University
%            juan.zhao@vanderbilt.edu
% Last Rev : May 17 16:35:48 MET DST 2016
% Tested   : PC Matlab v5.2 and Solaris Matlab v5.3

% Copyright notice: You are free to modify, extend and distribute 
%    this code granted that the author of the original code is 
%    mentioned as the original author of the code.
%%
T = T_x;           %m*n_t
S = S_x;           %m*n_s
[m_t,n_t] = size(T); %rows of t:m; n_t columns of t
[m_s,n_s] = size(S); %rows of s:m; n_s columns of s

B_t = zeros(m_t,k);   %m*k
B_s = zeros(m_s,k);   %m*k, m is the instances of s
P_t = randn(k,n_t); %k*_n_t, n_t is the dimensions of t
P_s = randn(k,n_s); %k*_n_s, n_s is the dimensions of s

e = 1;
step = 1
cur_mse = 1000
prev_mse = inf
while(step < steps)
    %e1 = B_t*P_t-T
    PPT = P_t*P_t.'
    PPS = P_s*P_s.'
    B_t = B_t - 2*alpha*(B_t*PPT+(beta/2)*B_t*PPS+r*B_t-T*P_t.'-(beta/2)*S*P_s.');
    B_s = B_s - 2*alpha*(B_s*PPS+(beta/2)*B_s*PPT+r*B_s-S*P_s.'-(beta/2)*T*P_t.');
    P_t = P_t - alpha*(2*(B_t.'*B_t*P_t)+beta*(B_s.'*B_s*P_t)+2*r*P_t-2*B_t.'*T-beta*B_s.'*T)
    P_s = P_s - alpha*(2*(B_s.'*B_s*P_s)+beta*(B_t.'*B_t*P_s)+2*r*P_s-2*B_s.'*S-beta*B_t.'*S);
    cur_mse =  norm(B_t*P_t-T,'fro')+norm(B_s*P_s-S,'fro')+(norm(B_s*P_t-T,'fro')+norm(B_t*P_s-S,'fro'))*(beta/2)
    + r*norm(P_t,'fro')+r*norm(B_t,'fro')+r*norm(P_s,'fro')+r*norm(B_s,'fro');
    %B_t = B_t - 2*alpha*((B_t*P_t-T)*P_t.'+r*B_t)
    %P_t = P_t - 2*alpha*(B_t.'*(B_t*P_t-T)+r*P_t)
    %e = norm(B_t*P_t-T,'fro')+norm(P_t,'fro')+norm(B_t,'fro')
    if cur_mse/prev_mse >= 0.99999 
        break;
    end
    prev_mse = cur_mse;   
    step = step +1;
end
VS = [B_s S_y];
VT = [B_t T_y];
