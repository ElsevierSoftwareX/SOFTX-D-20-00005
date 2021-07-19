%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2020 QEP Research Group
%Main_generate_system_forFeatureDetection version 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code generates three Lorenz systems which interact depending on
%the values of the interaction terms

%Moreover,if system 1 (X) influences system 2 (Y), the influence has
%boolean condition. 

%Use this code fot the influencing features detection

clear; clc; 

%Definition of the number of points for the simulation (Nt), time step (dt) and time vector
%(t)
Nt = 1e4+1;
dt = 0.003;
t = 0:dt:(Nt-1)*dt;

%Definition of the Lorentz system constants (equal for all systems)
sigma = 10;
r = 28;
b = 8/3;

%definition of the influence coefficients (mijk means that j influence k)
mi21 = 0;
mi31 = 0;
mi12 = 1;
mi32 = 0;
mi13 = 0;
mi23 = 1;

%Random noise can be added for noise sensitivity analysis
I_noise = 0.05;

%initialisation of the vector. The first point is chosen randomly. Thus,
%any new numerical simulation will be different
x1=zeros(size(t)); x1(1) = rand()*5;
x2=zeros(size(t)); x2(1) = rand()*5;
x3=zeros(size(t)); x3(1) = rand()*5;
y1=zeros(size(t)); y1(1) = rand()*5;
y2=zeros(size(t)); y2(1) = rand()*5;
y3=zeros(size(t)); y3(1) = rand()*5;
z1=zeros(size(t)); z1(1) = rand()*5;
z2=zeros(size(t)); z2(1) = rand()*5;
z3=zeros(size(t)); z3(1) = rand()*5;

%The system is solved at any time step. The solution is performed by an
%Euler backward numerical scheme.

for i = 2:Nt
    %system 1
    x1(i) = x1(i-1) + sigma*(x2(i-1)-x1(i-1))*dt;
    x2(i) = x2(i-1) + (r*x1(i-1) - x2(i-1) - x1(i-1)*x3(i-1) + mi21*y2(i-1)^2+mi31*z3(i-1)^2)*dt;
    x3(i) = x3(i-1) + (x1(i-1)*x2(i-1) - b*x3(i-1))*dt;
    
    %boolean condition for X influencing Y
    if x2(i-1) > 10
        mi12t(i) = mi12;
    else
        mi12t(i) = 0;
    end
    
    %system 2
    y1(i) = y1(i-1) + sigma*(y2(i-1)-y1(i-1))*dt;
    y2(i) = y2(i-1) + (r*y1(i-1) - y2(i-1) - y1(i-1)*y3(i-1) + mi12t(i)*x2(i-1)^2+mi32*z3(i-1)^2)*dt;
    y3(i) = y3(i-1) + (y1(i-1)*y2(i-1) - b*y3(i-1))*dt;
    %system3
    z1(i) = z1(i-1) + sigma*(z2(i-1)-z1(i-1))*dt;
    z2(i) = z2(i-1) + (r*z1(i-1) - z2(i-1) - z1(i-1)*z3(i-1) + mi13*x2(i-1)^2+mi23*y2(i-1)^2)*dt;
    z3(i) = z3(i-1) + (z1(i-1)*z2(i-1) - b*z3(i-1))*dt;
end

%The equations of a System are linked togheter
X = [x1; x2; x3];
Y = [y1; y2; y3];
Z = [z1; z2; z3];

%The influence matrix is created
Mi = [1 mi12 mi13; mi21 1 mi23; mi31 mi32 1];
Mi = Mi';

%Noise adding
X = normrnd(X,I_noise);
Y = normrnd(Y,I_noise);
Z = normrnd(Z,I_noise);

%Plot the three systems
figure (1)
clf
subplot(1,3,1)
plot3(X(1,:),X(2,:),X(3,:))
grid on
xlabel('x_1')
ylabel('x_2')
zlabel('x_3')

subplot(1,3,2)
plot3(Y(1,:),Y(2,:),Y(3,:))
grid on
xlabel('y_1')
ylabel('y_2')
zlabel('y_3')

subplot(1,3,3)
plot3(Z(1,:),Z(2,:),Z(3,:))
grid on
xlabel('z_1')
ylabel('z_2')
zlabel('z_3')

figure (2)
clf 
plot(mi12t,'r')

%useless and redundant parameters are removed
clear x1 x2 x3 y1 y2 y3 z1 z2 z3
clear i r sigma b mi12 mi21 mi23 mi32 mi13 mi31
clear dt I_noise Nt 

