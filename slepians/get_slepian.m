% Jonathan Vandermause
% January 20, 2017
% Optimal adiabatic LZ

function[final_theta, pl, HZ] = get_slepian(bandwidth)
    % Choose Rabi frequency.
    omega_x = 1;
    % Choose pulse parameters.
    N = 2^10;
    taus = linspace(0, tau_p, N);

    % Calculate total angle.
    theta_init = (pi / 2) + atan(10);
    theta_fin = (pi / 2) - atan(10);
    total_ang = theta_init - theta_fin;

    % Get Slepian, which is optimal for small change in theta.
    Slep_test = dpss(N, bandwidth);
    Slep_0 = Slep_test(:, 1);

    % Compute integral in advance.
    int_adv = trapz(taus, Slep_0);
    fac = total_ang / int_adv;
    Slep_0 = -Slep_0 * fac;

    % Integrate to get theta as a function of tau.
    thetas = zeros(1, N);
    for n = 1 : N
        if n == 1
            thetas(n) = theta_init;
        else
            thetas(n) = trapz(taus(1 : n), Slep_0(1 : n)) + theta_init;
        end
    end

    % Calculate real time as a tunction of tau.
    ts = zeros(1, N);
    for n = 2 : N
        ts(n) = trapz(taus(1 : n), sin(thetas(1 : n)));
    end

    % Define real ts.
    real_ts = 0 : ts(length(ts)) / (N - 1) : ts(length(ts));

    % Calculate theta as a function of t.
    final_theta = interp1(ts, thetas, real_ts);

    % Report pulse length.
    %ts(length(ts)) / (2 * pi)

    HZ = tan(final_theta - (pi / 2));

    hold on
    plot(HZ)
    axis([-10 N+10 -10.5 10.5])
