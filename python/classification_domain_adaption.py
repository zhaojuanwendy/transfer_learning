import numpy as np
import pandas as pd
import os
from sklearn import preprocessing
from sklearn import tree
from sklearn import ensemble
from sklearn import svm
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score
from sklearn.multiclass import OneVsRestClassifier
from sklearn.metrics import roc_auc_score
#descision tree

def evaluate(y_test,y_pred,y_scores):
    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred, average='binary')
    recall = recall_score(y_test, y_pred, average='binary',pos_label=1)
    f1 = f1_score(y_test, y_pred, average='binary')
    auc = roc_auc_score(y_test, y_scores)
    return [accuracy,precision,recall,f1,auc]

def decsion_tree(X_train,y_train,X_test,y_test):
    clf = tree.DecisionTreeClassifier(max_depth=5)
    clf = clf.fit(X_train,y_train)
    y_pred = clf.predict(X_test)
    y_scores = clf.predict_proba(X_test)[:,1]
    return evaluate(y_test,y_pred,y_scores)

#randomforest

def forest_tree(X_train,y_train,X_test,y_test):
    clf = ensemble.RandomForestClassifier(n_estimators=100)
    clf = clf.fit(X_train,y_train)
    y_pred = clf.predict(X_test)
    y_scores = clf.predict_proba(X_test)[:,1]
    return evaluate(y_test,y_pred,y_scores)


def svm_one_class(X_train,y_train,X_test,y_test):
    _train = preprocessing.normalize(X_train, norm='l2')
    _test = preprocessing.normalize(X_test, norm='l2')
    lin_clf = svm.LinearSVC()
    lin_clf.fit(_train, y_train) 
    LinearSVC(C=1.0, class_weight=None, fit_intercept=True,
     intercept_scaling=1, loss='squared_hinge', max_iter=1000,
     multi_class='ovr', penalty='l2', random_state=None, tol=0.0001,
     verbose=0)
    y_pred = lin_clf.predict(_test)
    y_scores = lin_clf.decision_function(_test)
    return evaluate(y_test,y_pred,y_scores)                     


def svm_norm(X_train,y_train,X_test,y_test):
    _train = preprocessing.normalize(X_train, norm='l2')
    _test = preprocessing.normalize(X_test, norm='l2')
    clf = svm.SVC(kernel='linear', C=1,probability=True).fit(_train, y_train)
    y_pred = clf.predict(_test)
    y_scores = clf.decision_function(_test)
    return evaluate(y_test,y_pred,y_scores)                           

def gaussian_nb(X_train,y_train,X_test,y_test):
    gnb = GaussianNB()
    y_pred = gnb.fit(X_train, y_train).predict(X_test)
    y_scores  = gnb.fit(X_train, y_train).predict_proba(X_test)[:,1]
    accuracy = float(X_test.shape[0]-(y_test != y_pred).sum())/float(X_test.shape[0])
    precision = precision_score(y_test, y_pred, average='binary')
    recall = recall_score(y_test, y_pred, average='binary',pos_label=1)
    f1 = f1_score(y_test, y_pred, average='binary')
    auc = roc_auc_score(y_test, y_scores) 
    return [accuracy,precision,recall,f1,auc]


def knn_classify(X_train,y_train,X_test,y_test):
    clf = KNeighborsClassifier(n_neighbors=10)
    clf = clf.fit(X_train,y_train)
    y_pred = clf.predict(X_test)
    y_scores = clf.predict_proba(X_test)[:,1]
    return evaluate(y_test,y_pred,y_scores)

def knn_norm(X_train,y_train,X_test,y_test):
    clf = KNeighborsClassifier(n_neighbors=10)
    _train = preprocessing.normalize(X_train, norm='l2')
    _test = preprocessing.normalize(X_test, norm='l2')
    y_pred = clf.fit(_train,y_train).predict(_test)
    y_scores = clf.predict_proba(_test)[:,1]
    return evaluate(y_test,y_pred,y_scores)


