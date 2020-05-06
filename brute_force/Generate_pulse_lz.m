% ------------------------------------------------------------------------------
% Generate_pulse_lz script
%
% Tadeáš Uhlíř
% 3/24/19
% ------------------------------------------------------------------------------

tic

% Control parameters
frame = 2;
max_deriv = 0.1;

max_time = 1.5 * 3600;
size_epsilon = 10;

filename = "something.mat";
load('data/initial_pulse.mat', 'delta_omega_init', 'omega_1', 'original_q', 'dt', 'pulse_t')

% Start with saved guess pulse
delta_omega = delta_omega_init;

radii =  29 : -2 : 3;
% radii =  30 : -2 : 4;

centers = 1 : length(delta_omega_init);

spacing = dt;

number_of_points = length(delta_omega_init);

best_delta_omega = delta_omega_init;
q_whole = get_Qn_new(delta_omega_init, omega_1, spacing, frame);

b = 0;
total = 0;
q_record = 0;

% Loop 1: change the center.
while toc < max_time
    total = total + 1;
    if mod(total, 1000) == 0
        q_record = q_record + 1;
        fprintf('Iteration %d \n', total) 
        progress = toc/max_time*100;
        fprintf('Progress: %.1f%% \n', progress)
    end

    b = b + 1;
    if b == length(centers) + 1
        b = 1;
    end
    
    center = centers(b);

    q_update = 1;
    q_check = 1;
    
    i = 0;  % radius index
    j = 0;  % derv index
    r = -1;  % curve index
    c = 0;  % total number of iterations
    
    % Loop 2: change the radius.
    while q_update == q_check && c < length(radii)*5
        c = c + 1;

        % Cycle through radii.
        i = i + 1;
        if i == length(radii) + 1
            i = 1;
        end
        radius = radii(i);

        % Define max_epsilon.
        max_epsilon = get_max_epsilon(radius, max_deriv);

        [left,right] = new_left_right(center, radius, number_of_points);

        % Calculate minimum value of the Q-curve segment.
        if left == 1 || right == number_of_points
            q_update = get_Qn_new(best_delta_omega(left : right), ... 
                omega_1(left : right), spacing, frame);
        else % We take one point above boundaries to perturb when possible
            q_update = get_Qn_new(best_delta_omega(left - 1 : right + 1), ...
                omega_1(left - 1 : right + 1), spacing, frame);
        end
        q_check = q_update;
        
        old_Q_whole = get_Qn_new(best_delta_omega, omega_1, ...
            spacing, frame);

        % Loop 3: set the curve.
        new = best_delta_omega;
        best = omega_1;

        % Loop 4: perturb the curve.
        for n = 1 : size_epsilon
            derv = ((2 * rand) - 1) * max_epsilon;  % choose random derv

        % 3/4 perturbation depends on r
        new = perturb_delta(new, center, radius, 10 * derv);

            % Calculate minimum value of Q-curve.
            if left == 1 || right == number_of_points
                new_q = get_Qn_new(new(left : right), ...
                    best(left : right), spacing, frame);
                Q_whole = get_Qn_new(new, best, spacing, frame);
            else
                new_q = get_Qn_new(new(left - 1 : right + 1), ...
                    best(left - 1 : right + 1), spacing, frame);
                Q_whole = get_Qn_new(new, best, spacing, frame);
            end

            abs_test = 1;

            % Force Q to increase.
            if Q_whole < old_Q_whole
                abs_test = 0;
            end

            if abs_test == 1 && new_q > q_update
                q_update = new_q;
                best_delta_omega = new;
                q_whole = get_Qn_new(... 
                    best_delta_omega, omega_1, spacing, frame);
            end
        end
    end

end

tim = toc;

save(join(["optimized", filename], "/"), 'best_delta_omega', 'q_whole', ...
    'tim', 'frame', 'max_deriv', 'size_epsilon', 'total')
