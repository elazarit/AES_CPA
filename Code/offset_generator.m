function [read_trc,P_shifted,shift_amount_arr] = offset_generator(Pz,n_trc)
    %Offset parameters
    low_range = 300;
    high_range = 1000;
    offset_interval = high_range-low_range;
    margin_lim = round(1.1*high_range);
    %Generating a random array of offsets
    shift_amount_arr = round(low_range + offset_interval.*rand(1,n_trc));
    [ ~, Pz_cols] = size(Pz);
    read_trc=Pz_cols-margin_lim;
    P_shifted = zeros(n_trc,read_trc);
    %Applying offsets on traces
    for i=1:n_trc
        shifted_trace = circshift( Pz(i,:),-shift_amount_arr(i));
        P_shifted(i,:) = shifted_trace(1:read_trc);
    end
end