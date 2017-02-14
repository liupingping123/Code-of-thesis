% ����ѵ���ĳɹ�
[A,B,C,bias] = tensor_reg(re_co_tensor_flow);
%% ��������
load('tensor_flow.mat');
load('price_list.mat');
test_tensor_flow = re_co_tensor_flow(178:221);%���Ը���Ϊ��ͬ���ع���ʽ
test_price = price_list(178:221);%����������������ֵ��С�����Գ���1000��ѡȡǰn��ѵ��
pred_price = [];
%% Ԥ��
for i = 1:44
    one_tensor = test_tensor_flow{i};
    tempPrice = ttm(one_tensor, {A,B,C}, [1 2 3]); %<-- same as above
    tempPrice = reshape(double(tempPrice),1,1);
    pred_price = [pred_price;tempPrice];
end
pred_price = (pred_price - bias)/1000;
test_di = [];
for tempprice = test_price
    if tempprice>=0
        test_di = [test_di;1];
    else
        test_di = [test_di;-1];
    end
end
pred_di = [];
for tempprice = pred_price'
    
    if tempprice>=0       
        pred_di = [pred_di;1];
    else
        pred_di = [pred_di;-1];
    end
end

right_num = 0;
for i = 1:44
    if pred_di(i)==test_di(i)
        right_num = right_num+1;
    end
end
save pred_price pred_price