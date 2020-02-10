% ------------------------------------------------------------------------------
% script Generate_pulse_live - runs the brute_force optimization and draws the
% pulse and it's Q coefficient on a figure in the real time
%
% Tadeáš Uhlíř
% 04/02/2019
% ------------------------------------------------------------------------------


% -------------------------------Prepare Figure---------------------------------
fig = figure('Units','inches',...
    'Position', [0 0 11 8], 'PaperPositionMode','auto');
all_axes = tight_subplot(2, 2, 0.04, [0.05 0.02], [0.04 0.01]);

y_labels = ["\Delta\omega(t)", "\omega_1(t)", "Q_n(t)", "Q_n"];
x_labels = ["Time (s)", "Time (s)", "Time (s)", "Frame"];

for i = 1:length(all_axes)
    ax = all_axes(i);
    ax.FontSize = 7;
    grid(ax, 'on')
    grid(ax, 'minor')
    xticklabels(ax, 'auto')
    yticklabels(ax, 'auto')
    ylabel(ax, y_labels(i), 'FontWeight', 'bold')
    xlabel(ax, x_labels(i), 'FontWeight', 'bold')
    if i==1 || i==5 || i==6
        legend(ax, 'Location', 'NorthWest')
    elseif i~=4
        legend(ax)
    end
end

s1 = all_axes(1);
s2 = all_axes(2);
s3 = all_axes(3);
s4 = all_axes(4);

% ----------------------------Optimization Starts-------------------------------
% Control parameters
filename = "test.mat";
frame = 1;
max_deriv = 0.25;

max_iterations = 790000;
size_epsilon = 10;

load('random_pulse_paper.mat', 'delta_guess_fine', 'omega_guess_fine', 'original_q', 'dt', 'pl')

leg = sprintf('%.0fus,n=%d,%s', pl*1e6, frame, "Original");

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

x = 0 : pl/(number_of_points-1) : pl;

best_delta_omega = delta_omega;
best_omega_1 = omega_1;
q_whole = get_Qn_new(delta_omega, omega_1, spacing, frame);

b = 0;
total = 0;

% Loop 1: change the center.
while total < max_iterations
    total = total + 1;
    if mod(total, 1000) == 0
        fprintf('Iteration %d \n', total)
        progress = total/max_iterations*100;
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

    plot(s1, x, best_delta_omega, 'LineWidth', 1,  ...
        'DisplayName', leg)

    plot(s2, x, best_omega_1, 'LineWidth', 1, ...
        'DisplayName', leg)

    [qs,Q] = get_Q_curves(best_delta_omega, best_omega_1, pl/(number_of_points-1), 10);

    if frame~=0
        plot(s3, x(1:end-2*frame), Q(frame, 1:end-2*frame), 'LineWidth', 1, ...
            'DisplayName', leg)
    end

    bar(s4, qs, 'LineWidth', 1)
    drawnow

end
