%����ִ�к������õ����Ų���
%

RMSE_total = [];
right_num_total = [];

beta_total = [];
R_total = [];
MaxIter_total = [];
alpha_total = [];
lambda_total = [];
for beta = 0.2:0.2:0.9
    for R = 3:15
        for MaxIter = 30:10:50           
            alpha = 0.0001;
            while alpha <= 10
                lambda = 0.00000000000001;
                while lambda <= 0.000001
                    [ RMSE,right_num ] = function_version_of_main_tensor_LPP_and_LDA( lambda,R,MaxIter,alpha,beta );
                    RMSE_total = [RMSE_total;RMSE];
                    right_num_total = [right_num_total;right_num];
                    beta_total = [beta_total;beta];
                    R_total = [R_total;R];
                    MaxIter_total = [MaxIter_total;MaxIter];
                    alpha_total = [alpha_total;alpha];
                    lambda_total = [lambda_total;lambda];
                    lambda = lambda *10 ;
                end
                alpha = alpha * 10;
            end
        end
    end
end


