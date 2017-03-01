function [ NewX,Sb,Sw ] = LDA_2D( y_class, mat_flow, num_class, dim_to_keep )
%LDA_2D �˴���ʾ�йش˺�����ժҪ
%   mat_flow�Ǹ�cell
%%
% �õ�����ÿ��ĸ���
y_result = tabulate(y_class);
N = zeros(num_class,1);
T = zeros(num_class,1);
% �����ܸ���
num_sample = size(y_class,2);
Sb = zeros(size(mat_flow{1},1));
Sw = zeros(size(mat_flow{1},1));
% �����������ƽ����At
At = zeros(size(mat_flow{1}));
for i = 1:num_sample
    At = At + mat_flow{i};
end
At = At/num_sample;

for i = 1:num_class
    T(i) = y_result(i,1);
    N(i) = y_result(i,2);
    % ��Ϊ��ʱ���������ۼ����
    Atemp = zeros(size(mat_flow{1}));
    for j = 1:num_sample
        if y_class(j) == T(i)
            Atemp = Atemp + mat_flow{j};
        end
    end
    % �õ�ÿ���ƽ��ֵ
    A{i} = Atemp/T(i);
    % �õ�Sb
    Sb = Sb + N(i)* (A{i}-At)*(A{i}-At)';
   
    for j = 1:num_sample
        if y_class(j) == T(i)
            Sw = Sw + ((mat_flow{j}-A{i}) * (mat_flow{j}-A{i})');
        end
    end
end
T = pinv(Sw) * Sb;
[X,eigens] = eig(T);
[values,posits]=sort(diag(eigens),'descend');
NewX=X(:,posits(1:dim_to_keep));

end

