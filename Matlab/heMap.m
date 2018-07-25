function [e,VS,VT] = heMap(S_x,S_y,T_x,T_y,beta,k,theta)
% HeMap - HeMap function \\
% d = HeMap(S_x,S_y,T_x,T_y,b)
%
%    S_x source data feature matrix
%    S_y source data label vector
%    T_x target data feature matrix
%    T_y target data label vector
%    beta  beta
%    theta, theta+beta = 1, theta!=0
%    k  values of eig vector
% Returns:
%    [VS,VT] - projected source data and target data respectively
%
% Author   : Juan Zhao
%            Tennessee State University
%            jzhao1@tnstate.edu
% Last Rev : May 17 16:35:48 MET DST 2016
% Tested   : PC Matlab v5.2 and Solaris Matlab v5.3

% Copyright notice: You are free to modify, extend and distribute 
%    this code granted that the author of the original code is 
%    mentioned as the original author of the code.
%%
e = 0
SS=S_x*S_x.';
TT=T_x*T_x.';

A1=2*(theta^2)*TT+((beta^2)/2)*SS;
A2=beta*theta*(SS+TT);
A3=A2.';
A4=((beta^2)/2)*TT+2*(theta^2)*SS;
A=[[A1;A3] [A2;A4]];
%%
mySeed = 10;
rng(mySeed); 
opts.v0 = rand(length(A),1);
[V,D] = eigs(A,k,'lm',opts); %Largest magnitude. fix seed in order to keep generating the same results each time 

%%
n=length(V);
B_t = V(1:n/2,:);
B_s = V(n/2+1:n,:);
%%
P_t = (2*B_t.'*T_x+beta*B_s.'*T_x)/(2+beta)
P_s = (2*B_s.'*S_x+beta*B_t.'*S_x)/(2+beta)
e = norm(B_t*P_t-T_x,'fro')+norm(B_s*P_s-S_x,'fro')+(norm(B_s*P_t-T_x,'fro')+norm(B_t*P_s-S_x,'fro'))*(beta/2)
%%
VS = [B_s S_y];
VT = [B_t T_y];
