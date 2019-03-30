function[leg] = generate_leg(info, long)

frame = get_par(info, 'frame');
der = get_par(info, 'max_deriv');
iters = get_par(info, 'iterations');

if nargin < 2 || ~long 
    leg = sprintf('n=%d,der=%4.2f,%d', frame, der, iters);
else
    pl = get_par(info, 'pl');
    leg = sprintf('pl=%.0e,n=%d,der=%4.2f', pl, frame, der);
end
