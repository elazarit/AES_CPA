function c_freq = clk_freq (P_orig, read_trc)
    peaks =2;             % Number of top peaks used for clk freq. calculation
    Fs = 1000000000;      % Sampling frequency                    
    L = read_trc;         % Length of signal


    X = sum(P_orig,1);
    Y = fft(X);

    %Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    %Define the frequency domain f.
    f = Fs*(0:(L/2))/L;
    %Finds akk peakes in descending order with min. 10Mhz gap
    [~,locs] = findpeaks((P1),f,'SortStr','descend','MinPeakDistance', 10000000);

    %Remove all peaks lower then 5Mhz
    locs(locs < 5000000) = [];
    %isolate top peaks and sorting them
    top = locs(1:peaks);
    top = sort(top);
    clk_frq_arr = zeros(peaks,1);
    for j = 1:peaks
        if j == 1
            clk_frq_arr(j) = top(j);
        else
            clk_frq_arr(j) = top(j)-top(j-1);
        end
    end
    %Round the clk signal to 3 significant numbers
    clk_frq_arr = round(clk_frq_arr,3,'significant');
    c_freq = mode(clk_frq_arr);
end
