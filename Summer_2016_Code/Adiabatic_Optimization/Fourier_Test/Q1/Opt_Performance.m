% Jonathan Vandermause
% July 10, 2016
% Q opt performance


sigma_x = [0, 1; 1, 0];
sigma_z = [1, 0; 0, -1];



% Interpolate optimized pulse.
% delta_omega = best_Q3_pulse;
delta_omega = store_delta_E4(2, :);

nop = length(delta_omega);

% power = (pi / 2) / (24.12e-6);
omega_1 = ones(1, nop);

rho_initial = (1/2) * (eye(2) + sigma_z);

rho_final = (1/2) * (eye(2) - sigma_z);

pls_no = 100;
init = 0e-3;
fin = 4 * pi;
pls = init : (fin - init) / (pls_no - 1) : fin;
store = zeros(1, length(pls));

for q = 1 : length(pls)

    pl = pls(q);
    step = pl / nop;
    rho = rho_initial;

    for n = 1 : nop

        H = delta_omega(n) * (sigma_z / 2) + omega_1(n) * (sigma_x / 2);
        U = expm(-1i * H * step);
    
        rho = U * rho * ctranspose(U);
    end

    store(q) = real(trace(ctranspose(rho) * rho_final));

    q
end

hold on
% plot(pls, log10(1 - store.^2))
plot(pls, store)