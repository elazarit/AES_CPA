function mat = trace_to_mat (n_trc, l_trc, f_trc, skip_trc, read_trc)
    %initialize a matrix
    mat = zeros(n_trc, read_trc);
    %open trace file
    p_f_trc = fopen (f_trc, 'r');
    %checks for file availability
    if p_f_trc < 0
        error('Trace BIN file missing');
    end
    
    for i = 1:n_trc
        %skips "skip_trc" samples
        fseek(p_f_trc, skip_trc, 0);
        %reads "read_trc" samples
        mat(i,:)= fread(p_f_trc, read_trc);
        %goes the the end ot the "i"'th line
        fseek(p_f_trc, l_trc-skip_trc-read_trc, 0);
    end
    fclose(p_f_trc);
end
