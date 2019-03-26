% 2/25/2015
% Jon Vandermause
% perturb_quadratic

function[perturb] = perturb_quadratic(curve, point, radius, epsilon)

number_of_points = length(curve);
perturb = curve;

[left, right] = new_left_right(point, radius, number_of_points);

for n = left : right
    delta = (-epsilon / (radius^2)) * (n - left) * ...
        (n - right);

    perturb(n) = perturb(n) + delta;
    
end