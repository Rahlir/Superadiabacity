% Jonathan Vandermause
% May 27, 2017
% Single Q Fourier Opt

% Input parameters.
nop = 1000;
power = 1;
T = pi;
detune_factor = 10; % set max detuning of initial LZ pulse
upperb_fac = 2; % set limit to max detuning to avoid runaway solutions
mode_size = 7;  % sets the number of modes to be optimized
rep = 50;  % number of pulses generated for each Q factor
frame = 3;

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

% Initialize storage vectors.
store_Q = zeros(1, rep);
store_Four = zeros(rep, length(lowb));
store_pulse = zeros(rep, nop);


for p = 1 : rep
    % Choose random seed.
%     rand_guess = [1 + upperb_fac * rand, mode_bound * ...
%         (rand(1, mode_size) * 2 - 1)];

%     % Q1 seed:
%     rand_guess = [1.4061   -0.0104   -7.3016   -0.0199   -2.7367 ...
%         -0.0213   -1.2225   -0.0187   -0.5361   -0.0133   -0.2093 ...
%         -0.0077   -0.0647   -0.0034   -0.0122   -0.0007];
    
%     % Q2 seed:
%     rand_guess = [1.3966    0.0243   -6.7027    0.1227   -2.3276  ...
%         0.0785   -0.9371    0.0596   -0.3895    0.0418   -0.1505  ...
%         0.0282   -0.0486    0.0116   -0.0092    0.0035];

    rand_guess = [1.3862    0.0957   -4.3141    0.0817   -0.4146    0.0215 ...
        0    0];


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
    Four_Func = Get_Four_Func(delta_omega, par);    % retrieve pulse

    % Store the results of the optimization.
    store_Q(1, p) = Q;
    store_Four(p, :) = par; 
    store_pulse(p, :) = Four_Func;

    p
end
