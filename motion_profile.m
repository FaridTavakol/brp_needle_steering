function [theta , w_hat]=motion_profile(alpha,theta_d,c)

full_rotation = 360;
theta = zeros(full_rotation);
w_hat = zeros(full_rotation);

for i=1:1:full_rotation
    theta(i)=i-1; 
%   the if statement does not make any sense.
%   The theta value should always be scaled to a value between 0-360 before
%   being passed to this function  
    if((theta(i)-theta_d)>180)
        w_hat(i) = 1 - alpha * exp(-(360-(theta(i)-theta_d))^2 / (2*c^2));
    else
        w_hat(i) = 1 - alpha * exp(-(theta(i)-theta_d)^2 / (2*c^2));
    end    
end 
