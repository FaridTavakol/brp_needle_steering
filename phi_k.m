close all; clear all; clc; 

%% calculate phi 
%{
l1=250;
l2=0;
k=0.004;
phi = acot(sqrt(((1/k)^2-l2^2)/l1^2))*180/pi;

k_inver=1/(sqrt(l2^2+(l1*cot(phi*pi/180))^2));
phi_inver = acot(sqrt(((1/k_inver)^2-l2^2)/l1^2))*180/pi;
%}
%% plot alpha vs k 
%{%}
alpha_set = [0 0.5 0.8 0.9 0.95 0.98 1];
k_set = [0 0.0007 0.0010 0.0016 0.0022 0.0024 0.0041]; 

data=importdata('/home/farid/Documents/prostate_robot_project/NeedleSteeringMatlab/2DCameraPlot/CurvatureFit_Errorbar.xlsx');
errorData=data.data; 
errorZ=errorData(1,:);
% errorY=errorData(5,:);
errorY=k_set;
errorL=errorData(8,:);
errorU=errorData(9,:);

hold on
plot(alpha_set, k_set, '.b-','MarkerSize',35,'LineWidth', 5); 
errorbar(errorZ,errorY, errorL,errorU,'k.','LineWidth',3,'MarkerSize',25);

% axis equal 
set(gca,'FontSize',30); 
set(findobj(gca,'Type','text'),'FontSize',30,'FontWeight','bold'); 
set(gca,'XTick', 0:0.1:1);
% axis([-25 25 -25 25 0 105]);
axis([0 1.1 0 4.5e-3]);
xlabel('\alpha')
ylabel('\kappa (mm^{-1})')
title('Steering Effort (\alpha) vs Curvature (\kappa)')
legend('Linear Interpolation','Experiment Data');
