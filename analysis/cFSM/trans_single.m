function [kglobal]=trans_single(alpha,k)
%
%this routine make the local-to-global co-ordinate transformation
%basically it does the same as routine 'trans', however:
%   it does not care about kg (geom stiff matrix)
%   onle involve one half-wave number m

% S. Adany, Feb 06, 2004
% Z. Li, Jul 10, 2009
%
c=cos(alpha);
s=sin(alpha);
%
%
gamma=[ c	0	0	0  -s	0	0	0
	    0	1	0	0	0	0	0	0
	    0	0	c	0	0	0  -s	0
	    0	0	0	1	0	0	0	0
	    s	0	0	0	c	0	0	0
	    0	0	0	0	0	1	0	0
	    0	0	s	0	0	0	c	0
	    0	0	0	0	0	0	0	1 ];
%
kglobal=gamma*k*gamma';
