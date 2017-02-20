%主函数程序
%   假设我们知道特征的维度是多少
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_len = length(y_incre);
train_num = ceil(total_len*0.8);
test_num = total_len - train_num;
%% 构建张量流
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_len);

%% 回归训练
[A,B,C,bias] = tensor_reg(re_tensor_flow,y_incre,total_len,train_num,test_num,6,100,3,2000);

%% 检验训练的结果
right_num = test_ABCbias(A,B,C,bias,re_tensor_flow,y_incre,total_len,train_num,test_num);

%% 展示正确率
right_num
test_num
right_num/test_num