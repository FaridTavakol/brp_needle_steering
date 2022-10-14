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

Gab(:,:,1) = [1 0 0 0;...
    0 cosd(beta) -sind(beta) 0;...
    0 sind(beta) cosd(beta) 0;...
    0 0 0 1];
% The position of the origin of the transform Gab in each iteration
FramePos = zeros(3, 1, 1);
FramePos(1:3,1) =  Gab(1:3,4,1)';

% Configuration
insertionSpeed = 10; % mm/s
w_max = 0;%


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
if flag
    plot(FramePos(3,:), FramePos(2,:),'Linewidth',3,'color','r','DisplayName',append('Simulated needle with pitch of ',num2str(beta)));
end

%% Function for plotting a circle
function h = circle(x,y,r, name)
% set(gca,'DataAspectRatio', [1 1 1])
th = 0:pi/5000:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit,'DisplayName',name, 'LineWidth',2, 'LineStyle',':');
end
