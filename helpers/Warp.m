function [Cw, J, Xs, Ys, w, Bx, By, B1, B2]=Warp(node,elem)
%[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem);
%Program to compute the sectional properties of thin walled member.
%Cw, J , Warping function, Shear center location
% Badri Hiriyur Aug 20, 2002
%Input
%node=[# x z DOFX DOFZ DOFY DOF0 stress]
%elem=[# i j t]
n=length(node(:,1));

%Basic Section Properties
% Area lengths, coordinates etc
t=elem(:,4);
x=node(:,2);
y=node(:,3);
A=0;
for i=1:n-1
    l(i)=sqrt((x(i+1)-x(i))^2+(y(i+1)-y(i))^2);
    Ai(i)=t(i)*l(i);
    x_(i)=(1/2)*(x(i)+x(i+1));
    y_(i)=(1/2)*(y(i)+y(i+1));
    dx(i)=x(i+1)-x(i);
    dy(i)=y(i+1)-y(i);
    A=A+Ai(i);
end

%Centroid
xc=0;
yc=0;
for i=1:n-1
    xc=xc+(1/A)*t(i)*l(i)*x_(i);
    yc=yc+(1/A)*t(i)*l(i)*y_(i);
end

%Moments of Inertia, Torsion constant
J=0;
Ixc=0;
Iyc=0;
Ixyc=0;
for i=1:n-1
    J=J+(1/3)*l(i)*t(i)^3;
    Ixc=Ixc+((y_(i)^2*Ai(i)+(1/12)*dy(i)^2*Ai(i)));
    Iyc=Iyc+((x_(i)^2*Ai(i)+(1/12)*dx(i)^2*Ai(i)));                          
    Ixyc=Ixyc+((x_(i)*y_(i)*Ai(i)+(1/12)*dx(i)*dy(i)*Ai(i)));                
end
Ixc=Ixc-yc^2*A;
Iyc=Iyc-xc^2*A;
Ixyc=Ixyc-yc*xc*A;
%Principal moments of inertia
Imax=(1/2)*((Ixc+Iyc)+sqrt((Ixc-Iyc)^2+4*Ixyc^2));
Imin=(1/2)*((Ixc+Iyc)-sqrt((Ixc-Iyc)^2+4*Ixyc^2));
Th_p=1/2*(atan2(-2*Ixyc,(Ixc-Iyc)));

%Transform into new coordinates about principal axes
for i=1:n
    XY=[(x(i)-xc) (y(i)-yc); (y(i)-yc) -(x(i)-xc)]*[cos(Th_p);sin(Th_p)];
    X(i)=XY(1);
    Y(i)=XY(2);
end

%Shearflow and Shear center
VX(1)=0;
VY(1)=0;
for i=1:n-1
    dX(i)=(1/l(i))*abs(X(i)*Y(i+1)-X(i+1)*Y(i));
    dY(i)=(1/l(i))*abs(X(i)*Y(i+1)-X(i+1)*Y(i));                
    
    if (Y(i)*(X(i+1)-X(i)))<(X(i)*(Y(i+1)-Y(i)))
        dlX(i)=1;
    else if (Y(i)*(X(i+1)-X(i)))>(X(i)*(Y(i+1)-Y(i)))
            dlX(i)=-1;
        else if (Y(i)*(X(i+1)-X(i)))==(X(i)*(Y(i+1)-Y(i)))
                dlX(i)=0;
            end
        end
    end
    
    if (X(i)*(Y(i+1)-Y(i)))<(Y(i)*(X(i+1)-X(i)))
        dlY(i)=1;
    else if (X(i)*(Y(i+1)-Y(i)))>(Y(i)*(X(i+1)-X(i)))
            dlY(i)=-1;
        else if (X(i)*(Y(i+1)-Y(i)))==(Y(i)*(X(i+1)-X(i)))
                dlY(i)=0;
            end
        end
    end
    VX(i+1)=VX(i)+Ai(i)*(Y(i+1)+Y(i))/2;
    VY(i+1)=VY(i)-Ai(i)*(X(i+1)+X(i))/2;
end

Xs=0;
Ys=0;
if Imax~=0
    for i=1:n-1
        Xs=Xs+(-1/Imax)*dlX(i)*dX(i)*l(i)*(VX(i)+(1/6)*Ai(i)*(Y(i+1)+2*Y(i)));
    end
end
if Imin~=0
    for i=1:n-1
        Ys=Ys+(-1/Imin)*dlY(i)*dY(i)*l(i)*(VY(i)-(1/6)*Ai(i)*(X(i+1)+2*X(i)));
    end
end

%Warping funcions and Warping Constant
X_s(1)=X(1)-Xs;
Y_s(1)=Y(1)-Ys;
ws(1)=0;
wa(1)=0;
ws_=0;

for i=1:n-1
    X_s(i+1)=X(i+1)-Xs;
    Y_s(i+1)=Y(i+1)-Ys;
    ds(i)=(1/l(i))*abs(X_s(i)*Y_s(i+1)-X_s(i+1)*Y_s(i));
    if (Y_s(i)*(X(i+1)-X(i)))<(X_s(i)*(Y(i+1)-Y(i)))
        dls(i)=1;
    else if (Y_s(i)*(X(i+1)-X(i)))>(X_s(i)*(Y(i+1)-Y(i)))
            dls(i)=-1;
        else if (Y_s(i)*(X(i+1)-X(i)))==(X_s(i)*(Y(i+1)-Y(i)))
                dls(i)=0;
            end
        end
    end
    ws(i+1)=ws(i)+ds(i)*l(i)*dls(i);
    ws_=ws_+(1/A)*Ai(i)*(ws(i+1)+ws(i))/2;
end

xx(1)=0;
for i=1:n
    w(i,1)=ws_-ws(i);
end

Cw=0;
for i=1:n-1
    dw=w(i+1)-w(i);
    wa=w(i);
    Cw=Cw+t(i)*(wa^2*l(i)+(1/3)*dw^2*l(i)+wa*dw*l(i));
end

%Monosymmetry Parameters Bx and By
B1=0;
B2=0;
for i=1:n-1
    Xa=X(i);
    dX=X(i+1)-X(i);
    Ya=Y(i);
    dY=Y(i+1)-Y(i);
    B1=B1+Ai(i)*1/12*(3*dY*dX^2+3*dY^3+4*Ya*dX^2+12*Ya*dY^2+8*dY*Xa*dX+12*Ya*Xa*dX+18*Ya^2*dY+6*dY*Xa^2+12*Ya*Xa^2+12*Ya^3);
    B2=B2+Ai(i)*1/12*(3*dX^3+3*dX*dY^2+12*Xa*dX^2+4*Xa*dY^2+8*dX*Ya*dY+18*Xa^2*dX+12*Xa*Ya*dY+6*dX*Ya^2+12*Xa^3+12*Xa*Ya^2);
end
B1=(1/Imax)*B1-2*(Ys);
B2=(1/Imin)*B2-2*(Xs);


X=x-xc*ones(n,1);
Y=y-yc*ones(n,1);
Bx=0;
By=0;
for i=1:n-1
    Xa=X(i);
    dX=X(i+1)-X(i);
    Ya=Y(i);
    dY=Y(i+1)-Y(i);
    Bx=Bx+Ai(i)*1/12*(3*dY*dX^2+3*dY^3+4*Ya*dX^2+12*Ya*dY^2+8*dY*Xa*dX+12*Ya*Xa*dX+18*Ya^2*dY+6*dY*Xa^2+12*Ya*Xa^2+12*Ya^3);
    By=By+Ai(i)*1/12*(3*dX^3+3*dX*dY^2+12*Xa*dX^2+4*Xa*dY^2+8*dX*Ya*dY+18*Xa^2*dX+12*Xa*Ya*dY+6*dX*Ya^2+12*Xa^3+12*Xa*Ya^2);
end
Bx=(1/Ixc)*Bx-2*(Ys);
By=(1/Iyc)*By-2*(Xs);

