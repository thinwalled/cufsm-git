function [kglobal,kgglobal]=trans_m(alpha,k,kg)
%
% transfer the local stiffness into global stiffness

%created on Jul 10, 2009 by Z. Li

a=alpha;
%
z0=0;
gamma=[cos(a)   z0    z0	  z0	-sin(a)	z0   z0	   z0
	    z0	  1	    z0	  z0	  z0    z0	 z0    z0
	    z0	  z0  cos(a)  z0	  z0	z0 -sin(a) z0
	    z0	  z0	z0	   1	  z0	z0	 z0	   z0
	   sin(a) z0	z0	  z0	cos(a)	z0	 z0	   z0
	    z0	  z0	z0	  z0	  z0	1	 z0    z0
	    z0	  z0  sin(a)  z0	  z0	z0	cos(a) z0
	    z0	  z0	z0	  z0	  z0	z0	 z0	   1 ];
%extend to multi-m
% for i=1:m
%     gamma(8*(i-1)+1:8*i,8*(i-1)+1:8*i)=gam;
% end
%
kglobal=gamma*k*gamma';
kgglobal=gamma*kg*gamma';