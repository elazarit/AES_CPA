function [M_raw, MAX_corr, dec_key, S_MAX_corr] = max_corr(raw, raw1, raw2)
    % pearson correlation absolute value's mats
    abs_raw = abs(raw);
    abs_raw1 = abs(raw1);
    abs_raw2 = abs(raw2);
    % gets the maximum correlation of each key
    M_raw = max(abs_raw,[],2).*max(abs_raw1,[],2).*max(abs_raw2,[],2);
    % saves the guessed key to "dec_key" and its correlation to "MAX_corr"
    [MAX_corr, dec_key] = max(M_raw,[],1);
    % looks for the second heighest correlation
    M_raw(dec_key)=0;
    % -1 fix - 1:256 range to 0:255 range of keys
    dec_key = dec_key -1;
    S_MAX_corr = max(M_raw,[],1);
end