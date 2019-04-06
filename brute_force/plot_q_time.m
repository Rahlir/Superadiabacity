% ------------------------------------------------------------------------------
% function plot_q_time - generates plot of q_factor versus iterations of the
% brute force algorithm
%
% Inputs:
%   data - table of pulses containing the vector Q_vs_time which holds data of
%          q_factor versus the 1000 times iterations
%   index - index of the pulse in the data table for which to generate the plot
% Outputs:
%   fig - figure with the plot of q_factor versus iterations
%
% Tadeáš Uhlíř
% 04/07/2019
% ------------------------------------------------------------------------------

function[fig] = plot_q_time(data, index)

    fig = figure('Units','inches', ...
        'Position', [0 0 11 8], 'PaperPositionMode','auto');

    q_in_time = data.Q_vs_time(index, :);
    q_in_time = q_in_time(any(q_in_time, 1));

    x_axis = 1000 : 1000 : length(q_in_time)*1000;
    length(q_in_time)
    length(x_axis)

    plot(x_axis, q_in_time)
    grid on
    grid minor
    ylabel('Q_n factor')
    xlabel('Iterations')
