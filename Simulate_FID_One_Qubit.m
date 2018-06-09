% Jonathan Vandermause
% July 21, 2017
% Simulate FID One Qubit

sigma_x = [0, 1; 1, 0];
sigma_y = [0, -1i; 1i, 0];
sigma_z = [1, 0; 0, -1];

% JYY = expm(-1i * (pi / 2) * kron(sigma_y, eye(2)) / 2) * ...
%     expm(-1i * (pi / 2) * kron(eye(2), sigma_y) / 2) * ...
%     expm(-1i * (pi / 2) * kron(sigma_z, sigma_z) / 2) * ...
%     expm(-1i * (pi / 2) * kron(eye(2), sigma_x) / 2);

% Input the density operator to be simulated:
detect = sigma_x;

decay = -50;

X90 = expm(-1i * (pi/2) * sigma_x / 2);
Y90 = expm(-1i * (pi/2) * sigma_y / 2);

sigma_plus = sigma_x + 1i * sigma_y;
sigma_minus = sigma_x - 1i * sigma_y;
test = sigma_y + 1i * sigma_x;

% Define Hamiltonian.
omega_1 = 50;   % in radians per second

Hamiltonian = -pi * omega_1 * sigma_z;


L = 5000;   % length of signal
T = 5;   % final time
acqu_time = 0 : T / (L - 1) : T;
Fs = (L - 1) / T;   % sampling frequency
samp_period = 1 / Fs;   % sampling period
freq_vec = Fs * ((-(L/2)+1) : (L/2)) / L;  % frequency vector

FID = zeros(1, length(acqu_time));
for n = 1 : length(acqu_time)
    time = acqu_time(n);
    current_rho = expm(-1i * Hamiltonian * time) * ...
        detect * expm(1i * Hamiltonian * time);
    
    
    FID(n) = trace(current_rho * ...
        sigma_minus)*exp(decay * time);
end

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create plot
subplot(2, 1, 1)
plot(freq_vec, real(fftshift(fft(FID))))

subplot(2, 1, 2)
plot(freq_vec, imag(fftshift(fft(FID))))