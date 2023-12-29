function [fib_c,nodef_c,node_c,element_c,node_c90,element_c90,A,xcg,zcg,Ixx,Izz,Ixz,thetapf,I11,I22]=...
    PMM_fiber_node_element_Z_rot(section,n_elem_cufsm,n_elem_plastic,NL,ndata,text,CorZ,Round_corner)
%%% In the name of Allah
%%% Fiber element Model
%%% March 2013
%%% Adding Z; November 2013
%%% Shahabeddin Torabian


% Reading SSMA Section Properties
% [ndata,text,alldata]=xlsread('SSMA1.xlsx');

% % Number of Elements for CUFSM stability analysis
% n_elem_cufsm=[4 4 4 4 8 4 4 4 4];
% 
% % Number of Elements and fiber layers for Plastic Surface analysis
% n_elem_plastic=3*[4 4 4 4 16 4 4 4 4];
% NL_plastic=7;
% NL=7;
% CorZ=2;

% load ('Zsections.mat')
% Assigning dimensions
% section='7Z-60';
I=find(ismember(text,section));
D=ndata(I,1);
B=ndata(I,2);
t=ndata(I,3);
d=ndata(I,4);
R=ndata(I,5);

if CorZ==1
    theta=90;
else 
    theta=ndata(I,21);
end

% Converting to center-line dimensions
Ro=R+t;
Rc=R+t/2;
Dc=D-2*Ro;
Bc=B-Ro-Ro*tan((theta/2)/180*pi);
dc=d-Ro*tan((theta/2)/180*pi);

% Preparing templatecalc.m input data

h=Dc;
b1=Bc;
b2=Bc;
d1=dc;
d2=dc;
r1=Rc;
r2=Rc;
r3=Rc;
r4=Rc;
q1=theta;
q2=theta;
kipin=1;

% for 90  deg.
        h_90=D-t;
        b1_90=B-t/2-t/2*tan((theta/2)/180*pi);
        b2_90=B-t/2-t/2*tan((theta/2)/180*pi);
        d1_90=d-t/2*tan((theta/2)/180*pi);
        d2_90=d-t/2*tan((theta/2)/180*pi);
        q1_90=theta;
        q2_90=theta;

% n_elem_plastic=3*[4 4 4 4 16 4 4 4 4];

% Number of layers (Even Numbers 1,3,5,7,9,11,...)

% NL=5;
Dt=t/NL;

% Preparing templatecalc.m input data
if Round_corner==0;
    r1=0;r2=0;r3=0;r4=0;
end

if r1==0&r2==0&r3==0&r4==0;
    
    if CorZ==1
        for i=1:NL      
            hh(i)=h+(i-(NL+1)/2)*2*Dt;
            bb1(i)=b1+(i-(NL+1)/2)*2*Dt;
            bb2(i)=b2+(i-(NL+1)/2)*2*Dt;
            dd1(i)=d1+(i-(NL+1)/2)*Dt;
            dd2(i)=d2+(i-(NL+1)/2)*Dt;
            rr1(i)=0;
            rr2(i)=0;
            rr3(i)=0;
            rr4(i)=0;
            qq1(i)=q1;
            qq2(i)=q2;
            tt(i)=Dt;    
        end
    else
        for i=1:NL 
            hh(i)=h-t;
            bb1(i)=b1_90-(i-(NL+1)/2)*Dt-(i-(NL+1)/2)*Dt*tan((theta/2)/180*pi);
            bb2(i)=b2_90+(i-(NL+1)/2)*Dt+(i-(NL+1)/2)*Dt*tan((theta/2)/180*pi);
            dd1(i)=d1_90-(i-(NL+1)/2)*Dt*tan((theta/2)/180*pi);
            dd2(i)=d2_90+(i-(NL+1)/2)*Dt*tan((theta/2)/180*pi);           
            rr1(i)=0;
            rr2(i)=0;
            rr3(i)=0;
            rr4(i)=0;
            qq1(i)=q1;
            qq2(i)=q2;
            tt(i)=Dt;
        end
    end
        
    
else
   
    for i=1:NL        
        hh(i)=h;  
        if CorZ==1
        rr1(i)=(i-(NL+1)/2)*Dt+r1;
        rr2(i)=(i-(NL+1)/2)*Dt+r2;
        else
        rr1(i)=((NL+1)/2-i)*Dt+r1;
        rr2(i)=((NL+1)/2-i)*Dt+r2;
        end
        rr3(i)=(i-(NL+1)/2)*Dt+r3;
        rr4(i)=(i-(NL+1)/2)*Dt+r4;
        bb1(i)=b1;
        bb2(i)=b1;
        dd1(i)=d1;
        dd2(i)=d1;
        qq1(i)=q1;
        qq2(i)=q2;
        tt(i)=Dt;

    end

end

