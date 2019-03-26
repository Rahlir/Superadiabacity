% Jonathan Vandermause
% January 19, 2017
% Slepian test

N = 2048;
j_res = 0.1;

[Slep_test, lambda] = dpss(N, j_res);

Slep_Freq = fft(Slep_test(:, 1));
Slep_Freq_Amp = zeros(1, N + 1);
for n = 1 : N
    % Zero frequency and positive frequencies.
    if n <= (N/2 + 1)
        Slep_Freq_Amp((N/2) + n) = abs(Slep_Freq(n));
    end
    
    % Negative frequencies.
    if n >= (N/2 + 1)
        Slep_Freq_Amp(n - (N/2)) = abs(Slep_Freq(n));
    end
end

hold on
plot(Slep_Freq_Amp)
    