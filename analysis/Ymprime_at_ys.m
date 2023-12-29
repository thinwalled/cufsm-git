function [Ymprime] = Ym_at_ys(BC,m,ys,a)
%First Derivative of Longitudinal shape function values
%written by BWS in 2015
%could be called in lots of places, but now (2015) is hardcoded by Zhanjie
%in several places in the interface
%written in 2015 because wanted it for a new idea on discrete springs

if strcmp(BC,'S-S')
    Ymprime=(pi*m*cos((pi*m*ys)/a))/a;
elseif strcmp(BC,'C-C')
    Ymprime=(pi*cos((pi*ys)/a)*sin((pi*m*ys)/a))/a + (pi*m*sin((pi*ys)/a)*cos((pi*m*ys)/a))/a;
elseif strcmp(BC,'S-C')|strcmp(BC,'C-S')
    Ymprime=(pi*cos((pi*ys*(m + 1))/a)*(m + 1))/a + (pi*cos((pi*m*ys)/a)*(m + 1))/a;
elseif strcmp(BC,'C-F')|strcmp(BC,'F-C')
    Ymprime=(pi*sin((pi*ys*(m - 1/2))/a)*(m - 1/2))/a;
elseif strcmp(BC,'C-G')|strcmp(BC,'G-C')
    Ymprime=(pi*sin((pi*ys*(m - 1/2))/a)*cos((pi*ys)/(2*a)))/(2*a) + (pi*cos((pi*ys*(m - 1/2))/a)*sin((pi*ys)/(2*a))*(m - 1/2))/a;
end


