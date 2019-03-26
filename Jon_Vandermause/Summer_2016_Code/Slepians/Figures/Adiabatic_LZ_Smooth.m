% Jonathan Vandermause
% January 24, 2017
% Smooth Adiabatic LZ

% Choose Rabi frequency.
omega_x = 1;

% Choose pulse parameters.
N = 2^10;
tau_p = 10 * pi;
bin_no = tau_p * omega_x / (2 * pi);
taus = 0 : tau_p / (N - 1) : tau_p;

% Calculate total angle.
theta_init = (pi / 2) + atan(10);
theta_fin = (pi / 2) - atan(10);
total_ang = theta_init - theta_fin;

% Get Slepian, which is optimal for small change in theta.
[Slep_test, lambda] = dpss(N, bin_no);
Slep_0 = Slep_test(:, 1);

% Fit Slepian to approximate it as an infinitely differentiable function.
smooth_func = fit(transpose(taus), Slep_0, 'fourier5');

% Discretize fitted Slepian.
new_points = 1e4;
new_taus = 0 : tau_p / (new_points - 1) : tau_p;
Slep_Disc = zeros(1, new_points);
for n = 1 : new_points
    tau_curr = new_taus(n);
    Slep_Disc(n) = feval(smooth_func, tau_curr);
end

% Compute integral in advance.
int_adv = trapz(new_taus, Slep_Disc);
fac = total_ang / int_adv;
Slep_Disc = -Slep_Disc * fac;

% Integrate to get theta as a function of tau.
thetas = zeros(1, new_points);
for n = 1 : new_points
    if n == 1
        thetas(n) = theta_init;
    else
        thetas(n) = trapz(new_taus(1 : n), Slep_Disc(1 : n)) + theta_init;
    end
end

% Calculate real time as a tunction of tau.
ts = zeros(1, new_points);
for n = 2 : new_points
    ts(n) = trapz(new_taus(1 : n), sin(thetas(1 : n)));
end

% Define real ts.
t_points = 300;
real_ts = 0 : ts(length(ts)) / (t_points - 1) : ts(length(ts));

% Calculate theta as a function of t.
final_theta = interp1(ts, thetas, real_ts);

HZ = zeros(1, length(final_theta));

for n = 1 : length(final_theta)
    HZ(n) = tan(final_theta(n) - (pi / 2));
end

figure
plot(HZ)
axis([-10 t_points+10 -10.5 10.5])