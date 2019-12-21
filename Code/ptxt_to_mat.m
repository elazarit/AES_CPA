function mat = ptxt_to_mat (n_trc, f_ptxt)
    key_bytes = 16;
    %initialize a matrix
    mat = zeros(n_trc, key_bytes);
    %open plain txt file
    p_f_ptxt = fopen (f_ptxt, 'r');
    %checks for file availability
    if p_f_ptxt < 0
        error('Trace Plain Text .TXT file missing');
    end
    
    for i = 1:n_trc
        %reads the "i"'th line
        row = fgets(p_f_ptxt);
        %converts each couple in the hexa row to a decimal inside a vecotr column 
        tmp =  sscanf(row,'%02x');
        %stores a column into a row
        mat(i,:) = tmp.';
    end
    fclose(p_f_ptxt);
end
