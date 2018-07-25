function [mean_d,median_d,max_d,min_d,std_d] = compute_distance(S_x,T_x,isSelf)
% compute_similary function
%  f = compute_similary(S_x,T_x)
%    S_x source data feature matrix
%    T_x target data feature matrix
%  Return:
%     [mean_d,median_d,max_d,min_d,min_d,std_d], mean, median, max, min,
%     standard devition of the pairwise distance between the source and target domain.
%%
%S_x = zscore(S_x);
%T_x = zscore(T_x);
% D = pdist2(X,Y) returns a matrix D containing the Euclidean distances 
% between each pair of observations in the mx-by-n data matrix X and my-by-n data matrix Y. 
% Rows of X and Y correspond to observations, columns correspond to variables. 
% D is an mx-by-my matrix, with the (i,j) entry equal to distance between observation i in X and observation j in Y. 
if isSelf == 1
    D = pdist(S_x,'Euclidean') 
else
    D = pdist2(S_x,T_x,'Euclidean') 
end
%%
mean_d = mean(D(:))
%%
median_d = median(D(:))
%%
max_d = max(D(:))
min_d = min(D(:))
%%
std_d = std(D(:))

end