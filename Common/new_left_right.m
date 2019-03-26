% FUNCTION TO DEFINE NEW EDGE POINTS CHECKING IF LEFT/RIGHT IS
% WITHIN BOUNDS

% 2/25/2015
% Jon Vandermause
% new left right

function [left, right] = new_left_right(center, radius, ... 
    number_of_points)

% Define endpoints of region of interest.
left = center - radius;
right = center + radius;

% Account for edge cases.
if left < 1
    diff = 1 - left;
    left = 1;
    right = right + diff;
elseif right > number_of_points
    diff = right - number_of_points;
    right = right - diff;
    left = left - diff;
end
