%% run cluster_enhanced_hemap with 3 different optimazation solution%
domains=cell(3,1);
domains{1}='dos_vs_probe';
domains{2}='dos_vs_r2l';
domains{3}='probe_vs_r2l';

root_path = 'data/';
fraq=0.5;
for i=1:size(domains,1)
    domain = domains{i}
    for s = [1000]
        folder = ['samples','_',num2str(s),'_',num2str(fraq)] %num2str(fraq)
        %folder = num2str(s)
        %file_path = [root_path,folder,'/clustered'];
        %file_path = [root_path,domain,'/',folder,'/clustered_source_original/'];
        file_path = [root_path,domain,'/',folder];
        [S_x,S_y,T_x,T_y] = loadData(file_path);
        for j=4:5 %3 different optimazation solutions, short for hemap1,hemap2,hemap3
            result_path = [file_path,'/result_hemap',num2str(j),'/'];
            mkdir_if_not_exist(result_path);
            addpath(result_path);
            steps = 1000;   %iteration steps
            alpha = 0.001;  %learning rate
            r = 0.1;
            E = zeros(36);
            index = 1;
            for k = 1:6
                b = 0
                while b<=1
                    %normalization S_x, T_x firstly
                    S_x = zscore(S_x);
                    T_x = zscore(T_x);
                    if j==1
                         theta = 1;
                         [e,VS,VT]=heMap(S_x,S_y,T_x,T_y,b,k,theta);                 
                    elseif j==2
                         [e,step,VS,VT]=heMap_2(S_x,S_y,T_x,T_y,b,k,r,alpha,steps);
                    elseif j==3
                         [e,step,VS,VT]=heMap_3(S_x,S_y,T_x,T_y,b,k,r,alpha,steps);
                    elseif j==4
                        [e,step,VS,VT]=heMap_3(S_x,S_y,T_x,T_y,b,k,1,alpha,steps);
                    elseif j==5
                        [e,step,VS,VT]=heMap_3(S_x,S_y,T_x,T_y,b,k,1,alpha,steps);
                    end
                    
                    E(1,index)=e;
                    index =index+1;
                    new_result_path = [result_path,'/norm.k',num2str(k),'.b',num2str(b,'%10.1f\n')];
                    mkdir_if_not_exist(new_result_path);
                    file_VS=fullfile(new_result_path,'transformed_source.csv');
                    file_VT=fullfile(new_result_path,'transformed_target.csv');
                    csvwrite(file_VS,VS);
                    csvwrite(file_VT,VT);
                    b = b+0.2;
                end
            end
        end
    end
end