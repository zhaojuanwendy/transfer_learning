% This scriptis run the process of clustering the source and target domain and compute the similiary between
% the source and target cluster
% @date Aug. 9, 2017
% @author Juan

% curren domain
domain = 'dos_vs_r2l';
root_path = 'data/';
current_path = strcat(root_path,domain,'/','samples_1000_0.5');
% read data

[S_x,S_y,T_x,T_y] = loadData(current_path);
S_x_norm=normc(S_x);
T_x_norm=normc(T_x);
% cluter the target domain with kmeans++
T_C = kmeans(T_x_norm',2);
T_C = T_C - 1;
T_C = T_C';
% call PCA to make the S_x and T_x equal dimensions for columns ( features)

% [coeff_s,score_s,latent_s] = pca(zscore(S_x))
% [coeff_t,score_t,latent_t] = pca(zscore(T_x))
% S_reduced_x = score_s(:,1:8);
% T_reduced_x = score_t(:,1:8);
% run cluter_enhanced function to compute the similiary of source and 
% target domain and reorder the source and target domain
% use real label for source domain
[S_new_x,S_new_y,T_new_x,T_new_y]=cluster_enhanced(S_x_norm,S_y,T_x_norm,T_y,T_C);

out_file_path = [current_path,'/clustered_source_original/'];
mkdir_if_not_exist(out_file_path);
addpath(out_file_path);
csvwrite(fullfile(out_file_path,'source.x.dat'),S_new_x);
csvwrite(fullfile(out_file_path,'source.y.dat'),S_new_y);
csvwrite(fullfile(out_file_path,'target.x.dat'),T_new_x);
csvwrite(fullfile(out_file_path,'target.y.dat'),T_new_y);

