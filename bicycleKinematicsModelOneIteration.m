function [gab, nb] = bicycleKinematicsModelOneIteration(gab0, u1, u2)
% 
% function [gab, nb, i] = BMRun(gab0, nb, i, du1, du2, time)
%   gab0 = Initial Frame B to Frame A transformation
%   du1 = Needle insertion distance for this iteration
%   du2 = Needle rotational angle for this iteration 

% Access configuration parameters
global e3;
global V1;
global V2;
global l2;

%Solve kinematics for this iteration
gab = gab0 * expSE3(toLieSE3((u1 * V1) + (u2 * V2)));
nb = (gab0(1:3,1:3) * l2 * e3) + gab0(1:3,4);

