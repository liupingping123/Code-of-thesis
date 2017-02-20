function [ B ] = re_co_tensor_tucker_single( A,V1,V2,V3 )
%re_co_tensor_tucker 此处显示有关此函数的摘要
%   此处显示详细说明
%% 按不同的模展开张量
A1 = tenmat(A,1);
A2 = tenmat(A,2);
A3 = tenmat(A,3);
%% 分解展开矩阵
[U1,S1,Vmd1] = svd(A1.data);
[U2,S2,Vmd2] = svd(A2.data);
[U3,S3,Vmd3] = svd(A3.data);

%% 去噪
U1(:,5:6) = [];%5:6
U2(:,71:100) = [];%70:100
U3(:,3) = [];%3
%% 构建核心张量
S = ttm(A,{U1',U2',U3'});
%% 去除噪声
U1 = V1'*U1;
U2 = V2'*U2;
U3 = V3'*U3;
%% 重构
B = ttm(S,{U1,U2,U3}); %tucker的三方面矩阵就是U1，U2，U3

end

