% ------------------------------------------------------------------------------
% Tadeáš Uhlíř
% 03/27/2019
% get_bar function
%
% Input:
%   tb - table of data containing columns of parameters, pulse length, and
%   q_values
% Output:
%   fig - figure with the bar chart
% ------------------------------------------------------------------------------

function[fig] = get_bar(tb)

    n_categories = length(categories(tb.Params));
    n_pulses = length(categories(tb.Pulse_length));
    X = categorical(categories(tb.Params))';
    Y = zeros(n_categories, n_pulses);
    Y_orig = zeros(n_categories, n_pulses);


    for i=1:n_pulses
        cats_pl = categories(tb.Pulse_length);
        pulse = cats_pl{i};
        
        for j=1:n_categories
            param = X(j);
            ind = (tb.Pulse_length == pulse) & (tb.Params == param);
            if any(ind)
                Y(j, i) = tb.Q_factor(ind);
                Y_orig(j, i) = tb.Original_Q(ind);
            end
        end
        
    end   

    leg_numbs = str2double(categories(tb.Pulse_length));
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
