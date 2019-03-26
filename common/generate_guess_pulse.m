% ------------------------------------------------------------------------------
% Based on:
% Jon Vandermause
% 12/5/2015
% Generate guess pulse
%
% Tadeáš Uhlíř
% 03/24/19 
% generate_guess_pulse function
% ------------------------------------------------------------------------------

function[delta_guess, omega_guess] = generate_guess_pulse(nop, pl, w1_max, ...
    frame)

all_frames = true;

if nargin < 4
    all_frames = true;
end

delta_guess = zeros(1, nop);
omega_guess = zeros(1, nop);

% omega_guess is parabolic
for n = 1 : nop
    omega_guess(n) = (n - 1) * (nop - n) * (w1_max / (nop));
end

omega_guess = omega_guess * w1_max / max(omega_guess);

% choose ramp to maximize q3
As = 1e4 : 1 : 2e5;
max_Q = 0;
for n = 1 : length(As)
    A = As(n);
        
    delta = - A : 2 * A / (nop - 1) : A;
    
    Q = get_Q_curves(delta, omega_guess, pl/(nop-1), 10);
    if ~all_frames
        Q_frame = Q(frame);
    else
        Q_frame = max(Q);
    end
    
    if Q_frame > max_Q
        max_Q = Q_frame;
        delta_guess = delta;
    end
end

