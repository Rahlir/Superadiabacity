% Jonathan Vandermause
% January 25, 2017
% Performance Comparison

figure
semilogy(pls, 1 - store_short.^2)
hold on
semilogy(pls, 1 - store_1p5.^2)

theta_init = (pi / 2) + atan(10);
theta_fin = (pi / 2) - atan(10);
total_ang = theta_init - theta_fin;

hold on
plot([total_ang, total_ang], [10^-11, 1], 'k--')