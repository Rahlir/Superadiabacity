% Jonathan Vandermause
% January 19, 2017
% Theta to HZ

% Run optimal waveform test first.
HZ = zeros(1, length(final_theta));

for n = 1 : length(final_theta)
    HZ(n) = tan(final_theta(n) - (pi / 2));
end

figure
plot(HZ)
axis([-10 N+10 -10.5 10.5])