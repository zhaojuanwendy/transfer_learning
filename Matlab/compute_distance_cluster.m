function [mean_d,median_d] = compute_distance_cluster(S_x,T_x,S_C,T_C)
% compute_similary function between cluster of the source and target domain
%  f = compute_similary(S_x,T_x)
%    S_x source data feature matrix
%    T_x target data feature matrix
%    S_C source data cluster label
%    T_C target data clusster label
%  Return:
S_x = normc(S_x);
T_x = normc(T_x);
S = [S_x,S_C] % source data ordered by labeled or cluster labeled
T = [T_x,T_C]
d_s = size(S)
s_len = d_s(1,2) 
d_t = size(T)
t_len = d_t(1,2)
% get the anomarly and normal cluster for source and target domain
SN = S(S(:,s_len)==0,1:s_len-1); % source normal
SA = S(S(:,s_len)==1,1:s_len-1); % source anomarly
TN = T(T(:,t_len)==0,1:t_len-1); % target normal
TA = T(T(:,t_len)==1,1:t_len-1); % target anomarly

% compute the centroid of each cluster
m_sn = mean(SN) % a row vector containing of mean of each column 
m_sa = mean(SA) 
m_tn = mean(TN)
m_ta = mean(TA)

SN_TN = pdist2(m_sn,m_tn,'Euclidean') %distance between the source normal and target normal cluster.
SN_TA = pdist2(m_sn,m_ta,'Euclidean') 
SA_TN = pdist2(m_sa,m_tn,'Euclidean')
SA_TA = pdist2(m_sa,m_ta,'Euclidean')

me_sn = median(SN) % a row vector containing of mean of each column 
me_sa = median(SA) 
me_tn = median(TN)
me_ta = median(TA)

me_SN_TN = pdist2(me_sn,me_tn,'Euclidean') %distance between the source normal and target normal cluster.
me_SN_TA = pdist2(me_sn,me_ta,'Euclidean') 
me_SA_TN = pdist2(me_sa,me_tn,'Euclidean')
me_SA_TA = pdist2(me_sa,me_ta,'Euclidean')
mean_d = [SN_TN,SN_TA;SA_TN,SA_TA]
median_d = [me_SN_TN,me_SN_TA;me_SA_TN,me_SA_TA]
end