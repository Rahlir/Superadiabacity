% Jonathan Vandermause
% June 3, 2017
% Mode visualization

ts = [0 : 0.01 : pi];

% hold on
% plot([0, pi], [1, -1], 'k-')

% hold on
% plot(ts, sin(ts * 2))

hold on
pulse = Q1_Four;
nop = length(ts);
power = 1;
detune_factor = 10;
[omega_1, delta_omega] = Prepare_Initial_Pulse(nop, power, detune_factor);
delta_omega = Get_Four_Func(delta_omega, pulse);
plot(ts, delta_omega / 10)