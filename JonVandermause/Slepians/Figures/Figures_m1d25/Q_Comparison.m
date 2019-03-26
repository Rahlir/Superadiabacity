% Jonathan Vandermause
% January 25, 2017
% Compare Q

q_vec = [q_short(1 : 6), q_1p5(1 : 6)];

figure
subplot(1, 2, 1)
bar(q_vec)

x = 0 : 1/97 : 1;
subplot(1, 2, 2)
plot(x, Q_short(1, 1 : 98))
hold on
plot(x, Q_1p5(1, 1 : 98))