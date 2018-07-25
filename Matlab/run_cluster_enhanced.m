domains=cell(3,1);
domains{1}='dos_vs_probe';
domains{2}='dos_vs_r2l';
domains{3}='probe_vs_r2l';
root_path = 'data_learning_curve/';

fraq_array=[0.5];

for i=1:size(domains,1)
    domain = domains{i};
    if i ==1
        sample_size = [500,1000,2000,3000];
    else
        sample_size = [500,1000,2000];
    end
  for s = sample_size
        for fraq = fraq_array
            folder = ['samples','_',num2str(s),'_',num2str(fraq)] %Source domain labeled order, target domain unorder
            %folder = num2str(s)
            file_path = [root_path,domain,'/',folder];
            %file_path = root_path
            [S_x,S_y,T_x,T_y] = loadData(file_path);
            %S_C = load(fullfile(file_path,'clustered.source.y.dat')); 
            T_C = load(fullfile(file_path,'clustered.target.y.dat'))  %read the cluster label
            [S_new_x,S_new_y,T_new_x,T_new_y]=cluster_enhanced(S_x,S_y,T_x,T_y,T_C) %reorder the source and target data according the cluster labels,use the real labels for cluster labels for source domain

            out_file_path = [file_path,'/clustered_source_original/']
            mkdir_if_not_exist(out_file_path);
            addpath(out_file_path);
            csvwrite(fullfile(out_file_path,'source.x.dat'),S_new_x);
            csvwrite(fullfile(out_file_path,'source.y.dat'),S_new_y);
            csvwrite(fullfile(out_file_path,'target.x.dat'),T_new_x);
            csvwrite(fullfile(out_file_path,'target.y.dat'),T_new_y);
        end
  end
end
    
    