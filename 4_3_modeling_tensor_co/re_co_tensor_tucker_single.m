function [ B Bmat] = re_co_tensor_tucker_single( A,V1,V2,V3,dim1,dim2,dim3 )
%re_co_tensor_tucker �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%% ����ͬ��ģչ������
A1 = tenmat(A,1);
A2 = tenmat(A,2);
A3 = tenmat(A,3);
%% �ֽ�չ������
[U1,S1,Vmd1] = svd(A1.data);
[U2,S2,Vmd2] = svd(A2.data);
[U3,S3,Vmd3] = svd(A3.data);

%% ȥ��
U1(:,dim1+1:end) = [];%5:6
U2(:,dim2+1:end) = [];%70:100
U3(:,dim3+1:end) = [];%3
%% ������������
S = ttm(A,{U1',U2',U3'});
%% �任
U1 = V1'*U1;
U2 = V2'*U2;
U3 = V3'*U3;
%% �ع�
B = ttm(S,{U1,U2,U3}); %tucker��������������U1��U2��U3
Bmat = double(B);
end

