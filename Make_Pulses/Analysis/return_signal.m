% Jon Vandermause
% May 10, 2016
% return signal

function [signal] = return_signal(header, exp_no)

% Define file name.
real_fname = strcat(header,num2str(exp_no),'/pdata/1/1r');
imag_fname = strcat(header,num2str(exp_no),'/pdata/1/1i');
procfile = strcat(header,num2str(exp_no),'/pdata/1/procs');

% Record spectrum.
real_file = fopen(real_fname,'r');
real_buf = fread(real_file, inf, 'int32');
fclose(real_file);

% Record spectrum.
imag_file = fopen(imag_fname,'r');
imag_buf = fread(imag_file, inf, 'int32');
fclose(imag_file);

% Record proc_no.
fid2 = fopen(procfile, 'r');
test = textscan(fid2, '%s');
fclose(fid2);
proc = test{1}{131};

real_spec = real_buf * (2 ^ (str2double(proc)));
imag_spec = imag_buf * (2 ^ (str2double(proc)));

signal = real_spec + 1i * imag_spec;