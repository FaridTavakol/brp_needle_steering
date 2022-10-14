%% Test scipt to evaluate the passive needle inseriton error compensation
% Adding path
close all;
clear;
clc;
addpath("~/Documents/prostate_robot_project/brp_needle_steering/");
addpath('/home/farid/Documents/prostate_robot_project/passive-needle-deflection-error-compensation-using-bicycle-model');
%Load configurations for each needle group
dataExtractor;
needle_groups_config = configs();
%% Initial target and entry point parameters 18G 30 degree
entry_point = [0 0 0]; 
target_point = [0,0,xq(end)];
figure(1);
row = 9;
hold on;
set(gca,'DataAspectRatio', [1 1 1]);
plot(xq,-n_18_G_30_d_yq(row,:),'LineStyle','--','LineWidth',2,'DisplayName','Actual needle track')
plot(xq(end),-n_18_G_30_d_yq(row,end),'Marker','square','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',10,'DisplayName','Actual needle track')
% plot the original target point
beta = needle_groups_config(1).beta_d;
curvature = needle_groups_config(1).curvature;
plot_flag = true;

% estimate the new target point and plot the uncorrected needle path
[corrected_target] = estimate_entry_point(target_point,entry_point(3), curvature, beta, plot_flag);
%% plotting the results
% plot the original target point
plot(target_point(3),target_point(2),'Marker','hexagram','MarkerFaceColor','g','MarkerEdgeColor','k','MarkerSize',15,'DisplayName','Target Point')
yline(0, 'LineStyle','-.','Color','k')
% plot the corrected needle path point
corrected_entry_point = [entry_point(1),corrected_target(2),entry_point(3)]; 
sim_needle_insertion(corrected_entry_point,target_point(3),beta,curvature,plot_flag,'Predicted Compensated needle track');
plot(xq,-n_18_G_30_d_yq(row,:)+corrected_entry_point(2),'LineStyle',':','LineWidth',2,'DisplayName','Actual needle track if compensated')
plot(xq(end),-n_18_G_30_d_yq(row,end)+corrected_entry_point(2),'Marker','*','MarkerFaceColor','g','MarkerEdgeColor','k','MarkerSize',15,'DisplayName','Actual needle tip if compensated')
set(gca,'DataAspectRatio', [1 1 1]);
set(gca, 'FontSize',12, 'FontWeight','bold', 'GridLineStyle','-.')
xlabel('z(mm)')
ylabel('y(mm)')
legend('Location','NorthEast','NumColumns',3, 'box','off')
title('Single Insertion Needle Tracks for 30^{\circ} 18 G needle','Interpreter','tex')
grid on
grid minor
hold off
