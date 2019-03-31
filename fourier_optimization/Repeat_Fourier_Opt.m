% Jonathan Vandermause
% January 17, 2017
% Repeat Fourier

% Input parameters.
nop = 1000;
power = 1;
T = pi;
detune_factor = 10; % set max detuning of initial LZ pulse
upperb_fac = 2; % set limit to max detuning to avoid runaway solutions
mode_size = 15;  % sets the number of modes to be optimized
rep = 100;  % number of pulses generated for each Q factor
frame_no = 3;   % number of Q factors to optimize

% Prepare pulse.
[omega_1, delta_omega] = prepare_initial_pulse(nop, power, detune_factor);

% Prepare optimization.
mode_bound = upperb_fac * detune_factor;    % restricts size of modes
lowb = [1, -mode_bound * ones(1, mode_size)];   % set lower bounds
upperb = [upperb_fac, mode_bound * ones(1, mode_size)]; % set upper bounds

% Initialize storage vectors.
store_Q = zeros(frame_no, rep);
store_Four = zeros(frame_no, rep, length(lowb));
store_pulse = zeros(frame_no, rep, nop);

for j = 1 : frame_no
    frame = j;
    for p = 1 : rep
        % Choose random seed.
        rand_guess = [1 + upperb_fac * rand, mode_bound * ...
            (rand(1, mode_size) * 2 - 1)];

        % We optimize the Fourier modes using Matlab's "fmincon" command, which
        % searches for a constrained minimum of a function of several
        % variables. In general, X = fmincon(FUN,X0,A,B,Aeq,Beq,LB,UB) defines
        % a set of lower and upper bounds so that a solution X is found in the
        % range LB <= X <= UP. We impose a lower and upper bound on the first
        % entry of par in order to avoid runaway solutions. Other than this
        % bound, no constraints are placed on the optimization.
        options = optimoptions('fmincon','MaxFunEvals',1e4);
        [par, fval] = fmincon(@(par) fourier_q(par, delta_omega, ...
            omega_1, T, frame), rand_guess, [], [], [], [], ...
            lowb, upperb, [], options);

        Q = 1/fval
        Four_Func = get_four_func(delta_omega, par);    % retrieve pulse

        % Store the results of the optimization.
        store_Q(j, p) = Q;
        store_Four(j, p, :) = par; 
        store_pulse(j, p, :) = Four_Func;

        p
    end
end
