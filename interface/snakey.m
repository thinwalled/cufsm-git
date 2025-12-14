function [node,elem]=snakey(strips)
%Snakey, a function to convert simple l,theta,t etc. into CUFSM node and elem
%BWS and ChatGPT5.1 on 1 Dec 2025

%First conver the straight lines and corner radius into one set of segments
%this means trimming the line segments if corner radius present and the new
%sttucture seg will include line arc line arc.. etc. where the lengths are
%all trimmed to account for the radius, also we need a starting and
%stopping angle for the radii/corners, which we construct from the original
%centerline angles.

%Determine if closed shape if yes we will loop back to first flat later
isClosed = isfield(strips,'closed') && strips.closed;

%Length of arrays 
%number of straight segments
nl = numel(strips.l);   % number of straight centerline segments
% number of corner radii
%nr = numel(strips.r);   % number of corner radii
if ~isfield(strips,'r') || isempty(strips.r)
    nr = 0;          %skip corners!
    strips.r = [];   % ensure field exists for later indexing
else
    nr = numel(strips.r);
end

%Initial new segment arrays that will merge centerline and corner input
seg.l  = []; %length
seg.q1 = []; %angle at start of segment
seg.q2 = []; %angle at end of segmentm only different for corners
seg.n  = []; %number of strips to break the segment into
seg.t  = []; %thickness of the segment
seg.id = []; %material id for the segment

for j = 1:nl

    % ---------- FLAT j ----------
    Lflat = strips.l(j);
    qFlat = strips.q(j);
    nFlat = strips.n(j);
    tFlat = strips.t(j);
    idFlat = strips.id(j);

    % Left corner contribution (between flat j-1 and j)
    rLeft  = 0;
    dthetaLeft = 0;
    if j > 1 && nr >= j-1
        % open (or closed) shape, internal corner index j-1
        rLeft      = strips.r(j-1);
        dthetaLeft = strips.q(j) - strips.q(j-1);
        dthetaLeft = wrap_pi(dthetaLeft);
    elseif isClosed && nr == nl && j == 1
        % closed shape: last radius connects flat mFlats to flat 1
        rLeft      = strips.r(end);
        dthetaLeft = strips.q(1) - strips.q(end);
        dthetaLeft = wrap_pi(dthetaLeft);
    end

    % Right corner contribution (between flat j and j+1)
    rRight  = 0;
    dthetaRight = 0;
    if j < nl && nr >= j
        % corner between flat j and j+1
        rRight      = strips.r(j);
        dthetaRight = strips.q(j+1) - strips.q(j);
        dthetaRight = wrap_pi(dthetaRight);
    elseif isClosed && nr == nl && j == nl
        % closed shape: last radius connects flat mFlats to flat 1
        rRight      = strips.r(end);
        dthetaRight = strips.q(1) - strips.q(end);
        dthetaRight = wrap_pi(dthetaRight);
    end

    % Trim flat by corner radii (general angle: d = r * tan(|Δθ|/2))
    LflatEff = Lflat;
    if rLeft > 0 && dthetaLeft ~= 0
        dLeft = rLeft * abs(tan(dthetaLeft/2));
        LflatEff = LflatEff - dLeft;
    end
    if rRight > 0 && dthetaRight ~= 0
        dRight = rRight * abs(tan(dthetaRight/2));
        LflatEff = LflatEff - dRight;
    end
    if LflatEff < 0
        LflatEff = 0;
    end

    % Add flat segment (even if LflatEff is 0, we can skip later by n=0 or L=0)
    seg.l(end+1)  = LflatEff;
    seg.q1(end+1) = qFlat;
    seg.q2(end+1) = qFlat;
    seg.n(end+1)  = nFlat;
    seg.t(end+1)  = tFlat;
    seg.id(end+1) = idFlat;

    % ---------- CORNER after flat j ----------
    % open shapes: corners 1..mFlats-1 between j and j+1
    % closed shapes: assume r(end) is between flat mFlats and flat 1
    cornerIdx = 0;
    qIn  = 0;
    qOut = 0;

    if j < nl && nr >= j
        cornerIdx = j;
        qIn  = strips.q(j);
        qOut = strips.q(j+1);
    elseif isClosed && nr == nl && j == nl
        cornerIdx = nl;
        qIn  = strips.q(nl);
        qOut = strips.q(1);
    end

    if cornerIdx > 0
        rCorner = strips.r(cornerIdx);
        nCorner = strips.rn(cornerIdx);
        tCorner = strips.rt(cornerIdx);
        idCorner = strips.rid(cornerIdx);

        if rCorner > 0 && nCorner > 0 && qIn ~= qOut
            dtheta = qOut - qIn;
            dtheta = wrap_pi(dtheta);
            Larc   = rCorner * abs(dtheta);    % arc length = r * |Δθ|
            q2Arc = qIn+dtheta; %wrapped end angle for this dtheta
            seg.l(end+1)  = Larc;
            seg.q1(end+1) = qIn;
            seg.q2(end+1) = q2Arc;
            seg.n(end+1)  = nCorner;
            seg.t(end+1)  = tCorner;
            seg.id(end+1) = idCorner;
        end
    end
