import numpy as np
import pandas as pd
import os
import math
from sklearn import preprocessing
from sklearn.preprocessing import normalize
from sklearn.cluster import MiniBatchKMeans, KMeans,SpectralClustering
from sklearn.metrics.pairwise import pairwise_distances_argmin

def mini_cluster(X):
    mbk = MiniBatchKMeans(init='k-means++', n_clusters=2,
                      n_init=10, max_no_improvement=10, verbose=0)
    y_pred = mbk.fit_predict(X)
    return y_pred

def run_clustering():
    domains = ['dos_vs_probe','dos_vs_r2l','probe_vs_r2l']
    for i in range(len(domains)):
        domain = domains[i]
        print domain
        #if i == 0:
         #   sample_size = [500,1000,2000,3000]
        #else:
         #   sample_size = [500,1000,2000]
        s = 1000;
        fraq_array=[0.1,0.2,0.3,0.4,0.5];
        for fraq in fraq_array:
            data_folder = '../matlab/data_imblance/'+domain+'/samples_'+str(s)+'_'+str(fraq) #the input data for classfication
            X_train = np.loadtxt(data_folder+'/source.x.dat', delimiter=',')
            y_train = np.loadtxt(data_folder+'/source.y.dat', delimiter=',',dtype=int)
            X_test = np.loadtxt(data_folder+'/target.x.dat', delimiter=',')
            y_test = np.loadtxt(data_folder+'/target.y.dat', delimiter=',',dtype=int)

            X_train_norm = preprocessing.normalize(X_train, norm='l2')
            X_test_norm = preprocessing.normalize(X_test, norm='l2')

             #train_y_pred = mini_cluster(X_train_norm)
             #print math.fabs(np.sum(y_train -train_y_pred))
             
             #cluster the target domain
            test_y_pred = mini_cluster(X_test_norm)
            print math.fabs(np.sum(y_test -test_y_pred))
            #np.savetxt(in_folds_folder+"/clustered.source.y.dat", train_y_pred.astype(int), fmt='%i', delimiter=",")
            np.savetxt(data_folder+"/clustered.target.y.dat", test_y_pred.astype(int), fmt='%i', delimiter=",")

                
                                                              
  
if __name__ == '__main__':
   #in_domains_classify()
    #cross_domains_classify()

   run_clustering()
  

    

