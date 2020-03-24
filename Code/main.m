%% PARAMATERS %%
tic
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
skip_trc = 45000;
% how many samples to skip from the end of each trace
skip_end_trc = 295000;
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

dec_key_wds = zeros(1,AES_bytes);
MAX_corr_wds = zeros(1,AES_bytes);
S_MAX_corr_wds = zeros(1,AES_bytes);

dec_key_w = zeros(1,AES_bytes);
MAX_corr_w = zeros(1,AES_bytes);
S_MAX_corr_w = zeros(1,AES_bytes);

dec_key_d = zeros(1,AES_bytes);
MAX_corr_d = zeros(1,AES_bytes);
S_MAX_corr_d = zeros(1,AES_bytes);

dec_key_s = zeros(1,AES_bytes);
MAX_corr_s = zeros(1,AES_bytes);
S_MAX_corr_s = zeros(1,AES_bytes);
%%
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
    
    % initialize "h" arrays
    H = zeros(n_trc,AES_key_opt);
    H1 = zeros(n_trc,AES_key_opt);
    H2 = zeros(n_trc,AES_key_opt);
    
    % Create mat "H" by calculating Hamming weight (by counting num of 1's)
    for i = 1:AES_key_opt
        %HW
        H(:,i) = sum(dec2bin(B(:,i)).' == '1' );
        
        %HD
        H1(:,i) = sum(dec2bin(bitxor(B(:,i),XxorK(:,i))).' == '1' );
        
        %SD
        bin_sum = sum(dec2bin(bitxor(B(:,i),XxorK(:,i))).' == '1' );
        bin_to_0 = sum(dec2bin(bitand(bitxor(B(:,i),XxorK(:,i)),XxorK(:,i))).' == '1' );
        H2(:,i) = bin_to_0*0.5+bin_sum;    
    end
    %%
    % Calculate "raw" arrays
    raw = pearson_corr (n_trc, read_trc, AES_key_opt, H, P);
    raw1 = pearson_corr (n_trc, read_trc, AES_key_opt, H1, P);
    raw2 = pearson_corr (n_trc, read_trc, AES_key_opt, H2, P);
    %%    
    % Pearson correlation mats for  HWHDSD, HW, HD and SD 
    [M_raw_wds, MAX_corr_wds(key), dec_key_wds(key), S_MAX_corr_wds(key)] = max_corr(raw, raw1, raw2);
    [M_raw_w, MAX_corr_w(key), dec_key_w(key), S_MAX_corr_w(key)] = max_corr(raw, 1, 1);
    [M_raw_d, MAX_corr_d(key), dec_key_d(key), S_MAX_corr_d(key)] = max_corr(1, raw1, 1);
    [M_raw_s, MAX_corr_s(key), dec_key_s(key), S_MAX_corr_s(key)] = max_corr(1, 1, raw2);
    % Threshold for switching from HWHDSD to the biggest of HW/HD/SD
    if ((MAX_corr_wds(key)/S_MAX_corr_wds(key))>1.35)
        dec_key(key) = dec_key_wds(key);
        MAX_corr(key) = MAX_corr_wds(key);
        S_MAX_corr(key) = S_MAX_corr_wds(key);
    else
        corr_temp = [(MAX_corr_w(key)/S_MAX_corr_w(key)),(MAX_corr_d(key)/S_MAX_corr_d(key)),(MAX_corr_s(key)/S_MAX_corr_s(key))];
        [CR,i_temp] = max(corr_temp);
        if (i_temp==1)
            dec_key(key) = dec_key_w(key);
            MAX_corr(key) = MAX_corr_w(key);
            S_MAX_corr(key) = S_MAX_corr_w(key);
        elseif (i_temp==2)
            dec_key(key) = dec_key_d(key);
            MAX_corr(key) = MAX_corr_d(key);
            S_MAX_corr(key) = S_MAX_corr_d(key);
        else
            dec_key(key) = dec_key_s(key);
            MAX_corr(key) = MAX_corr_s(key);
            S_MAX_corr(key) = S_MAX_corr_s(key);
        end
    end
end
%%
% converts the guessed decimal keys to hexa keys
hex_key = dec2hex(dec_key_w);

%%

%xlswrtie()

%figure(1)
%plot(raw')                                           % Without Independent Variable
%grid
%xlabel('Load in Kips')
%ylabel('Percentage')
toc
%%
