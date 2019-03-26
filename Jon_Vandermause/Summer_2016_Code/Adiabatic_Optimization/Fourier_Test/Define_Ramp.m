% Jonathan Vandermause
% July 11, 2016
% Define ramp

nop = 300;
power = 1;
T = pi;
step = T / nop;
omega_1 = ones(1, nop) * power;
delta_omega = zeros(1, nop);

for n = 1 : nop
    delta_omega(n) = 10 * power - (2 * 10 * power * (n - 1)) / (nop - 1);
end