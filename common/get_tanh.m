% ------------------------------------------------------------------------------
% function get_tanh - returns delta_omega and the omega_1 pulse of the tan/tanh pulse
% 
% Inputs:
%   number_of_points - number of data points for the pulse
%   A - parameter A that multiplies the tan function of delta_omega
%   kappa - the parameter used to divide the tan function and as an argument of the
%           arctan of the delta_omega component of the pulse
%   w_1_max - parameter that multiplies the tanh function of omega_1
%   squiggle - parameters inside the tanh function of the omega_1 pulse
%   time_step - time between each data points of the pulse vector
% Outputs:
%   delta_omega - delta_omega component of the tan/tanh pulse
%   omega_1 - omega_1 component of the tan/tanh pulse
%   Q_n - the Q factor of the pulse in the first 10 superadiabatic frames
%
% Tadeáš Uhlíř
% 03/31/2019
% Based on:
% Jon Vandermause
% 1/30/2015
% ------------------------------------------------------------------------------

function[delta_omega, omega_1, Q_n] = get_tanh(number_of_points, A, kappa, w_1_max, ...
                                               squiggle, time_step)

    % This pulse is taken from Hwang/Garwood 1998.

    delta_omega = zeros(1,number_of_points);
    omega_1 = zeros(1,number_of_points);
    tau = number_of_points-1;

    for n = 0:tau
        % Notice we've flipped delta_omega compared to Fig. 3(f) in
        % Deschamps et. al:
        delta_omega(n+1)=A*tan(atan(kappa)*(1-2*n/tau))/kappa;
        
        % omega_1 is a combination of two curves:
        if n <= round(number_of_points/2)
            omega_1(n+1)=w_1_max*tanh(squiggle * 2 * n / tau);
        else
            omega_1(n+1)=w_1_max*tanh(squiggle * 2 * (tau - n) / tau);
        end
    end

    Q_n = get_Q_curves(delta_omega, omega_1, time_step, 10);
