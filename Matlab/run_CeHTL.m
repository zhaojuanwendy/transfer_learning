domains=cell(3,1);
%domains{1} = 'dos_vs_r2l';

domains{1}='dos_vs_probe';
domains{2}='dos_vs_r2l';
domains{3}='probe_vs_r2l';

root_path = 'data/';

%fraq_array=[0.1,0.2,0.3,0.4,0.5];
fraq_array=[0.5];

for i=1:size(domains,1)
    domain = domains{i};
    sample_size = 1000;
%     if i ==1
%         sample_size = [500,1000,2000,3000];
%     else
%         sample_size = [500,1000,2000];
%     end
  %for s = sample_size
    for fraq = fraq_array
        folder = ['samples','_',num2str(s),'_',num2str(fraq)] %num2str(fraq)
        %folder = num2str(s)
        file_path = [root_path,domain,'/',folder];
        [S_x,S_y,T_x,T_y] = loadData(file_path);
        
        
        % cluter the target domain with kmeans++    
        S_x_norm=normc(S_x);
        T_x_norm=normc(T_x);
      
        T_C = kmeans(T_x_norm',2);
        T_C = T_C - 1;
        T_C = T_C';

        [S_new_x,S_new_y,T_new_x,T_new_y]=cluster_enhanced(S_x_norm,S_y,T_x_norm,T_y,T_C);
        result_path = [file_path,'/result_cehtl/'];
        mkdir_if_not_exist(result_path);
        addpath(result_path);
        steps = 2000;
        alpha = 0.001;
        r = 0;
        E = zeros(36);
       
        for k = 1:6
            b = 0;
            while b<=1
                
                S_new_x = zscore(S_new_x);
                T_new_x = zscore(T_new_x);

                [e,step,VS,VT]=HeTL(S_new_x,S_y,T_new_x,T_y,b,k,r,alpha,steps);
       
                %E(1,index)=e;
                
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
%end




