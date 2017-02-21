%主函数程序
%   假设我们知道特征的维度是多少
%   对价格相似度方法的主函数
clear;
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\y_incre.mat');
total_len = length(y_incre);
train_num = ceil(total_len*0.8);
test_num = total_len - train_num;
%U保留的维度
dim1=5;
dim2=80;
dim3=2;
%V保留的主成分维度
dim_v1=4;
dim_v2=70;
dim_v3=2;
%% 构建张量流
[re_tensor_flow, tensor_flow] = con_tensor_flow(total_len,dim1,dim2,dim3);

%% 训练得到V1,V2,V3
[V1,V2,V3] = re_co_tensor_tucker(tensor_flow,y_incre,train_num,dim1,dim2,dim3,dim_v1,dim_v2,dim_v3);

%% 利用V1,V2,V3得到利用相关性重建的张量流
re_tensor_flow_mat = zeros(6,100,3,total_len);
re_co_tensor_flow = cell(1,total_len);
re_co_tensor_flow_mat = zeros(dim_v1,dim_v2,dim_v3,total_len);
for i = 1:total_len
    [re_co_tensor_flow{i},re_co_tensor_flow_mat(:,:,:,i)] = re_co_tensor_tucker_single(tensor_flow{i},V1,V2,V3,dim1,dim2,dim3);
    re_tensor_flow_mat(:,:,:,i) =  re_tensor_flow{i};
    %one_tensor=re_co_tensor_flow{i};
    %featurelist(i,:)= double(tenmat(one_tensor,3));
end
%featurelist=normr(featurelist);
% %% 回归训练
%[A,B,C,bias] = tensor_reg(re_co_tensor_flow,y_incre,total_len,train_num,test_num,2,dim_v1,dim_v2,dim_v3);
% %% 检验训练的结果
% right_num = test_ABCbias(A,B,C,bias,re_co_tensor_flow,y_incre,total_len,train_num,test_num)
%% general tensor ridge regression
lambda = 0.001;
R = 3;

[U, d, err] = genTensorRegression(tensor(re_tensor_flow_mat(:,:,:,1:train_num)),y_incre(1:train_num)',lambda,R);
model.U = U;
model.b = d;
model.train_err = err;

%% 测试
ten_U = ktensor(U);
%ten_U = tensor(ten_U);

pred_price = [];
for i = 1:test_num
    tempFeature = tensor(re_tensor_flow_mat(:,:,:,train_num+i));
    YPt = innerprod(tempFeature, ten_U)+d;
    pred_price = [pred_price;YPt]
end
t1s=0;
%% 结果
 for i=1:44
     if pred_price(i)*y_incre(i+177)>0
         t1s=t1s+1;
     end
 end
save pred_price pred_price
t1s
t1s/44
%% 展示正确率
% disp(right_num);
% disp(test_num);
% disp(right_num/test_num);