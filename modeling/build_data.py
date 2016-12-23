# -*- coding: utf-8 -*-
"""
Created on Mon Dec 19 16:52:42 2016
得到训练集和数据集
@author: Richard
"""

import pandas as pd
import numpy as np

f = open('test_news.txt')
news = f.readlines()
news.reverse()
news_split = []
for i in range(0,len(news)):
    news_split.append(news[i].split('\t'))#有六个条目，日期，阅读数，点赞数，题目，新闻，回复
all_date = []
for i in news_split:
    all_date.append(i[0])
news_date = set(all_date)


'''得到股价的日期'''
stocks = pd.read_csv(r'test_price.csv',index_col='date')
stocks = stocks.sort_index(ascending=True)
stocks = pd.DataFrame({"price": stocks.ix[:,'close']})
#计算
stocks_return = (stocks.shift(-1)['price']-stocks['price'])/stocks['price']
stocks_return = pd.DataFrame({"return": stocks_return})

stocks_not_null = stocks_return[stocks_return["return"].notnull()]#去除回报为空的行
print stocks_not_null.head()
all_date = []
for date in stocks_not_null.index.tolist():
    all_date.append(date[5:])
price_date = set(all_date)

'''混合两个共有的日期，并得到训练集和测试集'''
print '价格和新闻各有多少天',len(price_date),len(news_date)
final_date = price_date & news_date
print '混合的天数：',len(final_date)
final_combined = []
'''把新闻和差价结合'''
all_return = []
all_news = []
all_tobewrite_date = []
lastdate = ''
tempnews = ''
tempdate = ''
tempprice = 0.0
for i in news_split:    
    if i[0] in final_date:
       
        if i[0][0] == '1':
            tempdate = '2015-'+i[0]
        else:
            tempdate = '2016-'+i[0]

        if tempdate != lastdate: 
            all_return.append(tempprice)
            all_news.append(tempnews)
            all_tobewrite_date.append(lastdate)
            tempnews = ''
        tempprice = stocks_not_null[stocks_not_null.index==tempdate]['return'].tolist()[0]
        tempnews = tempnews + i[3]+' '+i[4] +' '
        lastdate = tempdate
all_return.append(tempprice)
all_news.append(tempnews)
all_tobewrite_date.append(lastdate)
print '-----'
print len(all_return)
print len(all_news)
print len(all_tobewrite_date)
print all_news[-1]
print stocks_not_null.tail()
print stocks_not_null.head()
print '09-30' in final_date
all_return = all_return[1:]
all_news = all_news[1:]
all_tobewrite_date = all_tobewrite_date[1:]
print len(all_news)
f = open('data.txt','a')
for i in range(0,len(final_date)):
    f.write(all_tobewrite_date[i]+'\t'+str(all_return[i])+'\t'+all_news[i]+'\n')
f.close()

    

    
    