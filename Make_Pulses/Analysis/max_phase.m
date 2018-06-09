% Jon Vandermause
% April 28, 2016
% max phase

% Take the real part of an NMR spectral signal, and choose a peak. Phase
% the signal until the peak is maximized, and use the maximum value to
% estimate the intensity of the absorptive and lorentzian components of the
% signal.

function[peak1_phase, max_val, coeffs] = max_phase(signal, peaks, phase_no)


phases = 0 : 2 * pi / (phase_no - 1) : 2 * pi;
max_val = -Inf;

for n = 1 : length(phases)
    phase = phases(n);
    phasor = exp(1i * phase);
    
    new_signal = signal * phasor;
    
    peak1_max = max(real(new_signal(peaks(1) : peaks(2))));

    if peak1_max > max_val
        max_val = peak1_max;
        peak1_phase = phase;
    end
    
end

coeffs(1) = max_val * cos(peak1_phase);
coeffs(2) = max_val * sin(-peak1_phase);