%% Test scipt to evaluate the passive needle inseriton error compensation
% Adding path
close all;
clear;
clc;
addpath("~/Documents/prostate_robot_project/brp_needle_steering/");
addpath('/home/farid/Documents/prostate_robot_project/passive-needle-deflection-error-compensation-using-bicycle-model');
%Load configurations for each needle group
needle_groups_config = configs();
%% Initial target and entry point parameters 18G 30degree
entry_point = [0,0,0]; 
target_point = [0,0,190];
beta = needle_groups_config(1).beta_d;
curvature = needle_groups_config(1).curvature;
plot_flag = true;
figure(1);
hold on;
% estimate the new target point and plot the uncorrected needle path
[corrected_target] = estimate_entry_point(target_point,entry_point(3), curvature, beta, plot_flag);
%% plotting the results
% plot the original target point
plot(target_point(3),target_point(2),'Marker','hexagram','MarkerFaceColor','g','MarkerEdgeColor','k','MarkerSize',15,'DisplayName','Target Point')
% plot the corrected needle path point
corrected_entry_point = [0,corrected_target(2),0]; 
sim_needle_insertion(corrected_entry_point,target_point(3),beta,curvature,plot_flag);
plot(189.684,-27.9593,'Marker','o','MarkerFaceColor','r','MarkerEdgeColor','k','MarkerSize',15,'DisplayName','Uncompensated Tip Location')
set(gca,'DataAspectRatio', [1 1 1]);
set(gca, 'FontSize',16, 'FontWeight','bold', 'GridLineStyle','-.')
xlabel('z(mm)')
ylabel('y(mm)')
legend('Location','NorthEast','NumColumns',3, 'box','off')
title('Single Insertion Needle Tracks for 30^{\circ} 18 G needle','Interpreter','tex')
grid on
grid minor
hold off
