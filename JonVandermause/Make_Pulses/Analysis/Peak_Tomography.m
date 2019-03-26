% Jon Vandermause
% 5/10/2016
% Peak tomography

rep = 60;
peaks = [3929, 4577];
phase_no = 1000;

pls = 25e-6 : 1e-6 : (25e-6 + 59e-6);

header = '~/Desktop/Data/Short_Slepian/';
data_footer = '/pdata/1/1r';
proc_footer = '/pdata/1/procs';

X_meas = zeros(1, rep);
Y_meas = zeros(1, rep);
Z_meas = zeros(1, rep);

ref_sig = return_signal(header, 1);
ref = max(real(ref_sig));

k = 1;
for p = 1 : rep
    for n = 1 : 2  
        signal = return_signal(header, k+1);
        [peak1_phase, max_val, coeffs] = ...
            max_phase(signal, peaks, phase_no);
        
        if n == 1
            X_meas(p) = coeffs(1);
            Y_meas(p) = coeffs(2);
        elseif n == 2
            Z_meas(p) = coeffs(1);
        end
        
        k = k + 1;
    end
    
    p
end

figure
plot(pls, Z_meas / ref)