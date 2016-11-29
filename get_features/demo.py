#coding=utf-8
'''
-t2s                将句子从繁体转化为简体
-seg_only           只进行分词，不进行词性标注
-deli delimeter     设置词与词性间的分隔符，默认为下划线_
-filter             使用过滤器去除一些没有意义的词语，例如“可以”。
-user userword.txt  设置用户词典，用户词典中的词会被打上uw标签。词典中每一个词一行，UTF8编码(python版暂无)
-model_dir dir      设置模型文件所在文件夹，默认为models/

-input input_file   设置从文件读入，默认为命令行输入
-output output_file 设置输出到文件中，默认为命令行输出

'''
import thulac

print 'start'
thu1 = thulac.thulac("-seg_only")  #设置模式为行分词模式

#thu1.run() #根据参数运行分词程序，从屏幕输入输出
print " ".join(thu1.cut("我爱北京天安门")) #进行一句话分词

#==============================================
thu2 = thulac.thulac("-input cs.txt -filter") #设置模式为分词和词性标注模式
thu2.run() #根据参数运行分词和词性标注程序，从cs.txt文件中读入，屏幕输出结果
print " ".join(thu2.cut("我爱北京天安门可是")) #进行一句话分词和词性标注

print 'end'
