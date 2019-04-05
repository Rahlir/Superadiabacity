% ------------------------------------------------------------------------------
% function get_stress - loads the stress data of a pulse if it is saved
% in the cache folder. Otherwise, calculates the stress data and saves the result
% to the cache
% 
% Inputs:
%   data - table containing the pulse and its optimization frame, max_derivative, 
%          and name
%   index - index of the pulses for which the stress should be calculated
% Outputs:
%   x_ax - x-axis of the pulse lengths
%   f_states - y-axis of the final state of the spin
%
% Tadeáš Uhlíř
% 08/27/2018
% Changed:
% 04/04/2019
% ------------------------------------------------------------------------------

function[x, f_s] = get_stress(data, index)

    max_pl = 100e-6;
    n_points = 100;

    ident_name = sprintf("n=%d,deriv=%05.2f", data.Frame(index), data.Max_Derivative(index));
    name = data.Name(index);
    fn = strjoin(["cache", "/", name, ident_name, "stress", ".mat"], '');

    if exist(fn, 'file')
        load(fn, 'x', 'f_s');
    else
        [x, f_s] = stress_test(data.Pulse(index, :, 1), data.Pulse(index, :, 2), ...
            max_pl, n_points);
        save(fn, 'x', 'f_s')
    end

    % y2 = zeros(length(inds), length(y));
    % y2(i, :) = y;
