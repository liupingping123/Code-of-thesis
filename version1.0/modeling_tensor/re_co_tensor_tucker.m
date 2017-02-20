function [V1,V2,V3] = re_co_tensor_tucker(  )
%re_co_tensor_tucker �˴���ʾ�йش˺�����ժҪ
%   ����۸����������
%   ���V1��V2��V3���ع���ѵ������

%% ��������
load('price_list.mat');
load('tensor_flow.mat');
days = 177;%177; %����ѵ��������
train_tensor_flow = tensor_flow(1:days);
train_prices = price_list(1:days);
%% �����۸����ƾ���W
W = zeros(days,days);
for i = 1:days
    for j = i:days
        if abs(train_prices(i)-train_prices(j))<0.01
            W(i,j) = 1;
        end
    end
end
D = sum(W,2);
C_flow = cell(1,days);
U1_flow = cell(1,days);
U2_flow = cell(1,days);
U3_flow = cell(1,days);
%% �õ��������ĺ������Ͳ�ͬģ̬��ģ
for i = 1:days
    % ����ͬ��ģչ������
    A1 = tenmat(train_tensor_flow{i},1);
    A2 = tenmat(train_tensor_flow{i},2);
    A3 = tenmat(train_tensor_flow{i},3);
    % �ֽ�չ������
    [U1,S1,V1] = svd(A1.data);
    [U2,S2,V2] = svd(A2.data);
    [U3,S3,V3] = svd(A3.data);
    % ���������������ع�
    S = ttm(train_tensor_flow{i},{U1',U2',U3'});
    C_flow{i} = S;
    U1_flow{i} = U1;
    U2_flow{i} = U2;
    U3_flow{i} = U3;
end
%% ���V1��V2��V3
DU1 = zeros(6,6);
WU1 = zeros(6,6);
DU2 = zeros(100,100);
WU2 = zeros(100,100);
DU3 = zeros(3,3);
WU3 = zeros(3,3);
% V1
for i = 1:days
    DU1 = DU1 + D(i)*U1_flow{i}*U1_flow{i}';
    for j = 1:days
        WU1 = WU1 + W(i,j)*U1_flow{i}*U1_flow{i}';
    end
end
T1 = (DU1^-1) * (DU1 - WU1);
[V1,eig1] = eig(T1);
% V2
for i = 1:days
    DU2 = DU2 + D(i)*U2_flow{i}*U2_flow{i}';
    for j = 1:days
        WU2 = WU2 + W(i,j)*U2_flow{i}*U2_flow{i}';
    end
end
T2 = (DU2^-1) * (DU2 - WU2);
[V2,eig2] = eig(T2);
% V3
for i = 1:days
    DU3 = DU3 + D(i)*U3_flow{i}*U3_flow{i}';
    for j = 1:days
        WU3 = WU3 + W(i,j)*U3_flow{i}*U3_flow{i}';
    end
end
T3 = (DU3^-1) * (DU3 - WU3);
[V3,eig3] = eig(T3);

V1 = real(V1);
V2 = real(V2);
V3 = real(V3)
end

