% Jonathan Vandermause
% January 16, 2017
% Speed limit signature

SL_no = 9;
iter = 1 : 1e4;

figure
loglog(iter, 1 - store_prog_E4(SL_no, :).^2)
hold on
loglog(iter, 1 - store_prog_E4(SL_no + 1, :).^2)
hold on
loglog(iter, 1 - store_prog_E4(SL_no - 1, :).^2)
