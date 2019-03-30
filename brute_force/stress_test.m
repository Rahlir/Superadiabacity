% ------------------------------------------------------------------------------
% function stress_test - stress test for the given pulse that shows the final
% spin state for various pulse lengths
% 
% Inputs:
%   delta_omega - delta_omega component of the pulse
%   omega_1 - omega_1 component of the pulse
%   max_pl - maximum pulse length for which the spin should be evolved
%   n_points - number of data points returned
% Outputs:
%   pls - x-axis containing the data points for pulse lengths
%   fsts - y-axis containing the final states for each pulse length in pls
%   s_qs - "Super Q" factor that are not currently calculated well
%   max_frames - vector containing the frames for each data point in pls in
%   in which the q_factor is the largest
%
% Tadeáš Uhlíř
% 03/30/2019
% ------------------------------------------------------------------------------

function[pls, fsts, s_qs, max_frames] = stress_test(delta_omega, ...
    omega_1, max_pl, n_points)

    if nargin < 3
        n_points = 70;
    end

    % Define vector consisting of pulse lengths:
    pulse_lengths = linspace(max_pl, 1e-6, n_points);

    final_states = zeros(1, length(pulse_lengths));
    super_qs = zeros(1, length(pulse_lengths));
    max_frs = zeros(1, length(pulse_lengths));
    for n = 1 : length(pulse_lengths)
        
        pulse_length = pulse_lengths(n);
        
        [~, final_state] = new_spread(delta_omega, ...
            omega_1, 10, pulse_length, 300);
        
        final_states(n) = final_state(4);
        
        Q_values = get_Q_curves(delta_omega, omega_1, ...
            pulse_length / 299, 10);
        [super_Q, max_fr] = max(Q_values);
        super_qs(n) = super_Q;
            max_frs(n) = max_fr;
    end

    pls = pulse_lengths;
    fsts = final_states;
    s_qs = super_qs;
    max_frames = max_frs;
