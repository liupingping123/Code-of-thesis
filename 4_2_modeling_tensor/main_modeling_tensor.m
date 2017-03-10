%����������
%   ��������֪��������ά���Ƕ���
%% ����yֵ����ȡѵ�����Ͳ��Լ��ĸ���
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_num = length(y_incre);
train_num = ceil(total_num*0.8);
test_num = total_num - train_num;
y_test_real = y_incre(train_num+1:total_num)';
%% �趨U����!��ά��
dim1=4;
dim2=60;
dim3=4;

%% ����������
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_num,dim1,dim2,dim3,'threestick','yes');% ʹ������������������Ĭ�ϵ�����������Ƿ��һ��

%% �õ��������ľ�����ʽ����������ʹ��֮��Ļع�
%����ѵ���Ͳ��Ե���������
tensor_flow_mat = zeros(6,100,6,total_num);
for i = 1:total_num
    %����ѵ���Ͳ��Ե���������
    tensor_flow_mat(:,:,:,i) =  re_tensor_flow{i};
end
%% general tensor ridge regression�����ò���
using_mat = tensor_flow_mat;
lambda = 0.0000000001;%0.000000000001
R = 3;
MaxIter = 50;
Tol = 1e-6;
[U, d, err] = genTensorRegression(tensor(using_mat(:,:,:,1:train_num)),y_incre(1:train_num)', lambda, R, MaxIter, Tol);%genTensorRegression
model.U = U;
model.b = d;
model.train_err = err;

%% Ԥ��
ten_U = ktensor(U);
ten_U = tensor(ten_U);
pred_price = [];
for i = 1:test_num
    tempFeature = tensor(using_mat(:,:,:,train_num+i));
    tempPred = innerprod(tempFeature, ten_U)+d;
    pred_price = [pred_price;tempPred];
end
%% ���
right_num=0;
right_class_num = 0;
for i=1:test_num
    if pred_price(i) >= 0
        if y_incre(i+train_num) >= 0
            right_num=right_num+1;
        end
    end
    if pred_price(i) < 0
        if y_incre(i+train_num) < 0
            right_num=right_num+1;
        end
    end 
end
%% ��������Root Mean Squared Errors
RMSE = sum((pred_price(1:test_num)-y_test_real(1:test_num)).^2);
save pred_price pred_price
disp('RMSE'),disp(RMSE);
disp('Ԥ��Ե�����'),disp(right_num),disp('Ԥ��������׼ȷ��'),disp(right_num/test_num);


%% ֮ǰ����Ļع鷽��ʵ��
% [re_tensor_flow, tensor_flow] = con_tensor_flow(total_len);
% [A,B,C,bias] = tensor_reg(re_tensor_flow,y_incre,total_len,train_num,test_num,6,100,3,2000);
% right_num = test_ABCbias(A,B,C,bias,re_tensor_flow,y_incre,total_len,train_num,test_num);
