% ------------------------------------------------------------------------------
% function Fourier_Q - returns Q factor of the pulse modified using the Fourier
% transform. Used in 'fmincon' matlab function
%
% Inputs:
%   par - vector containing the parameters used in the Fourier transform
%   delta_ramp - delta_omega component of the pulse that has usually the form of
%                ramp
%   omega_1 - omega_1 component of the pulse
%   pl - pulse length
%   frame - frame for which the pulse is optimized
% Outputs:
%   Q_n - Q factor of the pulse found with the Fourier transform
%
% Tadeáš Uhlíř
% 03/31/2019
% Original by:
% Jonathan Vandermause
% July 11, 2016
% ------------------------------------------------------------------------------

function[Q_n] = fourier_q(par, delta_ramp, omega_1, pl, frame)

    nop = length(delta_ramp);   % number of points in the pulse
    step = pl / nop;    % time duration of each step

    modified_del = zeros(1, length(delta_ramp));    % initialize pulse
    for n = 1 : nop
        % The first entry of par multiplies the detuning by a constant factor:
        modified_del(n) = par(1) * delta_ramp(n);
        for j = 2 : length(par)
            % Subsequent entries of par add a sinuisoid of definite frequency
            % to the detuning:
            modified_del(n) = modified_del(n) + par(j) * ...
                sin((j - 1) * pi * (n - 1) / (nop - 1));
        end
    end

    % Calculate the reciprocal of the Q-factor, which will be minimized in
    % order to maximize adiabaticity:
    Q_n = 1 / get_Qn_new(modified_del, omega_1, step, frame);
