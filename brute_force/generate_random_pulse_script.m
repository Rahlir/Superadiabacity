% ------------------------------------------------------------------------------
% Tadeáš Uhlíř
% 03/26/2019
% generate_random_pulse_script script
% ------------------------------------------------------------------------------

filename = 'output/random_pulse.mat';

nop = 60;
w1_max = 8e4;
pl = 50e-6;

[delta_guess, omega_guess] = generate_random_pulse(nop, w1_max);

x = 0 : pl/(nop-1) : pl;
xx = 0 : pl/(nop*5-1) : pl;

delta_guess_fine = spline(x, delta_guess, xx);
omega_guess_fine = spline(x, omega_guess, xx);

dt = pl / (length(delta_guess) - 1);

original_q = get_Q_curves(delta_guess_fine, omega_guess_fine, dt, 10);

save(filename, 'delta_guess_fine', 'omega_guess_fine', 'original_q', 'dt', 'pl')
