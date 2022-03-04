% Testing the CURV steering approach
clc;
clear;
close all;

% phi = 0.1984;   %constant front wheel angle, radians, 0.1984*180/pi=11.34deg
% k = -1/sqrt(l2^2+(l1*cot(phi))^2)   %curvature (1/r) or k= tan(phi)/l1

% Unit Vectors
global e1;
e1 = [1;0;0];
global e2;
e2 = [0;1;0];
global e3;
e3 = [0;0;1];

% Geometric Relations
global l1;
l1 = 20;      %mm
global l2;
l2 = 5.633;  %mm
global curvature;
curvature = 0.1938;

global V1;
V1 = [e3; curvature * e1];
global V2;
V2 = [zeros(3,1); e3];

% Servo loop period, set to 5ms,200hZ
global T;
T = 0.005;

% Simulation configuration
simulationTime = 40;       %second
time = 0:T:simulationTime;  % simulation run time
numberOfIterations = simulationTime/T + 1;



% Initial conditions:
insertionSpeed = 3;      % mm/s
% rotationSpeed = 32*pi;     % rad/s
needleTipPos = zeros(3,1,numberOfIterations);
needleTipPos(:,:,1) = [0;0;0];

% Initial coordinate frame
Gab = zeros(4,4, numberOfIterations);
Gab(4,4,:) = 1;

Gab(:,:,1) = [1 0 0 0;...
    0 1 0 0;...
    0 0 1 0;...
    0 0 0 1];
% The position of the origin of the transform Gab in each iteration
FramePos = zeros(3, 1, numberOfIterations);
FramePos(1:3,1) =  Gab(1:3,4,1)';

% Configuration
% w_max =deg2rad(100);   % Max rotation speed of needle in deg/sec
w_max =100;   % Max rotation speed of needle in deg/sec
c = 20;         % Need to optimize the gaussian width, this is a tuning parameter


theta = zeros(1,numberOfIterations);   % Initial steering direction angle
RotationSpeed = zeros(1,numberOfIterations);
TotalInsertionDistance = zeros(1,numberOfIterations);

% Command inputs, would come from higher level java control loop
theta_d =180;   % Desired steering direction (0 - 360) (0 is in y-z plane)
alpha = 0.9;     % Steering effort (0 - 1), 0: straight, 1 curved
% Could also add a rotation speed parameter to override w_max

for i = 1:numberOfIterations
    % Calculate the desired set point position 'theta(k+1)'
    % for the current servo loop interval
    %% NEED TO TAKE INTO ACCOUNT 0/360 DEGREE CROSSING
    % control input inside control loop to generate complex curve
    %     if k<0.5*(size(time,2)-1)
    %       theta_d =180;
    %       alpha = 0;
    %     else
    %       theta_d =180;
    %       alpha = 0.8;
    %     end
    
    %CHECK
    if((theta(i)-theta_d)>180)
        w_hat = 1 - alpha * exp(-(360-(theta(i)-theta_d))^2 / (2*c^2));
    else
        w_hat = 1 - alpha * exp(-(theta(i)-theta_d)^2 / (2*c^2));
    end
    
    
    % w = w_max * w^
    RotationSpeed(i) = w_hat * w_max;
    
    % Determine angle for the next iteration
    theta(i+1) = theta(i) + RotationSpeed(i) * T;
    if(theta(i+1)>360)
        theta(i+1) = theta(i+1) - 360;
    end
    
    % Change in the insertion
    u1 = insertionSpeed * T;
    TotalInsertionDistance(i+1) = TotalInsertionDistance(i) + u1;
    % Change in the angle
    u2 = RotationSpeed(i) * T;
    % Calculating the kinematics using nonholonomic bicycle model   
    [Gab(:,:,i+1), needleTipPos(:,:,i+1)] = bicycleKinematicsModelOneIteration(Gab(:,:,i), u1, u2, T);
    FramePos(:,:,i+1) = Gab(1:3,4,i+1);
    
end
% Display output
figure(1)
hold on;
subplot(2,1,1)
plot(time,theta(1:end-1),'r','Linewidth',2);
grid on
title('Needle Rotation Angle Setpoints')
xlabel('Time (sec)')
ylabel('Rotation Angle')
subplot(2,1,2)
plot(time,RotationSpeed,'b','Linewidth',2);
grid on
title('Needle Rotation Speed')
xlabel('Time (sec)')
ylabel('Rotation Speed')

%Plot Trajectory
figure(2);
hold on;
plot3(needleTipPos(1,1:end),needleTipPos(2,1:end), needleTipPos(3,1:end), 'r','Linewidth',2);
plot3(FramePos(1,:), FramePos(2,:), FramePos(3,:), 'b','Linewidth',2);
grid on
xlabel('x(cm)')
ylabel('y(cm)')
zlabel('z(cm)')
title('simulated trajectory')
legend('tip','frame')
axis equal

%Plot Trajectory
figure(6);
hold on;
plot(needleTipPos(3,:),needleTipPos(2,:), 'r','Linewidth',2);
plot(FramePos(3,:), FramePos(2,:), 'b','Linewidth',2);
grid on
xlabel('z(cm)')
ylabel('y(cm)')
title('simulated trajectory')
% legend('tip','frame')
% axis equal


%Plot Trajectory
figure(3);
subplot(2,1,1)
hold on;
plot(FramePos(3,:), FramePos(2,:), 'b','Linewidth',2);
grid on
ylabel('y(cm)')
xlabel('z(cm)')
title('simulated trajectory of frame vs time')
% axis equal
subplot(2,1,2)
hold on;
plot(FramePos(3,:), FramePos(1,:), 'b','Linewidth',2);
grid on
ylabel('x(cm)')
xlabel('z(cm)')
% axis equal

%Plot Trajectory
figure(4);
hold on;
plot(time, [needleTipPos(1,1:end-1); needleTipPos(2,1:end-1)]);
grid on
title('simulated trajectory of tip vs time')
xlabel('Time(sec)')
ylabel('position(cm)')
legend('x','y')