function [Mxn,Mzn,Pn]=PMM_Dumping(fib_c,Fy,PY,MxxY,MzzY,Ne,Deg)

%%% In the name of Allah
%%% Fiber element Model
%%% March 2013
%%% Shahabeddin Torabian

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=0;
teta=Deg/180*pi;
NF=length(fib_c);

for k=1:length(teta)

%%%Plastic N.A

xmin=min(fib_c(:,2));
xmax=max(fib_c(:,2));
zmin=min(fib_c(:,3));
zmax=max(fib_c(:,3));

CP(1,2:3)=[xmin,zmin];
CP(2,2:3)=[xmin,zmax];
CP(3,2:3)=[xmax,zmin];
CP(4,2:3)=[xmax,zmax];

for i=1:4
    dCP(i)=(cos(teta(k))*CP(i,3)-sin(teta(k))*CP(i,2));
end

emin=min(dCP)*1.02;
emax=max(dCP)*1.02;
r=max(abs(emin),abs(emax));
De=2*r/Ne;
e=-r:De:r;

Mx(length(e),k)=0;
Mz(length(e),k)=0;
P(length(e),k)=0;

for i=1:length(e)
   Mx(i,k)=0;
   Mz(i,k)=0;
   P(i,k)=0; 
  for j=1:NF
    
      CL=fib_c(j,3)*cos(teta(k))-fib_c(j,2)*sin(teta(k))-e(i);
      
    if CL>0
        fib_c(j,5)=-fib_c(j,4)*Fy;
    elseif CL<0
        fib_c(j,5)=+fib_c(j,4)*Fy;
    else 
        fib_c(j,5)=0;
    end
    
    Mx(i,k)=Mx(i,k)-fib_c(j,5)*fib_c(j,3);
    Mz(i,k)=Mz(i,k)+fib_c(j,5)*fib_c(j,2);
    P(i,k)=P(i,k)+fib_c(j,5);

  end 
end  


end

Mxn=Mx/MxxY;
Mzn=Mz/MzzY;
Pn=P/PY;


end




