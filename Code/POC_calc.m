function shift = POC_calc(fixed, moving)
    %Calculate the FFT of both traces and the normalized cross-spectrum correlation
    F=fftshift(fft(fixed));
    M=fftshift(fft(moving));
    R=(F.*conj(M))./abs((F.*conj(M)));
    R(isnan(R))=0;
    %IFFT OF R
    r = fftshift(abs(ifft(R)));
    %Estimate the translation:
    [~,y] = max(r);
    shift=ceil(length(fixed)/2-y+1);
end



