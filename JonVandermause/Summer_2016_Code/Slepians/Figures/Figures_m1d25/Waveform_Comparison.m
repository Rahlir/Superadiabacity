% Jonathan Vandermause
% January 25, 2017
% Waveform Comparison

nop = length(Slep_Short);
not = length(HZ_1p5);
t_frac = 0 : 1 / (nop - 1) : 1;
t_HZ = 0 : 1 / (not - 1) : 1;

figure

% Plot optimal time derivative of control angle.
subplot(1, 2, 1)
plot(t_frac, Slep_Short)
hold on
plot(t_frac, Slep_1p5)

% Plot finite time control waveforms.
subplot(1, 2, 2)
plot(t_HZ, HZ_short)
hold on
plot(t_HZ, HZ_1p5)

