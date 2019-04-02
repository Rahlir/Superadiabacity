% ------------------------------------------------------------------------------
% Based on:
% 4/14/2015
% Jon Vandermause
% optimize qn 4
%
% Tadeáš Uhlíř
% 3/24/19
% generate_pulse script
% ------------------------------------------------------------------------------

tic

% Control parameters
filename = 'h18m23s42.mat';
frame = 2;
max_deriv = 0.125;

max_time = 3 * 3600;
size_epsilon = 10;
nop = 60;

load('random_pulse_paper.mat', 'delta_guess_fine', 'omega_guess_fine', 'original_q', 'dt', 'pl')

% Start with saved guess pulse
delta_omega = delta_guess_fine;
omega_1 = omega_guess_fine;

radii =  29 : -2 : 3;
% radii =  30 : -2 : 4;

centers = 1 : length(delta_omega);
orig_centers = centers;
maximum = 8e4;

spacing = dt;

number_of_points = length(delta_omega);

best_delta_omega = delta_omega;
best_omega_1 = omega_1;
q_whole = get_Qn_new(delta_omega, omega_1, spacing, frame);

b = 0;
total = 0;

% Loop 1: change the center.
while toc < max_time
    total = total + 1;
    if mod(total, 1000) == 0
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
                best_omega_1(left : right), spacing, frame);
        else % We take one point above boundaries to perturb when possible
            q_update = get_Qn_new(best_delta_omega(left - 1 : right + 1), ...
                best_omega_1(left - 1 : right + 1), spacing, frame);
        end
        q_check = q_update;
        
        old_Q_whole = get_Qn_new(best_delta_omega, best_omega_1, ...
            spacing, frame);

        % Loop 3: set the curve.
        for r = 0 : 1
            if r == 0
                new = best_delta_omega;
                best = best_omega_1;
            else
                new = best_omega_1;
                best = best_delta_omega;
            end

            % Loop 4: perturb the curve.
            for n = 1 : size_epsilon
                derv = ((2 * rand) - 1) * max_epsilon;  % choose random derv

                % 3/4 perturbation depends on r
                if r == 1
                    new = perturb_quadratic(new, center, radius, derv);
                else
                    new = perturb_delta(new, center, radius, 10 * derv);
                end

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

                 % constrain omega_1
                if r == 1  
                    for p = 1 : length(new)
                        if abs(new(p)) > maximum
                            abs_test = 0;
                        end
                    end
                end

                % Force Q to increase.
                if Q_whole < old_Q_whole
                    abs_test = 0;
                end

                if abs_test == 1 && new_q > q_update
                    q_update = new_q;
                    if r == 0
                        best_delta_omega = new;
                    else
                        best_omega_1 = new;
                    end
                    q_whole = get_Qn_new(... 
                        best_delta_omega, best_omega_1, spacing, frame);
                end
            end
        end
    end

end

tim = toc;

save(join(["paper_output", filename], "/"), 'best_delta_omega', 'best_omega_1', ...
     'q_whole', 'tim', 'pl', 'frame', 'max_deriv', 'size_epsilon', 'total')
