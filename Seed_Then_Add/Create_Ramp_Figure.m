% Jonathan Vandermause
% May 29, 2017
% Create ramp figure

% Run the program "Ramp_Performance.m" first.
times = 0 : 1 / (length(delta_omega) - 1) : 1;

% Plot pulse shape.
subplot(2, 2, 1)
plot(times, delta_omega, 'b:')

% Calculate and plot Q-factors.
pl = pi;    % set pulse length equal to QSL (only non-arbitrary choice)
time_step = pl / length(delta_omega);
Qs = get_Q_curves(delta_omega, omega_1, time_step, 5);
subplot(2, 2, 3)
bar(Qs)

% Plot ramp performance
subplot(1, 2, 2)
plot(pls, store)

% Plot QSL time.
hold on
plot([pi pi], [0 1], 'k--') % dashed line at QSL
hold on
plot(taus_E4(1 : 9), store_fid_E4(1 : 9), 'k.')
