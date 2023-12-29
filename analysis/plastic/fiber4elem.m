function [fib] = fiber4elem(node,elem,nfiber)
%BWS dummy function for fiber maker routine
%input
%node,elem standard CUFSM inputs
%fiber column vector the length of elem that defines number of through
%thickness sections (fibers) for the fiber element calculator
%
%output
%elem_fiber
%elem(:,1:5)-standard definition
%elem(:,6)-fibers through the thickness in the given element
%ST 2016

elem(:,6)=nfiber;

[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22]=grosprop(node,elem);


k=1;
NEM=max(elem(:,1));
NNM=max(node(:,1));

for i=1:length(elem(:,1))
    x1=node(elem(i,2),2);
    z1=node(elem(i,2),3);
    x2=node(elem(i,3),2);
    z2=node(elem(i,3),3);
    elem(i,7)=pi-atan2((z2-z1),(x2-x1)); 

    Istart=find(node(:,1)==elem(i,2));
    Iend=find(node(:,1)==elem(i,3));
    elem(i,8)=(node(Istart,2)+node(Iend,2))/2;
    elem(i,9)=(node(Istart,3)+node(Iend,3))/2;
    elem(i,10)=((node(Istart,2)-node(Iend,2))^2+(node(Istart,3)-node(Iend,3))^2)^0.5;
        k=k+1;
end

k=1;
NE=length(elem(:,1));
for i=1:NE
    for j=1:elem(i,6)

        NL=elem(i,6);

        if NL~=1
            if j==1;
            fib_g(j,1)=-elem(i,4)/2+elem(i,4)/NL/2;
            fib_g(j,2)=0;
            else
            fib_g(j,1)=fib_g(j-1,1)+elem(i,4)/NL;
            fib_g(j,2)=0;
            end
        else
            fib_g(1,1)=0;
            fib_g(1,2)=0;
        end
    end

    R = [cos(elem(i,7)+pi/2)  -sin(elem(i,7)+pi/2) ; sin(elem(i,7)+pi/2)  cos(elem(i,7)+pi/2)];

    fib_rot=fib_g(:,:)*R;
    fib(((i-1)*NL+1):(i*NL),1)=((i-1)*NL+1):(i*NL);
    fib(((i-1)*NL+1):(i*NL),2:3)=fib_rot+ones(NL,1)*elem(i,8:9);
    fib(((i-1)*NL+1):(i*NL),4)=elem(i,10)*elem(i,4)/NL; 
end

%%% Moving Center to Centroid
%fib:[fiber# x_f z_f A_f]

% fib(:,2)=fib(:,2)-xcg;
% fib(:,3)=fib(:,3)-zcg;


%%% Rotating fibers to Principal Coordinate System
%fib:[fiber# x_f z_f A_f]

% R = [cos(-thetap/180*pi)  -sin(-thetap/180*pi) ; sin(-thetap/180*pi)  cos(-thetap/180*pi)];
% fib_rot=fib;
% Dim_r=R*fib(:,2:3)';
% fib_rot(:,2:3)=Dim_r';
% fib=fib_c_rot;


end