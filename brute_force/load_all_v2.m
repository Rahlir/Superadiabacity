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

    infos = strings(length(files), 1);
    identifiers = strings(length(files), 1);
    guess_deltas = zeros(length(files), 300);
    guess_omegas = zeros(length(files), 300);
    best_deltas = zeros(length(files), 300);
    best_omegas = zeros(length(files), 300);
    q_wholes = zeros(length(files), 1);
    q_origs = zeros(length(files), 1);
    times = zeros(length(files), 1);
    pls = zeros(length(files), 1);
    totals = zeros(length(files), 1);
    legs = strings(length(files), 1);

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
        
        info = generate_info(pl, frame, max_deriv, total);
        infos(i) = info;
        identifier = generate_identifier_v2(sprintf('or%4.2f', max_deriv), pl*1e6, frame);
        identifiers(i) = identifier;
        
        q_origs(i) = original_q(frame);
        
        guess_deltas(i, :) = delta_guess_fine;
        guess_omegas(i, :) = omega_guess_fine;
        best_deltas(i, :) = best_delta_omega;
        best_omegas(i, :) = best_omega_1;
        q_wholes(i) = q_whole;
        times(i) = tim;
        totals(i) = total;
        
        pl = get_par(info, 'pl');
        leg = generate_leg(info);
        
        pls(i) = pl;
        legs(i) = leg;
    end
    fprintf('\n')

    imprvs = (q_wholes - q_origs)./q_origs*100;
    times_m = times/60;
    imprvs_m = imprvs./times_m;

    data = table(infos, categorical(pls), categorical(legs), cat(3, best_deltas, best_omegas), ...
        cat(3, guess_deltas, guess_omegas), q_wholes, q_origs, imprvs, totals, imprvs_m, identifiers, ...
        'VariableNames', {'Info', 'Pulse_length', 'Params', 'Pulse', 'Guess_pulse', ...
        'Q_factor', 'Original_Q', 'Improvement', 'Iterations', 'Improvement_per_min', ...
        'Identifier'});
    data_final = sortrows(data, {'Params', 'Pulse_length'});
        
