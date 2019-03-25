% Jonathan Vandermause
% June 4, 2017
% Test Slepian Performance

% First, define pulse.
nop = 300;
power = 1;
omega_1 = power * ones(1, nop);
delta_omega = Slepian_1p5_Delta;


% Define Paulis.
sigma_x = [0, 1; 1, 0];
sigma_z = [1, 0; 0, -1];


% Define initial and target states.
rho_initial = (1/2) * (eye(2) + sigma_z);
rho_final = (1/2) * (eye(2) - sigma_z);

pls_no = 500;   % number of pulse lengths
init = 0;       % shortest pulse length tested
fin = 10 * pi;   % longest pulse length tested
pls = init : (fin - init) / (pls_no - 1) : fin;
store = zeros(1, length(pls));

for q = 1 : length(pls)

    pl = pls(q);
    step = pl / nop;
    rho = rho_initial;

    for n = 1 : nop
        % Define Hamiltonian at a given step:
        H = delta_omega(n) * (sigma_z / 2) + omega_1(n) * (sigma_x / 2);
        % Define propagator:
        U = expm(-1i * H * step);
        % Update the density matrix:
        rho = U * rho * ctranspose(U);
    end
    
    % Store fidelity:
    store(q) = real(trace(ctranspose(rho) * rho_final));

    q
end

figure
% plot(pls, log10(1 - store.^2))
plot(pls, store)