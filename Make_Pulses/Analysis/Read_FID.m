% Jon Vandermause
% 1/13/2015
% Read FID

fname = '~/Desktop/Data/Short_Slepian/2/fid';

start = 80;

fid=fopen(fname,'r','l');
   buf=fread(fid, inf, 'int32');
status=fclose(fid);

signal = zeros(1, length(buf)/2);

k = 1;
for n = 1 : 2 : length(buf) - 1   
    signal(k) = buf(n) + 1i * buf(n + 1);
    k = k + 1;
end

spec = fftshift(fft(signal(start : length(signal))));
% spec = spec * exp(1i * 5);
phase = max_phase(spec, peaks, 1e4);
phased_spec = spec * exp(1i * phase);

figure
subplot(3, 1, 1)
plot(real(signal))
subplot(3, 1, 2)
plot(real(phased_spec))
subplot(3, 1, 3)
plot(imag(phased_spec))