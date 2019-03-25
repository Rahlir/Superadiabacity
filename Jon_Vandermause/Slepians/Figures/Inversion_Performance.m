% Jonathan Vandermause
% July 10, 2017
% Inversion performance

% Define Paulis.
sigma_x = [0, 1; 1, 0];
sigma_z = [1, 0; 0, -1];

% Define pulse.
delta_omega = HZ / 2;
nop = length(delta_omega);
omega_1 = (1/2) * ones(1, nop);

% Set initial and target state.
initial_state = [1;0];
target_state = [0;1];

% Set pulse lengths.
pls_no = 100;
init = 0;
fin = 8 * pi;
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
    
    q
end

figure
plot(pls, store)
% semilogy(pls / (2 * pi), 1 - store.^2)