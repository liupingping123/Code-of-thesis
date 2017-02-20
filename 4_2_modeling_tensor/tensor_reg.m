function [A,B,C,bias] = tensor_reg(tensor_flow,y_incre,total_len,train_num,test_num,dim1,dim2,dim3,num_train)
%ѵ�������ع���������շ���A,B,C,bias
%   ����һ������������һ��ȱʡֵdays
%   ����ع�����Ҫ�Ĳ���
days = train_num;% ѡȡǰn��ѵ��

%% ��������
using_tensor_flow = tensor_flow(1:total_len);%���Ը���Ϊ��ͬ���ع���ʽ  re_co_tensor_flow(1:221)
price = y_incre(1:days)*1000;%����������������ֵ��С�����Գ���1000��ѡȡǰn��ѵ��
%% �����ʼֵ
A = ones(1,dim1);B = ones(1,dim2);C = ones(1,dim3);bias = 0;
lastA = ones(1,dim1);lastB = ones(1,dim2);lastC = ones(1,dim3);lastbias = 0;

%% ѵ��
num = 1;
while num < num_train % ����Ϊ2000
    
    % ����m�Ĳ�ͬ��������ת��Ϊ����
    % m = 1
    featureslist = [];
    for i = 1:days
        one_tensor = using_tensor_flow{i};
        tempFeatures = ttm(one_tensor, {lastB,lastC}, [2 3]); %<-- same as above
        tempFeatures = reshape(double(tempFeatures),1,dim1);
        featureslist = [featureslist;tempFeatures];
    end
    
    tempmodel = train(price', sparse(featureslist), '-s 13');
    A = tempmodel.w;
    bias = tempmodel.bias;
    
    % m = 2
    featureslist = [];
    for i = 1:days
        one_tensor = using_tensor_flow{i};
        tempFeatures = ttm(one_tensor, {A,lastC}, [1 3]); %<-- same as above
        tempFeatures = reshape(double(tempFeatures),1,dim2);
        featureslist = [featureslist;tempFeatures];
    end
    
    tempmodel = train(price', sparse(featureslist), '-s 13');
    B = tempmodel.w;
    bias = tempmodel.bias;
    
    % m = 3
    featureslist = [];
    for i = 1:days
        one_tensor = using_tensor_flow{i};
        tempFeatures = ttm(one_tensor, {A,B}, [1 2]); %<-- same as above
        tempFeatures = reshape(double(tempFeatures),1,dim3);
        featureslist = [featureslist;tempFeatures];
    end
    
    tempmodel = train(price', sparse(featureslist), '-s 13');
    C = tempmodel.w;
    bias = tempmodel.bias;
    
    % ��ʾ���ϴ�ѵ������Ĳ�ֵ
    dispA = sum((A - lastA).^2);
    dispB = sum((B - lastB).^2);
    dispC = sum((C - lastC).^2);
    totaldisp = dispA + dispB + dispC;
    disp(num);
    num = num + 1;
    disp(totaldisp);
    disp(bias - lastbias);
    lastA = A;
    lastB = B;
    lastC = C;
    lastbias = bias;
    
end

end
