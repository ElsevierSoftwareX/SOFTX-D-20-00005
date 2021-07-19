%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%Main_TDNN_CausalityDetection version 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This is the Main for the causality detection.
%The inputs are the time series, while the output is the interaction matrix
tic
%Define the inputs. All time series must be placed in a cell vector S{i}
%where i is the i-th time serie which may influence the others
clear S
S{1}=X;
S{2}=Y;
S{3}=Z;
%S{4} = ...
%S{5} = ...

%load the configuration parameters. To change any parameters, you can go
%inside the NN_config function and change it. Otherwise, you can change the
%parameters here, in the main, after the NN_config application. 

NN = NN_config();

%select 1 is you want to use parallel computing, otherwise 0
parallel_computing = 1;

%select the threshold of the p-value for the decision
p_three = 0.05;

%Main "for" cycle, where the influence of each serie on the i-th variable
%will be tested

%length of S for the next iterative process
N_S = length(S);

%some variable intialisation for faster computing - see later for their
%meaning
cc = cell(N_S,N_S);
E_var_j = zeros(N_S,N_S);
F = zeros(N_S,N_S);
KS = zeros(N_S,N_S);


for i = 1 : N_S
    
    disp(strcat("analysing class ",num2str(i)));
    
    %At first, we predict the output using all the time series
    
    %exctract the output
    output = [];
    output = S{i};
    
    %extract the input
    input = [];
    for k = 1 : N_S 
        input = [input; S{k}];
    end
    
    %the net is trained
    NN=NN_train(input,output,NN);
    
    %the output is predicted
    output_p = NN_test(input,NN);
    output_p = output_p(:);
    
    %the first delay layer is removed from the "true" output
    %("unpredictable points because we have not their past")
    output_t = output(:,max(NN.config.inputDelays)+1:end);
    output_t = output_t(:);
    
    %the error vector of the prediction using all time series is evaluated
    err_all = (output_p-output_t);
    
    %the variance of the error evaluated
    E_var_all(1,i) = mean(err_all.^2);
    
    %The for cycle which predict the i-th time serie without the j-th time
    %serie

    if parallel_computing == 1
        parfor j = 1 : N_S
            disp(strcat("analysing influence of ",num2str(j)," on ",num2str(i)));
           %Inputs preparation
            v = 1 : 1 : N_S;
            v(j) = [];
            input = [];
            for k = 1 : length(v)
                input = [input; S{v(k)}];
            end

            %a string casuality matrix, just for nomenclature
            cc{i,j} = strcat("influence of ", num2str(j)," on ",num2str(i));

            %the net is trained
            NN_t=NN_train(input,output,NN);

            %the output is predicted
            output_p = NN_test(input,NN_t);
            output_p = output_p(:);
            %the error of the prediction is evaluated
            err_t = (output_p-output_t);

            %the variance matrix is evaluated
            E_var_j(i,j) = mean(err_t.^2);
            
            %Loss of prediction accuracy matrix
            Accur_loss(i,j) = E_var_j(i,j)/E_var_all(i);

            %the p-value matrix performed by a Variance test is calculated
            [Mi_p(i,j),F(i,j)] = vartest2(err_t,err_all);
            
            if Accur_loss(i,j)<1
                Mi_p(i,j) = 0;
            end
            
        end
    else
        for j = 1 : N_S
           %Inputs preparation
           disp(strcat("analysing influence of ",num2str(j)," on ",num2str(i)));
            v = 1 : 1 : N_S;
            v(j) = [];
            input = [];
            for k = 1 : length(v)
                input = [input; S{v(k)}];
            end

            %a string casuality matrix, just for nomenclature
            cc{i,j} = strcat("influence of ", num2str(j)," on ",num2str(i));

            %the net is trained
            NN_t=NN_train(input,output,NN);

            %the output is predicted
            output_p = NN_test(input,NN_t);
            output_p = output_p(:);
            %the error of the prediction is evaluated
            err_t = (output_p-output_t);

            %the variance matrix is evaluated
            E_var_j(i,j) = mean(err_t.^2);
            
            %Loss of prediction accuracy matrix
            Accur_loss(i,j) = E_var_j(i,j)/E_var_all(i);

            %the p-value matrix performed by a Variance test is calculated
            [Mi_p(i,j),F(i,j)] = vartest2(err_t,err_all);
            
            if Accur_loss(i,j)<1
                Mi_p(i,j) = 0;
            end
            
        end
    end
    
end

%plot the results
figure (2)

subplot(1,3,1)
heatmap(F);
xlabel("Influencing Class")
ylabel("Influenced Class")
title("p-value")

subplot(1,3,2)
heatmap(Mi_p);
xlabel("Influencing Class")
ylabel("Influenced Class")
title("Decision")

subplot(1,3,3)
heatmap(Accur_loss);
xlabel("Influencing Class")
ylabel("Influenced Class")
title("Error variance ratio")

toc
