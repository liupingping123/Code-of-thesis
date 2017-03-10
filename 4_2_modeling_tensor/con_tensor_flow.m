function [re_tensor_flow,tensor_flow] = con_tensor_flow(total_len,dim1,dim2,dim3,conmethod,whenormlize)
%��������������
%   ֮��Ҫ������ʲô����������ѡ������������������
%   conmethod�ǹ�������������ѡ��threestick������Ĭ�ϵ����������
%% ��������
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\firm_features.mat');
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\news_features_pca.mat');%ע��Թ�˾��ȡ�������Ǿ���PCA��ά֮��Ľ��
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\emo_features.mat');
%% ��һ��,��һ������������ع鲻��
if strcmp(whenormlize,'yes')
emo_features = normc(emo_features);
firm_features = normc(firm_features);
news_features = normc(news_features);
end
%����ԭʼ��������
tensor_flow = cell(1,size(emo_features,1));
%����tucker�ֽ�֮����ع����������
re_tensor_flow = cell(1,size(emo_features,1));
%% �ع�����
for i = 1:total_len
    M = zeros(6,100,6);
    if strcmp(conmethod,'threestick')
        %disp('ʹ��������������');
        M(:,1,1) = firm_features(i,:);
        M(2,:,2) = news_features(i,:);
        M(3,3,:) = emo_features(i,:);
    else
        M = outproducts(firm_features(i,:),news_features(i,:),emo_features(i,:));
        %disp('ʹ�����������');
    end
    
    T = tensor(M);
    tensor_flow{i} = T;
    re_tensor_flow{i} = re_tensor_tucker(T,dim1,dim2,dim3);
end
%% ���ع�ǰ�������ع������������������ͳ��tensor_flow
save tensor_flow tensor_flow re_tensor_flow;
end