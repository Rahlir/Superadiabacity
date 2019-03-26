% Jonathan Vandermause
% May 28, 2017
% Prepare Initial Pulse

function[omega_1, delta_omega] = Prepare_Initial_Pulse(nop, power, ...
    detune_factor)

omega_1 = ones(1, nop) * power;
delta_omega = zeros(1, nop);
for n = 1 : nop
    delta_omega(n) = detune_factor * power - ...
        (2 * detune_factor * power * (n - 1)) / (nop - 1);
end