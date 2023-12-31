function [ksglobal]=spring_trans(alpha,ks,m_a)
%
% Transfer the local stiffness into global stiffness
% Zhanjie 2008
% modified by Z. Li, Aug. 09, 2009
% adapted for spring Dec 2015

totalm = length(m_a); %Total number of longitudinal terms m
a=alpha;
%
z0=0;
gam=[cos(a)   z0    z0	  z0	-sin(a)	z0   z0	   z0
	    z0	  1	    z0	  z0	  z0    z0	 z0    z0
	    z0	  z0  cos(a)  z0	  z0	z0 -sin(a) z0
	    z0	  z0	z0	   1	  z0	z0	 z0	   z0
	   sin(a) z0	z0	  z0	cos(a)	z0	 z0	   z0
	    z0	  z0	z0	  z0	  z0	1	 z0    z0
	    z0	  z0  sin(a)  z0	  z0	z0	cos(a) z0
	    z0	  z0	z0	  z0	  z0	z0	 z0	   1 ];
%extend to multi-m
for i=1:totalm
    gamma(8*(i-1)+1:8*i,8*(i-1)+1:8*i)=gam;
end
%
ksglobal=gamma*ks*gamma';
