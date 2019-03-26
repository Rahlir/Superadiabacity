% Jonathan Vandermause
% January 24, 2017
% Q Vs Tau

waveform = HZ_short;
not = 1000;
t_min = total_ang / 1.5;
t_max = total_ang * 3;
ts = t_min : (t_max - t_min) / (not - 1) : t_max;
super_Qs = zeros(1, not);

nop = length(waveform);
omega_1 = ones(1, nop);

for n = 1 : length(ts)
    time = ts(n);
    time_step = time / nop;
    iterations = 10;
    x = 0 : time / (nop - 1) : time;
    [q, Q] = get_Q_curves(waveform, omega_1, time_step,...
        iterations);
    super_Qs(n) = max(q);
    
    n
end

hold on
semilogy(ts, super_Qs)