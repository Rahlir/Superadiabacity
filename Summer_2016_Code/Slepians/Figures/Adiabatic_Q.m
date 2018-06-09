% Jonathan Vandermause
% January 20, 2017
% Adiabatic Q

time = total_ang * 1.5;
waveform = HZ_1p5;

nop = length(waveform);
time_step = time / nop;
iterations = 10;
x = 0 : time / (nop - 1) : time;

omega_1 = ones(1, nop);

[q, Q] = get_Q_curves(waveform, omega_1, time_step,...
    iterations);

% hold on
% bar(q)

q