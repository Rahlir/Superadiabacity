% ------------------------------------------------------------------------------
% function load_all - loads the relevant data from the folder where it is stored
% 
% Inputs:
%   dir_name - directory name where the data is saved
%   initial_pulse_fn - filename of the initial (guess) pulse, 'random_pulse.mat'
%                      by default
% Outputs:
%   data_final - table containing the data. Pulse lengths, optimized pulses,
%                guess pulses, q-factors, improvement percentage, iterations,
%                improvement per minute
%
% Tadeáš Uhlíř
% 03/30/2019
% Changed:
% 04/04/2019
% ------------------------------------------------------------------------------

function[data_final] = load_all(dir_name, initial_pulse_fn)

    str_files = '*.mat';

    if nargin > 0
        str_files = strjoin({dir_name, str_files}, '/');
    end

    if nargin < 2
        initial_pulse_fn = "random_pulse.mat";
    end

    files = dir(str_files);

    guess_deltas = zeros(length(files), 300);
    guess_omegas = zeros(length(files), 300);
    best_deltas = zeros(length(files), 300);
    best_omegas = zeros(length(files), 300);
    q_wholes = zeros(length(files), 1);
    q_origs = zeros(length(files), 1);
    times = zeros(length(files), 1);
    pls = zeros(length(files), 1);
    iterations = zeros(length(files), 1);
    frames = zeros(length(files), 1);
    max_derivs = zeros(length(files), 1);

    load(initial_pulse_fn, "delta_guess_fine", "omega_guess_fine", ...
         "original_q", "dt", "pl")

    % load("random_pulse_paper.mat", "delta_guess_fine", "omega_guess_fine", ...
         % "original_q", "dt", "pl")
    % original_q_short = original_q;
    % load("random_pulse_new.mat", "delta_guess_fine", "omega_guess_fine", ...
         % "original_q", "dt", "pl")

    for i=1:length(files)
        progress = (i-1)/length(files)*100;

        if i~=1
            fprintf(repmat('\b', 1, 15))
        end
        fprintf('Loading: %5.2f%%', progress)

        name = files(i).name;
        folder = files(i).folder;
        filename = strjoin({folder, name}, '/');

        load(filename, 'best_delta_omega', 'best_omega_1', 'q_whole', ...
            'tim', 'pl', 'frame', 'max_deriv', 'total')

        q_origs(i) = original_q(frame);
        % if pl < 60e-6
            % q_origs(i) = original_q_short(frame);
        % else
            % q_origs(i) = original_q(frame);
        % end

        guess_deltas(i, :) = delta_guess_fine;
        guess_omegas(i, :) = omega_guess_fine;
        best_deltas(i, :) = best_delta_omega;
        best_omegas(i, :) = best_omega_1;
        q_wholes(i) = q_whole;
        times(i) = tim;
        iterations(i) = total;

        pls(i) = pl;
        frames(i) = frame;
        max_derivs(i) = max_deriv;
    end
    fprintf('\n')

    imprvs = (q_wholes - q_origs)./q_origs*100;
    times_m = times/60;
    imprvs_m = imprvs./times_m;

    data_final = table(pls, frames, max_derivs, cat(3, best_deltas, best_omegas), ...
                       cat(3, guess_deltas, guess_omegas), q_wholes, q_origs, ...
                       imprvs, iterations, imprvs_m, ...
                       'VariableNames', {'Pulse_length', 'Frame', ...
                       'Max_Derivative', 'Pulse', 'Guess_pulse', ...
                       'Q_factor', 'Original_Q', 'Improvement', ...
                       'Iterations', 'Improvement_per_min'});

    % data_final = sortrows(data, {'Params', 'Pulse_length'});
