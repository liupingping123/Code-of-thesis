function [right_num] = test_ABCbias(A,B,C,bias,tensor_flow,y_incre,total_len,train_num,test_num)
%����ѵ���ĳɹ�
%   ����ع������������������yֵ
%   �����ȷ�ĸ���
%% ��������
test_tensor_flow = tensor_flow(train_num+1:total_len);%���Ը���Ϊ��ͬ���ع���ʽ
test_price = y_incre(train_num+1:total_len);%����������������ֵ��С�����Գ���1000��ѡȡǰn��ѵ��
pred_price = [];
%% Ԥ��
for i = 1:test_num
    one_tensor = test_tensor_flow{i};
    tempPrice = ttm(one_tensor, {A,B,C}, [1 2 3]); %<-- same as above
    tempPrice = reshape(double(tempPrice),1,1);
    pred_price = [pred_price;tempPrice];
end
%% �õ����յ�Ԥ����
pred_price = (pred_price - bias);
%% �õ����Լ���������
test_di = [];
for tempprice = test_price
    if tempprice>=0
        test_di = [test_di;1];
    else
        test_di = [test_di;-1];
    end
end
%% �õ����Լ�Ԥ������������
pred_di = [];
for tempprice = pred_price'
    
    if tempprice>=0       
        pred_di = [pred_di;1];
    else
        pred_di = [pred_di;-1];
    end
end
%% �����ж��ٸ�Ԥ����ȷ
right_num = 0;
for i = 1:test_num
    if pred_di(i)==test_di(i)
        right_num = right_num+1;
    end
end
save pred_price pred_price
end