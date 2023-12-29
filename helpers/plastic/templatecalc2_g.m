function [prop,node,elem,lengths,springs,constraints,geom,cz]=templatecalc2_g(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,qf1,qf2,ql1,ql2,t,kipin,n_elements)
%BWS
%August 23, 2000
%Shahabeddin Torabian
%May 2015
%Modification November 2015
%CorZ=determines sign conventions for flange 1=C 2=Z

if CorZ==2
	cz=-1;
else
	cz=1;
end
%channel template
%
%convert angles to radians
qf1=qf1*pi/180;
qf2=qf2*pi/180;
ql1=ql1*pi/180;
ql2=ql2*pi/180;

%rest of the dimensions are "flat dimensions" and acceptable for modeling
if r1==0&r2==0&r3==0&r4==0
%         h_90=h+t/2*(tan(qf1/2)+tan(qf2/2));
%         b1_90=b1+t/2*(tan(qf1/2)+tan(ql1/2));
%         b2_90=b2+t/2*(tan(qf2/2)+tan(ql2/2));
%         d1_90=d1+t/2*tan(ql1/2);
%         d2_90=d2+t/2*tan(ql1/2);
%    
%     geom=[1 b1_90*cos(pi()/2-qf1)+d1_90*cos(ql1+qf1-pi()/2) -b1_90*sin(pi()/2-qf1)+d1_90*sin(ql1+qf1-pi()/2)
%         2 b1_90*cos(pi()/2-qf1) -b1_90*sin(pi()/2-qf1)
%         3 0                                0
%         4 0                                h_90
%         5 cz*(b2_90*cos(pi()/2-qf2)) h_90+b2_90*sin(pi()/2-qf2)
%         6 cz*(b2_90*cos(pi()/2-qf2)+d2_90*cos(ql2+qf2-pi()/2)) h_90+b2_90*sin(pi()/2-qf2)-d2_90*sin(ql2+qf2-pi()/2)];
%             h_90=h+t/2*(tan(qf1/2)+tan(qf2/2));
   
    geom=[1 b1*cos(pi()/2-qf1)+d1*cos(ql1+qf1-pi()/2) -b1*sin(pi()/2-qf1)+d1*sin(ql1+qf1-pi()/2)
        2 b1*cos(pi()/2-qf1) -b1*sin(pi()/2-qf1)
        3 0                                0
        4 0                                h
        5 cz*(b2*cos(pi()/2-qf2)) h+b2*sin(pi()/2-qf2)
        6 cz*(b2*cos(pi()/2-qf2)+d2*cos(ql2+qf2-pi()/2)) h+b2*sin(pi()/2-qf2)-d2*sin(ql2+qf2-pi()/2)];
    
else
    geom=[1 r1*(1-cos(qf1))+b1*cos(pi()/2-qf1)+r2*(sin(pi()/2-qf1)+sin(ql1-pi()/2+qf1))+d1*cos(ql1+qf1-pi()/2) -r1*sin(qf1)-b1*sin(pi()/2-qf1)+r2*(cos(pi()/2-qf1)-cos(ql1+qf1-pi()/2))+d1*sin(ql1+qf1-pi()/2)
        2 r1*(1-cos(qf1))+b1*cos(pi()/2-qf1)+r2*(sin(pi()/2-qf1)+sin(ql1+qf1-pi()/2)) -r1*sin(qf1)-b1*sin(pi()/2-qf1)+r2*(cos(pi()/2-qf1)-cos(ql1+qf1-pi()/2))
        3 r1*(1-cos(qf1))+b1*cos(pi()/2-qf1) -r1*sin(qf1)-b1*sin(pi()/2-qf1)
        4 r1*(1-cos(qf1)) -r1*sin(qf1)
        5 0                                0
        6 0                                h
        7 cz*r3*(1-cos(qf2)) h+r3*sin(qf2)
        8 cz*(r3*(1-cos(qf2))+b2*cos(pi()/2-qf2)) h+r3*sin(qf2)+b2*sin(pi()/2-qf2)
        9 cz*(r3*(1-cos(qf2))+b2*cos(pi()/2-qf2)+r4*(sin(pi()/2-qf2)+sin(ql2+qf2-pi()/2))) h+r3*sin(qf2)+b2*sin(pi()/2-qf2)-r4*(cos(pi()/2-qf2)-cos(ql2+qf2-pi()/2))
        10 cz*(r3*(1-cos(qf2))+b2*cos(pi()/2-qf2)+r4*(sin(pi()/2-qf2)+sin(ql2+qf2-pi()/2))+d2*cos(ql2+qf2-pi()/2)) h+r3*sin(qf2)+b2*sin(pi()/2-qf2)-r4*(cos(pi()/2-qf2)-cos(ql2+qf2-pi()/2))-d2*sin(ql2+qf2-pi()/2)];
