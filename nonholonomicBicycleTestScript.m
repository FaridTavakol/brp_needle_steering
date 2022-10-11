% Testing the CURV steering approach
% clc;
% clear;
% close all;

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
%mm
global l2;
l2 = 0; %23.775;  %mm For unicycle model this will be zero
% curvature =9.0402e-04 ;%0.00449;

global V1;
V1 = [e3; LScurvature * e1];
global V2;
V2 = [zeros(3,1); e3];

% Servo loop period, set to 5ms,200hZ
global T;
T = 0.05;

% Simulation configuration
simulationTime = 20;       %second
time = 0:T:simulationTime;  % simulation run time
numberOfIterations = simulationTime/T + 1;



% Initial conditions:
needleTipPos = zeros(3,1,1);
needleTipPos(:,:,1) = [0;0;0];

% Initial coordinate frame
Gab = zeros(4,4, 1);
Gab(4,4,:) = 1;

% Gab(:,:,1) = [1 0 0 0;...
%     0 1 0 0;...
%     0 0 1 0;...
%     0 0 0 1];

% beta = 4.15; % initial entry angle (roll) in degrees
Gab(:,:,1) = [1 0 0 0;...
    0 cosd(beta) -sind(beta) 0;...
    0 sind(beta) cosd(beta) 0;...
    0 0 0 1];
% The position of the origin of the transform Gab in each iteration
FramePos = zeros(3, 1, 1);
FramePos(1:3,1) =  Gab(1:3,4,1)';

% Configuration
insertionSpeed = 10;      % mm/s
w_max = 0;%deg2rad(360*2);   % Max rotation speed of needle in deg/sec
c = 20;         % Need to optimize the gaussian width, this is a tuning parameter


% theta = zeros(1,numberOfIterations);   % Initial steering direction angle
% theta(1) = 0.0;
% RotationSpeed = zeros(1,numberOfIterations);
% w_hat = zeros(1,numberOfIterations);
% TotalInsertionDistance = zeros(1,numberOfIterations);

%% Could also add a rotation speed parameter to override w_max
i = 1;
while FramePos(3,1,i) <= 120

    % Calculate the desired set point position 'theta(k+1)'
    % for the current servo loop interval
    % NEED TO TAKE INTO ACCOUNT 0/360 DEGREE CROSSING


    u1 = insertionSpeed * T;
    u2 = 0;

    % Calculating the kinematics using nonholonomic bicycle model
    [Gab(:,:,i+1), needleTipPos(:,:,i)] = bicycleKinematicsModelOneIteration(Gab(:,:,i), u1, u2);
    FramePos(:,:,i+1) = Gab(1:3,4,i+1);
    i=i+1;
end
%% Plotting the results

%Plot Trajectory
FramePos(2,:) = -1 * FramePos(2,:);
plot(FramePos(3,:), FramePos(2,:),'Linewidth',3, 'DisplayName',append('Simulated needle with pitch of ',int2str(beta)));

%% Evaluate the resultign plot
nx=FramePos(3,1:i)';
ny=FramePos(2,1:i)';
n = [nx,ny];
result = CircleFitByPratt(n);
radius = result(3);
center = [result(1), result(2)];
curv =1/radius;
disp("Curvature of simulated needle: ");
disp(curv);
circle(center(1),center(2),radius, append('sim fit circle pitch of ',int2str(beta)));


%% Function for plotting a circle
function h = circle(x,y,r, name)
% set(gca,'DataAspectRatio', [1 1 1])
th = 0:pi/5000:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'DisplayName',name, 'LineWidth',2, 'LineStyle',':');
end
