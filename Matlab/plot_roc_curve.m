domains=cell(3,1);
domains{1}='dos_vs_probe';
domains{2}='dos_vs_r2l';
domains{3}='probe_vs_r2l';

labels = cell(5,1)
labels{1}='NoTL';
labels{2}='HeMap';
labels{3}='HeMap-CGD';
labels{4}='CeHTL';
colors = [0.45,0.67,0.29;0,0.45,0.73;0.65,0.11,0.2;0.94,0.49,0.168;0.51,0.2,0.56]
   
root_path = 'data_new/';
%fig_path = '../../Dropbox/Papers/Writing_paper_transfer_learning2016/Journal_version/updates_graph/'
fraq=0.5
s = 1000

% k_b_1 = [2,0.0;4,0.0;6,0.8;4,0.4] %dos_vs_probe
% k_b_2 = [5,0.6;3,0.2;5,0.6;5,0.0] %dos_vs_r2l
% k_b_3 = [4,1.0;4,0.8;2,0.2;5,0.0] %probe_vs_r2l

k_b_1 = [2,0.0;4,0.0;6,0.2] %dos_vs_probe, svm_norm_ac
k_b_2 = [5,0.6;3,0.2;5,0.6] %dos_vs_r2l,svm_norm_ac
k_b_3 = [4,1.0;5,0.4;6,0.4] %probe_vs_r2l,svm_norm_ac


for j=1:size(domains,1)
%read and classify baseline
    fig = figure;
    %set the data path
    domain_path = [root_path,domains{j},'/']
    folder = ['samples','_',num2str(s),'_',num2str(fraq)] %num2str(fraq)
    file_path = [domain_path,folder]; 
    [S_x,S_y,T_x,T_y] = loadData(file_path);
    SVMModel = fitcsvm(S_x,S_y,'KernelFunction','linear','Standardize',true,'ClassNames',{'0','1'});
    SVMModel = fitPosterior(SVMModel);
    [~,score] = predict(SVMModel,T_x);
    [X,Y,T,AUC]  = perfcurve(T_y,score(:,2),1) 
    display = [labels{1},' (AUC = ',num2str(AUC,'%100.2f\n'),')']
    line1 = plot(X,Y,'color',colors(1,:),'DisplayName',display,'LineWidth',1)     
    hold on

% k_b_1 = [6,0.4;4,0.0;6,0.4;4,0.2] %dos_vs_probe
% k_b_2 = [5,0.2;3,0.2;5,0.6;5,0.0] %dos_vs_r2l
% k_b_3 = [5,0.2;5,0.4;5,0.8;3,0.4] %probe_vs_r2l
%k_b_1 = [5,0.2;5,0.2;5,0.2;5,0.2] %dos_vs_probe
%k_b_2 = [5,0.4;5,0.4;5,0.4;5,0.4] %dos_vs_r2l
%k_b_3 = [5,0.4;5,0.4;5,0.4;5,0.4] %probe_vs_r2l
    for i = 1:3
        if i <= 2
            result_path = [domain_path,folder,'/result_hemap',num2str(i)];
        else
            result_path = [domain_path,folder,'/clustered_source_original/result_hemap',num2str(i-1)];
        end
        
        %% read transformed data  
        if j == 1
            k = k_b_1(i,1)
            b = k_b_1(i,2)
        elseif j == 2
            k = k_b_2(i,1)
            b = k_b_2(i,2)

        else
            k = k_b_3(i,1)
            b = k_b_3(i,2)
        end
        new_result_path = [result_path,'/norm.k',num2str(k),'.b',num2str(b,'%10.1f\n')];

        s_file = fullfile(new_result_path,'transformed_source.csv')
        t_file = fullfile(new_result_path,'transformed_target.csv')
        S = csvread(s_file) 
        T = csvread(t_file) 
        d_s = size(S)
        s_len = d_s(1,2) 
        d_t = size(T)
        t_len = d_t(1,2)

        S_x = S(:,1:s_len-1)
        S_y = S(:,s_len)

        T_x = T(:,1:t_len-1)
        T_y = T(:,t_len)

        %train an svm classifer
        SVMModel = fitcsvm(S_x,S_y,'KernelFunction','linear','Standardize',true,'ClassNames',{'0','1'});
        SVMModel = fitPosterior(SVMModel);
        [label,score] = predict(SVMModel,T_x);
        [X,Y,T,AUC] = perfcurve(T_y,score(:,2),1) 
        %plot(X,Y,'color',[1 1 0])
        display = [labels{i+1},' (AUC = ',num2str(AUC,'%100.2f\n'),')']
        plot(X,Y,'color',colors(i+1,:),'DisplayName',display,'LineWidth',2)   
        hold on
    end
    plot([0, 1], [0, 1], '--k','HandleVisibility','off')
    hold off
    lgd = legend('show','Location','southeast');
    set(lgd,'FontSize',14)
    xlabel('False Positive Rate','FontSize',14);
    ylabel('True Positive Rate','FontSize',14);
    set(gca,'FontSize',14);
    %title('ROC for classification by SVM');
    file = ['roc_',domains{j}]
    print(file,'-depsc')
    print(file,'-dpng')
end