end

%now we march through seg and build out node and elem

%Define the starting point for building out the segments
if ~isfield(strips,'origin') || ~isfield(strips.origin,'type')
    % no origin is specified, so use 0,0
    xst = 0;
    yst = 0;
elseif strcmpi(strips.origin.type,'start')
    % origin is specified at the start point
    if isfield(strips.origin,'x')
        xst = strips.origin.x;
    else
        xst = 0;
    end
    if isfield(strips.origin,'z')
        yst = strips.origin.z;
    else
        yst = 0;
    end
else
    % any other type -> build at (0,0); final shift is handled later
    xst = 0;
    yst = 0;
end

i=1; %node counter
node=[];
elem=[];
started = false; %flag for initiating nodes (in case first segment is zero length)

for j=1:length(seg.l)
    n=seg.n(j);
    l=seg.l(j);
    q1=seg.q1(j);
    q2=seg.q2(j);
    dq=(q2-q1)/max(n,1); %angle change over the n times if an arc
    t=seg.t(j);
    id=seg.id(j);
    %incremental segment length
    if q1 == q2 % straight segment: use flat length
        le = l / n;
    else % arc segment: Ls = r * |Δθ|, use chord length
        dtheta = q2 - q1;
        dtheta = wrap_pi(dtheta);
        r      = l / abs(dtheta);                    % recover r
        le     = 2*r*sin(abs(dtheta)/(2*n));         % chord length
    end

    if n==0 || le==0 %then no need to make elements for these skip
        continue
    end

    for k=1:n
        if ~started %very first node
            x1=xst;
            y1=yst;
            node(i,:)=[i x1 y1 1 1 1 1 1.0]; i=i+1;
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

% Loop closure for closed shapes
if isfield(strips,'closed') && strips.closed
    nNodes = size(node,1);
    first  = 1;
    last   = nNodes;

    if nr == 0
        % --- Case 1: no explicit corner radii (e.g. CHS faceted ring)
        % Just merge last node into the first without moving node 1.
        node(last,2:3) = node(first,2:3);

    else
        % --- Case 2: closed shape with corners (e.g. RHS)
        % Keep your existing "average" behaviour to damp numerical drift.
        xm = 0.5*(node(first,2) + node(last,2));
        ym = 0.5*(node(first,3) + node(last,3));
        node(first,2:3) = [xm ym];
    end

    % Redirect any elements that reference "last" to "first"
    elem(elem(:,2) == last, 2) = first;
    elem(elem(:,3) == last, 3) = first;

    % Remove redundant last node
    node(last,:) = [];
    i = i-1;   % (optional, only used if you keep tracking i)
end

%As a matter of preference I prefer the origin to be in the lower left
%corner, so once things are set let's change the origin to that point. if
%the user specificall sets origin to lower left they have the option of
%moving it to specific location as well
if ~isfield(strips,'origin') || ~isfield(strips.origin,'type')
    % Legacy behavior: lower-left at (0,0)
    xo = min(node(:,2));
    zo = min(node(:,3));
    node(:,2) = node(:,2) - xo;
    node(:,3) = node(:,3) - zo;
else
    if strcmpi(strips.origin.type,'lowerleft')
        % shift so that lower-left = (origin.x, origin.z)
        xo = min(node(:,2));
        zo = min(node(:,3));
        x0 = 0; z0 = 0;
        if isfield(strips.origin,'x'), x0 = strips.origin.x; end
        if isfield(strips.origin,'z'), z0 = strips.origin.z; end
        node(:,2) = node(:,2) - xo + x0;
        node(:,3) = node(:,3) - zo + z0;
    elseif strcmpi(strips.origin.type,'start')
        % do nothing here: we already started at the desired origin
        % (make sure you set xst/yst from strips.origin.x/z at the top)
    else
        % Fallback: treat unknown type like legacy lower-left at (0,0)
        xo = min(node(:,2));
        zo = min(node(:,3));
        node(:,2) = node(:,2) - xo;
        node(:,3) = node(:,3) - zo;
    end
end

end %function

function d = wrap_pi(d)
%WRAP_PI  Wrap angle to the range (-pi, pi]
%   Takes any angle in radians and returns an equivalent angle
%   between -pi and pi (pi included, -pi excluded).

d = mod(d + pi, 2*pi) - pi;

end

