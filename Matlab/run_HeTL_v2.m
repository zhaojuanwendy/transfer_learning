%load data

domains=cell(3,1);
%domains{1} = 'dos_vs_r2l';

domains{1}='dos_vs_probe';
domains{2}='dos_vs_r2l';
domains{3}='probe_vs_r2l';

root_path = 'data/';

%fraq_array=[0.1,0.2,0.3,0.4,0.5];
fraq=0.5;

for i=1:size(domains,1)
    domain = domains{i};
    sample_size = 1000;
%     if i ==1
%         sample_size = [500,1000,2000,3000];
%     else
%         sample_size = [500,1000,2000];
%     end
  for s = sample_size
    folder = ['samples','_',num2str(s),'_',num2str(fraq)]; %num2str(fraq)
    %folder = num2str(s)
    file_path = [root_path,domain,'/',folder];
    %file_path = [root_path,domain,'/',folder,'/clustered_source_original/'];
    [S_x,S_y,T_x,T_y] = loadData(file_path);
    result_path = [file_path,'/result_hetl2/'];
    mkdir_if_not_exist(result_path);
    addpath(result_path);
    steps = 1000;
    alpha = 0.001;
    r = 1;
    E = zeros(36);
    index = 1;

    % try set k from 1 to 6
    for k = 1:6
        b = 0;
        while b<=1
            S_x = zscore(S_x);
            T_x = zscore(T_x);

            [e,step,VS,VT]=HeTL_v2(S_x,S_y,T_x,T_y,b,k,r,alpha,steps);
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




