% ------------------------------------------------------------------------------
% function get_stress - loads the stress data of the pulse(s) if they are saved
% in the cache folder. Otherwise, calculates the stress data and saves the result
% to the cache
% 
% Inputs:
%   data - table containing the pulses and their control parameters
%   inds - indices of the pulses for which the stress should be calculated
% Outputs:
%   x_ax - x-axis of the pulse lengths
%   f_states - y-axis of the final state of the spin
%
% Tadeáš Uhlíř
% 08/27/2018
% ------------------------------------------------------------------------------

function[x_ax, f_states] = get_stress(data, inds)

    max_pl = 100e-6;
    n_points = 100;

    i = 1;
    ind = inds(i);

    name = data.Identifier(ind);
    fn = strjoin(["cache", "/", name, "stress", ".mat"], '');

    if exist(fn, 'file')
        load(fn, 'x', 'f_s', 'y');
    else
        [x, f_s] = stress_test(data.Pulse(ind, :, 1), data.Pulse(ind, :, 2), ...
            max_pl, n_points);
        save(fn, 'x', 'f_s', 'y')
    end

    x_ax = zeros(length(inds), length(x));
    x_ax(i, :) = x;

    f_states = zeros(length(inds), length(f_s));
    f_states(i, :) = f_s;

    % y2 = zeros(length(inds), length(y));
    % y2(i, :) = y;

    fprintf('%d out of %d done\n', i, length(inds))

    for i=2:length(inds)
        ind = inds(i);
        name = data.Identifier(ind);
        fn = strjoin(["cache", "/", name, "stress", ".mat"], '');

        if exist(fn, 'file')
            load(fn, 'x', 'f_s', 'y');
        else
            [x, f_s] = stress_test(data.Pulse(ind, :, 1), data.Pulse(ind, :, 2), ...
                max_pl, n_points);
            save(fn, 'x', 'f_s', 'y')
        end
        
        fprintf('%d out of %d done\n', i, length(inds))
        
        x_ax(i, :) = x;
        f_states(i, :) = f_s;
        % y2(i, :) = y;
    end
