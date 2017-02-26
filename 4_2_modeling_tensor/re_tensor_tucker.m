function [ B ] = re_tensor_tucker(A,dim1,dim2,dim3)
%���ø߽�����ֵ�ֽ���������ع�
%   ����Ϊ������dim1,dim2,dim3�Ǳ�����ά��
%   ���Ϊ�ع�����
%   ȥ��U��ĩβ����
%% ����ͬ��ģչ������
A1 = tenmat(A,1);
A2 = tenmat(A,2);
A3 = tenmat(A,3);
%% �ֽ�չ������
[U1,S1,V1] = svd(A1.data);
[U2,S2,V2] = svd(A2.data);
[U3,S3,V3] = svd(A3.data);
%% ȥ������
U1(:,dim1+1:end) = [];%5:6
U2(:,dim2+1:end) = [];%70:100
U3(:,dim3+1:end) = [];%3
%% ���������������ع�
S = ttm(A,{U1',U2',U3'});
B = ttm(S,{U1,U2,U3}); %tucker��������������U1��U2��U3
end

