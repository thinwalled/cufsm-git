function dlbar=gammait2(phi,dl)
%BWS
%1998 last modified
%transform local disps into global dispa
p=phi;
%dl=gamma*dlbar so...
gamma=[	cos(p)	0	-sin(p)
	0	1	0
	sin(p)	0	cos(p)];
dlbar=inv(gamma)*dl;