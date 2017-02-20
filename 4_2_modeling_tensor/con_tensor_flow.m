function [re_tensor_flow,tensor_flow] = con_tensor_flow(total_len)
%��������
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\firm_features.mat');
%ע��Թ�˾��ȡ�������Ǿ���PCA��ά֮��Ľ��
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\news_features_pca.mat');
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\emo_features.mat');
%����ԭʼ��������
tensor_flow = cell(1,size(emo_features,1));
%�����ع����������
re_tensor_flow = cell(1,size(emo_features,1));
for i = 1:total_len
    M = zeros(6,100,3);
    M(:,1,1) = firm_features(i,:);
    M(2,:,2) = news_features(i,:);
    M(3,3,:) = emo_features(i,:);
    T = tensor(M);
    tensor_flow{i} = T;
    re_tensor_flow{i} = re_tensor_tucker(T);
end
%���ع�ǰ�������ع������������������ͳ��tensor_flow
save tensor_flow tensor_flow re_tensor_flow;
end