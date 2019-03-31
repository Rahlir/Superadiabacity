% Jonathan Vandermause
% May 28, 2017
% Seed then add

% Input parameters.
nop = 1000;
power = 1;
T = pi;
detune_factor = 10; % set max detuning of initial LZ pulse
upperb_fac = 2; % set limit to max detuning to avoid runaway solutions
mode_size = 5;  % sets the number of modes to be optimized
mode_add = 10; % modes added after seed
rep = 1000;  % number of pulses generated for each Q factor
frame_no = 3;   % number of Q factors to optimize

% Prepare pulse.
[omega_1, delta_omega] = Prepare_Initial_Pulse(nop, power, detune_factor);

% Prepare optimization.
mode_bound = upperb_fac * detune_factor;    % restricts size of modes
lowb = [1, -mode_bound * ones(1, mode_size)];   % set lower bounds
upperb = [upperb_fac, mode_bound * ones(1, mode_size)]; % set upper bounds

% Initialize storage vectors.
store_Q = zeros(frame_no, rep);
store_Four = zeros(frame_no, rep, mode_size + mode_add + 1);

for j = 1 : frame_no
    frame = j;
    k = 0;
    for p = 1 : rep
        % Choose random seed.
        rand_guess = [1 + upperb_fac * rand, mode_bound * ...
            (rand(1, mode_size) * 2 - 1)];
        
        % Optimize.
        options = optimoptions('fmincon','MaxFunEvals',1e4);
        [par, fval] = fmincon(@(par) fourier_q(par, delta_omega, ...
            omega_1, T, frame), rand_guess, [], [], [], [], ...
            lowb, upperb, [], options);

        Q = 1/fval
        
        % If above threshold value, add modes.
        if Q > 0.8
            k = k + 1;
            
            new_seed = [par, zeros(1, mode_add)];
            
            [par, fval] = fmincon(@(par) fourier_q(par, delta_omega, ...
                omega_1, T, frame), new_seed, [], [], [], [], ...
                [lowb, -mode_bound * ones(1, mode_add)], ...
                [upperb, mode_bound * ones(1, mode_add)], ...
                [], options);

            Q_add = 1/fval
            
            
            % Store the results of the optimization.
            store_Q(j, k) = Q_add;
            store_Four(j, k, :) = par;          
        end
    end
end