def classfiy(X_train,y_train,X_test,y_test):
    print('begin classfication....')
    a1 = decsion_tree(X_train,y_train,X_test,y_test)
    a2 = forest_tree(X_train,y_train,X_test,y_test)
    a3 = svm_one_class(X_train,y_train,X_test,y_test)
    a4 = svm_norm(X_train,y_train,X_test,y_test)
    a5 = gaussian_nb(X_train,y_train,X_test,y_test)
    a6 = knn_classify(X_train,y_train,X_test,y_test)
    a7 = knn_norm(X_train,y_train,X_test,y_test)
    print('finish classfication...')
    
    return [a1,a2,a3,a4,a5,a6,a7]

def generate_columns(models):
    columns = []
    for model in models:
        columns.append(model+'_ac')
        columns.append(model+'_p')
        columns.append(model+'_recall')
        columns.append(model+'_f1')
        columns.append(model+'_auc')
    return columns

def generate_evaluation(model_metrics) :
    evaluations = []
    for model_metric in model_metrics:
        evaluations.append(model_metric[0]) #accuracy
        evaluations.append(model_metric[1]) #precision
        evaluations.append(model_metric[2]) #recall
        evaluations.append(model_metric[3]) #f1
        evaluations.append(model_metric[4]) #auc
    return evaluations

def feq(a,b):
    if abs(a-b)<0.00000001:
        return 1
    else:
        return 0
    
if __name__ == '__main__':
    import os
    domains = ['dos_vs_probe','dos_vs_r2l','probe_vs_r2l']
    domain = 'dos_vs_r2l' #probe_vs_r2l
    size = 1000
    fraq = 0.5
    for domain in domains:    
        
        data_folder = '../matlab/data/'+domain+'/samples_'+str(size)+'_'+str(fraq)+'/result_hetl/'
        print(data_folder)
        models = ['decision_tree','forest_tree','svm_one_class','svm_norm','gaussian_nb','knn_classify','knn_norm']
        metrics = generate_columns(models)   
        columns =  ['k','b','isnormlized']+metrics
        #df = pd.DataFrame(columns=columns,index={0})
        metrics_values=[]
                    
##        
        for k in range(1,7):
            #b=0;
            b=0.0
            while b<=1.1:
                folder_name = 'norm.k'+str(k)+'.b'+str(b)+'/'
                print(os.path.join(data_folder, folder_name))
                if os.path.isdir(os.path.join(data_folder, folder_name)):
                    train = pd.read_csv(os.path.join(data_folder, folder_name)+"/transformed_source.csv",header = None)
                    test = pd.read_csv(os.path.join(data_folder, folder_name)+"/transformed_target.csv",header = None) 
                    features_len = len(train.columns)-1
                    X_train = train.iloc[:,0:features_len].as_matrix()
                    y_train = train.iloc[:,features_len]
                    X_test = test.iloc[:,0:features_len].as_matrix()
                    y_test = test.iloc[:,features_len]           
                    index_label = 'k='+str(k)+',b='+str(b)
                    model_metrics = classfiy(X_train,y_train,X_test,y_test)
                    evaluations = generate_evaluation(model_metrics)
                    result = [str(k),str(b), 'yes']+evaluations
                    #df1 = pd.DataFrame([result], columns=columns)
                    #print df1
                    #df=df.append(df1)
                    metrics_values.append(result)
                b = b+0.2;
                b = round(b,1)
        
        df = pd.DataFrame(metrics_values,columns=columns)
            
        #get the max value of each metric	
        maxValue = df[columns].max()
        for i in range(0,3):
            maxValue[columns[i]] = 'max_v'
        #get the k,d,is_normlized for the max value for each metric   
        max_rows = []
        max_row = df[metrics[1]].idxmax()
        print('metrics', metrics[0])
        print('max_row', max_row)
        for metric in metrics:
            max_row = df[metric].idxmax()
            print(max_row)
            #k_d_value = str(df.loc[df[metric].idxmax()][columns[0]])
            k_d_value = 'k='+str(df.loc[max_row][columns[0]])+',b='+str(df.loc[max_row][columns[1]])+','+str(df.loc[max_row][columns[2]])
            max_rows.append(k_d_value)
        result = ['best k','best d','']+max_rows
        df = df.append(maxValue,ignore_index=True)
        df = df.append(pd.DataFrame([result], columns=columns))
        print(df)
        df.to_csv(data_folder+'/result_all_'+domain+str(size)+'_'+str(fraq)+'_svm_linear.csv',index=False)


	

