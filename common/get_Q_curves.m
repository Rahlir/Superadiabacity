% 2/16/2015
% reviewed 10/31/2015
% Jon Vandermause
% get adiabatic Qs

function [q, Q] = get_Q_curves(delta, one, time_step, iterations)

% q is the vector of q_n, where n is the adiabatic frame.
q = zeros(iterations, 1);

alpha = zeros(iterations, length(delta));
alpha_dot = zeros(iterations, length(delta));
omega = zeros(iterations, length(delta));
Q = zeros(iterations, length(delta));

% Set the first iteration.
alpha(1, :) = correct_atan(delta,one);
for n = 1:length(delta)-2
    alpha_dot(1,n) = (alpha(1, n+2) - alpha(1, n)) / (2*time_step);
    omega(1,n) = sqrt(one(n+1)^2 + delta(n+1)^2);
    Q(1,n) = omega(1,n)/abs(alpha_dot(1,n));
end
q(1) = min(Q(1,1:length(delta) - 2));


% Iterate over superadiabatic frames.
for n = 2 : iterations
    % Number of points drops by two for each iteration.
    alpha(n, :) = correct_atan(alpha_dot(n - 1,:),omega(n - 1,:));
    
    number_of_points = length(delta) - 2 * n;
    for p = 1 : number_of_points
        alpha_dot(n, p) = (alpha(n, p+2) - alpha(n, p)) / (2 * time_step);
        omega(n, p) = sqrt(omega(n - 1, p + 1)^2 + alpha_dot(n - 1, p + 1)^2);
        Q(n, p) = omega(n, p) / abs(alpha_dot(n, p));
    end
    q(n) = min(Q(n,1 : number_of_points));
end
        
        
    
