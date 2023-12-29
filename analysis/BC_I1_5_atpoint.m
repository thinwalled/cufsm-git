function [I1,I5] = BC_I1_5_atpoint(BC,kk,nn,a,ys)
%
% Calculate the value of the longitundinal shape functions for discrete springs
%
% BC: a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
%Outputs:
%I1,I5
    %calculation of I1 is the value of Ym(y/L)*Yn(y/L)
    %calculation of I5 is the value of Ym'(y/L)*Yn'(y/L)

Ykk = Ym_at_ys(BC,kk,ys,a);
Ynn = Ym_at_ys(BC,nn,ys,a);
Ykkprime = Ymprime_at_ys(BC,kk,ys,a);    
Ynnprime = Ymprime_at_ys(BC,nn,ys,a);    
I1=Ykk*Ynn;
I5=Ykkprime*Ynnprime;
