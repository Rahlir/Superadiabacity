% Jonathan Vandermause
% January 24, 2017
% Find tau_p

ntp = 100;
taup_max = 2.311;
taup_min = 2.11;
tau_ps = taup_min : (taup_max - taup_min) / (ntp - 1) : taup_max;

pulse_lengths = zeros(1, ntp);

for q = 1 : length(tau_ps)
    tau_p = tau_ps(q);

    % Choose Rabi frequency.
    omega_x = 1;

    % Calculate total angle.
    theta_init = (pi / 2) + atan(10);
    theta_fin = (pi / 2) - atan(10);
    total_ang = theta_init - theta_fin;

    % Choose pulse parameters.
    N = 1e3;
    bin_no = tau_p * omega_x / (2 * pi);
    taus = 0 : tau_p / (N - 1) : tau_p;

    % Get Slepian, which is optimal for small change in theta.
    [Slep_test, lambda] = dpss(N, bin_no);
    Slep_0 = Slep_test(:, 1);

    % Compute integral in advance.
    int_adv = trapz(taus, Slep_0);
    fac = total_ang / int_adv;
    Slep_0 = -Slep_0 * fac;

    % Integrate to get theta as a function of tau.
    thetas = zeros(1, N);
    ts = zeros(1, N);
    for n = 1 : N
        if n == 1
            thetas(n) = theta_init;
        else
            thetas(n) = thetas(n - 1) + trapz(taus(n-1 : n), ...
                Slep_0(n-1 : n));
        end

        if n > 1
            ts(n) = ts(n - 1) + trapz(taus(n-1 : n), ...
                sin(thetas(n-1 : n)));
        end
    end

    pulse_lengths(q) = ts(length(ts));
    
    q
end

figure
plot(tau_ps, pulse_lengths)