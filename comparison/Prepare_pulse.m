% ------------------------------------------------------------------------------
% script Prepare_pulse - Script to prepare initial pulse to be used for the
% optimization using different methods
% 
% Tadeáš Uhlíř
% 05/06/2020
% ------------------------------------------------------------------------------

nop = 1000;
power = 1;

A = 10;
kappa = 15;

pulse_t = 2 * pi;

omega_1 = ones(1, nop) * power;
delta_omega_init = get_tanh(nop, A, kappa, 1, 1, pulse_t/nop);

initial_Q = get_Q_curves(delta_omega_init, omega_1, pulse_t/nop, 10);
for qn = 1:10
    fprintf('Q%02d: %.4f\n', qn, initial_Q(qn))
end
