% ------------------------------------------------------------------------------
% script generate_random_pulse_script - generates random guess pulse to be
% optimized later and saves it to the disc
% 
% Tadeáš Uhlíř
% 03/26/2019
% ------------------------------------------------------------------------------

filename = 'random_pulse_new.mat';

nop = 60;
w1_max = 8e4;
pl = 60e-6;

[delta_guess, omega_guess] = generate_random_pulse(nop, w1_max);

x = 0 : pl/(nop-1) : pl;
xx = 0 : pl/(nop*5-1) : pl;

delta_guess_fine = spline(x, delta_guess, xx);
omega_guess_fine = spline(x, omega_guess, xx);

dt = pl / (length(delta_guess_fine) - 1);

original_q = get_Q_curves(delta_guess_fine, omega_guess_fine, dt, 10);

save(filename, 'delta_guess_fine', 'omega_guess_fine', 'original_q', 'dt', 'pl')
