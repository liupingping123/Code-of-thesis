%主函数程序
%   假设我们知道特征的维度是多少
%   对价格相似度方法的主函数
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_len = length(y_incre);
train_num = ceil(total_len*0.8);
test_num = total_len - train_num;
%% 构建张量流
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_len);

%% 训练得到V1,V2,V3
[V1,V2,V3] = re_co_tensor_tucker(tensor_flow,y_incre,train_num);

%% 利用V1,V2,V3得到利用相关性重建的张量流
days = total_len;
re_co_tensor_flow = cell(1,days);
for i = 1:days
    re_co_tensor_flow{i} = re_co_tensor_tucker_single(tensor_flow{i},V1,V2,V3);
end
%% 回归训练
[A,B,C,bias] = tensor_reg(re_co_tensor_flow,y_incre,total_len,train_num,test_num,4,70,2,3);

%% 检验训练的结果
right_num = test_ABCbias(A,B,C,bias,re_co_tensor_flow,y_incre,total_len,train_num,test_num);

%% 展示正确率
disp(right_num);
disp(test_num);
disp(right_num/test_num);