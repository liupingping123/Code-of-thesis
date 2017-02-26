%主函数程序
%   假设我们知道特征的维度是多少
%   对价格相似度方法的主函数
%   使用LDA方法
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
%U保留的维度
dim1=5;
dim2=80;
dim3=2;
%X保留的主成分维度
dim_x1=4;
dim_x2=70;
dim_x3=1;
%% 构建张量流
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_len,dim1,dim2,dim3);
%% 训练得到X1，X2，X3
num_class = 3;%分为几类
[re_LDA_tensor_flow,X1,X2,X3] = re_2D_LDA_tensor_tucker(tensor_flow,y_class,total_len,train_num,dim1,dim2,dim3,dim_x1,dim_x2,dim_x3,num_class);

%% 利用V1,V2,V3得到利用相关性重建的张量流
re_tensor_flow_mat = zeros(dim_x1,dim_x2,dim_x3,total_len);
for i = 1:total_len
    re_tensor_flow_mat(:,:,:,i) =  re_LDA_tensor_flow{i};
end

%% general tensor ridge regression，设置参数
using_mat = re_tensor_flow_mat;%更改训练和测试的特征张量
lambda = 0.00000001;%0.000000000001
R = 5;
MaxIter = 50;
Tol = 1e-6;
[U, d, err] = genTensorRegression(tensor(using_mat(:,:,:,1:train_num)),y_incre(1:train_num)', lambda, R, MaxIter, Tol);%genTensorRegression
model.U = U;
model.b = d;
model.train_err = err;

%% 测试
ten_U = ktensor(U);
ten_U = tensor(ten_U);
pred_price = [];
for i = 1:test_num
    tempFeature = tensor(using_mat(:,:,:,train_num+i));
    tempPred = innerprod(tempFeature, ten_U)+d;
    pred_price = [pred_price;tempPred];
end
right_num=0;
%% 结果
 for i=1:44
     if pred_price(i)*y_incre(i+177)>0
         right_num=right_num+1;
     end
 end
%% Root Mean Squared Errors
RMSE = sum((pred_price(1:test_num)-y_test_real(1:test_num)).^2);
save pred_price pred_price
disp('RMSE'),disp(RMSE);
disp('预测对的天数'),disp(right_num),disp('预测升降的准确率'),disp(right_num/44);