domains=cell(3,1);
%domains{1} = 'dos_vs_r2l';

domains{1}='dos_vs_probe';
domains{2}='dos_vs_r2l';
domains{3}='probe_vs_r2l';
root_path = 'data/';
fraq=0.5;
s = 1000; %sample_size
for i=1:size(domains,1)
    domain = domains{i};
    folder = ['samples','_',num2str(s),'_',num2str(fraq)]; %num2str(fraq)
    %folder = num2str(s)
    file_path = [root_path,domain,'/',folder];
    %file_path = root_path
    [S_x,S_y,T_x,T_y] = loadData(file_path);
    result_path = [file_path,'/result_hetl/'];
    mkdir_if_not_exist(result_path);
    addpath(result_path);
    
    steps = 1000;
    alpha = 0.01;
    r = 0;
    E = zeros(36);
    index = 1;
    for k = 1:6
        b = 0;
        while b<=1

            S_x = zscore(S_x);
            T_x = zscore(T_x);

            [e,step,VS,VT]=HeTL(S_x,S_y,T_x,T_y,b,k,r,alpha,steps);
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



