% Jonathan Vandermause
% January 19, 2016
% Leakage Function Ex

% Compute Slepian.
N = 1024;
j_res = 0.5;
[Slep_test, lambda] = dpss(N, j_res);

% Store first zeroth Slepian.
Slep_0 = Slep_test(:, 1);

% Define s values.
s_min = 0;
s_max = 8;
nos = 1000;
svals = s_min : (s_max - s_min) / (nos - 1) : s_max;

% Calculate window squared and summed.
W_ss = N * sum(Slep_0.^2);

W = zeros(1, nos);
for n = 1 : nos
    sval = svals(n);
    
    W_curr = 0;
    for k = 0 : N-1
        w_k = Slep_0(k+1);
        four_amp = exp(2*pi*1i*sval*k/N) * w_k;
        W_curr = W_curr + four_amp;
    end
    
    W_curr = (abs(W_curr))^2 / W_ss;
    
    W(n) = W_curr;
end

figure
plot(Slep_0(:, 1))
