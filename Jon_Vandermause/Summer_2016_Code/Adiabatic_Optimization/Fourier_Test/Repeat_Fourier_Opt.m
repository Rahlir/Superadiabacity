% Jonathan Vandermause
% January 17, 2017
% Repeat Fourier

% Prepare pulse.
nop = 1000;
power = 1;
T = pi;
step = T / nop;
omega_1 = ones(1, nop) * power;

delta_omega = zeros(1, nop);
for n = 1 : nop
    delta_omega(n) = 10 * power - (2 * 10 * power * (n - 1)) / (nop - 1);
end

% Prepare optimization.
rep = 100;

lowb = [10, -Inf, -Inf, -Inf, -Inf];
upperb = [100, Inf, Inf, Inf, Inf];

store_Q = zeros(1, rep);
store_Four = zeros(rep, length(lowb));
store_pulse = zeros(rep, nop);

frame = 1;

for p = 1 : rep
    rand_guess = [50 * rand, 10 * ((rand * 2) - 1), ...
        10 * ((rand * 2) - 1), 10 * ((rand * 2) - 1), ...
        10 * ((rand * 2) - 1)];
    
    [par, fval] = fmincon(@(par) Fourier_Q(par, delta_omega, ...
        omega_1, T, frame), rand_guess, [], [], [], [], ...
        lowb, upperb);

    Q = 1/fval
    Four_Func = Get_Four_Func(delta_omega, par);
    
    store_Q(p) = Q;
    store_Four(p, :) = par; 
    store_pulse(p, :) = Four_Func;
    
    p
end

q = 0;
for n = 1 : length(store_Q)
    if store_Q(n) < 3
        q = q + 1;
        filt_Q(q) = store_Q(n);
        filt_Four(q, :) = store_Four(n, :);
        filt_pulse(q, :) = store_pulse(n, :);
    end
end