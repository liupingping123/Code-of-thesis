function [re_LPPandLDA_tensor_flow,T1new,T2new,T3new] = re_LPP_and_LDA_tensor_tucker(tensor_flow,y_incre,y_class,total_num,train_num,test_num,dim1,dim2,dim3,dim_t1,dim_t2,dim_t3,alpha,beta,num_class)
%re_LPP_and_LDA_tensor_tucker
%   ����۸����������
%   ���X1,X2,X3���ع���ѵ������
%   tensor_flow�����������
%   y_incre�Ƕ�Ӧ��yֵ
%   train_num��ѵ������
%   dim1��dim2��dim3��U������ά��
%   dim_v1,dim_v2,dim_v3��V������ά��

%% �õ�ѵ������
train_tensor_flow = tensor_flow(1:train_num);
train_prices = y_incre(1:train_num);
train_y_class = y_class(1:train_num);
%% ����һЩ����
C_flow = cell(1,train_num);
U1_flow = cell(1,train_num);
U2_flow = cell(1,train_num);
U3_flow = cell(1,train_num);
U1_flow_new = cell(1,total_num);
U2_flow_new = cell(1,total_num);
U3_flow_new = cell(1,total_num);
re_LPPandLDA_tensor_flow = cell(1,total_num);
%% �����۸����ƾ���W
W = zeros(train_num,train_num);
for i = 1:train_num
    for j = i:train_num
        if abs(train_prices(i)-train_prices(j))<0.01
            W(i,j) = 1;
        end
    end
end
D = sum(W,1);
D = D';
%% �õ��������ĺ������Ͳ�ͬģ̬���ģ��
for i = 1:train_num
    % ����ͬ��ģչ������
    A1 = tenmat(train_tensor_flow{i},1);
    A2 = tenmat(train_tensor_flow{i},2);
    A3 = tenmat(train_tensor_flow{i},3);
    % �ֽ�չ������
    [U1,S1,V1] = svd(A1.data);
    [U2,S2,V2] = svd(A2.data);
    [U3,S3,V3] = svd(A3.data);
    % ȥ��
    U1(:,dim1+1:end) = [];%5:6
    U2(:,dim2+1:end) = [];%71:100
    U3(:,dim3+1:end) = [];%3
    % ���������������ع�
    S = ttm(train_tensor_flow{i},{U1',U2',U3'});    
    C_flow{i} = S;
    U1_flow{i} = U1;
    U2_flow{i} = U2;
    U3_flow{i} = U3;
end
%% �õ�Sb��Sw
for i = 1:total_num
    % ����ͬ��ģչ������
    A1 = tenmat(tensor_flow{i},1);
    A2 = tenmat(tensor_flow{i},2);
    A3 = tenmat(tensor_flow{i},3);
    % �ֽ�չ������
    [U1,S1,V1] = svd(A1.data);
    [U2,S2,V2] = svd(A2.data);
    [U3,S3,V3] = svd(A3.data);
    %% ȥ������
    U1(:,dim1+1:end) = [];%
    U2(:,dim2+1:end) = [];%
    U3(:,dim3+1:end) = [];%
    S = ttm(tensor_flow{i},{U1',U2',U3'});
    C_flow{i} = S;
    U1_flow{i} = U1;
    U2_flow{i} = U2;
    U3_flow{i} = U3;
    
end
[X1,Sb1,Sw1] = LDA_2D(train_y_class, U1_flow(1:train_num), num_class, dim_t1);
[X2,Sb2,Sw2] = LDA_2D(train_y_class, U2_flow(1:train_num), num_class, dim_t2);
[X3,Sb3,Sw3] = LDA_2D(train_y_class, U3_flow(1:train_num), num_class, dim_t3);
%% ���DU,WU��ע�⣬���������ά�ȿ���������ȡ�����Ĳ�ͬ�����ı�
DU1 = zeros(6,6);
WU1 = zeros(6,6);
DU2 = zeros(100,100);
WU2 = zeros(100,100);
DU3 = zeros(6,6);
WU3 = zeros(6,6);
%% DU1��WU2
for i = 1:train_num
    DU1 = DU1 + D(i)*U1_flow{i}*U1_flow{i}';
    for j = i:train_num
        WU1 = WU1 + W(i,j)*U1_flow{i}*U1_flow{j}';
    end
end
%% DU2��WU2
for i = 1:train_num
    DU2 = DU2 + D(i)*U2_flow{i}*U2_flow{i}';
    for j = i:train_num
        WU2 = WU2 + W(i,j)*U2_flow{i}*U2_flow{j}';
    end
end
%%  DU3��WU3
for i = 1:train_num
    DU3 = DU3 + D(i)*U3_flow{i}*U3_flow{i}';
    for j = i:train_num
        WU3 = WU3 + W(i,j)*U3_flow{i}*U3_flow{j}';
    end
end

%% ���T1
T1 = pinv(DU1) * (beta*(DU1 - alpha*WU1)+(1-beta)*(WU1-DU1));
[V1,eig1] = eig(T1);
[values1,posits1]=sort(diag(eig1),'descend');
T1new=T1(:,posits1(1:dim_t1));
%% ���T2
T2 = pinv(DU2) * (beta*(DU2 - alpha*WU2)+(1-beta)*(WU2-DU2));
[V2,eig2] = eig(T2);
[values2,posits2]=sort(diag(eig2),'descend');
T2new=T2(:,posits2(1:dim_t2));
%% ���T3
T3 = pinv(DU3) * (beta*(DU3 - alpha*WU3)+(1-beta)*(WU3-DU3));
[V3,eig3] = eig(T3);
[values3,posits3]=sort(diag(eig3),'descend');
T3new=T3(:,posits3(1:dim_t3));

%% ȡʵ��
T1new = real(T1new);
T2new = real(T2new);
T3new = real(T3new);

%% �õ��µ�������
for i = 1:total_num
    U1_flow_new{i} = T1new'*U1_flow{i};
    U2_flow_new{i} = T2new'*U2_flow{i};
    U3_flow_new{i} = T3new'*U3_flow{i};
    re_LPPandLDA_tensor_flow{i} = ttm(C_flow{i},{ U1_flow_new{i}, U2_flow_new{i}, U3_flow_new{i}});
end
end

