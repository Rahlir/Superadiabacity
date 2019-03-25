% Jonathan Vandermause
% July 11, 2016
% Define ramp

% This script creates a Ladau-Zener pulse.

% Specify parameters of the pulse:
nop = 300;  % set number of points in the pulse
power = 1;  % amplitude of drive field
T = pi;     % duration of the tranition
step = T / nop; % step size
omega_1 = ones(1, nop) * power; % drive field (independent of time)
detune_fac = 10;    % determines the detuning at the beginning of pulse

delta_omega = zeros(1, nop);    % initialize detuning
for n = 1 : nop
    % create ramp
    delta_omega(n) = detune_fac * power - ...
        (2 * detune_fac * power * (n - 1)) / (nop - 1);
end

figure
plot(delta_omega)