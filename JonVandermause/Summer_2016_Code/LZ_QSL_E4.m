% Jonathan Vandermause
% January 10, 2017
% LZ QSL E4

% Insert parameters.
nop = 300;
iterations = 1e4;
delta_guess = 10 : -20 / (nop - 1) : -10;
omega_guess = ones(1, nop);
initial_state = [1,0;0,0];
target_state = [0,0;0,1];
mag_fac = 300;

% Choose pulse lengths.
not = 10;
lower_t = 0.1;
step = (pi - lower_t) / (not - 2);
upper_t = lower_t + step * (not - 1);
taus = lower_t : step : upper_t;

% Initialize storage vectors.
store_delta = zeros(not, nop);
store_prog = zeros(not, iterations);
store_fid = zeros(1, not);
store_mag = zeros(1, not);

% Loop through pulse lengths.
for n = 1 : not
    tau = taus(n);
    
    % Call GRAPE.
    [fidelity, waveform, progress, mag_fac_final] = GrapeLZAdapt(nop,...
        tau, iterations, delta_guess, omega_guess, initial_state,...
        target_state, mag_fac);
    
    % Update magnifying factor.
    mag_fac = mag_fac_final;
    
    % Store result.
    store_delta(n, :) = waveform;
    store_prog(n, :) = progress;
    store_fid(n) = fidelity;
    store_mag(n) = mag_fac;
    
    n
end

% Plot fidelity as a function of pulse length.
figure
plot(taus, store_fid)