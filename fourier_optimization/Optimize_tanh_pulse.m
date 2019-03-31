% ------------------------------------------------------------------------------
% script Optimize_tanh_pulse - optimizes the parameters A, x, kappa, for the 
% tan/tanh pulse to find tan/tanh pulse that has the highest Q factor
% 
% Tadeáš Uhlíř
% 03/31/2019
% Original by:
% Jon Vandermause
% 3/17/2015
% ------------------------------------------------------------------------------

% optimize Qs (set frames = 10): (120us pulse)
As = 49e5 : 1e4 : 51e5;
xis = 48 : 0.1 : 50;
kappas = 64 : 0.1 : 67;

% optimize Qs (set frames = 10): (100us pulse)
% As = 53e5 : 1e4 : 55e5;
% xis = 49 : 0.1 : 51;
% kappas = 69 : 0.1 : 71;

% % optimize Qs (set frames = 10): (50us pulse)
% As = 26e5 : 1e4 : 28e5;
% xis = 40 : 0.1 : 42;
% kappas = 35 : 0.1 : 37;

% optimize Qs (set frames = 10): (Q1)
% As = 3e5 : 1e4 : 5e5;
% xis = 15 : 0.1 : 17;
% kappas = 6 : 0.1 : 8;

frames = 10;

number_of_points = 300;
time_step = tau / (number_of_points - 1);

max_Q = 0;
best_xi = 0;
best_kappa = 0;
best_A = 0;

for i = 1 : length(As)
    A = As(i);
    for j = 1 : length(xis)
        xi = xis(j);
        for k = 1 : length(kappas)
            kappa = kappas(k);

            [delta_omega, omega_1] = get_tanh(number_of_points, A, ...
                kappa, w_max, xi);

            Q_curves = get_Q_curves(delta_omega, omega_1, time_step, frames);

            current_Q = max(Q_curves);

            if current_Q > max_Q
                max_Q = current_Q;
                best_A = As(i);
                best_xi = xis(j);
                best_kappa = kappas(k);

                best_delta_omega = delta_omega;
                best_omega_1 = omega_1;
            end
        end
    end

    i
end

max_Q
best_xi
best_A
best_kappa

q = get_Q_curves(best_delta_omega, best_omega_1, time_step, frames)

hold on
subplot(2, 1, 1)
hold on
plot(best_delta_omega)
subplot(2, 1, 2)
hold on
plot(best_omega_1)
