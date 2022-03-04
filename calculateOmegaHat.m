function w_hat = calculateOmegaHat(theta,alpha,theta_d,c)
% This function calculates the desired angular velocity using curv steering
% theta is the current angle 
%
w_hat = 1 - alpha * exp(-(theta-theta_d)^2 / (2*c^2));

end