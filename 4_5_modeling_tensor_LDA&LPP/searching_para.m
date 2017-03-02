%用于执行函数，得到最优参数
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
                while lambda <= 10
                    [ RMSE,right_num ] = function_version_of_main_tensor_LPP_and_LDA( lambda,R,MaxIter,alpha,beta );
                    RMSE_total = [RMSE_total;RMSE];
                    right_num_total = [right_num_total;RMSE];
                    beta_total = [beta_total;RMSE];
                    R_total = [R_total;RMSE];
                    MaxIter_total = [MaxIter_total;RMSE];
                    alpha_total = [alpha_total;RMSE];
                    lambda_total = [lambda_total;RMSE];
                    lambda = lambda *1000 ;
                end
                alpha = alpha * 10;
            end
        end
    end
end


