function [A,xc,yc,Ix,Iy,Ixy,theta,I1,I2,J,xs,ys,Cw,B1,B2,Pe,dcoord] = cutwp_prop(coord,ends,KL1,KL2,KL3,force,exy,E,v,dist)
%  Adopted as cutwp_prop for use in CUFSM by Adany and Schafer in 2004
%  with permission of Sarawit.
%
%  December 2006 fixed bugs with beta calculations. (Schafer)
%
%  Compute cross section properties 
%----------------------------------------------------------------------------
%  Written by:
%       Andrew T. Sarawit
%       last revised:   Wed 10/25/01
%       
%  Function purpose:
%       This function computes the cross section properties: area, centroid, 
%       moment of inertia, torsional constant, shear center, warping constant, 
%       B1, B2, elastic critical buckling load and the deformed buckling shape   
%
%  Dictionary of Variables
%     Input Information:
%       coord(i,1:2)   ==  node i's coordinates
%                            coord(i,1) = X coordinate
%                            coord(i,2) = Y coordinate
%       ends(i,1:2)    ==  subelement i's nodal information
%                            ends(i,1) = start node #
%                            ends(i,2) = finish node #
%                            ends(i,3) = element's thickness 
%       KL1            ==  effective unbraced length for bending about the 1-axis
%       KL2            ==  effective unbraced length for bending about the 2-axis
%       KL3            ==  effective unbraced length for twisting about the 3-axis
%       force          ==  type of force applied
%                      == 'Pe'  : elastic critical axial force 
%                      == 'Me1' : elastic critical moment about the 1-axis 
%                      == 'Me2' : elastic critical moment about the 2-axis
%       exy(1:2)     ==  Pe eccentricities coordinates
%                            exy(1) = ex
%                            exy(2) = ey
%  Output Information:
%       A              ==  cross section area
%       xc             ==  X coordinate of the centroid from orgin
%       yc             ==  Y coordinate of the centroid from origin
%       Ix             ==  moment of inertia about centroid X axes
%       Iy             ==  moment of inertia about centroid Y axes
%       Ixy            ==  product of inertia about centroid
%       Iz             ==  polar moment of inertia about centroid
%       theta          ==  rotation angle for the principal axes
%       I1             ==  principal moment of inertia about centroid 1 axes 
%       I2             ==  principal moment of inertia about centroid 2 axes
%       J              ==  torsional constant
%       xs             ==  X coordinate of the shear center from origin
%       ys             ==  Y coordinate of the shear center from origin
%       Cw             ==  warping constant
%       B1             ==  int(y*(x^2+y^2),s,0,L)  
%       B2             ==  int(x*(x^2+y^2),s,0,L)
%                          where: x = x1+s/L*(x2-x1)
%                                 y = y1+s/L*(y2-y1)
%                                 L = lenght of the element
%       Pe(i)          ==  buckling mode i's elastic critical buckling load
%       dcoord         ==  node i's coordinates of the deformed buckling shape 
%                            coord(i,1,mode) = X coordinate 
%                            coord(i,2,mode) = Y coordinate
%                          where: mode = buckling mode number  
%
%  Note: 
%     J,xs,ys,Cw,B1,B2,Pe,dcoord is not computed for close-section      
%       
%----------------------------------------------------------------------------
%
% find nele  == total number of elements 
%      nnode == total number of nodes 
%      j     == total number of 2 element joints 
nele = size(ends,1); 
node = ends(:,1:2); node = node(:);
nnode = 0; j = 0;

while ~isempty(node)
    i = find(node==node(1));
    node(i) = [];
    if size(i,1)==2
        j = j+1;
    end
    nnode = nnode+1;
end

% classify the section type
if j == nele
    section = 'close';
else
    section = 'open';
end

% if the section is close re-order the element 
if strcmp(section,'close')
    xnele = (nele-1);
    for i = 1:xnele
        en = ends; en(i,2) = 0;
        [m,n] = find(ends(i,2)==en(:,1:2));
        if n==1
            ends(i+1,:) = en(m,:);
            ends(m,:) = en(i+1,:);
        elseif n == 2
            ends(i+1,:) = en(m,[2 1 3]);
            ends(m,:) = en(i+1,[2 1 3]);
        end
    end
