% Jon Vandermause
% May 10, 2016
% get ref phase

function[ref_phase] = get_ref_phase(header, exp_no, phase_no)

signal = return_signal(header, exp_no);
phases = 0 : 2 * pi / (phase_no - 1) : 2 * pi;

max_val = -Inf;

for n = 1 : length(phases)
    phase = phases(n);
    phasor = exp(1i * phase);
    
    new_signal = signal * phasor;
    
    peak_max = max(real(new_signal));
    
    if peak_max > max_val
        max_val = peak_max;
        ref_phase = phase;
    end
end