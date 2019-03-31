% ------------------------------------------------------------------------------
% function prepare_initial_pulse - generates the initial pulse to be used in the
% Fourier optimization
%
% Inputs:
%   nop - numper of data points for the pulse
%   power - parameter controlling the steepness of the delta ramp and height of
%           omega_1
%   detune_factor - detuning factor for the delta ramp
% Outputs:
%   omega_1 - omega_1 component of the pulse
%   delta_omega - delta_omega component of the pulse
%
% Tadeáš Uhlíř
% 03/31/2019
% Original by:
% Jonathan Vandermause
% May 28, 2017
% ------------------------------------------------------------------------------

function[omega_1, delta_omega] = prepare_initial_pulse(nop, power, ...
    detune_factor)

    omega_1 = ones(1, nop) * power;
    delta_omega = zeros(1, nop);
    for n = 1 : nop
        delta_omega(n) = detune_factor * power - ...
            (2 * detune_factor * power * (n - 1)) / (nop - 1);
    end
