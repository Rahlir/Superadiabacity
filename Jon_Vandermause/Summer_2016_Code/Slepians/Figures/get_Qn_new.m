% 4/9/2015
% Jon Vandermause
% get_Qn_new

function[Qn] = get_Qn_new(delta_omega, omega_1, time_step, frame)

first_n = get_Q_curves(delta_omega, omega_1, time_step, frame);
Qn = first_n(frame);