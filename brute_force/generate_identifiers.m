% ------------------------------------------------------------------------------
% function generate_identifiers - generate identifiers from specified columns of
%                                 a table
% 
% Inputs:
%   data - table of data
%   columns - indices of columns from which to generate the identifier
%   format - format of the identifier as used in sprintf function
% Outputs:
%   identifiers - column vector of identifiers strings 
%
% Tadeáš Uhlíř
% 03/30/2019
% ------------------------------------------------------------------------------

function[identifiers] = generate_identifiers(data, columns, format)

    identifiers = strings(height(data), 1);

    for i = 1:height(data)
        one_row = data(i, columns);
        identifiers(i) = sprintf(format, one_row.Variables);
    end
