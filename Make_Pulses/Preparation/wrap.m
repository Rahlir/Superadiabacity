% 4/3/2015
% Jon Vandermause
% wrap up the phase

function[wrapped_phase] = wrap(unwrapped_phase)

nop = length(unwrapped_phase);
wrapped_phase = zeros(1, length(unwrapped_phase));
for n = 1 : nop
    phase = unwrapped_phase(n);
    factor = 360 * floor(phase / 360);
%     if phase >= 0
%         factor = 360 * floor(phase / 360);
%     else
%         factor = 360 * ceil(phase / 360);
%     end
    wrapped_phase(n) = phase - factor;
end