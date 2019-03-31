% ------------------------------------------------------------------------------
% Based on:
% Jon Vandermause
% 12/5/2015
% generate_guess_pulse
%
% Tadeáš Uhlíř
% 03/24/19 
% generate_random_pulse function
% ------------------------------------------------------------------------------

function[delta_guess, omega_guess] = generate_random_pulse(nop, w1_max)

    omega_guess = zeros(1, nop);

    % omega_guess is parabolic
    for n = 1 : nop
        omega_guess(n) = (n - 1) * (nop - n) * (w1_max / (nop));
    end

    omega_guess = omega_guess * w1_max / max(omega_guess);

    % choose ramp to maximize q3
    % A = 1408010;
    A = rand * 19e4 + 1e4;
    delta_guess = - A : 2 * A / (nop - 1) : A;