end

% find the element properties
for i = 1:nele
    sn = ends(i,1); fn = ends(i,2); 
    % thickness of the element
    t(i) = ends(i,3);
    % compute the coordinate of the mid point of the element
    xm(i) = mean(coord([sn fn],1));
    ym(i) = mean(coord([sn fn],2));
    % compute the dimension of the element
    xd(i) = diff(coord([sn fn],1));
    yd(i) = diff(coord([sn fn],2));
    % compute the length of the element
    L(i) = norm([xd(i) yd(i)]);
end

% compute the cross section area
A = sum(L.*t);
% compute the centroid 
xc = sum(L.*t.*xm)/A;
yc = sum(L.*t.*ym)/A;

if abs(xc/sqrt(A)) < 1e-12
    xc = 0;
end
if abs(yc/sqrt(A)) < 1e-12
    yc = 0;
end

% compute the moment of inertia
Ix = sum((yd.^2/12+(ym-yc).^2).*L.*t);
Iy = sum((xd.^2/12+(xm-xc).^2).*L.*t);
Ixy = sum((xd.*yd/12+(xm-xc).*(ym-yc)).*L.*t);

if abs(Ixy/A^2) < 1e-12
    Ixy = 0;
end

% compute the rotation angle for the principal axes
theta = angle(Ix-Iy-2*Ixy*1i)/2;

% transfer the section coordinates to the centroid principal coordinates
coord12(:,1) = coord(:,1)-xc;
coord12(:,2) = coord(:,2)-yc;
coord12 = [cos(theta) sin(theta); -sin(theta) cos(theta)]*coord12';
coord12 = coord12';

% find the element properties
for i = 1:nele
    sn = ends(i,1); fn = ends(i,2); 
    % compute the coordinate of the mid point of the element
    xm(i) = mean(coord12([sn fn],1));
    ym(i) = mean(coord12([sn fn],2));
    % compute the dimension of the element
    xd(i) = diff(coord12([sn fn],1));
    yd(i) = diff(coord12([sn fn],2));
end

% compute the principal moment of inertia
I1 = sum((yd.^2/12+ym.^2).*L.*t);
I2 = sum((xd.^2/12+xm.^2).*L.*t);

if strcmp(section,'close')
    % compute the torsional constant for close-section
    for i = 1:nele
        sn = ends(i,1); fn = ends(i,2);
        p(i) = ((coord(sn,1)-xc)*(coord(fn,2)-yc)-(coord(fn,1)-xc)*(coord(sn,2)-yc))/L(i);
    end
    J = 4*sum(p.*L/2)^2/sum(L./t);
    xs = NaN; ys = NaN; Cw = NaN; B1 = NaN; B2 = NaN; Pe = NaN; dcoord = NaN; 
