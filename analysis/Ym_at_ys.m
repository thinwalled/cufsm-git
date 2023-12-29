function [Ym] = Ym_at_ys(BC,m,ys,a)
%Longitudinal shape function values
%written by BWS in 2015
%could be called in lots of places, but now (2015) is hardcoded by Zhanjie
%in several places in the interface
%written in 2015 because wanted it for a new idea on discrete springs

if strcmp(BC,'S-S')
    Ym=sin(m*pi*ys/a);
elseif strcmp(BC,'C-C')
    Ym=sin(m*pi*ys/a).*sin(pi*ys/a);
elseif strcmp(BC,'S-C')|strcmp(BC,'C-S')
    Ym=sin((m+1)*pi*ys/a)+(m+1)/m*sin(m*pi*ys/a);
elseif strcmp(BC,'C-F')|strcmp(BC,'F-C')
    Ym=1-cos((m-0.5)*pi*ys/a);
elseif strcmp(BC,'C-G')|strcmp(BC,'G-C')
    Ym=sin((m-0.5)*pi*ys/a).*sin(pi*ys/a/2);
end