[prop1,node_c,element_c,lengths1,springs1,constraints1,geom1,cz1]=...
    templatecalc2(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,q1,q2,t,kipin,n_elem_cufsm);

[A,xcg,zcg,Ixx,Izz,Ixz,thetap_c,I11,I22]=grosprop(node_c,element_c);

node_c(:,2)=node_c(:,2)-xcg;
node_c(:,3)=node_c(:,3)-zcg;

R = [cos(-thetap_c/180*pi)  -sin(-thetap_c/180*pi) ; sin(-thetap_c/180*pi)  cos(-thetap_c/180*pi)];
node_c_rot=node_c;
Dim_r=R*node_c(:,2:3)';
node_c_rot(:,2:3)=Dim_r';
node_c=node_c_rot;
           
[prop1,node_c90,element_c90,lengths1,springs1,constraints1,geom1,cz1]=...
    templatecalc2(CorZ,h_90,b1_90,b2_90,d1_90,d2_90,0,0,0,0,q1_90,q2_90,t,kipin,n_elem_cufsm);

[A,xcg,zcg,Ixx,Izz,Ixz,thetap_c90,I11,I22]=grosprop(node_c90,element_c90);

node_c90(:,2)=node_c90(:,2)-xcg;
node_c90(:,3)=node_c90(:,3)-zcg;

R = [cos(-thetap_c90/180*pi)  -sin(-thetap_c90/180*pi) ; sin(-thetap_c90/180*pi)  cos(-thetap_c90/180*pi)];
node_c90_rot=node_c90;
Dim_r90=R*node_c90(:,2:3)';
node_c90_rot(:,2:3)=Dim_r90';
node_c90=node_c90_rot;

for i=1:NL

[prop1,node1,elem1,lengths1,springs1,constraints1,geom1,cz1]=...
    templatecalc2(CorZ,hh(i),bb1(i),bb2(i),dd1(i),dd2(i),rr1(i),rr2(i),rr3(i),rr4(i),qq1(i),qq2(i),tt(i),kipin,n_elem_plastic);

NN=length(node1);
NE=length(elem1);
nodeR(:,1)=node1(:,1)+NN*(i-1);
if CorZ==1
corrx=node_c(1,2)+(i-(NL+1)/2)*Dt*sin(q1/180*pi)-node1(1,2);
corry=node_c(1,3)-(i-(NL+1)/2)*Dt*cos(q1/180*pi)-node1(1,3);
else
corrx=node_c(1,2)-(i-(NL+1)/2)*Dt*sin(q1/180*pi)-node1(1,2);
corry=node_c(1,3)+(i-(NL+1)/2)*Dt*cos(q1/180*pi)-node1(1,3);
end
nodeR(:,2)=node1(:,2)+corrx;
nodeR(:,3)=node1(:,3)+corry;
nodeR(:,4:8)=node1(:,4:8);

elemR(:,1)=elem1(:,1)+NE*(i-1);
elemR(:,2:3)=elem1(:,2:3)+NN*(i-1);
elemR(:,4)=Dt;
elemR(:,5)=elem1(:,5);

if i==1
node=nodeR;
elem=elemR;
springs=springs1;
constraints=constraints1;
else
node=[node;nodeR];
elem=[elem;elemR]; 
springs=[springs;springs1];
constraints=[constraints;constraints1];
end

end


%%% Section Properties and Fiber generation
[A,xcg,zcg,Ixx,Izz,Ixz,thetapf,I11,I22,fib]=grosprop1(node,elem);

axestemp=1;
cz=1;

flags=[0,0,0,0,0,0,0,0,0];
axesnum=1;


NF=length(fib);

AX=0;
Az=0;

for i=1:NF
 
  AX=AX+fib(i,2)*fib(i,4);
  Az=Az+fib(i,3)*fib(i,4);
  
       
end

Af=sum(fib(:,4));
xgf=AX/Af;
zgf=Az/Af;


%%% Moving center to Centroid
%fib:[fiber# x_f z_f A_f]

fib_c=fib;
fib_c(:,2)=fib(:,2)-xcg;
fib_c(:,3)=fib(:,3)-zcg;

R = [cos(-thetapf/180*pi)  -sin(-thetapf/180*pi) ; sin(-thetapf/180*pi)  cos(-thetapf/180*pi)];

fib_c_rot=fib_c;
Dim_r=R*fib_c(:,2:3)';
fib_c_rot(:,2:3)=Dim_r';
fib_c=fib_c_rot;

nodef_c=node;
nodef_c(:,2)=node(:,2)-xcg;
nodef_c(:,3)=node(:,3)-zcg;

nodef_c_rot=nodef_c;
Dim_r=R*nodef_c(:,2:3)';
nodef_c_rot(:,2:3)=Dim_r';
nodef_c=nodef_c_rot;

% for rotated Z
FIx=Ixx;
FIz=Izz;
Ixx=I11;
Izz=I22;
I11=FIx;
I22=FIz;
Ixz=0;


end