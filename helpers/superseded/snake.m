%Test functions for snakey v2 with new input structure
%generating initial geometries for centerline template examples

%Lipped channel, centerline dimensions
clear strips
d=1;
b=4;
h=8;
t=0.1;
r=2*t;
%straight line segments (centerline)
strips.l= [d b h b d];
strips.q= [270 180 90 0 -90]*pi/180;
strips.n= [2 4 8 4 2];
strips.t= [t t t t t]; 
strips.id=[100 100 100 100 100];
strips.closed=false; %open shape
%corner radius between segments (if desired)
strips.r=[r r r r]; 
strips.rn=[4 4 4 4];
strips.rt=[t t t t];
strips.rid=[100 100 100 100];
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('lippedc_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%Lipped zed, centerline dimensions
clear strips
d=1;
b=4;
h=8;
t=0.1;
r=2*t;
qlips=50; %degrees
%straight line segments (centerline)
strips.l= [d b h b d];
strips.q= [-50 0 90 0 -50]*pi/180;
strips.n= [2 4 8 4 2];
strips.t= [t t t t t]; 
strips.id=[100 100 100 100 100];
strips.closed=false; %open shape
%corner radius between segments (if desired)
strips.r=[r r r r]; 
strips.rn=[4 4 4 4];
strips.rt=[t t t t];
strips.rid=[100 100 100 100];
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('lippedz_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%Sigma (TSN example), centerline dimensions
clear strips
t=0.1017;
D=6; B=3; A=1.25; C=1; E=0.625; N=2.25; D1=0.7234; D2=0.5; rin=0.105;
d2=D2-t/2;
d1=D1-t;
b=B-t;
a=A-t/2;
ce=sqrt((C)^2+(E)^2);
qce=atan2(C,E)*180/pi;
n=N;
r=rin+t/2;
%straight line segments (centerline)
strips.l= [d2 d1 b a ce n ce a b d1 d2];
strips.q= [90 180 -90 0 qce 0 -qce 0 90 180 -90]*pi/180;
strips.n= [2 2 8 4 4 4 4 4 8 2 2];
strips.t= [t t t t t t t t t t t]; 
strips.id=[9 9 9 9 9 9 9 9 9 9 9];
strips.closed=false; %open shape
%corner radius between segments (if desired)
strips.r=  [r r r r r r r r r r]; 
strips.rn= [4 4 4 4 4 4 4 4 4 4];
strips.rt= [t t t t t t t t t t];
strips.rid=[9 9 9 9 9 9 9 9 9 9];
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[9 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('sigma_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%N deck, 24 in coverage, centerline dimensions
clear strips
t=0.0474; %18 gage
w=24; h=3; b2=1+7/8; bs=2+5/8;
qc=atan2(h,(bs-b2)/2);
c=h/sin(qc);
b1=w/3-b2-2*h/tan(qc);
r=2*t;
qc=qc*180/pi;
%straight line segments (centerline)
strips.l= [b2/2 c  b1 c  b2 c  b1 c   b2 c  b1 c   b2 b2/2];
strips.q= [0    qc 0 -qc 0  qc 0  -qc 0  qc 0  -qc 0  qc]*pi/180;
strips.n= [2    6  4  6  2  6  4  6   2  6  4  6   2  2];
strips.t= [t    t  t  t  t  t  t  t   t  t  t  t   t  t]; 
strips.id=[9    9  9  9  9  9  9  9   9  9  9  9   9  9];
strips.closed=false; %open shape
%corner radius between segments (if desired)
strips.r=  r*ones(1,13); 
strips.rn= 4*ones(1,13);
strips.rt= t*ones(1,13);
strips.rid=9*ones(1,13);
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[9 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('Ndeck_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')


%Hat, centerline dimensions
d=1;
b=4;
h=8;
t=0.1;
r=2*t;
%straight line segments (centerline)
strips.l= [d b h b d];
strips.q= [0 90 0 -90 0]*pi/180;
strips.n= [2 4 8 4 2];
strips.t= [t t t t t]; 
strips.id=[100 100 100 100 100];
strips.closed=false; %open shape
%corner radius between segments (if desired)
strips.r=[r r r r]; 
strips.rn=[4 4 4 4];
strips.rt=[t t t t];
strips.rid=[100 100 100 100];
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('hat_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%RHS, centerline dimensions
b=4;
h=8;
t=0.5;
r=2*t;
%straight line segments (centerline)
strips.l= [b h b h];
strips.q= [0 90 180 270]*pi/180;
strips.n= [4 8 4 8];
strips.t= [t t t t]; 
strips.id=[100 100 100 100];
strips.closed=true; %open shape
%corner radius between segments (if desired)
strips.r=[r r r r]; 
strips.rn=[4 4 4 4];
strips.rt=[t t t t];
strips.rid=[100 100 100 100];
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('RHS_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%Heavy Duty Studs Like ClarkDietrich, centerline dimensions
t=0.068;
a=6-t;
b=3-t;
c=2.25-t;
d=0.75-t/2;
r=2*t;
%straight line segments (centerline)
strips.l= [d c b a b c d];
strips.q= [90 0 -90 180 90 0 -90]*pi/180;
strips.n= [2 4 4 8 4 4 2];
strips.t= [t t t t t t t]; 
strips.id=[100 100 100 100 100 100 100];
strips.closed=false; %open shape
%corner radius between segments (if desired)
strips.r=[r r r r r r]; 
strips.rn=[4 4 4 4 4 4];
strips.rt=[t t t t t t];
strips.rid=[100 100 100 100 100 100];
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('hds_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%CHS, centerline flat approximation
clear strips
r=6;
t=0.25;
n=31;
dq=2*pi/(n-1);
%straight line segments (centerline)
strips.l= dq*r*ones(1,n);
strips.q= pi/2:dq:2*pi+pi/2;
strips.n= 1*ones(1,n);
strips.t= t*ones(1,n); 
strips.id=9*ones(1,n);
strips.closed=true; 
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[9 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('chs_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%I-section, centerline dimensions
clear strips
tw=0.25;
tf=1;
hin=14;
h=hin+2*tf;
bf=6;
%branch of the I-section without half flanges
strips.l= [bf/2 h bf/2];
strips.q= [0 90 180]*pi/180;
strips.n= [3 8 3];
strips.t= [tf tw tf]; 
strips.id=[100 100 100];
strips.closed=false; %open shape
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=[]; constraints=[];
%generate top 1/2 flange
strips.l= [bf/2];
strips.q= [0]*pi/180;
strips.n= [3];
strips.t= [tf]; 
strips.id=[100];
strips.origin.type='start'; %or 'lowerleft'
strips.origin.x=bf/2; %x coordinate of the start or lowerleft
strips.origin.z=h;    %z coordinate of the start or lowerleft
[node2,elem2]=snakey(strips);
%generate bottom 1/2 flange
strips.origin.z=0;
[node3,elem3]=snakey(strips);
%merge node and elem with node2 and elem2
tol=t/100; %to find nodes to be merged
[node, elem] = merge_branch(node, elem, node2, elem2, tol);
%merge node ane elem with node3 and elem3
[node, elem] = merge_branch(node, elem, node3, elem3, tol);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('I_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%Tee-section, centerline dimensions
clear strips
tw=0.25;
tf=1;
hin=7;
h=hin+tf;
bf=6;
%branch of the T-section without half flanges
strips.l= [h bf/2];
strips.q= [90 180]*pi/180;
strips.n= [8 3];
strips.t= [tw tf]; 
strips.id=[100 100];
strips.closed=false; %open shape
%call snakey to generate strips
[node,elem]=snakey(strips);
%generate top 1/2 flange
strips.l= [bf/2];
strips.q= [0]*pi/180;
strips.n= [3];
strips.t= [tf]; 
strips.id=[100];
strips.origin.type='start'; %or 'lowerleft'
strips.origin.x=bf/2; %x coordinate of the start or lowerleft
strips.origin.z=h;    %z coordinate of the start or lowerleft
[node2,elem2]=snakey(strips);
%merge node and elem with node2 and elem2
tol=t/100; %to find nodes to be merged
[node, elem] = merge_branch(node, elem, node2, elem2, tol);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('T_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')

%Angle
clear strips
D=6; %out to out depth
W=4; %out to out width
t=1/2;
d=D-t/2;
w=W-t/2;
%branch of the T-section without half flanges
strips.l= [d w];
strips.q= [-90 0]*pi/180;
strips.n= [6 6];
strips.t= [t t]; 
strips.id=[9 9];
strips.closed=false; %open shape
%call snakey to generate strips
[node,elem]=snakey(strips);
prop=[9 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[]; springs=0; constraints=0;
save('L_test', 'prop', 'node', 'elem', 'lengths', 'springs', 'constraints')


