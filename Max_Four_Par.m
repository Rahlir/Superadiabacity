% Jonathan Vandermause
% July 11, 2016
% Max_Four_Par

% Create Landau-Zener pulse.
nop = 1000;
power = 1;
T = pi;
step = T / nop;
omega_1 = ones(1, nop) * power;
delta_omega = zeros(1, nop);

for n = 1 : nop
    delta_omega(n) = 10 * power - (2 * 10 * power * (n - 1)) / (nop - 1);
end

% Select the superadiabatic Q-factor to maximize.
frame = 3;

% Search for Fourier-optimized pulse that maximizes the Q-factor.
[par, fval] = fmincon(@(par) Fourier_Q(par, delta_omega, ...
    omega_1, T, frame), [10 * rand, 10 * ((rand * 2) - 1), ...
    10 * ((rand * 2) - 1), 10 * ((rand * 2) - 1), ...
    10 * ((rand * 2) - 1)], [], [], [], [], ...
    [1, -Inf, -Inf, -Inf, -Inf], [10, Inf, Inf, Inf, Inf]);

par
1/fval

Four_Func = Get_Four_Func(delta_omega, par);

clf
plot(delta_omega)
hold on
plot(Four_Func)

