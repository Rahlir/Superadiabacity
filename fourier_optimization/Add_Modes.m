% Jonathan Vandermause
% May 27, 2017
% Add modes

% Use the best pulses among the 5-mode optimized pulses as seeds for a
% 15-mode optimization.

% Input parameters.
nop = 1000;
power = 1;
T = pi;
detune_factor = 10; % set max detuning of initial LZ pulse
upperb_fac = 2; % set limit to max detuning to avoid runaway solutions
mode_size = 15;  % sets the number of modes to be optimized
rep = 100;  % number of pulses generated for each Q factor
frame_no = 1;   % number of Q factors to optimize

% Prepare pulse.
step = T / nop;
omega_1 = ones(1, nop) * power;
delta_omega = zeros(1, nop);
for n = 1 : nop
    delta_omega(n) = detune_factor * power - ...
        (2 * detune_factor * power * (n - 1)) / (nop - 1);
end

% Prepare optimization.
mode_bound = upperb_fac * detune_factor;    % restricts size of modes
lowb = [1, -mode_bound * ones(1, mode_size)];   % set lower bounds
upperb = [upperb_fac, mode_bound * ones(1, mode_size)]; % set upper bounds

for j = 1 : frame_no
%     frame = j;
%     % Find maximum Q.
%     max_Q = 0;
%     for n = 1 : length(store_Q_5(j, :))
%         q_curr = store_Q_5(j, n);
%         if q_curr > max_Q
%             max_Q = q_curr;
%             max_ind = n;
%         end
%     end
    
    for n = 1 : 100
    
        % Set as the seed for another round of optimization.
        seed = [reshape(store_Four_5(j, n, :), 1, 6), ...
            zeros(1, mode_size - 5)];

        % Run the optimization.
        options = optimoptions('fmincon','MaxFunEvals',1e4);
        [par, fval] = fmincon(@(par) fourier_q(par, delta_omega, ...
            omega_1, T, frame), seed, [], [], [], [], ...
            lowb, upperb, [], options);

        Q = 1/fval
        Four_Func = Get_Four_Func(delta_omega, par);    % retrieve pulse
        par
    end
end

