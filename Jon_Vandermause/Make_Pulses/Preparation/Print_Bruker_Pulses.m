% Jon Vandermause
% 6/21/2016
% Prepare Multiple

function Print_Bruker_Pulses(delta_omega, omega_1, Ts, pi_length, ...
    head, start_no)

N = length(delta_omega);   % number of points
rabi = pi / pi_length;  % Rabi frequency
foot = '.txt';          % footer of generated text file
    
for j = 1 : length(Ts)
    T = Ts(j);  % pulse length
    pt = 0 : T/(N - 1) : T; % pulse times

    % Calculate the phase from delta omega.
    phase = zeros(1, N);
    for n = 2 : N
        phase(n) = -trapz(pt(1 : n), delta_omega(1 : n));
    end
    phase = phase + (pi - phase(N));    % ensure that final phase is pi
    
    max_power = rabi; % set maximum power

    power = (omega_1 / max_power) * 100;

    % Convert phase to wrapped degrees.
    phase = phase * (360 / (2 * pi));
    phase = wrap(phase);
    
    % Define array that stores the pulse power and phase.
    array = [power; phase];
    
    % Create file name.
    text_index = start_no + j - 1;
    file_name = strcat(head,num2str(text_index),foot);

    % Enter the first 18 lines of the pulse program manually.
    header_lines = 18;

    header = cell(1, header_lines);
    
    points_string = strcat({'##NPOINTS= '},num2str(N));
    points_string = points_string{1};

    header{1} = ...
        '##TITLE= /opt/topspin3.0/exp/stan/nmr/lists/wave/user/HypSec_trunc2.84_110';
    header{2} = '##JCAMP-DX= 5.00 Bruker JCAMP library';
    header{3} = '##DATA TYPE= Shape Data';
    header{4} = '##ORIGIN= Bruker BioSpin GmbH';
    header{5} = '##OWNER= <nmrsu>';
    header{6} = '##DATE= 15/02/24';
    header{7} = '##TIME= 16:15:04';
    header{8} = '##MINX= 1.164538e+01';
    header{9} = '##MAXX= 9.999960e+01';
    header{10} = '##MINY= 2.546774e-02';
    header{11} = '##MAXY= 3.585574e+02';
    header{12} = '##$SHAPE_EXMODE= Adiabatic';
    header{13} = '##$SHAPE_TOTROT= 1.800000e+02';
    header{14} = '##$SHAPE_BWFAC= 1.929340e+02';
    header{15} = '##$SHAPE_INTEGFAC= 2.356110e-02';
    header{16} = '##$SHAPE_MODE= 0';
    header{17} = points_string;
    header{18} = '##XYPOINTS= (XY..XY)';

    % Loop through header array and print to text file.
    fileID = fopen(file_name,'w');
    for n = 1 : header_lines
        fprintf(fileID,'%s\n', header{n});
    end
    fprintf(fileID,'%.6e, %.6e\n', array);
    fprintf(fileID, '%s', '##END= ');
    fclose(fileID);
end