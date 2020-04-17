function [P_align,read_trc] = traces_alignment(P_shifted,n_trc,read_trc,shift_amount_arr)
%calculate the alignment amount needed via POC method
%all the traces are aligned according to the first trace
align =  zeros(1,n_trc);
 for i=2:n_trc
     align(i) = round(POCShift(P_shifted(1,:),P_shifted(i,:)));
 end
%calaculate the shift difference between first trace and other traces
%creating an error vector in order to check that the algorithm is indeed
%working
shift_diff = zeros(1,n_trc);
error =  zeros(1,n_trc);
 for i =2:n_trc
     shift_diff(i) = shift_amount_arr(1)-shift_amount_arr(i);
     error(i) = shift_diff(i) - align(i);
 end
 histogram(error)
%alignment
%shift all the trace in one direction according to the max shift
%swaping beetwen first and max shifted element
[~,Max_s] = max(align);
[~,Min_s] = min(align);
read_trc = read_trc + align(Min_s) - align(Max_s);
  for i=1:n_trc
      shifted = circshift( P_shifted(i,:),align(Min_s)-align(i));
      P_align(i,:) = shifted(1:read_trc);
  end
end