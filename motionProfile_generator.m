clear; close all; clc; 

theta_d=180; alpha=0.9;

c_set= [0 20 40 60 80 135 180];

[theta_A, w_hat_A]=motion_profile(alpha, theta_d, c_set(1)); 
[theta_B, w_hat_B]=motion_profile(alpha, theta_d, c_set(2)); 
[theta_C, w_hat_C]=motion_profile(alpha, theta_d, c_set(3)); 
[theta_D, w_hat_D]=motion_profile(alpha, theta_d, c_set(4)); 
[theta_E, w_hat_E]=motion_profile(alpha, theta_d, c_set(5)); 
[theta_F, w_hat_F]=motion_profile(alpha, theta_d, c_set(6)); 
[theta_G, w_hat_G]=motion_profile(alpha, theta_d, c_set(7)); 

hold on; 
plot(theta_A, w_hat_A, 'b.','Linewidth',6,'MarkerSize', 30);
plot(theta_B, w_hat_B, 'm.','Linewidth',6,'MarkerSize', 30);
plot(theta_C, w_hat_C, 'r.','Linewidth',6,'MarkerSize', 30);
plot(theta_D, w_hat_D, 'k.','Linewidth',6,'MarkerSize', 30);
plot(theta_E, w_hat_E, 'g.','Linewidth',6,'MarkerSize', 30);
plot(theta_F, w_hat_F, 'y.','Linewidth',6,'MarkerSize', 30);
plot(theta_G, w_hat_G, 'c.','Linewidth',6,'MarkerSize', 30);

set(gca,'FontSize',40); 
set(findobj(gca,'Type','text'),'FontSize',40,'FontWeight','bold'); 
xlabel('\theta(deg)')
ylabel('$\hat{w}$','interpreter','Latex'); 
title('Motion Profile')
% legend('c=0','c=30','c=60','c=135','c=225','c=315','c=360');
legend('c=0','c=20','c=40','c=60','c=80','c=135','c=180');

h=get(legend);
h1=h.Children; 
h2=findobj(h1,{'type','patch','-or','type','line'});
grid ON;
for m=1:length(h2)
set(h2(m),'markersize',30); 
end 


