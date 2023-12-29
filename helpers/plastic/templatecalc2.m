function [prop,node,elem,lengths,springs,constraints,geom,cz]=templatecalc2(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,q1,q2,t,kipin,n_elements)
%BWS
%August 23, 2000
%
%CorZ=determines sign conventions for flange 1=C 2=Z
if CorZ==2
	cz=-1;
else
	cz=1;
end
%channel template
%
%convert angles to radians
q1=q1*pi/180;
q2=q2*pi/180;
%rest of the dimensions are "flat dimensions" and acceptable for modeling
if r1==0&r2==0&r3==0&r4==0
    geom=[1 b1+d1*cos(q1) d1*sin(q1)
        2 b1            0
        3 0             0
        4 0             h
        5 cz*(b2)       h
        6 cz*(b2+d2*cos(q2)) h-d2*sin(q2)];
else
    geom=[1 r1+b1+r2*cos(pi/2-q1)+d1*cos(q1) r2-r2*sin(pi/2-q1)+d1*sin(q1)
        2 r1+b1+r2*cos(pi/2-q1)            r2-r2*sin(pi/2-q1)
        3 r1+b1                            0
        4 r1                               0
        5 0                                r1
        6 0                                r1+h
        7 cz*r3                               r1+h+r3
        8 cz*(r3+b2)                            r1+h+r3
        9 cz*(r3+b2+r4*cos(pi/2-q2))            r1+h+r3-r4+r4*sin(pi/2-q2)
        10 cz*(r3+b2+r4*cos(pi/2-q2)+d2*cos(q2)) r1+h+r3-r4+r4*sin(pi/2-q2)-d2*sin(q2)];
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
                    r=r2;, xc=r1+b1;, zc=r2;, qstart=pi/2-q1;, dq=q1*j/nn(i);
                end
                if i==4
                    r=r1;, xc=r1;, zc=r1;, qstart=pi/2;, dq=pi/2*j/nn(i);
                end
                if i==6
                    r=r3;, xc=cz*r3;, zc=r1+h;, qstart=(1==cz)*pi;, dq=cz*pi/2*j/nn(i);
                end
                if i==8
                    r=r4;, xc=cz*(r3+b2);, zc=r1+h+r3-r4;, qstart=3*pi/2;, dq=cz*q2*j/nn(i);
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
