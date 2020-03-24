
function raw = pearson_corr (n_trc, read_trc, AES_key_opt, H, P)
    % initialize "raw" array
    raw = zeros(AES_key_opt,read_trc);
    H_C_sum = sum(H);
    P_C_sum = sum(P);
    % calculates the pearson correlation mat "raw" size "AES_key_opt","l_trc"
    for i = 1:AES_key_opt
        for j = 1:read_trc
            % claculate H' and P' for every "i" and "j"
            H_avg = H_C_sum(i)/n_trc;
            P_avg = P_C_sum(j)/n_trc;
            % numerator calculation
            numerator=0;
            for k = 1:n_trc
                numerator = numerator + (H(k,i) - H_avg)*(P(k,j) - P_avg);
            end
            % denumerator calculation
            denom_H = 0;
            denom_P = 0;
            for k = 1:n_trc
               denom_H = denom_H + (H(k,i) - H_avg)^2;
               denom_P = denom_P + (P(k,j) - P_avg)^2;
            end
            denominator = sqrt((denom_H*denom_P));
            % pearson correlation mat calculation
            raw(i,j) = numerator/denominator;
        end    
    end 
end