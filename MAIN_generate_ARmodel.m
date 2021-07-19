%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%Main_generate_ARmodel version 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code generates three Lorenz systems which interact depending on
%the values of the interaction terms

clear; clc; 

%Definition of the number of points for the simulation (Nt), time step (dt) and time vector
%(t)
Nt = 1e4;
t = 1:Nt;

%definition of the influence coefficients C 
C = 0.2;

%Random noise can be added for noise sensitivity analysis
I_noise = 0.0;

%initialisation of the vector. The first point is chosen randomly. Thus,
%any new numerical simulation will be different
x=zeros(size(t)); x1(1) = rand()*1;
y=zeros(size(t)); y1(1) = rand()*1;

%The system is solved at any time step. 

for i = 2:Nt
   
    x(i) = 0.5*x(i-1) + 0.2*y(i-1) + normrnd(0,0.1);
    y(i) = C*x(i-1) + 0.7*y(i-1) + normrnd(0,0.1);
    
end

%Noise adding
x = normrnd(x,I_noise);
y = normrnd(y,I_noise);

%Plot the three systems
figure (1)
clf
plot(x,y)
grid on
xlabel('x')
ylabel('y')
