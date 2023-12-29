function [node]=warp_stress(node,prop,Tflag,T,B,L,x,Cw,J,w,Tcheck)
global outBedit outTedit

if Tcheck==1
    E=prop(1,2);
    G=prop(1,6);
    a=sqrt(E*Cw/(G*J));
    x=abs(x);
    L=abs(L);
    if x>L/2
        x=abs(L-x);
    end
    stress=E*T*sinh(x/a)*w/(G*J*a*cosh(L/(2*a)));
    for i=1:size(node,1)
        B=stress(i)*Cw/w(i);
    end
    set(outBedit,'String',num2str(B));
else
Tflag;
    if Tflag==1
        stress=B*w/Cw;
        if max(isnan(stress))
            stress=0;
        end
        node(:,8)=node(:,8)+stress;
    end
end