% Jonathan Vandermause
% July 11, 2016
% Fourier Q

function[Q_n] = Fourier_Q(par, delta_ramp, omega_1, pl, frame)

nop = length(delta_ramp);   % number of points in the pulse
step = pl / nop;    % time duration of each step

modified_del = zeros(1, length(delta_ramp));    % initialize pulse
for n = 1 : nop
    % The first entry of par multiplies the detuning by a constant factor:
    modified_del(n) = par(1) * delta_ramp(n);
    for j = 2 : length(par)
        % Subsequent entries of par add a sinuisoid of definite frequency
        % to the detuning:
        modified_del(n) = modified_del(n) + par(j) * ...
            sin((j - 1) * pi * (n - 1) / (nop - 1));
    end
end

% Calculate the reciprocal of the Q-factor, which will be minimized in
% order to maximize adiabaticity:
Q_n = 1 / get_Qn_new(modified_del, omega_1, step, frame);