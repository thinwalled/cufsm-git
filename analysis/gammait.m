function d=gammait(phi,dbar)
%BWS
%1998 (last modified)
%
%transform global coordinates into local coordinates
p=phi;
gamma=[cos(p)	0	0	0	-sin(p)	0	0	0
	0	1	0	0	0	0	0	0
	0	0	cos(p)	0	0	0	-sin(p)	0
	0	0	0	1	0	0	0	0
	sin(p)	0	0	0	cos(p)	0	0	0
	0	0	0	0	0	1	0	0
	0	0	sin(p)	0	0	0	cos(p)	0
	0	0	0	0	0	0	0	1 ];
d=gamma*dbar;