function extfiber = extfibergeom(node,elem,xcg,zcg,theta)
% BWS, June 20, 2026 -- with chatgpt coding assistance on parts
% extfibergeom extreme-fiber geometric distances based on element corners
%
% Inputs:
% node, elem = CUFSM geometry
% xcg, zcg   = centroid / elastic neutral axis origin
% theta      = principal axis angle, **radians**
%
% Output:
% d is the distance between extreme fibers on the x, z, 1, or 2 axes
% c is the distance between centroid and ext fiber in (p)lus/positive and
% (m)inues/negative directions
% beta_s_ is the 2yc/d value used in AISI S100 for asymmetry here we have
% 8 options depending on bending e.g. beta_s.x_p=2*cx_p/dx, ...
% All output variables are placed in the "extfiber" structure variable
% extfiber.dx, extfiber.dz, extfiber.d1, extfiber.d2
% extfiber.cx_p, extfiber.cx_m
% extfiber.cz_p, extfiber.cz_m
% extfiber.c1_p, extfiber.c1_m
% extfiber.c2_p, extfiber.c2_m
% extfiber.beta_s.x_p, extfiber.beta_s.x_m
% extfiber.beta_s.z_p, extfiber.beta_s.z_m
% extfiber.beta_s.1_p, extfiber.beta_s.1_m
% extfiber.beta_s.2_p, extfiber.beta_s.2_m

%Generate coordinates for all element corners
elemcorner = elemcornergen(node,elem);

%Coordindates of all element corners
x = elemcorner(:,5);
z = elemcorner(:,6);

% Global x-z extreme-fiber dimensions
xmin = min(x);
xmax = max(x);
zmin = min(z);
zmax = max(z);

extfiber.dx = xmax - xmin;
extfiber.dz = zmax - zmin;

extfiber.cx_p = xmax - xcg;
extfiber.cx_m = xcg - xmin;

extfiber.cz_p = zmax - zcg;
extfiber.cz_m = zcg - zmin;

% Coordinates relative to centroid
xr = x - xcg;
zr = z - zcg;

% Principal coordinates.
% Check sign convention against CUFSM's existing theta use.
coord1 =  xr*cos(theta) + zr*sin(theta);
coord2 = -xr*sin(theta) + zr*cos(theta);

c1min = min(coord1);
c1max = max(coord1);
c2min = min(coord2);
c2max = max(coord2);

extfiber.d1 = c1max - c1min;
extfiber.d2 = c2max - c2min;

extfiber.c1_p = c1max;
extfiber.c1_m = -c1min;

extfiber.c2_p = c2max;
extfiber.c2_m = -c2min;

%Asymmetry parameters beta_s
extfiber.beta_s.x_p=2*extfiber.cx_p/estfiber.dx; 
extfiber.beta_s.x_m=2*extfiber.cx_m/estfiber.dx;
extfiber.beta_s.z_p=2*extfiber.cz_p/estfiber.dz; 
extfiber.beta_s.z_m=2*extfiber.cz_m/estfiber.dz;
extfiber.beta_s.1_p=2*extfiber.c1_p/estfiber.d1;
extfiber.beta_s.1_m=2*extfiber.c1_m/estfiber.d1;
extfiber.beta_s.2_p=2*extfiber.c2_p/estfiber.d2; 
extfiber.beta_s.2_m=2*extfiber.c2_m/estfiber.d2;
