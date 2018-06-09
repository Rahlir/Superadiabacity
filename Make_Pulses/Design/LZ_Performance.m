% Jonathan Vandermause
% July 10, 2017
% Inversion performance

function[fidelity, X, Y, Z] = LZ_Performance(HZ, pls)

% Define Paulis.
sigma_x = [0, 1; 1, 0];
sigma_y = [0, -1i; 1i, 0];
sigma_z = [1, 0; 0, -1];

% Define pulse.
delta_omega = HZ / 2;
nop = length(delta_omega);
omega_1 = (1/2) * ones(1, nop);

% Set initial and target state.
initial_state = [1;0];
target_state = [0;1];

% Initialize vectors
fidelity = zeros(1, length(pls));
X = fidelity;
Y = fidelity;
Z = fidelity;

for q = 1 : length(pls)

    pl = pls(q);
    step = pl / nop;
    psi = initial_state;

    for n = 1 : nop

        H = delta_omega(n) * sigma_z + omega_1(n) * sigma_x;
        U = expm(-1i * H * step);
    
        psi = U * psi;
    end

    % Calculate fidelity.
    fidelity(q) = abs(ctranspose(psi) * target_state);
    
    % Calculate expectation values of Paulis.
    X(q) = ctranspose(psi) * sigma_x * psi;
    Y(q) = ctranspose(psi) * sigma_y * psi;
    Z(q) = ctranspose(psi) * sigma_z * psi;
end