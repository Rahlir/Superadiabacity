% Jonathan Vandermause
% January 10, 2017
% Grape LZ Adapt

function [fidelity, waveform, progress, mag_fac_final] = GrapeLZAdapt(...
    nop, tau, iterations, delta_guess, omega_guess, initial_state, ...
    target_state, mag_fac)


% Define step size.
step = tau / nop;

% Define Paulis.
sigma_z = 1/2 * [1,0;0,-1];
sigma_x = 1/2 * [0,1;1,0];

% Define initial and target operators.
rho_0 = initial_state; % pure state
C = target_state;  % inverted state

% Propagate the states.
gradients_x = zeros(1, nop);
gradients_z = zeros(1, nop);

progress = zeros(1, iterations);

lambdas = zeros(2, 2, nop);
rhos = lambdas;

works = 1;
while works == 1
    
    delta_omega = delta_guess;
    omega_1 = omega_guess;
    
    works = 0;
    
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
        progress(m) = fidelity;

        delta_omega(1 : nop) = delta_omega(1 : nop) + gradients_z * mag_fac;
        
        if m > 1
            if progress(m) < progress(m - 1)
                works = 1;
                mag_fac = mag_fac * 0.9;
                break
            end
        end
                

    end
end

mag_fac_final = mag_fac;
waveform = delta_omega;