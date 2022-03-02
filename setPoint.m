function thetaSet=setPoint(alpha,c,theta_d,w_max,T, theta)
% This function calculates the desired angular velocity given CURV
% parameters.
% Alpha is steering effort 
% c is Gaussian width
% Theta_d is desired theta
% w_max is maximum angular speed 
% T is timestep
% theta is current angle of the needle axis
    w_hat = 1 - alpha * exp(-(theta-theta_d)^2 / (2*c^2));
    delta_theta = w_max * w_hat * T;
    thetaSet = theta + delta_theta;
end