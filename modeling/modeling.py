# -*- coding: utf-8 -*-
"""
Created on Mon Dec 19 20:20:53 2016
对文本进行处理，对数据集进行分离，用各种机器学习模型建模
数据集一共221天
44天测试集，27天上涨，17天下降。都猜上涨应该是60%左右。
注意！python都是含左不含右
@author: Richard
"""
import jieba
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.metrics import classification_report
from sklearn.tree import DecisionTreeRegressor,DecisionTreeClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.decomposition import PCA
from sklearn.svm import SVR
from sklearn.neighbors import KNeighborsRegressor
'''打开数据'''
jieba.load_userdict(r'final_corpus.txt')
f = open('data.txt')
data = f.readlines()
f.close()

price_list = []
news_list = []
date_list = []
for temp in data:
    newdata = temp.split('\t')
    price_list.append(float(newdata[1]))
    news_list.append(newdata[2])
    date_list.append(newdata[0])
#数据分割点  
split_num = int(round(len(news_list)*0.8))

print '分割点：',split_num
print '数据一共长：',len(date_list)

y_train = price_list[:split_num]
y_test = price_list[split_num:]
X = []
corpus = {}.fromkeys([ line.rstrip().decode('utf8') for line in open('final_corpus.txt') ])

#print corpus
'''处理文本'''
for i in news_list:
    l_one = jieba.cut(i)
    temp = []
    for t in l_one:       
        if t in corpus:
            temp.append(t)
    X.append(' '.join(temp))
X_train = X[:split_num]
X_test = X[split_num:] 
test_date_list = date_list[split_num:]         

'''计算特征'''
basicvectorizer = CountVectorizer(ngram_range=(1,1))
basictrain = basicvectorizer.fit_transform(X_train)
transformer = TfidfTransformer()
traintfidf = transformer.fit_transform(basictrain).toarray()#最后得到的训练集的特征

basictest = basicvectorizer.transform(X_test)
testtfidf = transformer.transform(basictest).toarray()#最后得到的测试集的特征

print '第一个新闻的tfidf特征：',testtfidf[0]

'''计算数据集的涨跌'''
di_real_train = []#train集涨跌的真实值，di代表direction
for i in y_train:
    if i >= 0:di_real_train.append(1)
    else:di_real_train.append(0)
    
di_real_test = []#test集涨跌的真实值
for i in y_test:
    if i >= 0:di_real_test.append(1)
    else:di_real_test.append(0)

'''降维'''
estimator = PCA(n_components=400)
pca_X_train = estimator.fit_transform(traintfidf)
pca_X_test = estimator.transform(testtfidf)

    
'''回归树解决问题
dtr = DecisionTreeRegressor()
dtr.fit(traintfidf,y_train)
y_pred = dtr.predict(testtfidf)
print '回归树的R方',dtr.score(testtfidf,y_test)
di_pred = []#预测回归二值化
for i in y_pred:
    if i >= 0:di_pred.append(1)
    else:di_pred.append(0)
print '回归树的报告：'
print classification_report(di_pred,di_real_test)
'''

'''KNN回归'''
uni_knr=KNeighborsRegressor(weights='uniform')
uni_knr.fit(traintfidf,y_train)
uni_knr_y_pred = uni_knr.predict(testtfidf)
print 'KNR的R方',uni_knr.score(testtfidf,y_test)
di_pred_knr = []#预测回归二值化
for i in uni_knr_y_pred:
    if i >= 0:di_pred_knr.append(1)
    else:di_pred_knr.append(0)
print 'KNR的报告：'
print classification_report(di_pred_knr,di_real_test)

'''输出预测文本，哪里需要，把这段代码粘哪'''
f = open('pred_result.txt','a')
testlen = len(date_list)-split_num
for i in range(0,testlen):
    f.write(test_date_list[i]+'\t'+str(uni_knr_y_pred[i])+'\n')
f.close()

'''SVR 看似不适合解决这个问题
rbf_svr = SVR(kernel = 'poly')
rbf_svr.fit(pca_X_train,y_train)
rbf_svr_y_perd = rbf_svr.predict(pca_X_test)
print 'SVR的R方',rbf_svr.score(pca_X_test,y_test)
di_pred_svr = []#预测回归二值化
for i in rbf_svr_y_perd:
    if i >= 0:di_pred_svr.append(1)
    else:di_pred_svr.append(0)
print 'SVR的报告：'
print classification_report(di_pred_svr,di_real_test)
print di_real_test
print di_pred_svr
print y_train
print rbf_svr_y_perd
'''

'''分类解决问题 
dtc = DecisionTreeClassifier()
dtc.fit(traintfidf,di_real_train)
y_pred_di = dtc.predict(testtfidf)
print '决策树R方：',dtc.score(testtfidf,di_real_test)
print '决策树的报告'
print classification_report(y_pred_di,di_real_test)
'''

'''集成模型 梯度提升决策树
gbc = GradientBoostingClassifier()
gbc.fit(traintfidf,di_real_train)
gbc_y_pred = gbc.predict(testtfidf)
#print '集成模型 梯度提升决策树R方：',gbc.score(testtfidf,di_real_test)
print '集成模型 梯度提升决策树的报告'
print classification_report(gbc_y_pred,di_real_test)
'''




'''降维后的回归树
dtr_pca = DecisionTreeRegressor()
dtr_pca.fit(pca_X_train,y_train)
y_pred_pca = dtr_pca.predict(pca_X_test)
print '回归树（降维）的R方',dtr_pca.score(pca_X_test,y_test)
di_pred_pca = []#预测回归二值化
for i in y_pred_pca:
    if i >= 0:di_pred_pca.append(1)
    else:di_pred_pca.append(0)
print '回归树(降维)的报告：'
print classification_report(di_pred_pca,di_real_test)
'''




'''随机的结果
ran_re = []
for i in range(0,43):
    ran_re.append(random.randint(0, 1))
print '随即猜的结果：'
print classification_report(ran_re,di_real_test)
'''

        