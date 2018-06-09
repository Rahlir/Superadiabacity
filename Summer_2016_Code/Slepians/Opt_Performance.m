% Jonathan Vandermause
% July 10, 2016
% Q opt performance

% Define Paulis.
sigma_x = [0, 1; 1, 0];
sigma_z = [1, 0; 0, -1];

% Define pulse.
delta_omega = smooth(HZ / 2);
nop = length(delta_omega);
omega_1 = (omega_x / 2) * ones(1, nop);

% Set initial and target state.
H_init = delta_omega(1) * sigma_z + omega_1(1) * sigma_x;
H_fin = -delta_omega(1) * sigma_z + omega_1(1) * sigma_x;
[V_init, D_init] = eig(H_init);
[V_fin, D_fin] = eig(H_fin);
initial_state = V_init(:, 1);
target_state = V_fin(:, 1);
% initial_state = [1; 0];
% target_state = [0; 1];

% Set pulse lengths.
pls_no = 100;
init = 0;
fin = 20 * pi;
pls = init : (fin - init) / (pls_no - 1) : fin;
store = zeros(1, length(pls));

for q = 1 : length(pls)

    pl = pls(q);
    step = pl / nop;
    psi = initial_state;

    for n = 1 : nop

        H = delta_omega(n) * sigma_z + omega_1(n) * sigma_x;
        U = expm(-1i * H * step);
    
        psi = U * psi;
    end

    store(q) = abs(ctranspose(psi) * target_state);
end

figure
semilogy(pls / (2 * pi), 1 - store.^2)