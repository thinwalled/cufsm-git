function [M11_P,M22_P,P_P]=PMM_Plastic(fib,node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm,Ne,Deg)

%%% Fiber element Model
%%% ST March 2013
%%% ST Modified March 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%GUI WAIT BAR FOR BUILDIG SURFACE
wait_message=waitbar(0,'Building Plastic Surface','position',[150 300 384 68],...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(wait_message,'canceling',0)



theta=Deg/180*pi;
NF=length(fib);

[Py,~,~,M11_y,M22_y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm);

%%% Moving center to Centroid
%fib:[fiber# x_f z_f A_f]

fib(:,2)=fib(:,2)-xcg;
fib(:,3)=fib(:,3)-zcg;

R = [cos(-thetap/180*pi)  -sin(-thetap/180*pi) ; sin(-thetap/180*pi)  cos(-thetap/180*pi)];

fib_rot=fib;
Dim_r=R*fib(:,2:3)';
fib_rot(:,2:3)=Dim_r';
fib=fib_rot;


for k=1:length(theta)
        %info=['Angle ',num2str(lengths(l)),' done.'];
        waitbar(k/length(theta),wait_message);
%%%Plastic N.A

xmin=min(fib(:,2));
xmax=max(fib(:,2));
zmin=min(fib(:,3));
zmax=max(fib(:,3));

CP(1,2:3)=[xmin,zmin];
CP(2,2:3)=[xmin,zmax];
CP(3,2:3)=[xmax,zmin];
CP(4,2:3)=[xmax,zmax];

for i=1:4
    dCP(i)=(cos(theta(k))*CP(i,3)-sin(theta(k))*CP(i,2));
end

emin=min(dCP)*1.02;
emax=max(dCP)*1.02;
r=max(abs(emin),abs(emax));
De=2*r/Ne;
e=-r:De:r;

M1(length(e),k)=0;
M2(length(e),k)=0;
P(length(e),k)=0;

for i=1:length(e)
   M1(i,k)=0;
   M2(i,k)=0;
   P(i,k)=0; 
  for j=1:NF
    
      CL=fib(j,3)*cos(theta(k))-fib(j,2)*sin(theta(k))-e(i);
      
    if CL>0
        fib(j,5)=-fib(j,4)*fy;
    elseif CL<0
        fib(j,5)=+fib(j,4)*fy;
    else 
        fib(j,5)=0;
    end
    
    M1(i,k)=M1(i,k)-fib(j,5)*fib(j,3);
    M2(i,k)=M2(i,k)+fib(j,5)*fib(j,2);
    P(i,k)=P(i,k)+fib(j,5);

  end 
end  


end

if ishandle(wait_message)
    delete(wait_message);
end

M11_P=M1/M11_y;
M22_P=M2/M22_y;
P_P=P/Py;


end




