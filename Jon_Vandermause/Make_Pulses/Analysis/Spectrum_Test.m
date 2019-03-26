% Jonathan Vandermause
% July 22, 2017
% Spectrum Test

header = '~/Desktop/Data/Short_Slepian/';
exp_no = 2;
phase_no = 1e4;

peaks = [3929, 4577];

signal = return_signal(header, exp_no) / 1e6;
[phase, max_val, x, y] = max_phase(signal, peaks, phase_no)

figure
plot(real(signal))
hold on
plot(real(signal * exp(1i * phase)))

test = real(signal);