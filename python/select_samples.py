import numpy as np
import pandas as pd

#randoms sampling and arrange in the same class order, normal+anormal
def ramdomSampling(file_path,file_name,size,groupby_classOrder):
    df = pd.read_csv(file_path+file_name+".csv")
    df = df.sample(n=size)
    print 'normal' ,len(df[df['class']==0])
    print 'anormal' ,len(df[df['class']==1])
    if(groupby_classOrder == True):
        df = pd.concat([df[df['class']==0],df[df['class']==1]])
    df.to_csv(file_path+file_name+"_"+str(size)+'.csv',index = False);

def save_to_matlab(input_file_path,input_file_name_with_suffix,output_file_path,size):
    df = pd.read_csv(input_file_path+input_file_name_with_suffix)
    features_len = len(df.columns)-1
    if 'Train' in input_file_name_with_suffix or 'train' in input_file_name_with_suffix:
        print 'source'
        df.iloc[:,0:features_len].to_csv(file_path+'/source.x.dat',index = False,header =False)
        df.iloc[:,features_len].to_csv(file_path+'/source.y.dat',index = False,header =False)
    else:
        print 'target'
        df.iloc[:,0:features_len].to_csv(file_path+'/target.x.dat',index = False,header =False)
        df.iloc[:,features_len].to_csv(file_path+'/target.y.dat',index = False,header =False)
#select the features with class labels
def reduceFeatures(file_path,file_name,feature_index):
    df = pd.read_csv(file_path+file_name+".csv")
    orginal_features_len = len(df.columns)-1
    feature_index = subIndex(feature_index)
    feature_index = feature_index+[orginal_features_len]
    print feature_index
    df = df.iloc[:,feature_index]
    print list(df.columns.values)
    df.to_csv(file_path+file_name+'_reducedFeatures.csv',index = False);
def subIndex(array):
    for index in range(len(array)):
        array[index] = array[index] -1
    return array

domain = 'dos_vs_r2l'
file_path = '../data/split-data/'+domain+'/'
output_file_path = '../matlab/data/'+domain+'/'
file_names = ['KDDTrain_dos_rand_matrix','KDDTest_r2l_rand_matrix']
sizes=[1500] #size of data instances for each source and target domain
for file_name in file_names:
    for size in sizes:
        ramdomSampling(file_path,file_name,size,groupby_classOrder = False)
        save_to_matlab(file_path,file_name+".csv",output_file_path,size)
        
