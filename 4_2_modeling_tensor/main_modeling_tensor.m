%����������
%   ��������֪��������ά���Ƕ���
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_len = length(y_incre);
train_num = ceil(total_len*0.8);
test_num = total_len - train_num;
%% ����������
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_len);

%% �ع�ѵ��
[A,B,C,bias] = tensor_reg(re_tensor_flow,y_incre,total_len,train_num,test_num,6,100,3,2000);

%% ����ѵ���Ľ��
right_num = test_ABCbias(A,B,C,bias,re_tensor_flow,y_incre,total_len,train_num,test_num);

%% չʾ��ȷ��
right_num
test_num
right_num/test_num