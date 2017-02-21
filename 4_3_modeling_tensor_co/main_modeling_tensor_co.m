%����������
%   ��������֪��������ά���Ƕ���
%   �Լ۸����ƶȷ�����������
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_len = length(y_incre);
train_num = ceil(total_len*0.8);
test_num = total_len - train_num;
%U������ά��
dim1=5;
dim2=80;
dim3=2;
%V���������ɷ�ά��
dim_v1=4;
dim_v2=70;
dim_v3=2;
%% ����������
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_len,dim1,dim2,dim3);

%% ѵ���õ�V1,V2,V3
[V1,V2,V3] = re_co_tensor_tucker(tensor_flow,y_incre,train_num,dim1,dim2,dim3,dim_v1,dim_v2,dim_v3);

%% ����V1,V2,V3�õ�����������ؽ���������
re_tensor_flow_mat = zeros(6,100,3,total_len);

re_co_tensor_flow = cell(1,total_len);
re_co_tensor_flow_mat = zeros(dim_v1,dim_v2,dim_v3,total_len);
for i = 1:total_len
    [re_co_tensor_flow{i},re_co_tensor_flow_mat(:,:,:,i)] = re_co_tensor_tucker_single(tensor_flow{i},V1,V2,V3,dim1,dim2,dim3);
    re_tensor_flow_mat(:,:,:,i) =  re_tensor_flow{i};
end
%featurelist=normr(featurelist);
% %% �ع�ѵ��
%[A,B,C,bias] = tensor_reg(re_co_tensor_flow,y_incre,total_len,train_num,test_num,2,dim_v1,dim_v2,dim_v3);
% %% ����ѵ���Ľ��
% right_num = test_ABCbias(A,B,C,bias,re_co_tensor_flow,y_incre,total_len,train_num,test_num)
%% general tensor ridge regression
using_mat = re_co_tensor_flow_mat;%����ѵ���Ͳ��Ե���������
lambda = 0.000000000001;
R = 3;
MaxIter = 30;
Tol = 1e-6;
[U, d, err] = genTensorRegression(tensor(using_mat(:,:,:,1:train_num)),y_incre(1:train_num)', lambda, R, MaxIter, Tol);
model.U = U;
model.b = d;
model.train_err = err;

%% ����
ten_U = ktensor(U);
ten_U = tensor(ten_U);

pred_price = [];
for i = 1:test_num
    tempFeature = tensor(using_mat(:,:,:,train_num+i));
    tempPred = innerprod(tempFeature, ten_U)+d;
    pred_price = [pred_price;tempPred];
end
right_num=0;
%% ���
 for i=1:44
     if pred_price(i)*y_incre(i+177)>0
         right_num=right_num+1;
     end
 end
save pred_price pred_price
right_num
right_num/44
%% չʾ��ȷ��
% disp(right_num);
% disp(test_num);
% disp(right_num/test_num);