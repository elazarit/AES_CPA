clear variables;
close all;
%% PARAMATERS %%
tic
% AES parameters %
AES_size = 128;
AES_bytes = AES_size/8;
AES_key_opt = 2^8;

% Traces parameters &
% number of traces
n_trc = 200;
% length / number of smaples in each trace
l_trc = 370000;
% trace file address+name
f_trc = '..\Data\1.bin';
% how many samples to skip from the start of each trace
skip_trc = 46500;
% how many samples to skip from the end of each trace
skip_end_trc = 298500;
% total samples to read from each trace
read_trc = l_trc -skip_trc -skip_end_trc;

% Plain text parameters &
% hexa plain text input with "n_trc" inputs line, "AES_size" bits each ("AES_bytes" hexa couples [byte])
f_ptxt = '..\Data\in.txt';

%%
% load trace's BIN file into a matrix
P_orig = trace_to_mat (n_trc, l_trc, f_trc, skip_trc, read_trc);
X = P_orig(100,:);

%Claculate Clk freq. for filtering purposes
c_freq = clk_freq (P_orig, read_trc);

%LP filter, PassBand = 2*c_freq, BlockBand = 2.025*c_freq 
my_filt = designfilt('lowpassiir', 'PassbandFrequency', 2*c_freq, 'StopbandFrequency', 2.025*c_freq, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate', 1000000000, 'DesignMethod', 'cheby1');

%%
%Sampling parameters
Fs = 1000000000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = read_trc;             % Length of signal
t = (0:L-1)*T;        % Time vector

%%
%Plotting the original unfiltered signal in the time domain. 
plot(1000*t(1:L),X(1:L))
title('Original unfiltered X(t)')
xlabel('t (milliseconds)')
ylabel('X(t)')
%Compute the Fourier transform of the signal. 
Y = fft(X);
%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

%Define the frequency domain f and plot the single-sided amplitude spectrum.
figure();
f = Fs*(0:(L/2))/L;
plot(f,20*log10(P1)) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|(dB)')

%%
%Signal filtering
X = filter(my_filt,X);

%Plotting the filtered signal in the time domain. 
figure();
plot(1000*t(1:L),X(1:L))
title('filtered X(t)')
xlabel('t (milliseconds)')
ylabel('X(t)')


%Compute the Fourier transform of the filtered signal. 
Y = fft(X);

%Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

%Define the frequency domain f and plot the single-sided amplitude spectrum.
figure();
f = Fs*(0:(L/2))/L;
plot(f,20*log10(P1)) 
title('Single-Sided Amplitude Spectrum of filtered X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|(dB)')



