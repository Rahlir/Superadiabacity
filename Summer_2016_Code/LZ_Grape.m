% Jon Vandermause
% 2/2/2016
% LZ Grape

% Create inversion guess pulse.
nop = 300;
tau = 0.11;
step = tau / nop;

sigma_z = 1/2 * [1,0;0,-1];
sigma_x = 1/2 * [0,1;1,0];

delta_guess = 10 : -20 / (nop - 1) : -10;
omega_guess = ones(1, nop);

% Define initial and target operators.
rho_0 = [1,0;0,0]; % pure state
C = [0,0;0,1];  % inverted state

delta_omega = delta_guess;
omega_1 = omega_guess;

% Propagate the states.
gradients_x = zeros(1, nop);
gradients_z = zeros(1, nop);

iterations = 1e4;
performance_index = zeros(1, iterations);

lambdas = zeros(2, 2, nop);
rhos = lambdas;

figure
for m = 1 : iterations
    rho_update = rho_0;
    C_update = C;
    
    % Propagate the state.
    for n = 1 : nop
        lambdas(:, :, n) = C_update;
        
        U_j = expm(-1i * step * (delta_omega(n) * sigma_z + ...
            omega_1(n) * sigma_x));

        U_back = expm(-1i * step * (delta_omega(nop - n + 1) * sigma_z + ...
            omega_1(nop - n + 1) * sigma_x));

        rho_update = U_j * rho_update * ctranspose(U_j);
        C_update = ctranspose(U_back) * C_update * U_back;
        
        rhos(:, :, n) = rho_update;
    end
    
    % Calculate gradients.
    for p = 1 : nop
        lam_j = lambdas(:, :, nop - p + 1);
        rho_j = rhos(:, :, p);
        
        int_x = 1i * step * (sigma_x * rho_j - rho_j * sigma_x);
        int_z = 1i * step * (sigma_z * rho_j - rho_j * sigma_z);
        
        gradients_x(p) = -real(trace(ctranspose(lam_j) * int_x));
        gradients_z(p) = -real(trace(ctranspose(lam_j) * int_z));
    end
        
    fidelity = real(trace(ctranspose(C) * rho_update));
    performance_index(m) = fidelity;
    
    fidelity
    
    delta_omega(1 : nop) = delta_omega(1 : nop) + gradients_z * 7e7;
%     omega_1(1 : nop) = omega_1(1 : nop) + gradients_x * 1e12;
    
    subplot(2, 1, 1)
    plot(omega_1)
    subplot(2, 1, 2)
    plot(delta_omega)
    drawnow
        
end