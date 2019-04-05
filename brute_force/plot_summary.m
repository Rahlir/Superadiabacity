% ------------------------------------------------------------------------------
% function plot_summary - generates six plots on a single figure that provides
% useful information of the pulse(s) performance
%
% Inputs:
%   data - table containing guess puslses, optimized pulses, q_factors, and
%   control parameters of the pulse
%   inds - rows containing the pulses to be plotted
% Outputs:
%   fig - figure with the six plots
%
% Tadeáš Uhlíř
% 08/27/2018
% ------------------------------------------------------------------------------

function[fig] = plot_summary(data, inds)

    fig = figure('Units','inches',...
        'Position', [0 0 11 8], 'PaperPositionMode','auto');
    all_axes = tight_subplot(3, 2, 0.04, [0.05 0.02], [0.04 0.01]);

    y_labels = ["\Delta\omega(t)", "\omega_1(t)", "Q_n(t)", "Q_n", ...
        "Fidelity", "Super Q"];
    x_labels = ["Time (s)", "Time (s)", "Time (s)", "Frame", ...
        "Pulse length (s)", "Pulse length (s)"];

    for i = 1:length(all_axes)
        ax = all_axes(i);
        ax.FontSize = 7;
        hold(ax, 'on')
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
    s5 = all_axes(5);
    % s6 = all_axes(6);

    qs_all = zeros(10, length(inds));
    legs = strings(1, length(inds));
    % [x_ax, f_states_g, f_states, y2, y2_g] = do_stress_test(data, inds);

    colors = get(gca, 'ColorOrder');

    pls = zeros(length(inds), 1);

    for ind=1:length(inds)
        i = inds(ind);

        % identifier = data.Identifier(i);

        pl = data.Pulse_length(i);
        frame = data.Frame(i);
        name = data.Name(i);

        pls(ind) = pl;

        leg = sprintf('%.0fus,n=%d,%s', pl*1e6, frame, name);
        legs(ind) = leg;

        pulse = data.Pulse(i, :, :);
        nop = length(pulse(:, :, 1));

        fprintf('Calculating stress for %d out of %d\n', ind, length(inds))
        x = 0 : pl/(nop-1) : pl;
        [x_ax, f_states] = get_stress(data, i);


        plot(s1, x, pulse(:, :, 1), 'LineWidth', 1,  ...
            'Color', colors(ind,:), 'DisplayName', leg)
        plot(s2, x, pulse(:, :, 2), 'LineWidth', 1, 'Color', colors(ind,:), ...
            'DisplayName', leg)

        [qs,Q] = get_Q_curves(pulse(:, :, 1), pulse(:, :, 2), pl/(nop-1), 10);
        qs_all(:, ind) = qs;

        if frame~=0
            plot(s3, x(1:end-2*frame), Q(frame, 1:end-2*frame), 'LineWidth', 1, ...
                'Color', colors(ind,:), 'DisplayName', leg)
        end

        plot(s5, x_ax, real(f_states).^2, 'LineWidth', 1, 'Color', colors(ind,:), ...
            'DisplayName', leg)
        % real(f_states)
        % plot(s6, x_ax, y2, 'LineWidth', 1, 'Color', colors(ind,:), ...
            % 'DisplayName', leg)
    end

    % ylim(s2, [0 min(qs_all(frame, :))*3])

    bar(s4, qs_all, 'LineWidth', 1)
    legend(s4, legs)

    xlim(s1, [0, max(pls)])
    xlim(s2, [0, max(pls)])
    xlim(s3, [0, max(pls)])
    % ylim(s6, [0, max(max(y2(inds, :)))])


    % plot(Q_orig(frame, :))
    % hold on
    % plot(Q(frame, :))
    % hold off
    % t = annotation('textbox', [0.18, 0.14, 0.5, 0.5], 'String', ...
    %     {sprintf('Time: %.1fm', tim), sprintf('Q-whole: %.4f', q_whole)},...
    %     'FitBoxToText', 'on', 'verticalalignment', 'bottom');
    % t.FontWeight = 'bold';
    %
    % subplot(2, 2, 4)
    % bar([qs_orig, qs])
