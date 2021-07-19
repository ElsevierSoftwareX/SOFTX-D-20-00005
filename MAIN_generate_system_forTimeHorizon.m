%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%Main_generate_system version 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code generates one Lorenz system which is infuenced by a random
%signal y by a time delay dt_inf

%this code can be used to test software with time series having different
%parameters

clear; clc; 

%Definition of the number of points (Nt), time step (dt) and time vector
%(t)
Nt = 1e4+1;
dt = 0.005;
t = 0:dt:(Nt-1)*dt;

%Definition of the Lorentz system constants (equal for all systems)
sigma = 10;
r = 28;
b = 8/3;

%definition of the influence coefficients (mijk means that j influence k)
mi = 10;

%Definition of the time delays (minimum is 1)
dt_inf = 3;

%Random noise can be added for noise sensitivity analysis
I_noise = 0.02;

%initialisation of the vector. The first point is chosen randomly. Thus,
%any new numerical simulation will be different
x1=zeros(size(t)); x1(1:dt_inf) = rand()*5;
x2=zeros(size(t)); x2(1:dt_inf) = rand()*5;
x3=zeros(size(t)); x3(1:dt_inf) = rand()*5;

%vector y (random values) generation
y = normrnd(1,1,1,Nt);

%The system is solved at any time step. The solution is performed by an
%Euler backward numerical scheme.

for i = dt_inf+1:Nt
    %system X
    x1(i) = x1(i-1) + sigma*(x2(i-1)-x1(i-1))*dt;
    x2(i) = x2(i-1) + (r*x1(i-1) - x2(i-1) - x1(i-1)*x3(i-1) + mi*y(i-dt_inf)^2)*dt;
    x3(i) = x3(i-1) + (x1(i-1)*x2(i-1) - b*x3(i-1))*dt;
end

%The equations of a System are linked togheter
X = [x1; x2; x3];

%Noise adding
X = normrnd(X,I_noise);


%Plot the system
figure (1)
clf
plot3(X(1,:),X(2,:),X(3,:))
grid on
xlabel('x_1')
ylabel('x_2')
zlabel('x_3')

%useless and redundant parameters are removed
clear x1 x2 x3 
clear i r sigma b 
clear dt I_noise Nt 

