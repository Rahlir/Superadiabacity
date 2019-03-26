% Jonathan Vandermause
% July 11, 2016
% Fourier Q

function[Q_n] = Fourier_Q(par, delta_ramp, omega_1, pl, frame)

nop = length(delta_ramp);
step = pl / nop;

modified_del = zeros(1, length(delta_ramp));

for n = 1 : nop
    modified_del(n) = par(1) * delta_ramp(n);
    for j = 2 : length(par)
        modified_del(n) = modified_del(n) + par(j) * ...
            sin((j - 1) * pi * (n - 1) / (nop - 1));
    end
end

Q_n = 1 / get_Qn_new(modified_del, omega_1, step, frame);