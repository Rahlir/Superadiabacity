% Jonathan Vandermause
% 4/14/2016
% CNOT Grape Limited

% Synthesize a CNOT gate given chloroform controls.

% Define the dimension of the Hilbert space.
D = 4;

% Define epsilon.
epsilon = 1e6;

% Define Pauli matrices.
sigma_x = [0, 1; 1, 0];
sigma_y = [0, -1i; 1i, 0];
sigma_z = [1, 0; 0, -1];

% Define two-spin Pauli matrices.
X1 = kron(sigma_x, eye(2));
X2 = kron(eye(2), sigma_x);
Z1 = kron(sigma_z, eye(2));
Z2 = kron(eye(2), sigma_z);
ZZ = kron(sigma_z, sigma_z);

% Define matrix that stores the Hermitian controls:
m = 4;  % number of controls
H_C = zeros(D, D, m);
H_C(:, :, 1) = X1;
H_C(:, :, 2) = Z1;
H_C(:, :, 3) = X2;
H_C(:, :, 4) = Z2;

% Define matix that stores the free evolution Hamiltonian:
J = 209.17;  % J coupling in Hz
H_0 = zeros(D, D, 1);
H_0(:, :, 1) = (pi * J / 2) * ZZ;

% Define the desired CNOT gate.
U_F = [1, 0, 0, 0; 0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0] * ...
    [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 0, 1; 0, 0, 1, 0];
    

% Define mxN initial control matrix.
max_x = 12500 * 2 * pi; % max power in rad/s
N = 500;    % number of steps in the pulse
T = 0.006;   % length of the pulse
step = T / N;    % length of each step
pt = 0 : T/499 : 0.006;

% delta_omega_A = 0 : (max_x / 100) / (N - 1) : max_x / 100;
% omega_1_A = delta_omega_A;
% delta_omega_B = delta_omega_A;
% omega_1_B = delta_omega_B;

omega_1_A = zeros(1, N); %controls(1, :);
delta_omega_A = -196.3495408 * ones(1, N); % controls(2, :);
omega_1_B = omega_1_A;
delta_omega_B = delta_omega_A;

controls = zeros(m, N);
controls(1, :) = omega_1_A;
controls(2, :) = delta_omega_A;
controls(3, :) = omega_1_B;
controls(4, :) = delta_omega_B;

% controls = zeros(m, N);
% controls(1, :) = CNOT_12(1,:);
% controls(2, :) = CNOT_12(2,:);
% controls(3, :) = CNOT_12(3,:);
% controls(4, :) = CNOT_12(4,:);

figure
iterations = 10000;
for j = 1 : iterations
    
    X = eye(D);
    P = U_F;
    
    Xs = zeros(D, D, N);
    Ps = zeros(D, D, N);
    
    for n = 1 : N
        % Record P first.
        bi = N - n + 1; % back index
        Ps(:, :, bi) = P;

        % Forward Hamiltonian at step n:
        H_j = H_0;
        for k = 1 : m
            H_j = H_j + controls(k, n) * H_C(:, :, k);
        end

        % Forward propagator at step n:
        U_j = expm(-1i * H_j * step);

        % Backward Hamiltonian at step n:
        H_back = H_0;
        for k = 1 : m
            H_back = H_back + controls(k, bi) * H_C(:, :, k);
        end

        % Backward propagator at step n:
        U_back = expm(1i * H_back * step);

        % Calculate P_j and X_j matrices:
        X = U_j * X;
        P = U_back * P;
        
        % Record X last.
        Xs(:, :, n) = X;
    end

    % Add the gradients to the original controls.
    gradients = zeros(k, N);
    
    for n = 1 : N
        
        X_j = Xs(:, :, n);
        P_j = Ps(:, :, n);
        
        % Compute the gradient:
        for k = 1 : m
            gradients(k, n) = -real(trace(ctranspose(P_j) * ...
                (1i * step * H_C(:, :, k) * X_j)) * ...
                trace(ctranspose(X_j) * P_j));
        end
        
        for k = 1 : m
            
            candidate = controls(k, n) + epsilon * gradients(k, n);
            
            % rf power cannot be negative!
            if k == 1 || k == 3
                if candidate >= 0
                    controls(k, n) = candidate;
                end
            else
                controls(k, n) = candidate;
            end
            
            
        end
    end

    fidelity = abs(trace(ctranspose(U_F) * X))
    
    subplot(2, 2, 1)
    plot(pt, controls(1, :))
    title('X1')
    subplot(2, 2, 2)
    plot(pt, controls(2, :))
    title('Z1')
    subplot(2, 2, 3)
    plot(pt, controls(3, :))
    title('X2')
    subplot(2, 2, 4)
    plot(pt, controls(4, :))
    title('Z2')
    drawnow
    
    X;
end


