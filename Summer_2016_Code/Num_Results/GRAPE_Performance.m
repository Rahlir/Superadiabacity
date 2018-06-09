% Jonathan Vandermause
% January 16, 2017
% Grape performance

figure
plot(taus_1000(1 : 37), store_fid_1000(1 : 37), 'b-')
hold on
plot(taus_1000(38 : 60), store_fid_1000(38 : 60), 'b-')
hold on
plot(taus_E4, store_fid_E4, 'kx')
axis([taus_1000(1) 3.6 -0.1 1.1])