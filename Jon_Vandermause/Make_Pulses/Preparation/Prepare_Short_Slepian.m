% Jonathan Vandermause
% July 22, 2017
% Prepare Short Slepian

% Set rabi frequency.
pi_length = 50e-6;
rabi = pi / pi_length;

% % Create medium pulses.
% delta_omega_2 = SS_500 * rabi;
% omega_2 = ones(1, length(delta_omega_2)) * rabi;
% head = 'Slepian_';
% Ts_2 = 25e-6 : 1e-6 : 50e-6;
% start_no_2 = 1;
% Print_Bruker_Pulses(delta_omega_2, omega_2, Ts_2, pi_length, ...
%     head, start_no_2)

% Create long pulses.
delta_omega_3 = SS_1000 * rabi;
omega_3 = ones(1, length(delta_omega_3)) * rabi;
Ts_3 = 51e-6 : 1e-6 : 300e-6;
start_no_3 = 27;
Print_Bruker_Pulses(delta_omega_3, omega_3, Ts_3, pi_length, ...
    head, start_no_3)
