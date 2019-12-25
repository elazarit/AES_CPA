%% PARAMATERS %%

% AES parameters %
% Sets AES key size between 128, 192, 256;
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
skip_trc = 0;
% how many samples to skip from the end of each trace
skip_end_trc = 0;
% total samples to read from each trace
read_trc = l_trc -skip_trc -skip_end_trc;

% Plain text parameters &
% hexa plain text input with "n_trc" inputs line, "AES_size" bits each ("AES_bytes" hexa couples [byte])
f_ptxt = '..\Data\in.txt';

%%
% load trace's BIN file into a matrix
P = trace_to_mat (n_trc, l_trc, f_trc, skip_trc, read_trc);
% load hexa plain text file and convert it into a decimal matrix
X = ptxt_to_mat (n_trc, f_ptxt, AES_bytes);


% initialize output arrays %
% dec_key - guessed key in decimal values
% MAX_corr - max abs' correlation of the guessed key
% dec_key - second highest correlation after the guessed key
dec_key = zeros(1,AES_bytes);
MAX_corr = zeros(1,AES_bytes);
S_MAX_corr = zeros(1,AES_bytes);

% main loop, run through all the "AES_bytes" key bytes.
for key = 1:AES_bytes
    % initialize XxorK array 
    XxorK = zeros(n_trc,AES_key_opt);
    % bitxor-ing the "key" column of X with all the "AES_key_opt" options
    for i = 1:AES_key_opt
        XxorK(:,i) = bitxor(X(:,key),i-1);
    end
    % pass "XxorK" matrix through S-BOX transformation
    B = SBOX_table(XxorK(:,:)+1);
    
    % initialize "h" array
    H = zeros(n_trc,AES_key_opt);
    % Create mat "H" by calculating Hamming weight (by counting num of 1's)
    for i = 1:AES_key_opt
        H(:,i) = sum(dec2bin(B(:,i)).' == '1' );
    end
    
    % initialize "raw" array
    raw = zeros(AES_key_opt,n_trc);
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
    % pearson correlation absolute value's mat
    abs_raw = abs(raw);
    % gets the maximum correlation of each key
    M_raw = max(abs_raw,[],2);
    % saves the guessed key to "dec_key" and its correlation to "MAX_corr"
    [MAX_corr(key), dec_key(key)] = max(M_raw,[],1);
    % looks for the second heighest correlation
    M_raw(dec_key(key))=0;
    % -1 fix - 1:256 range to 0:255 range of keys
    dec_key(key) = dec_key(key) -1;
    S_MAX_corr(key) = max(M_raw,[],1);
end
% converts the guessed decimal keys to hexa keys
hex_key = dec2hex(dec_key);

%%

%xlswrtie()

%figure(1)
%plot(raw')                                           % Without Independent Variable
%grid
%xlabel('Load in Kips')
%ylabel('Percentage')

%%
