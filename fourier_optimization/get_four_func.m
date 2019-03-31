% ------------------------------------------------------------------------------
% function get_four_func - returns Fourier transform of the delta_omega component
% of the pulse
%
% Inputs:
%   delta_ramp - the original delta_omega component of the pulse
%   par - vector containing the parameters used for the Fourier transform
% Outputs:
%   modified_del - the Fourier transform of the delta_ramp
%
% Tadeáš Uhlíř
% 03/31/2019
% Original by:
% Jonathan Vandermause
% July 11, 2016
% ------------------------------------------------------------------------------

function[modified_del] = get_four_func(delta_ramp, par)

    % Reconstruct detuning profile from Fourier modes.

    nop = length(delta_ramp);   % number of points in the pulse
    modified_del = zeros(1, length(delta_ramp));    % initialize detuning

    % Use par (which contains multiplicative factor and Fourier modes) to
    % reconstruct the pulse:
    for n = 1 : nop
        modified_del(n) = par(1) * delta_ramp(n);
        for j = 2 : length(par)
            modified_del(n) = modified_del(n) + par(j) * ...
                sin((j - 1) * pi * (n - 1) / (nop - 1));
        end
    end
