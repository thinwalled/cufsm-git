%Test functions for snakey

%Lipped channel, centerline dimensions
d=1;
b=4;
h=8;
t=0.1;
r=2*t;
q=90*pi/180;
strips.l= [d-r r*q b-2*r r*q h-2*r r*q b-2*r r*q d-r];
strips.q1=[270 270 180   180 90    90  0     0   -90]*pi/180;
strips.q2=[270 180 180    90 90    0   0     -90 -90]*pi/180
strips.n= [2   4   4     4   8     4   4     4    2];
strips.t= [t   t   t     t   t     t   t     t    t];
strips.id=[100 100 100   100 100   100 100   100  100];
strips.closed=false; %open shape
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[];, springs=[];, constraints=[];
save('lippedc_test')

%Lipped Zed centerline dimensions
d=1;
b=4;
h=8;
t=0.1;
r=2*t;
q1=90*pi/180; %lip angle
q2=90*pi/180; %corners
strips.l= [d-r r*q1 b-2*r r*q2 h-2*r r*q2 b-2*r r*q1 d-r];
strips.q1=[-90 -90  0     0    90    90   0     0    -10]*pi/180;
strips.q2=[-90 0    0     90   90    0    0     -10  -10]*pi/180
strips.n= [2   4    4     4    8     4    4     4     2];
strips.t= [t   t    t     t    t     t    t     t     t];
strips.id=[100 100  100   100  100   100  100   100   100];
strips.closed=false; %open shape
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[];, springs=[];, constraints=[];
save('lippedz_test')

%RHS, centerline dimensions
b=4;
h=8;
t=0.5;
r=2*t;
q=90*pi/180; %corners
strips.l= [h-2*r r*q b-2*r r*q  h-2*r r*q  b-2*r r*q];
strips.q1=[270  270  180   180  90    90   0     0]*pi/180;
strips.q2=[270  180  180   90   90    0    0    -90]*pi/180
strips.n= [8    4    4     4    8     4    4     4];
strips.t= [t    t    t     t    t     t    t     t];
strips.id=[100  100  100   100  100   100  100   100];
strips.closed = true;   % for HSS/CHS/shapes that close back to start
[node,elem]=snakey(strips);
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
lengths=[];, springs=[];, constraints=[];
save('RHS_test')


function [node,elem]=snakey(strips)
%Snake
%A function to convert simple l,theta,t etc. inputs into CUFSM node and elem
%BWS
%30 Nov 2025
xst=0;
yst=0;
i=1;
node=[];
elem=[];
started = false; %flag for initiating the nodes

for j=1:length(strips.l)
    n=strips.n(j);
    le=strips.l(j)/max(n,1); %length of a strip divided up n times
    q1=strips.q1(j);
    q2=strips.q2(j);
    dq=(q2-q1)/max(n,1); %angle change over the n times
    t=strips.t(j);
    id=strips.id(j);
    if n==0 || le==0 %then no need to make elements for these
        continue
    end

    for k=1:n
        if ~started %very first node
            x1=xst;
            y1=yst;
            node(i,:)=[i x1 y1 1 1 1 1 1.0];, i=i+1;
            started = true;
        else
            x1=x2;
            y1=y2;
        end
        x2=x1+le*cos(q1+(k-0.5)*dq); %straight or mid-angle if changing
        y2=y1+le*sin(q1+(k-0.5)*dq);
        node(i,:)=[i x2 y2 1 1 1 1 1.0];
        elem(i-1,:)=[i-1 i-1 i t id];, i=i+1;
    end
end

%As a matter of preference I prefer the origin to be in the lower left
%corner, so once things are set let's change the origin to that point.
xo=min(node(:,2));
yo=min(node(:,3));
node(:,2)=node(:,2)-xo;
node(:,3)=node(:,3)-yo;

%Loop closure for HSS or closed shapes
if isfield(strips,'closed') && strips.closed %checks for field and true
    nNodes = size(node,1);
    first  = 1;
    last   = nNodes;

    % Snap first and last to the same point (simple average)
    xm = 0.5*(node(first,2) + node(last,2));
    ym = 0.5*(node(first,3) + node(last,3));
    node(first,2:3) = [xm ym];

    % Redirect any element that ended at "last" to end at "first"
    elem(elem(:,3) == last, 3) = first;

    % Now remove the redundant last node
    node(last,:) = []; 
    %and decrement i 
    i=i-1; %not necessary, but keeps order as intended
end

end %function