end
%number of elements between the geom coordinates


if r1==0&r2==0&r3==0&r4==0
    nn=n_elements(1:2:9);
else
    nn=n_elements;
end

node_e(1)=1;
for i=2:size(geom,1)
node_e(i)=node_e(i-1)+nn(i-1);
end
hold all
for i=1:size(geom,1)-1
      node(node_e(i),:)=[node_e(i) geom(i,2:3) 1 1 1 1 1.0];
%     node(n*(i-1)+1,:)=[n*(i-1)+1 geom(i,2:3) 1 1 1 1 1.0];
    start=geom(i,2:3);
    stop=geom(i+1,2:3);
    if r1==0&r2==0&r3==0&r4==0
        for j=1:nn(i)-1
            node(node_e(i)+j,:)=[node_e(i)+j start+(stop-start)*j/nn(i) 1 1 1 1 1.0];
        end
    else
        if max(i==[1 3 5 7 9]) %use linear interpolation
            for j=1:nn(i)-1
                node(node_e(i)+j,:)=[node_e(i)+j start+(stop-start)*j/nn(i) 1 1 1 1 1.0];
            end
        else %we are in a corner and must be fancier
            for j=1:nn(i)-1
                if i==2
                    r=r2; xc=r1*(1-cos(qf1))+b1*cos(pi()/2-qf1)+r2*(sin(pi()/2-qf1)); zc=-r1*sin(qf1)-b1*sin(pi()/2-qf1)+r2*(cos(pi()/2-qf1)); qstart=pi()/2-(ql1-(pi()/2-qf1)); dq=ql1*j/nn(i);
%                     plot(xc,zc,'o');
                end
                if i==4
                    r=r1; xc=r1; zc=0; qstart=pi-qf1; dq=qf1*j/nn(i);
%                      plot(xc,zc,'o');
                end
                if i==6
                    r=r3; xc=cz*r3; zc=h; qstart=(1==cz)*pi(); dq=cz*qf2*j/nn(i);
%                      plot(xc,zc,'o');
                end
                if i==8
                    r=r4; xc=cz*(r3*(1-cos(qf2))+b2*cos(pi()/2-qf2)+r4*(sin(pi()/2-qf2))); zc=h+r3*sin(qf2)+b2*sin(pi()/2-qf2)-r4*(cos(pi()/2-qf2)); qstart=cz*qf2-(1==cz)*pi(); dq=cz*ql2*j/nn(i);
%                      plot(xc,zc,'o');
                end
                x2=xc+r*cos(qstart+dq);
                z2=zc-r*sin(qstart+dq); %note sign on 2nd term is negative due to z sign convention (down positive)
                node(node_e(i)+j,:)=[node_e(i)+j x2 z2 1 1 1 1 1.0];
            end
        end
    end
end
if r1==0&r2==0&r3==0&r4==0
    i=6;
    node(node_e(i),:)=[node_e(i) geom(i,2:3) 1 1 1 1 1.0];
else
    i=10;
    node(node_e(i),:)=[node_e(i) geom(i,2:3) 1 1 1 1 1.0];
end
%
for i=1:size(node,1)-1
   elem(i,:)=[i i i+1 t 100];     
end
%
%set some default properties
if kipin==1
prop=[100 29500 29500 0.3 0.3 29500/(2*(1+0.3))];
else
prop=[100 203000 203000 0.3 0.3 203000/(2*(1+0.3))];
end
%
%set some deafult lengths
big=max([h;b1;b2;d1;d2]);
lengths=[logspace(log10(big/10),log10(big*1000),50)];
%
springs=[0];%    
constraints=[0];%    
%
