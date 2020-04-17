function shift = POCShift(fixed, moving)
%POCSHIFT Estimates the translation between two traces
%by phase-only correlation.
%   The algorithm works as follows:       
%     1. The FFT of both traces are calculated as well as the normalized
%        cross spectrum R.
%     2. The inverse Fourier transform r of a low-pass filtered R is computed
%     3. The translation is computed from the position of the peak in r
% implementation 
% 1. Calculate the FFT of both traces and the normalized cross-spectrum
F=fftshift(fft(fixed));
M=fftshift(fft(moving));
R=(F.*conj(M))./abs((F.*conj(M)));
R(isnan(R))=0;
% 3.IFFT OF R
r = fftshift(abs(ifft(R)));
% 3. Estimate the translation:
rmax = max(max(r));
y = find(r == rmax);
y=ceil(length(fixed)/2)-y+1;
shift=y;
end



