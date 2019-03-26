% Jonathan Vandermause
% January 21, 2017
% Slep Fit

% Choose pulse parameters.
omega_x = 1;
N = 2^16;
tau_p = 10 * pi;
taus = 0 : tau_p / (N - 1) : tau_p;
bin_no = tau_p * omega_x / (2 * pi);

% Get Slepian, which is optimal for small change in theta.
[Slep_test, lambda] = dpss(N, bin_no);
Slep_0 = Slep_test(:, 1);

% Define x and y data.
xData = taus;
yData = Slep_0;

% Set up fittype and options.
ft = fittype( 'fourier3' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0 0 0 0 0 0 0 9.58752621832545e-05];

% Fit model to data.
[fitresult, gof] = fit( transpose(xData), yData, ft);

integrate(fitresult, taus(length(taus)), 0)