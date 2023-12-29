function [ xyzr ] = B2xyzr(B,Teta,Phi)
%   Converting B data to xyzr

Teta=Teta/180*pi;
Phi=Phi/180*pi;


L=length(B);

k=1;
for i=1:length(Teta)
    for j=1:length(Phi)      
        xyzr(k,1)=Teta(i)/pi*180;
        xyzr(k,2)=Phi(j)/pi*180;
        xyzr(k,3)=B(k);
        xyzr(k,4)=B(k)*cos(Teta(i))*sin(Phi(j));
        xyzr(k,5)=B(k)*sin(Teta(i))*sin(Phi(j));
        xyzr(k,6)=B(k)*cos(Phi(j));
        if k<=L/2||length(Teta)==1
        xyzr(k,7)=B(k)*sin(Phi(j));
        else
        xyzr(k,7)=-B(k)*sin(Phi(j));
        end
        k=k+1;
    end
end

end

