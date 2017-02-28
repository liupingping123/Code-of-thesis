%����������
%   ��������֪��������ά���Ƕ���
%   �Լ۸����ƶȷ�����������
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_len = length(y_incre);
train_num = ceil(total_len*0.8);
test_num = total_len - train_num;
y_class = zeros(1,total_len);
y_test_real = y_incre(train_num+1:total_len)';
for i = 1:total_len
    if y_incre(i)>=0.001
        y_class(i) = 1;
    elseif y_incre(i)<=-0.001
        y_class(i) = 2;
    else 
        y_class(i) = 3;
    end
end
%U������ά��
dim1=5;
dim2=80;
dim3=2;
%V���������ɷ�ά��
dim_v1=4;
dim_v2=70;
dim_v3=1;
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

%% general tensor ridge regression
using_mat = re_tensor_flow_mat;%����ѵ���Ͳ��Ե���������
lambda = 0.000000001;
R = 5;
MaxIter = 50;
Tol = 1e-6;
[U, d, err] = genTensorRegression(tensor(using_mat(:,:,:,1:train_num)),y_incre(1:train_num)', lambda, R, MaxIter, Tol);%genTensorRegression
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
 for i=1:test_num
     if pred_price(i)*y_incre(i+train_num)>0
         right_num=right_num+1;
     end
 end
disp(right_num);
accuracy = right_num/test_num;
disp(accuracy);
%% Root Mean Squared Errors
RMSE = sum((pred_price(1:test_num)-y_test_real(1:test_num)).^2);
disp('RMSE'),disp(RMSE);
save pred_price pred_price