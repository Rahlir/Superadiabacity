% 2/9/2015
% Smooth tanh.
function [result] = correct_atan(delta_omega,omega_1)

result = zeros(1,length(omega_1));

add = 0;
factor = 0;
for n = 1 : length(delta_omega)
    result(n) = atan(delta_omega(n) / omega_1(n)) + factor;
    
    if n > 1
        diff = result(n) - result(n-1);
        if abs(diff) > 1
            if diff < 0
                add =  pi;
                result(n) = result(n) + pi;
            else
                add = -pi;
                result(n) = result(n) - pi;
            end
            factor = factor + add;
        end
    end
end

if result(1) < 0
    result = result + pi/2;
else
    result = result - pi/2;
end

% figure
% plot(initial)
% figure
% plot(result)
       