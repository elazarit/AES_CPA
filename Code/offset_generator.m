function [read_trc,P_shifted,shift_amount_arr] = offset_generator(Pz,n_trc)
%setting offsets interval
low_range = 300;
high_range = 1000;
offset_interval = high_range-low_range;
margin_lim = 2.5*offset_interval;
%generating a random array of offsets
shift_amount_arr = round(low_range + offset_interval.*rand(1,n_trc));
[ ~, Pz_cols] = size(Pz);
read_trc=Pz_cols-2*margin_lim;
P_shifted = zeros(n_trc,read_trc);
%applying offsets on traces
for i=1:n_trc
    shift_amount = shift_amount_arr(i);
    shifted_trace = circshift( Pz(i,:),-shift_amount);
    P_shifted(i,:) = shifted_trace(margin_lim+1:Pz_cols-margin_lim);
end
end