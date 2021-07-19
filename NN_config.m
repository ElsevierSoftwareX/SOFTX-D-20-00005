%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%NN_config version 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%this function is the configuration file of the neural net, where some of
%the most important parameters can be changed

function NN=NN_config()
    
    %training function:
    % 'trainlm' is usually fastest.
    % 'trainbr' takes longer but may be better for challenging problems.
    % 'trainscg' uses less memory. Suitable in low memory situations.
    %Please visit mathwork site for further information
    NN.config.trainFnc='trainlm';
    
    %define the delays to apply to the input. The minimum should be always
    %1, while maximum depends on the application
    NN.config.inputDelays = 1:2; 
    
    %define the size of the hidden layers. [5 2] generates two hiddel
    %layers, the first one with 5 neurons and the second one with 2 neurons    
    NN.config.hiddenLayerSize = [6 4];
    
    %Configuration about dataset, which must be divided in training,
    %validation and test. For more information visit mathowork site
    NN.config.divideFcn = 'dividerand';  % Divide data randomly
    NN.config.divideMode = 'time';  % Divide up every sample
    NN.config.divideParam.trainRatio = 70/100;
    NN.config.divideParam.valRatio = 15/100;
    NN.config.divideParam.testRatio = 15/100;

    %training parameters
    NN.config.trainParam.epochs=2000;  %Maximum number of epochs before code stops
    NN.config.trainParam.goal=1e-10;     %Maximum error to reach ("goal") to stop the iterations
    NN.config.trainParam.min_grad=1e-10; %Maximum gradient to reach to stop the iterations
    NN.config.trainParam.Max_fail=3000;  %Minimum number of fails before the iterations stop
    
    NN.config.performFcn = 'mse';       %Performance function. ("mse" = mean squared errors)
    
    %define the plot function available after the training, it is usefull
    %only for training monitoring
    NN.config.plotFcns = {'plotperform','plottrainstate', 'ploterrhist', ...
    'plotregression', 'plotresponse', 'ploterrcorr', 'plotinerrcorr'};

end
