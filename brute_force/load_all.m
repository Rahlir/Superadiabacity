% ------------------------------------------------------------------------------
% Based on:
% Tadeas Uhlir
% 08/24/2018
% load_all function
%
% Tadeáš Uhlíř
% 03/27/2019
% load_all_v2 function
% ------------------------------------------------------------------------------

function[data_final] = load_all_v2(dir_name)

    str_files = '*.mat';

    if nargin > 0
        str_files = strjoin({dir_name, str_files}, '/');
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

    load("random_pulse.mat", "delta_guess_fine", "omega_guess_fine", ...
         "original_q", "dt", "pl")

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

        guess_deltas(i, :) = delta_guess_fine;
        guess_omegas(i, :) = omega_guess_fine;
        best_deltas(i, :) = best_delta_omega;
        best_omegas(i, :) = best_omega_1;
        q_wholes(i) = q_whole;
        times(i) = tim;
        iterations(i) = total;

        pls(i) = pl;
    end
    fprintf('\n')

    imprvs = (q_wholes - q_origs)./q_origs*100;
    times_m = times/60;
    imprvs_m = imprvs./times_m;

    data_final = table(categorical(pls), cat(3, best_deltas, best_omegas), ...
        cat(3, guess_deltas, guess_omegas), q_wholes, q_origs, imprvs, iterations, imprvs_m, ...
        'VariableNames', {'Pulse_length', 'Pulse', 'Guess_pulse', 'Q_factor', 'Original_Q', ...
        'Improvement', 'Iterations', 'Improvement_per_min'});
    % data_final = sortrows(data, {'Params', 'Pulse_length'});
