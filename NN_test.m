%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%NN_test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This function aims to predict the output data with input data

function predicted=NN_test(input,NN)
    
    %Generate a output like vector, which will be used only for input data
    %preparation
    y_app=ones(NN.config.outsize,size(input,2));
    
    %input and "output" are converted for the test
    X = tonndata(input,true,false);
    T = tonndata(y_app,true,false);
    
    %input data is prepared for the test
    [x2,xi2,ai2,~] = preparets(NN.net,X,T);
    
    %output is predicted from input
    predicted=cell2mat(NN.net(x2,xi2,ai2));

end