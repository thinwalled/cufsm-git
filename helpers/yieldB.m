function [By]=yieldB(fy,Cw,w)
%BWS
%October 2015
%May 2019
%Trap NaN when w, Cw 0 as in a flat plate
%
B=1;
stress=B*w/Cw;
factor=fy/max(abs(stress));
By=factor*B;
if isnan(By)
    By=0;
end


