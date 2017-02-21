function [re_tensor_flow,tensor_flow] = con_tensor_flow(total_len,dim1,dim2,dim3)
%载入特征
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\firm_features.mat');
%注意对公司提取的特征是经过PCA降维之后的结果
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\news_features_pca.mat');
load('E:\study\master of TJU\0Subject research\code\Important\0_1_special_data\emo_features.mat');
%归一化
emo_features = normc(emo_features);
firm_features = normc(firm_features);
news_features = normc(news_features);
%构建原始的张量流
tensor_flow = cell(1,size(emo_features,1));
%构建重构后的张量流
re_tensor_flow = cell(1,size(emo_features,1));
for i = 1:total_len
    M = zeros(6,100,3);
    M(:,1,1) = firm_features(i,:);
    M(2,:,2) = news_features(i,:);
    M(3,3,:) = emo_features(i,:);
    T = tensor(M);
    tensor_flow{i} = T;
    re_tensor_flow{i} = re_tensor_tucker(T,dim1,dim2,dim3);
end
%把重构前的流和重构后的流都保存下来，统称tensor_flow
save tensor_flow tensor_flow re_tensor_flow;
end