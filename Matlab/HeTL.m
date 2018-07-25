function [e,step,VS,VT] = HeTL(S_x,S_y,T_x,T_y,beta,k,r,alpha,steps)
% HeTL - HeTL function \\
%
% d = HeTL(S_x,S_y,T_x,T_y,b)
%
%    S_x, source data feature matrix
%    S_y, source data label vector
%    T_x, target data feature matrix
%    T_y, target data label vector
%    beta,  beta
%    r, alpha
%    steps, max steps of iteration
%    k  values of eig vector
%    n number of instances
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

B_t = rand(m_t,k);   %m*k
B_s = rand(m_s,k);   %m*k, m is the instances of s
P_t = rand(k,n_t); %k*_n_t, n_t is the dimensions of t
P_s = rand(k,n_s); %k*_n_s, n_s is the dimensions of s

e = 1;
step = 1;
while(step < steps)
    e = 0;
    %e1 = B_t*P_t-T
    PPT = P_t*P_t.';
    PPS = P_s*P_s.';
    B_t = B_t - 2*alpha*(B_t*PPT-T*P_t.'+beta*(B_t-B_s));
    B_s = B_s - 2*alpha*(B_s*PPS-S*P_s.'+beta*(B_s-B_t));
    %P_t=ridge(T,B_t,5e-3)
    %P_s=ridge(T,B_s,5e-3)
    P_t=(B_t.'*B_t)^(-1)*B_t.'*T;
    P_s=(B_s.'*B_s)^(-1)*B_s.'*S;
    e =  norm(B_t*P_t-T,'fro')+norm(B_s*P_s-S,'fro')+(norm((B_t-B_s),'fro'))*(beta);
    %+ r*norm(P_t,'fro')+r*norm(B_t,'fro')+r*norm(P_s,'fro')+r*norm(B_s,'fro');
    if e<=0.1 
        break;
    end
    step = step +1;
end
VS = [B_s S_y];
VT = [B_t T_y];

