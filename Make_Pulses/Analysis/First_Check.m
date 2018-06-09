% Jonathan Vandermause
% July 22, 2017
% First check

figure
subplot(3, 1, 1)
plot(physical_pls, X)
hold on
plot(pls, X_meas/ref, '.')

subplot(3, 1, 2)
plot(physical_pls, Y)
hold on
plot(pls, Y_meas/ref, '.')

subplot(3, 1, 3)
plot(physical_pls, Z)
hold on
plot(pls, Z_meas/ref, '.')