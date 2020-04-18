function [P_align,read_trc] = traces_alignment(P_shifted,n_trc,read_trc,shift_amount_arr)
    %Calculate the alignment amount needed via POC method
    %All the traces are aligned according to the first trace
    align =  zeros(1,n_trc);
    for i=2:n_trc
        %POCSHIFT estimates the transition between two traces by phase-only correlation
        align(i) = round(POC_calc(P_shifted(1,:),P_shifted(i,:)));
    end
    %calaculate the shift difference between first trace and other traces
    %creating an error vector in order to verify that the algorithm is indeed working
    shift_diff = zeros(1,n_trc);
    error =  zeros(1,n_trc);
    for i =2:n_trc
        shift_diff(i) = shift_amount_arr(1)-shift_amount_arr(i);
        error(i) = shift_diff(i) - align(i);
    end
    histogram(error)
    %alignment
    %shift all the trace in one direction according to the max shift deviation
    [~,Max_s] = max(align);
    [~,Min_s] = min(align);
    read_trc = read_trc + align(Min_s) - align(Max_s);
    P_align = zeros(n_trc,read_trc);
    for i=1:n_trc
        shifted = circshift( P_shifted(i,:),align(Min_s)-align(i));
        P_align(i,:) = shifted(1:read_trc);
    end
end