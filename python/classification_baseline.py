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
    print 'begin classfication....'
    a1 = decsion_tree(X_train,y_train,X_test,y_test)
    a2 = forest_tree(X_train,y_train,X_test,y_test)
    a3 = svm_one_class(X_train,y_train,X_test,y_test)
    a4 = svm_norm(X_train,y_train,X_test,y_test)
    a5 = gaussian_nb(X_train,y_train,X_test,y_test)
    a6 = knn_classify(X_train,y_train,X_test,y_test)
    a7 = knn_norm(X_train,y_train,X_test,y_test)
    print 'finish classfication...'
    
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


if __name__ == '__main__':
    domains = ['dos_vs_probe']
    for i in range(len(domains)):
        domain = domains[i]
        print domain
        s = 2000;
        fraq_array=[0.1,0.2,0.3,0.4,0.5];
        for fraq in fraq_array:
            result = []
            data_folder = '../matlab/data_imblance/'+domain+'/samples_'+str(s)+'_'+str(fraq)+'/' #the input data for classfication    
            models = ['decision_tree','forest_tree','svm_one_class','svm_norm','gaussian_nb','knn_classify','knn_norm']
            metrics = generate_columns(models)   
            columns =  ['k','b','isnormlized']+metrics
            #df = pd.DataFrame(columns=columns,index={0})
            X_train = np.loadtxt(data_folder+'/source.x.dat', delimiter=',')
            y_train = np.loadtxt(data_folder+'/source.y.dat', delimiter=',',dtype=int)
            X_test = np.loadtxt(data_folder+'/target.x.dat', delimiter=',')
            y_test = np.loadtxt(data_folder+'/target.y.dat', delimiter=',',dtype=int)
            model_metrics = classfiy(X_train,y_train,X_test,y_test) 
            evaluations = generate_evaluation(model_metrics)      
            result.append(['1','1', 'yes']+evaluations)
            
            print result
            df = pd.DataFrame(result,columns=columns)
            df.to_csv(data_folder+'/result_baseline_'+domain+str(s)+'_'+str(fraq)+'_.csv',index=False)

	

