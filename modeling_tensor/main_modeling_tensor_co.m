%�Լ۸����ƶȷ�����������
clear;
tensor_flow = con_tensor_flow();
load('price_list.mat');
load('tensor_flow.mat');
% ѵ���õ�V1,V2,V3
[V1,V2,V3] = re_co_tensor_tucker();
days = 221;
re_co_tensor_flow = cell(1,days);
for i = 1:days
    re_co_tensor_flow{i} = re_co_tensor_tucker_single(tensor_flow{i},V1,V2,V3);
end