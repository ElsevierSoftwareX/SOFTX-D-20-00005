%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%NN_train
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%this is the training function of the neural network. 
%It needs input, output and the NN structure from the NN_config function
%the output is the NN structure with the trained net

function NN=NN_train(input,output,NN)
    
    %input and output are converted for the training
    X = tonndata(input,true,false);
    T = tonndata(output,true,false);
    
    %A parameter needed for the test, see MAIN_NN_CausalityDetection
    NN.config.outsize=size(output,1);

    %the initialisation parameters are set from the config NN.config
    %structure
    trainFcn = NN.config.trainFnc;
    inputDelays = NN.config.inputDelays;
    hiddenLayerSize = NN.config.hiddenLayerSize;

    %the TDNN is generated
    net = timedelaynet(inputDelays,hiddenLayerSize,trainFcn); 

    %Data are prepared for the training
    [x,xi,ai,t] = preparets(net,X,T); 

    %Other net parameters are set from the configuration file
    
    %training-validation-test set
    net.divideFcn = NN.config.divideFcn;
    net.divideMode = NN.config.divideMode;
    net.divideParam.trainRatio = NN.config.divideParam.trainRatio;
    net.divideParam.valRatio = NN.config.divideParam.valRatio;
    net.divideParam.testRatio = NN.config.divideParam.testRatio;
   
    %performance function
    net.performFcn=NN.config.performFcn;

    %training parameters
    net.trainParam.epochs=NN.config.trainParam.epochs;
    net.trainParam.goal=NN.config.trainParam.goal;
    net.trainParam.min_grad=NN.config.trainParam.min_grad;
    net.trainParam.Max_fail=NN.config.trainParam.Max_fail;

    %plot functions
    net.plotFcns=NN.config.plotFcns;

    %The network is trained
    net = train(net,x,t,xi,ai);
    
    %The network is put in the NN structure
    NN.net=net;

end


    
