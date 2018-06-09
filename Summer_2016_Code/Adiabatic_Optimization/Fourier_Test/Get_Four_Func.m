% Jonathan Vandermause
% July 11, 2016
% Get Four Func

function[modified_del] = Get_Four_Func(delta_ramp, par)

nop = length(delta_ramp);
modified_del = zeros(1, length(delta_ramp));

for n = 1 : nop
    modified_del(n) = par(1) * delta_ramp(n);
    for j = 2 : length(par)
        modified_del(n) = modified_del(n) + par(j) * ...
            sin((j - 1) * pi * (n - 1) / (nop - 1));
    end
end