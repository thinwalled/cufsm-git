function [I1,I2,I3,I4,I5] = BC_I1_5(BC,kk,nn,a)
%
% Calculate the 5 undetermined parameters I1,I2,I3,I4,I5 for local elastic
% and geometric stiffness matrices.
% BC: a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
%Outputs:
%I1,I2,I3,I4,I5
    %calculation of I1 is the integration of Ym*Yn from 0 to a
    %calculation of I2 is the integration of Ym''*Yn from 0 to a
    %calculation of I3 is the integration of Ym*Yn'' from 0 to a
    %calculation of I3 is the integration of Ym*Yn'' from 0 to a
    %calculation of I4 is the integration of Ym''*Yn'' from 0 to a
    %calculation of I5 is the integration of Ym'*Yn' from 0 to a

if strcmp(BC,'S-S')
    %For simply-pimply supported boundary condition at loaded edges
    if kk==nn
        I1=a/2;
        I2=-kk^2*pi^2/a/2;
        I3=-nn^2*pi^2/a/2;
        I4=pi^4*kk^4/2/a^3;
        I5=pi^2*kk^2/2/a;
    else
        I1=0;
        I2=0;
        I3=0;
        I4=0;
        I5=0;
    end
elseif strcmp(BC,'C-C')
    %For Clamped-clamped boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
    if kk==nn
        if kk==1
            I1=3*a/8;
        else
            I1=a/4;
        end
        I2=-(kk^2+1)*pi^2/4/a;
        I3=-(nn^2+1)*pi^2/4/a;
        I4=pi^4*((kk^2+1)^2+4*kk^2)/4/a^3;
        I5=(1+kk^2)*pi^2/4/a;
    else
        if kk-nn==2
            I1=-a/8;
            I2=(kk^2+1)*pi^2/8/a-kk*pi^2/4/a;
            I3=(nn^2+1)*pi^2/8/a+nn*pi^2/4/a;
            I4=-(kk-1)^2*(nn+1)^2*pi^4/8/a^3;
            I5=-(1+kk*nn)*pi^2/8/a;
        elseif kk-nn==-2
            I1=-a/8;
            I2=(kk^2+1)*pi^2/8/a+kk*pi^2/4/a;
            I3=(nn^2+1)*pi^2/8/a-nn*pi^2/4/a;
            I4=-(kk+1)^2*(nn-1)^2*pi^4/8/a^3;
            I5=-(1+kk*nn)*pi^2/8/a;
        else
            I1=0;
            I2=0;
            I3=0;
            I4=0;
            I5=0;
        end
    end
elseif strcmp(BC,'S-C')|strcmp(BC,'C-S')
    %For simply-clamped supported boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
    if kk==nn        
        I1=(1+(kk+1)^2/kk^2)*a/2;
        I2=-(kk+1)^2*pi^2/a;
        I3=-(kk+1)^2*pi^2/a;
        I4=(kk+1)^2*pi^4*((kk+1)^2+kk^2)/2/a^3;
        I5=(1+kk)^2*pi^2/a;
    else
        if kk-nn==1
            I1=(kk+1)*a/2/kk;
            I2=-(kk+1)*kk*pi^2/2/a;
            I3=-(nn+1)^2*pi^2*(kk+1)/2/a/kk;
            I4=(kk+1)*kk*(nn+1)^2*pi^4/2/a^3;
            I5=(1+kk)*(1+nn)*pi^2/2/a;
        elseif kk-nn==-1
            I1=(nn+1)*a/2/nn;
            I2=-(kk+1)^2*pi^2*(nn+1)/2/a/nn;
            I3=-(nn+1)*nn*pi^2/2/a;
            I4=(kk+1)^2*nn*(nn+1)*pi^4/2/a^3;
            I5=(1+kk)*(1+nn)*pi^2/2/a;
        else
            I1=0;
            I2=0;
            I3=0;
            I4=0;
            I5=0;
        end
    end
    %
elseif strcmp(BC,'C-F')|strcmp(BC,'F-C')
    %For clamped-free supported boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
    if kk==nn
        I1=3*a/2-2*a*(-1)^(kk-1)/(kk-1/2)/pi;
        I2=(kk-1/2)^2*pi^2*((-1)^(kk-1)/(kk-1/2)/pi-1/2)/a;
        I3=(nn-1/2)^2*pi^2*((-1)^(nn-1)/(nn-1/2)/pi-1/2)/a;
        I4=(kk-1/2)^4*pi^4/2/a^3;
        I5=(kk-1/2)^2*pi^2/2/a;
    else
        I1=a-a*(-1)^(kk-1)/(kk-1/2)/pi-a*(-1)^(nn-1)/(nn-1/2)/pi;
        I2=(kk-1/2)^2*pi^2*((-1)^(kk-1)/(kk-1/2)/pi)/a;
        I3=(nn-1/2)^2*pi^2*((-1)^(nn-1)/(nn-1/2)/pi)/a;
        I4=0;
        I5=0;
    end
elseif strcmp(BC,'C-G')|strcmp(BC,'G-C')
    %For clamped-guided supported boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
    if kk==nn
        if kk==1
            I1=3*a/8;
        else
            I1=a/4;
        end
        I2=-((kk-1/2)^2+1/4)*pi^2/a/4;
        I3=-((kk-1/2)^2+1/4)*pi^2/a/4;
        I4=((kk-1/2)^2+1/4)^2*pi^4/4/a^3+(kk-1/2)^2*pi^4/4/a^3;
        I5=(kk-1/2)^2*pi^2/a/4+pi^2/16/a;
    else
        if kk-nn==1
            I1=-a/8;
            I2=((kk-1/2)^2+1/4)*pi^2/a/8-(kk-1/2)*pi^2/a/8;
            I3=((nn-1/2)^2+1/4)*pi^2/a/8+(nn-1/2)*pi^2/a/8;
            I4=-nn^4*pi^4/8/a^3;
            I5=-nn^2*pi^2/8/a;
        elseif kk-nn==-1
            I1=-a/8;
            I2=((kk-1/2)^2+1/4)*pi^2/a/8+(kk-1/2)*pi^2/a/8;
            I3=((nn-1/2)^2+1/4)*pi^2/a/8-(nn-1/2)*pi^2/a/8;
            I4=-kk^4*pi^4/8/a^3;
            I5=-kk^2*pi^2/8/a;
        else
            I1=0;
            I2=0;
            I3=0;
            I4=0;
            I5=0;
        end
    end
end


