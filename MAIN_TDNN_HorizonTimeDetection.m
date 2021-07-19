%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%Main_TDNN_HorizonTimeDetection version 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This function performs a parametric analysis, changing the time delays. 
%It allows to evaluate the "time horizon of causality" of the influence of
%class Sin on class Sout

%Set the influencing time series
Sin = y;

%Set the influenced time series
Sout = X;

%Set the time horizons to investigate
T{1} = 1:1; 
T{2} = 1:2;
T{3} = 1:3;
T{4} = 1:4;
T{5} = 1:5;

%select 1 is you want to use parallel computing, otherwise 0
parallel_computing = 1;

%select the threshold of the p-value for the decision
p_three = 0.05;

clear input output output_t output_p NN
clear F Mi_p err_all err_t E_var1 E_var2 Var_ratio

if parallel_computing == 1

    parfor i = 1 : length(T)

        disp(strcat('Analysing time delay ',num2str(i)));
        %At first, we predict the output using all the time series

        %exctract the output
        output{i} = Sout;

        %extract the input
        input{i} = [Sin; Sout];

        %set the net and the time delays of the net
        NN{i} = NN_config();
        NN{i}.config.inputDelays = T{i};

        %the net is trained
        NN{i}=NN_train(input{i},output{i},NN{i});

        %the output is predicted
        output_p{i} = NN_test(input{i},NN{i});
        output_p{i} = output_p{i}(:);

        %the first delay layer is removed from the "true" output
        %("unpredictable points because we have not their past")
        output_t{i} = output{i}(:,max(NN{i}.config.inputDelays)+1:end);
        output_t{i} = output_t{i}(:);

        %the error vector of the prediction using all time series is evaluated
        err_all{i} = (output_p{i}-output_t{i});

        %the variance of the error evaluated
        E_var1(i) = mean(err_all{i}.^2);

        %the same prediction is performed without the influencing class

        %set the input vector
        input{i} = [];
        input{i} = Sout;

        %the net is trained
        NN{i}=NN_train(input{i},output{i},NN{i});

        %the output is predicted
        output_p{i} = NN_test(input{i},NN{i});
        output_p{i} = output_p{i}(:);

        %the error of the prediction is evaluated
        err_t{i} = (output_p{i}-output_t{i});

        %the variance matrix is evaluated
        E_var2(i) = mean(err_t{i}.^2);

        %Loss of prediction accuracy matrix
        Var_ratio(i) = E_var2(i)/E_var1(i);

        %the p-value matrix performed by a Variance test is calculated
        [Mi_p{i},F{i}] = vartest2(err_t{i},err_all{i});

        disp(strcat('Time delay ',num2str(i),' finished'));
    end

else
    
    for i = 1 : length(T)

        disp(strcat('Analysing time delay ',num2str(i)));
        %At first, we predict the output using all the time series

        %exctract the output
        output{i} = Sout;

        %extract the input
        input{i} = [Sin; Sout];

        %set the net and the time delays of the net
        NN{i} = NN_config();
        NN{i}.config.inputDelays = T{i};

        %the net is trained
        NN{i}=NN_train(input{i},output{i},NN{i});

        %the output is predicted
        output_p{i} = NN_test(input{i},NN{i});
        output_p{i} = output_p{i}(:);

        %the first delay layer is removed from the "true" output
        %("unpredictable points because we have not their past")
        output_t{i} = output{i}(:,max(NN{i}.config.inputDelays)+1:end);
        output_t{i} = output_t{i}(:);

        %the error vector of the prediction using all time series is evaluated
        err_all{i} = (output_p{i}-output_t{i});

        %the variance of the error evaluated
        E_var1(i) = mean(err_all{i}.^2);

        %the same prediction is performed without the influencing class

        %set the input vector
        input{i} = [];
        input{i} = Sout;

        %the net is trained
        NN{i}=NN_train(input{i},output{i},NN{i});

        %the output is predicted
        output_p{i} = NN_test(input{i},NN{i});
        output_p{i} = output_p{i}(:);

        %the error of the prediction is evaluated
        err_t{i} = (output_p{i}-output_t{i});

        %the variance matrix is evaluated
        E_var2(i) = mean(err_t{i}.^2);

        %Loss of prediction accuracy matrix
        Var_ratio(i) = E_var2(i)/E_var1(i);

        %the p-value matrix performed by a Variance test is calculated
        [Mi_p{i},F{i}] = vartest2(err_t{i},err_all{i});

        disp(strcat('Time delay ',num2str(i),' finished'));
    end
    
end
    

Mi_p = cell2mat(Mi_p);
F = cell2mat(F);

figure (1)
clf
subplot(1,2,1)
plot(Var_ratio,'x-.b','MarkerSize',12,'LineWidth',2)
hold on
plot(find(F<p_three,1,'first'),Var_ratio(find(F<p_three,1,'first')),'or','MarkerSize',16,'LineWidth',2)
grid on
xlabel('Time delay')
ylabel('Error Variance Ratio')
axis([-inf inf -inf inf])

subplot(1,2,2)
plot(Mi_p,'x-.b','MarkerSize',12,'LineWidth',2)
hold on
plot(find(F<p_three,1,'first'),Mi_p(find(F<p_three,1,'first')),'or','MarkerSize',16,'LineWidth',2)
grid on
xlabel('Time delay')
ylabel('F-value decision')
axis([-inf inf -0.05 1.05])