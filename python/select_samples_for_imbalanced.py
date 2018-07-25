import numpy as np
import pandas as pd
import os

#randoms sampling and arrange in the same class order, normal+anormal

def ramdomSampling_imbalanced(df,attack_domain,attack_fraq,total_size):
    attack_size = int(total_size*attack_fraq)
    normal_size = total_size-attack_size
    print attack_domain+' size', attack_size
    print 'normal_size', normal_size
    df_attack = df[df['class']==1].sample(int(attack_size)).reset_index(drop=True)
    df_normal = df[df['class']==0].sample(normal_size).reset_index(drop=True)
    df_new =  pd.concat([df_attack,df_normal])
    #shuffle the normal and attack data
    df_new = df_new.iloc[np.random.permutation(len(df_new))].reset_index(drop=True)
    #label the data with numbers, where 1 stands for attack, 0 stands for normal
    return df_new

def save_to_matlab(df,out_folds_folder,source_or_target):    
    features_len = len(df.columns)-1
    X = df.iloc[:,0:features_len]
    y = df.iloc[:,features_len]
    X.to_csv(out_folds_folder+'/'+source_or_target+'.x.dat',index = False,header =False)
    y.to_csv(out_folds_folder+'/'+source_or_target+'.y.dat',index = False,header =False)

def ensure_dir(f):
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(d)   
if __name__ == '__main__':
    attack_fraq_array = [0.1,0.2,0.3,0.4,0.5]
    total_size = 1000
    attack_main_categories = ['dos','probe','r2l']
    out_put_root_folder = '../matlab/data_imblance/'
    for k in range(len(attack_main_categories)-1):
            source = attack_main_categories[k]  #current source main category 
            for m in range(k+1,len(attack_main_categories)):
                 target = attack_main_categories[m]  #current target main category
                 out_put_folder = out_put_root_folder+source+'_vs_'+target
                 ensure_dir(out_put_folder)
                 for attack_fraq in attack_fraq_array:
                     # read data from file_folder
                     file_folder = '../data/split-data/'+source+'_vs_'+target
                     
                     source_df =  pd.read_csv(file_folder+'/KDDTrain_'+source+'_rand_matrix.csv')
                     source_samples_df = ramdomSampling_imbalanced(source_df,source,attack_fraq,total_size)
                     target_df =  pd.read_csv(file_folder+'/KDDTest_'+target+'_rand_matrix.csv')
                     target_samples_df = ramdomSampling_imbalanced(target_df,target,attack_fraq,total_size)

                      #output_folder                   
                     out_put_result_folder = out_put_folder +'/samples_'+str(total_size)+'_'+str(attack_fraq)+'/'
                     ensure_dir(out_put_result_folder)
                     
                     save_to_matlab(source_samples_df,out_put_result_folder,'source')

                    
                     save_to_matlab(target_samples_df,out_put_result_folder,'target')
  
                 
     
