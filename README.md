final project, Side channel attack of AES with CPA


# AES SCA, Side Channel Attack, CPA, Correlation Power Analysis

This code was written as part of the graduation project for Electrical engineering
at Afeka Tel Aviv Academic College of Engineering, May, 2020.

Written by:
[Tamir Elazari](https://github.com/elazarit)
[Steven Chich](https://github.com/Steven-024z)


## Summary
This code purpose is to perform SCA CPA on AES-128 encryption in order the discover
the secret key.

1 - [Our algorithm](#Our-algorithm)  
2 - [How to use?](#How-to-use-?)     
3 - [TBCt](#TBC)  


## Our algorithm

### Pseudocode

- load trace's BIN file into a matrix using trace_to_mat function
- load hexa plain text file and convert it into a decimal matrix
using ptxt_to_mat function
- calculate traces clock frequency using clk_freq function
- uses discovered clock frequency to filter the traces with LPF
- loops the next steps for all the key bytes, one by one:
- calculate all the possible hypothesis for the key byte
right after the outpus of the SBOX (XORing the plaintext
with all the possible key byte options and then pass it 
through the SBOX)
- calculate the correlation factor by Hamming Weight, HW, Hamming Distance, HD,
Switching Distance, SD, and our combined power model, HWHDSD.
-takes the key with the highest correlation from the HWHDSD, unless the CR (the ratio
between highest correlation and second highest one) is lower then 1.6.
-moves into the next key byte.


### optional

the algorithm conatain an option to create a time shift (between 300 to 1000 points)
between the traces and then resync them back using POC, Phase Only Correlation.
to enable this function change to desync_EN == '1', or enable it form the GUI.


## How to use?

To run the algorithm without the GUI, just run 'main.m'. be sure the predefine all the
parameters manually before running the code. all the needed parameters for the traces
are included inside 'info.txt', inside the 'Data' directory.

To run the algorithm easily with the GUI assist, just run 'run_gui.m', and define the
parameters according to the 'Parameters' meun.

### Parameters:
- Number of Traces: defines the number of traces to load from the *.bin file
- Traces length: defines the number of points inside easch trace
- Strart skipping: defines how many points to skip form the start of the traces when
reading them into a matrix. usefull to save processing time
- End skipping: defines how many points to skip form the end of the traces when reading
them into a matrix. usefull to save processing time
- desync_EN: enable desync and resync function. 



# TBC
To be continued... under work.

