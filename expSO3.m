function M = expSO3(w)
% 
% M = expSO3(w^)
% w is the skew-symmetric matrix generated by the 3-vector W
% Angle theta is |W| where W isthe 3-vector so3
% Computes the exponential map M of 3x3 SO3 Lie algebra w^, M = exp(w^)
% 

W = fromLieSO3(w);
L = sqrt(W(1)^2 + W(2)^2 + W(3)^2);
M = eye(3) + (sin(L)/L * w) + ((1-cos(L))/L^2 * w^2);