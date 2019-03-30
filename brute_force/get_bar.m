% ------------------------------------------------------------------------------
% function get_bar - generates bar graph of the q_factor and the q_factor of the
% guess pulse that was optimalized
%
% Input:
%   tb - table of data containing columns of parameters, pulse length, and
%   q_values
%   column_name - name of the column which is used for the x-axis
% Output:
%   fig - figure with the bar chart

% Tadeáš Uhlíř
% 03/27/2019
% ------------------------------------------------------------------------------

function[fig] = get_bar(tb, column_name)

    tb_sorted = sortrows(tb, column_name);

    index = find(strcmp(tb_sorted.Properties.VariableNames, column_name));
    categorical_column = categorical(tb_sorted.(index));

    n_categories = length(categories(categorical_column));
    n_pulses = length(categories(categorical(tb_sorted.Pulse_length)));
    X = categorical_column;
    Y = zeros(n_categories, n_pulses);
    Y_orig = zeros(n_categories, n_pulses);


    for i=1:n_pulses
        cats_pl = categories(categorical(tb_sorted.Pulse_length));
        pulse = cats_pl{i};
        
        for j=1:n_categories
            param = X(j);
            ind = (categorical(tb_sorted.Pulse_length) == pulse) & (categorical_column == param);
            if any(ind)
                Y(j, i) = tb_sorted.Q_factor(ind);
                Y_orig(j, i) = tb_sorted.Original_Q(ind);
            end
        end
        
    end   

    leg_numbs = str2double(categories(categorical(tb_sorted.Pulse_length)));
    legs = strings(1, length(leg_numbs)+1);
    legs(1:end-1) = compose("pl=%d\x03BCs", leg_numbs*1e6);
    legs(end) = "Guess Pulses";

    fig = figure('Units','inches', ...
        'Position', [0 0 11 8], 'PaperPositionMode','auto');
    bar(X, Y, 'LineWidth', 1)
    grid on
    grid minor
    hold on
    bar(X, Y_orig, 'FaceColor', 'k', 'FaceAlpha', 0.15, 'LineWidth', 1.1)
    hold off
    legend(legs, 'Location', 'NorthWest')
    ylabel('Q_n Factor', 'FontWeight', 'bold')
    xlabel('Algorithm parameters', 'FontWeight', 'bold')
