% Jonathan Vandermause
% July 22, 2017
% Design short Slepian

% Get the short Slepian (SS)
tau_p = 0.001;  % Slepian parameter
N = 1e5;    % number of points in the accelerated-time pulse
[SS_1000, pl_1000] = Get_Slepian(tau_p, 1000, N);  % 1000 points
[SS_500, pl_500] = Get_Slepian(tau_p, 500, N);  % 500 points
[SS_100, pl_100] = Get_Slepian(tau_p, 100, N);  % 100 points

% Check its performance versus pulse length.
pls_no = 100;
init = 0;
fin = 4 * pi;
pls_sim = init : (fin - init) / (pls_no - 1) : fin;
[fidelity, X, Y, Z] = LZ_Performance(SS_1000, pls_sim);


phys_fin = 4 * 50e-6;
physical_pls = init : (phys_fin - init) / (pls_no - 1) : phys_fin;