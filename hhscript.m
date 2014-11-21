%  This script can be used to generate simulation data using the
%current-clamped configuration.  The temperature is varied while all
%other parameters remain unchanged.

%  With each setting of the temperature, the simulation is run and the
%resulting data is saved to data files which can then be used to
%display the results in the Comparisons figure.

%  Before using the script, make sure that the Hodgkin-Huxley
%biophysics software has been started.
%If it hasn't been started, start the software using SOFTCELL.M
%      softcell('hh');

%hhscr('set') will list the parameters that can be changed

%  Insure that the current clamped configuration is being used.
hhscr('set','Configuration','current-clamped');

%  Since a lot of files will be created, it is best to store them in a
%separate folder.  Examples of foldername are
%foldername = 'C:\data\temp'; %Windows
%foldername = '/user/tsb/data/temp'; %UNIX
%foldername = 'MacHD:matlab:data:temp'; %Mac
foldername = pwd;

% set duration to 100 ms
hhscr('set', 'stimulus', 'duration', 100);
hhscr('set', 'numerics', 'initialstep', 0.025);
hhscr('set', 'numerics', 'maxstep', 0.025);
hhscr('set', 'numerics', 'reltol', 1e-7);

%  Set up a loop that samples through a temperature range.
pfig = figure;
paxes = axes;
hold(paxes, 'on');
FREQS = [];

for holdCurrent = 0:1:0
    for currentStep = 10:1:20
        hhscr('set', 'stimulus', 'holding', holdCurrent);

        hhscr('set', 'stimulus', 'pulse1', 'start', 10);
        hhscr('set', 'stimulus', 'pulse1', 'duration', 91);
        hhscr('set', 'stimulus', 'pulse1', 'amplitude', currentStep);
        hhscr('set', 'stimulus', 'pulse1', 'slope', 0);

        %perform simulation
        hhscr('start');

        %give yourself a note: indicate in the console what the settings are
        desc = ['hold = ' num2str(holdCurrent) ' uA/cm^2, step = ' num2str(currentStep) ' uA/cm^2'];
        disp(desc);

        [userdata, fig] = hhcntrl('data');
        %SAVEDATA
        s = struct('HHP',[],'t',[],'y',[],'HHS',[],'spar',[],'num',[],'dur',[]);
        s.HHP = getappdata(fig,'HHP'); 
        s.HHS = getappdata(fig,'HHS');
        s.t = getappdata(fig,'t'); 
        s.y = getappdata(fig,'y');
        s.spar = getappdata(fig,'spar'); 
        s.num = getappdata(fig,'num');
        s.dur = getappdata(fig,'dur');
        
        % added CODE HERE
Fs = 1;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = length(s.y(:,1));                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
[maxValue,indexMax] = max(abs(fft(s.y(:,1)-mean(s.y(:,1)))));
freq = indexMax * Fs / L;
FREQS = [FREQS, freq];
        % END ADDED CODE HERE
        
        pfig = figure;
        paxes = axes;
        
        plot(paxes, s.t, s.y(:,1), 'LineWidth', 1, 'Color', [0 0 0.4]);
        ylim(paxes, [-70,30]);
        title(paxes, desc);
        saveas(pfig, ['current_0_tiny_' sprintf('%04d', floor(currentStep * 100)) '.jpg']);
        close(pfig);
    end
end

ffig = figure;
faxes = axes;
hold(faxes, 'on');
title(faxes, 'Frequency changes');
plot(faxes, range(length(FREQS)), FREQS, 'LineWidth', 1, 'Color', [0 0 0.4]);

%That's it -- all the data has been saved.

%Now, put up all the data simultaneously by following these steps:
%1. call up the "Graphics" figure,
%2. using "Setup", select whichever variable(s) to plot,
%3. still inside "Setup HH plot", select the source of "Get values from"
%   to be the "Files with parameters".
% 3a. using "Select files", add the files to the list "Use these files".
% 3b. select "Overlay" to view the selected variable(s) in all the datafiles.