elseif strcmp(section,'open')
    % compute the torsional constant for open-section
    J = sum(L.*t.^3)/3;
    
    % compute the shear center and initialize variables 
    nnode = size(coord,1);
    w = zeros(nnode,2); w(ends(1,1),1) = ends(1,1);
    wo = zeros(nnode,2); wo(ends(1,1),1) = ends(1,1);
    Iwx = 0; Iwy = 0; wno = 0; Cw = 0;
    
    for j = 1:nele
        i = 1;
        while (any(w(:,1)==ends(i,1))&any(w(:,1)==ends(i,2)))|(~(any(w(:,1)==ends(i,1)))&(~any(w(:,1)==ends(i,2))))
            i = i+1;
        end
        sn = ends(i,1); fn = ends(i,2);
        p = ((coord(sn,1)-xc)*(coord(fn,2)-yc)-(coord(fn,1)-xc)*(coord(sn,2)-yc))/L(i);
        if w(sn,1)==0
            w(sn,1) = sn;  
            w(sn,2) = w(fn,2)-p*L(i);
        elseif w(fn,1)==0
            w(fn,1) = fn;   
            w(fn,2) = w(sn,2)+p*L(i);
        end
        Iwx = Iwx+(1/3*(w(sn,2)*(coord(sn,1)-xc)+w(fn,2)*(coord(fn,1)-xc))+1/6*(w(sn,2)*(coord(fn,1)-xc)+w(fn,2)*(coord(sn,1)-xc)))*t(i)* L(i);  
        Iwy = Iwy+(1/3*(w(sn,2)*(coord(sn,2)-yc)+w(fn,2)*(coord(fn,2)-yc))+1/6*(w(sn,2)*(coord(fn,2)-yc)+w(fn,2)*(coord(sn,2)-yc)))*t(i)* L(i); 
    end
    
    if (Ix*Iy-Ixy^2)~=0
        xs = (Iy*Iwy-Ixy*Iwx)/(Ix*Iy-Ixy^2)+xc;
        ys = -(Ix*Iwx-Ixy*Iwy)/(Ix*Iy-Ixy^2)+yc;
    else
        xs = xc; ys = yc;
    end
    
    if abs(xs/sqrt(A)) < 1e-12
        xs = 0;
    end
    if abs(ys/sqrt(A)) < 1e-12
        ys = 0;
    end
    
    % compute the unit warping
    for j = 1:nele
        i = 1;
        while (any(wo(:,1)==ends(i,1))&any(wo(:,1)==ends(i,2)))|(~(any(wo(:,1)==ends(i,1)))&(~any(wo(:,1)==ends(i,2))))
            i = i+1;
        end
        sn = ends(i,1); fn = ends(i,2);
        po = ((coord(sn,1)-xs)*(coord(fn,2)-ys)-(coord(fn,1)-xs)*(coord(sn,2)-ys))/L(i);
        if wo(sn,1)==0
            wo(sn,1) = sn;  
            wo(sn,2) = wo(fn,2)-po*L(i);
        elseif wo(ends(i,2),1)==0
            wo(fn,1) = fn;   
            wo(fn,2) = wo(sn,2)+po*L(i);
        end
        wno = wno+1/(2*A)*(wo(sn,2)+wo(fn,2))*t(i)* L(i); 
    end
    wn = wno-wo(:,2);
    
    % compute the warping constant
    for i = 1:nele
        sn = ends(i,1); fn = ends(i,2);
        Cw = Cw+1/3*(wn(sn)^2+wn(sn)*wn(fn)+wn(fn)^2)*t(i)* L(i);
    end
    
    % transfer the shear center coordinates to the centroid principal coordinates
    s12 = [cos(theta) sin(theta); -sin(theta) cos(theta)]*[xs-xc; ys-yc];  
    % compute the polar radius of gyration of cross section about shear center
    ro = sqrt((I1+I2)/A+s12(1)^2+s12(2)^2);
    % compute the shear modulus
    G = E/(2*(1+v));
    
    % compute B1 and B2
    B1 = 0; B2 = B1;
    for i = 1:nele
        sn = ends(i,1); fn = ends(i,2); 
        x1 = coord12(sn,1); y1 = coord12(sn,2);
        x2 = coord12(fn,1); y2 = coord12(fn,2);
        B1 = B1+((y1+y2)*(y1^2+y2^2)/4+(y1*(2*x1^2+(x1+x2)^2)+y2*(2*x2^2+(x1+x2)^2))/12)*L(i)*t(i);
        B2 = B2+((x1+x2)*(x1^2+x2^2)/4+(x1*(2*y1^2+(y1+y2)^2)+x2*(2*y2^2+(y1+y2)^2))/12)*L(i)*t(i);
    end
    B1 = B1/I1-2*s12(2);
    B2 = B2/I2-2*s12(1); 
    
    if abs(B1/sqrt(A)) < 1e-12
        B1 = 0;
    end
    if abs(B2/sqrt(A)) < 1e-12
        B2 = 0;
    end
    
    % compute rob
    if strcmp(force,'Pe')
        % transfer the Pe eccentricities coordinates to the centroid principal coordinates 
        e12 = [cos(theta) sin(theta); -sin(theta) cos(theta)]*[exy(1); exy(2)];
        rob = sqrt(ro^2+B1*e12(2)+B2*e12(1));
        a1 = s12(1)-e12(1);
        a2 = s12(2)-e12(2);
        if abs(a1/max(L)) < 1e-12
            a1 = 0;
        end
        if abs(a2/max(L)) < 1e-12
            a2 = 0;
        end
    else
        rob = ro;
    end
    
    % compute the flexural buckling and tortional buckling
    if strcmp(force,'Pe')|strcmp(force,'Me12')
        Pe1 = pi^2*E*I1/KL1^2;
        Pe2 = pi^2*E*I2/KL2^2;
    elseif strcmp(force,'Me1')
        Pe2 = pi^2*E*I2/KL2^2;
    elseif strcmp(force,'Me2')
        Pe1 = pi^2*E*I1/KL1^2;
    end
    Pe3 = (G*J+pi^2*E*Cw/KL3^2)/rob^2;
    
    %report out to screen
    %['line 298 of cutwp_prop, comments added']
    %Pe1
    %Pe2
    %Pe3
    %s12
    
    
    % compute the flexural-tortional buckling and lateral buckling 
    % with its corresponding displacements coefficients
    if strcmp(force,'Pe') & (a1 == 0) & (a2 == 0)
        Pe  = [Pe1; Pe2; Pe3];
        PeP = Pe(find(Pe>=0)); PeN = Pe(find(Pe<0));
        Pe = [sort(PeP); flipud(sort(PeN))];
        for i = 1:3
            if Pe(i) == Pe2
                A1(i) = 1; A2(i) = 0; A3(i) = 0; 
            elseif Pe(i) == Pe1
                A1(i) = 0; A2(i) = 1; A3(i) = 0; 
            elseif Pe(i) == Pe3
                A1(i) = 0; A2(i) = 0; A3(i) = 1;
            end
        end
    elseif strcmp(force,'Pe') & (a1 ~= 0) & (a2 == 0)
        Pcr1 = Pe2;
        B = 1-(a1/rob)^2;
        Pcr2 = ((Pe1+Pe3)-sqrt((Pe1+Pe3)^2-4*B*Pe1*Pe3))/(2*B);
        Pcr3 = ((Pe1+Pe3)+sqrt((Pe1+Pe3)^2-4*B*Pe1*Pe3))/(2*B);
        Pe  = [Pcr1; Pcr2; Pcr3];
        PeP = Pe(find(Pe>=0)); PeN = Pe(find(Pe<0));
        Pe = [sort(PeP); flipud(sort(PeN))];
        for i = 1:3
            if Pe(i) == Pe2
                A1(i) = 1; A2(i) = 0; A3(i) = 0;
            else
                A1(i) = 0; A3(i) = 1; 
                A2(i) = -Pe(i)*a1*(KL1/KL3)^2/(Pe1-Pe(i));
            end
        end   
    elseif strcmp(force,'Pe') & (a1 == 0) & (a2 ~= 0)
        Pcr1 = Pe1;
        B = 1-(a2/rob)^2;
        Pcr2 = ((Pe2+Pe3)-sqrt((Pe2+Pe3)^2-4*B*Pe2*Pe3))/(2*B);
        Pcr3 = ((Pe2+Pe3)+sqrt((Pe2+Pe3)^2-4*B*Pe2*Pe3))/(2*B);
        Pe  = [Pcr1; Pcr2; Pcr3];
        PeP = Pe(find(Pe>=0)); PeN = Pe(find(Pe<0));
        Pe = [sort(PeP); flipud(sort(PeN))];
        for i = 1:3
            if Pe(i) == Pe1
                A1(i) = 0; A2(i) = 1; A3(i) = 0; 
            else
                A2(i) = 0; A3(i) = 1; 
                A1(i) = Pe(i)*a2*(KL2/KL3)^2/(Pe2-Pe(i));
            end
        end   
    elseif strcmp(force,'Pe') & (a1 ~= 0) & (a2 ~= 0)
        c1 = a1^2+a2^2-rob^2;
        c2 = rob^2*(Pe1+Pe2+Pe3)-Pe1*a2^2-Pe2*a1^2;
        c3 = -rob^2*(Pe1*Pe2+Pe1*Pe3+Pe2*Pe3);
        c4 = rob^2*Pe1*Pe2*Pe3;
        Pe = sort(roots([c1 c2 c3 c4]));
        PeP = Pe(find(Pe>=0)); PeN = Pe(find(Pe<0));
        Pe = [sort(PeP); flipud(sort(PeN))];
        for i = 1:3
            A1(i) = 1; 
            A3(i) = (Pe2-Pe(i))*(KL3/KL2)^2/(Pe(i)*a2); 
            A2(i) = -Pe(i)*a1*A3(i)*(KL1/KL3)^2/(Pe1-Pe(i));
        end   
    elseif strcmp(force,'Me1') 
        Pcr1 = -Pe2/2*(B1+sqrt(B1^2+4*rob^2*Pe3/Pe2));
        Pcr2 = -Pe2/2*(B1-sqrt(B1^2+4*rob^2*Pe3/Pe2));
        Pe  = [Pcr1; Pcr2];
        PeP = Pe(find(Pe>=0)); PeN = Pe(find(Pe<0));
        Pe = [sort(PeP); flipud(sort(PeN))];
        for i = 1:2
            A1(i) = 1; A2(i) = 0; 
            A3(i) = -Pe2*(KL3/KL2)^2/Pe(i);
        end   
    elseif strcmp(force,'Me2') 
        Pcr1 = -Pe1/2*(B2+sqrt(B2^2+4*rob^2*Pe3/Pe1));
        Pcr2 = -Pe1/2*(B2-sqrt(B2^2+4*rob^2*Pe3/Pe1));
        Pe  = [Pcr1; Pcr2];
        PeP = Pe(find(Pe>=0));
        PeN = Pe(find(Pe<0));
        Pe = [sort(PeP); flipud(sort(PeN))];
        for i = 1:2
            A1(i) = 0; A2(i) = 1; 
            A3(i) = Pe1*(KL3/KL1)^2/Pe(i);
        end   
    elseif strcmp(force,'Me12')
        assignin('base', 'exy', exy );
        c = exy;
        assignin('base', 'c', c );
        Pcr1 = -((B1*c+B2)+sqrt((B1*c+B2)^2+4*rob^2*Pe3*(c^2/Pe2+1/Pe1)))/(2*(c^2/Pe2+1/Pe1));
        Pcr2 = -((B1*c+B2)-sqrt((B1*c+B2)^2+4*rob^2*Pe3*(c^2/Pe2+1/Pe1)))/(2*(c^2/Pe2+1/Pe1));
        Pe  = [Pcr1; Pcr2];
        PeP = Pe(find(Pe>=0));
        PeN = Pe(find(Pe<0));
        Pe = [sort(PeP); flipud(sort(PeN))];
        for i = 1:2
            A2(i) = 1; 
            A3(i) = Pe1*(KL3/KL1)^2/Pe(i);
            A1(i) = -c*Pe(i)*A3(i)*(KL2/KL3)^2/Pe2; 
        end  
    end
    
    % normalize the displacement coefficients
    for i = 1:length(Pe)
        An = norm([A1(i) A2(i) A3(i)]);
        A1(i) = dist*A1(i)/An;
        A2(i) = dist*A2(i)/An;
        A3(i) = dist*A3(i)/An;
    end
    
    % compute the deformed buckling shape
    for i = 1:length(Pe)
        xcoord(:,1) = coord12(:,1)-s12(1);
        xcoord(:,2) = coord12(:,2)-s12(2);
        xcoord = [cos(-A3(i)) sin(-A3(i)); -sin(-A3(i)) cos(-A3(i))]*xcoord';
        xcoord = xcoord';
        xcoord(:,1) = xcoord(:,1)+s12(1)+A1(i);
        xcoord(:,2) = xcoord(:,2)+s12(2)+A2(i);
        % transfer the deformed buckling shape coordinates to the x-y coordinates
        xcoord = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)]*xcoord';
        xcoord = xcoord';
        xcoord(:,1) = xcoord(:,1)+xc;
        xcoord(:,2) = xcoord(:,2)+yc;
        dcoord(:,:,i) = xcoord;
    end
end
