%����������
%   ��������֪��������ά���Ƕ���
%   �Լ۸����ƶȷ�����������
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_len = length(y_incre);
train_num = ceil(total_len*0.8);
test_num = total_len - train_num;
%% ����������
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_len);

%% ѵ���õ�V1,V2,V3
[V1,V2,V3] = re_co_tensor_tucker(tensor_flow,y_incre,train_num);

%% ����V1,V2,V3�õ�����������ؽ���������
days = total_len;
re_co_tensor_flow = cell(1,days);
for i = 1:days
    re_co_tensor_flow{i} = re_co_tensor_tucker_single(tensor_flow{i},V1,V2,V3);
end
%% �ع�ѵ��
[A,B,C,bias] = tensor_reg(re_co_tensor_flow,y_incre,total_len,train_num,test_num,4,70,2,3);

%% ����ѵ���Ľ��
right_num = test_ABCbias(A,B,C,bias,re_co_tensor_flow,y_incre,total_len,train_num,test_num);

%% չʾ��ȷ��
disp(right_num);
disp(test_num);
disp(right_num/test_num);