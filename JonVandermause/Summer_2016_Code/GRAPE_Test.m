% Jonathan Vandermause
% January 10, 2016
% GRAPE test

% Insert parameters.
nop = 300;
iterations = 100;
delta_guess = 10 : -20 / (nop - 1) : -10;
omega_guess = ones(1, nop);
initial_state = [1,0;0,0];
target_state = [0,0;0,1];
mag_fac = 6.6444e2;

% Choose pulse length.
tau = taus(37);

% Test function.
[fidelity, waveform, progress, mag_fac_final] = ...
    GrapeLZAdapt(nop, tau, iterations, delta_guess, omega_guess, ...
    initial_state, target_state, mag_fac);