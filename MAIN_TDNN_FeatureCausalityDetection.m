%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%Main_TDNN_CausalityDetection_multiNETstatistics version 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This is the Main for the causality feature detection.
%You need to set the influencing time and influence system

%set the input
clear S

%influencing time series
Sin = X;

%here you can add other time series which influences the output, but that
%you are not interested in understanding the feature (or maybe they
%haven't)
Sin_other = []; 

%influenced time series
Sout=Y;

%Set the configuration file of the net
NN = NN_config();

%Predict the time series with all systems
input = [Sin;Sin_other;Sout];
output = Sout;

%the net is trained
NN=NN_train(input,output,NN);

%the output is predicted
output_p1 = NN_test(input,NN);

%the first delay layer is removed from the "true" output
%("unpredictable points because we have not their past")
output_t = output(:,max(NN.config.inputDelays)+1:end);

%the error between the data and the model is calculated
err_all = output_p1 - output_t;

%Predict the time series without the influencing time series in Sin
input = [Sin_other;Sout];
output = Sout;

%the net is trained
NN=NN_train(input,output,NN);

%the output is predicted
output_p2 = NN_test(input,NN);

%the error between the data and the model is calculated
err_t = output_p2 - output_t;

%calculate the error features
Err_features = mean(abs(err_t.^2-err_all.^2),1).^0.5;

%calculate where the error is out from the statistics
Err_median = median(mean((err_all).^2,1).^0.5);
Err_std = std(mean((err_all).^2,1).^0.5);

Features = (movmean(Err_features-Err_median,[2 2]))/Err_std>3;

%plot
figure (1)
clf
subplot(1,2,1)
plot(t(max(NN.config.inputDelays)+1:end),Err_features)
xlabel('time')
ylabel('Absolute error')
grid on
axis([min(t) max(t) -inf inf])

subplot(1,2,2)
plot(t(max(NN.config.inputDelays)+1:end),Features,'r')
xlabel('time')
ylabel('Detected Features')
grid on
axis([min(t) max(t) -0.01 1.05])
