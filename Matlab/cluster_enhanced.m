function[S_new_x,S_new_y,T_new_x,T_new_y] = cluster_enhanced(S_x,S_C,T_x,T_y,T_C)
%%S_y, real labels for S_y
%%S_C, cluster labels for S_x
%%T_C, cluster labels for T_x
%file_path = root_path        
%cluster
%S_x_norm = zscore(S_x);
%T_x_norm = zscore(T_x);
%[idxT,C] = kmeans(T_x_norm,2,'Distance', 'cosine'); 
%T = [T_x,T_y,idxT];
%sort by cluster label
%T_new = sortrows(T,-43); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sort the source data according to the true class label
%sort the source date by labels (42), cluster labels(43)
S = [S_x,S_C];
[m,ns] = size(S)
S_new = sortrows(S,ns);             
S_new_x = S_new(:,1:ns-1)
S_new_y = S_new(:,ns)
%compute the similarity distance between the source and target
%cluster

%sort the target data according to the cluster label
T = [T_x,T_y,T_C];
[m,nt] = size(T)
[mean_d,median_d] = compute_distance_cluster(S_x,T_x,S_C,T_C)
SN_TN = mean_d(1,1)
SN_TA = mean_d(1,2)

if SN_TN < SN_TA             % source normal is more similar with target normal cluster
T_new = sortrows(T,nt);
else
T_new = sortrows(T,-nt);      
end
T_new_x = T_new(:,1:nt-2)
T_new_y = T_new(:,nt-1)