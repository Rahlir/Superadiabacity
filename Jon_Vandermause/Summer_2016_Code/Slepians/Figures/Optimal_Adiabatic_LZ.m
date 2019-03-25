% Jonathan Vandermause
% January 20, 2017
% Optimal adiabatic LZ

% Choose Rabi frequency.
omega_x = 1;

% Calculate total angle.
theta_init = (pi / 2) + atan(10);
theta_fin = (pi / 2) - atan(10);
total_ang = theta_init - theta_fin;

% Choose pulse parameters.
N = 5e5;
% tau_p = tau;
tau_p = 0.001;
bin_no = tau_p * omega_x / (2 * pi);
taus = 0 : tau_p / (N - 1) : tau_p;

% Get Slepian, which is optimal for small change in theta.
[Slep_test, lambda] = dpss(N, bin_no);
Slep_0 = Slep_test(:, 1);

% Compute integral in advance.
int_adv = trapz(taus, Slep_0);
fac = total_ang / int_adv;
Slep_Mod = -Slep_0 * fac;

% Integrate to get theta as a function of tau.
thetas = zeros(1, N);
ts = zeros(1, N);
for n = 1 : N
    if n == 1
        thetas(n) = theta_init;
    else
        thetas(n) = thetas(n - 1) + trapz(taus(n-1 : n), ...
            Slep_Mod(n-1 : n));
    end
    
    if n > 1
        ts(n) = ts(n - 1) + trapz(taus(n-1 : n), ...
            sin(thetas(n-1 : n)));
    end
    
    if (n / 1e4) == round(n / 1e4)
        n / 1e4
    end
end

% Define real ts.
t_points = 100;
real_ts = 0 : ts(length(ts)) / (t_points - 1) : ts(length(ts));

% Calculate theta as a function of t.
final_theta = interp1(ts, thetas, real_ts);

% Report pulse length.
pulse_length = ts(length(ts))

HZ = zeros(1, length(final_theta));

for n = 1 : length(final_theta)
    HZ(n) = tan(final_theta(n) - (pi / 2));
end

figure
plot(HZ)
axis([-10 t_points+10 -10.5 10.5])