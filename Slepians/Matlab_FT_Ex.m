% Jonathan Vandermause
% January 19, 2017
% Matlab FT Ex

Fs = 1000;  % Sampling frequency
T = 1 / Fs; % Sampling period
L = 1000;   % Length of signal
t = (0:L-1)*T;  % Time vector

% Generate signal.
S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);

% Add noise.
X = S + 2*randn(size(t));

% Fourier transform.
Y = fft(X);
P2 = abs(Y/L);  % two sided spectrum

% two sided spectrum:
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% Define frequencies.
f = Fs*(0:(L/2))/L;

figure
plot(f, P1)