% 2/25/2015
% Jon Vandermause
% get max epsilon
% for a given radius, return the largest epsilon that keeps the second
% derivative below a theshold value

function[max_epsilon] = get_max_epsilon(radius, max_deriv)

max_epsilon = (max_deriv * (radius ^ 2)) / 2;