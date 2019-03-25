% Jonathan Vandermause
% % June 2, 2017
% Create DAMOP figure

% % Plot hard pulse shape and performance first. (This pulse is not
% % adiabatic, so I won't plot the Q-factors.)
 % nop = 1000;
 % hard_delta = zeros(1, nop);
 % ts = 0 : 1 / (nop - 1) : 1;
% % % Select the right plot interactively before running the next line.
 % plot(ts, hard_delta, 'k--')
 % hold on
 %plot(pls, hard_store, 'k--')

% % Add GRAPE pulse performance.
% hold on
% plot(taus_E4(1 : 9), store_fid_E4(1 : 9), 'k.')

% % Add QSL.
% hold on
% plot([pi pi], [-1, 2], 'k')

% % % Add ramp shape and performance.
% nop = 1000;
% power = 1;
% detune_factor = 10;
% ts = 0 : 1 / (nop - 1) : 1;
% [omega_1, delta_omega] = Prepare_Initial_Pulse(nop, power, detune_factor);
% % hold on
% % plot(ts, delta_omega)
% % 
% % hold on
% % plot(pls, ramp_store)
% 
% pl = pi;    % set pulse length equal to QSL (only non-arbitrary choice)
% time_step = pl / length(delta_omega);
% Qs = get_Q_curves(delta_omega, omega_1, time_step, 5);
% % hold on
% % bar(Qs)


% % Add Q1 optimized pulse.
% hold on
% plot(pls, Q1_store)

%  pulse = Q1_Four;
%  nop = 1000;
% power = 1;
%  detune_factor = 10;
%  [omega_1, delta_omega] = Prepare_Initial_Pulse(nop, power, detune_factor);
%  delta_omega = Get_Four_Func(delta_omega, pulse);
%  ts = 0 : 1 / (nop - 1) : 1;
%  % hold on
%   plot(ts, delta_omega)
% 
% pl = pi;    % set pulse length equal to QSL (only non-arbitrary choice)
% time_step = pl / length(delta_omega);
% Qs = get_Q_curves(delta_omega, omega_1, time_step, 5);
% % hold on
% % bar(Qs)

% hold on
% bar([Qs_ramp, Qs_Q1])

% % Add Q2 optimized pulse.
% hold on
% plot(pls, Q2_store)

% pulse = Q2_Four;
% nop = 1000;
% power = 1;
% detune_factor = 10;
% [omega_1, delta_omega] = Prepare_Initial_Pulse(nop, power, detune_factor);
% delta_omega = Get_Four_Func(delta_omega, pulse);
% ts = 0 : 1 / (nop - 1) : 1;
% hold on
% plot(ts, delta_omega)
% 
% pl = pi;    % set pulse length equal to QSL (only non-arbitrary choice)
% time_step = pl / length(delta_omega);
% Qs = get_Q_curves(delta_omega, omega_1, time_step, 5);
% % hold on
% % bar(Qs)

% Add short slepian pulse.
% hold on
% plot(pls, store, 'k-')
% nop = 300;
% ts = 0 : 1 / (nop - 1) : 1;
% hold on
% plot(ts, Slepian_Short_Delta)
% pl = pi;    % set pulse length equal to QSL (only non-arbitrary choice)
% omega_1 = ones(1, nop);
% delta_omega = Slepian_Short_Delta;
% time_step = pl / length(delta_omega);
% Qs_Slepian_Short = get_Q_curves(delta_omega, omega_1, time_step, 5);
% hold on
% bar([Qs_ramp, Qs_Q1, Qs_Q2, Qs_Slepian_Short])

% Add 1.5 Slepian.
% hold on
% plot(pls, Slepian_1p5_Store, 'k-.')
% nop = 300;
% ts = 0 : 1 / (nop - 1) : 1;
% hold on
% plot(ts, Slepian_1p5_Delta)
% pl = pi;    % set pulse length equal to QSL (only non-arbitrary choice)
% omega_1 = ones(1, nop);
% delta_omega = Slepian_1p5_Delta;
% time_step = pl / length(delta_omega);
% Qs_Slepian_1p5 = get_Q_curves(delta_omega, omega_1, time_step, 5);
% hold on
% bar([Qs_ramp, Qs_Q1, Qs_Q2, Qs_Slepian_Short, Qs_Slepian_1p5])