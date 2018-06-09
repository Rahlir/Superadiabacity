% Jonathan Vandermause
% January 24, 2017
% Tau Hunt

desired_pl = total_ang * 1.5;

for n = 1 : length(tau_ps)
    pl_curr = pulse_lengths(n);
    
    if pl_curr > desired_pl
        tau = tau_ps(n);
        break
    end
end

