% ------------------------------------------------------------------------------
% function new_spread - function that simulates how the spin evolves for the
% whole pulse length
% 
% Inputs:
%   delta_omega - delta_omega component of the pulse
%   omega_1 - omega_1 component of the pulse
%   spline_factor - spline_factor is used to divide the axis into spline_factor
%                   times x-axis parts
%   pulse_length - total duration of the pulse
%   number_of_points - number of points stored in the pulse arrays
% Outputs:
%   spread - integral of the angle between the Hamiltonian and the spin vector
%   final_state - final state of the spin after the whole duration of the pulse
%   store_angle - angle between the Hamiltonian and the spin vector over time
%
% Tadeáš Uhlíř
% 03/30/2019
% 
% Based on:
% Jon Vandermause
% new spread
% 3/20/2015
% ------------------------------------------------------------------------------

% account for pulse length

function[spread, final_state, store_angle] = new_spread(delta_omega, ...
    omega_1, spline_factor, pulse_length, number_of_points)

    hbar =  2; %1.055e-34;
    step_size = pulse_length / (number_of_points - 1);
    spline_step = step_size / spline_factor;
    % Interpolate.
    x = 0 : step_size : pulse_length;
    xx = 0 : spline_step : pulse_length;
    delta_omega = spline(x, delta_omega, xx);
    omega_1 = spline(x, omega_1, xx);

    % Start with the 0 or 1 state.
    old_state = [1,0;0,0];

    % Define Pauli matrices.
    sigma_z = [1,0;0,-1];
    sigma_y = [0,-1i;1i,0];
    sigma_x = [0,1;1,0];

    % Store magnetization trajectory.
    store = zeros(3, length(delta_omega));
    store_H = zeros(3, length(delta_omega));
    store_angle = zeros(1, length(delta_omega));

    % We'll start by considering the modulated frame, which rotates about z at
    % the frequency of the applied pulse.

    for n = 1 : length(delta_omega)
        % Define components.
        z = delta_omega(n);
        x = omega_1(n);
        
        % Store Hamiltonian vectors.
        store_H(:,n) = [x, 0, z];
        
        H = delta_omega(n) * sigma_z / 1 + omega_1(n) * sigma_x / 1;
        U = expm(-1i * H * spline_step / hbar);
        old_state = U * old_state * ctranspose(U);
        
        % Compute Bloch vector components.
        bloch_x = real(trace(sigma_x * old_state));
        bloch_y = real(trace(sigma_y * old_state));
        bloch_z = real(trace(sigma_z * old_state));
        
        % Store magnetization vector.
        store(:,n) = [bloch_x; bloch_y; bloch_z];
        
        % Store angle.
        store_angle(n) = acos(dot(store_H(:,n),store(:,n))/ ...
            (norm(store_H(:,n)) * norm(store(:,n))));
    end

    spread = trapz(xx, store_angle) / pulse_length;
    final_state = old_state;
