% 3/4/2015
% Jon Vandermause
% perturb_delta

function[perturb] = perturb_delta(curve, point, radius, epsilon)

number_of_points = length(curve);
perturb = curve;

left = point - radius;
right = point + radius;

for n = left : right
    delta = (-epsilon / (radius^2)) * (n - left) * ...
        (n - right);
    if n > 0 && n <= number_of_points
        perturb(n) = perturb(n) + delta;
    end
end