function [x,y,actual_insertion] = sim_needle_insertion(entry_point,z_tgt,beta,curvature, plot_flag)
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
global V1;
V1 = [e3; curvature * e1];
global V2;
V2 = [zeros(3,1); e3];
% Servo loop period, set to 5ms,200hZ
global T;
T = 0.05;
% Initial conditions:
needleTipPos = zeros(3,1,1);
needleTipPos(:,:,1) = [0;0;0];
y_entry  = entry_point(2);
% Initial coordinate frame
Gab = [1 0 0 entry_point(1);...
    0 cosd(beta) -sind(beta) y_entry;...
    0 sind(beta) cosd(beta) entry_point(3);...
    0 0 0 1];
% The position of the origin of the transform Gab in each iteration
FramePos = zeros(3, 1, 1);
FramePos(1:3,1) =  Gab(1:3,4,1)';
% Configuration
insertionSpeed = 10; % mm/s
%% Could also add a rotation speed parameter to override w_max
i = 1;
u1 = insertionSpeed * T;
actual_insertion = 0;
u2 = 0;
while FramePos(3,1,i) <= z_tgt
    % Calculating the kinematics using nonholonomic bicycle model
    actual_insertion = actual_insertion + u1;
    [Gab(:,:,i+1), needleTipPos(:,:,i)] = bicycleKinematicsModelOneIteration(Gab(:,:,i), u1, u2);
    FramePos(:,:,i+1) = Gab(1:3,4,i+1);
    i=i+1;
end
x = FramePos(3,:);y = FramePos(2,:);
if plot_flag
    plot(FramePos(3,:), FramePos(2,:),'Linewidth',3,'color',rand(1,3),'DisplayName',append('Simulated needle with pitch of ',num2str(beta)));
end
end



