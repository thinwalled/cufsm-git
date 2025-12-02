function [node, elem] = add_corner(node, elem, e1, e2, r, nArc)
%ADD_CORNER Insert a rounded corner (fillet) between two straight elements.
%   [node,elem] = ADD_CORNER(node,elem,e1,e2,r,nArc)
%
%   e1,e2 : element numbers (elem(:,1)) that meet at a common node
%   r     : fillet radius
%   nArc  : number of arc segments (optional, default = 4)
%
%   Geometry follows the same convention as SNAKEY:
%   angle 1 is from i1 -> k, angle 2 is from k -> i2.

    if nargin < 6 || isempty(nArc)
        nArc = 4;
    end

    %% --- locate rows for the two elements
    idx1 = find(elem(:,1) == e1, 1);
    idx2 = find(elem(:,1) == e2, 1);
    if isempty(idx1) || isempty(idx2)
        error('add_corner:badElem','Element numbers not found in elem array.');
    end

    % node indices for each element
    n1i = elem(idx1,2); n1j = elem(idx1,3);
    n2i = elem(idx2,2); n2j = elem(idx2,3);

    % shared corner node k, and the "far" nodes i1, i2
    shared = intersect([n1i n1j],[n2i n2j]);
    if numel(shared) ~= 1
        error('add_corner:noCommonNode',...
              'Elements %d and %d must share exactly one node.',e1,e2);
    end
    k = shared;

    % identify the far nodes on each leg
    if n1i == k, i1 = n1j; else, i1 = n1i; end
    if n2i == k, i2 = n2j; else, i2 = n2i; end

    %% --- coordinates
    P0 = node(k,2:3);   % corner
    P1 = node(i1,2:3);  % far node on leg 1
    P2 = node(i2,2:3);  % far node on leg 2

    v1 = P0 - P1;       % i1 -> k   (incoming)
    v2 = P2 - P0;       % k  -> i2  (outgoing)
    L1 = norm(v1);
    L2 = norm(v2);
    if L1 == 0 || L2 == 0
        error('add_corner:degenerate','Zero-length element encountered.');
    end
    u1 = v1 / L1;       % unit along leg 1 (i1 -> k)
    u2 = v2 / L2;       % unit along leg 2 (k  -> i2)

    % direction angles matching snakey convention
    a1 = atan2(u1(2), u1(1));     % from i1 -> k
    a2 = atan2(u2(2), u2(1));     % from k  -> i2

    % interior turn angle (wrapped to -pi..pi)
    dAng  = wrap_pi(a2 - a1);
    theta = abs(dAng);
    if theta < 1e-6
        error('add_corner:smallAngle','Angle too small to fillet.');
    end
    sgn = sign(dAng);

    % trim distance along each leg: d = r * tan(theta/2)
    d = r * tan(theta/2);
    if d <= 0 || d >= L1 || d >= L2
        error('add_corner:radiusTooBig',...
              'Radius too large for adjacent element lengths.');
    end

    % tangent points on each leg
    %   leg1 follows i1 -> ... -> k, so move back from corner along -u1
    %   leg2 follows k  -> ... -> i2, so move out from corner along +u2
    A = P0 - d*u1;      % on leg 1
    B = P0 + d*u2;      % on leg 2

    %% --- STRESS VALUE TO USE ON THE ARC  -------------------------
    % Take the original corner stress at node k and propagate it.
    s_corner = node(k,8);   % original stress value at the sharp corner
    %----------------------------------------------------------------

    %% --- create arc nodes, using snakey-style chord stepping
    Larc = r * theta;                                % arc length
    le   = 2*r*sin(theta/(2*nArc));                 % chord length
    nOld = size(node,1);
    newNodeID = (nOld+1):(nOld+nArc+1);             % N0..NnArc

    % copy template row for DOF flags etc.
    template = node(1,:);

    arcNodes = zeros(nArc+1, size(node,2));
    X = A;                                           % current point

    for kArc = 1:(nArc+1)
        if kArc == 1
            % first node is exactly A
            XY = A;
        elseif kArc == (nArc+1)
            % last node is exactly B (force closure)
            XY = B;
        else
            % mid nodes: advance by chord in appropriate direction
            ang = a1 + sgn*( (kArc-1-0.5)*theta/nArc );
            X  = X + le*[cos(ang) sin(ang)];
            XY = X;
        end

        arcNodes(kArc,:)    = template;
        arcNodes(kArc,1)    = newNodeID(kArc);
        arcNodes(kArc,2:3)  = XY;
        arcNodes(kArc,8)    = s_corner;
    end

    % append arc nodes
    node = [node; arcNodes];

    %% --- update original leg elements to use new tangent nodes
    % element e1
    if n1j == k      % original orientation i1 -> k
        elem(idx1,2) = i1;
        elem(idx1,3) = newNodeID(1);   % end at A
    else             % original orientation k -> i1
        elem(idx1,2) = newNodeID(1);   % start at A
        elem(idx1,3) = i1;
    end

    % element e2
    if n2i == k      % original orientation k -> i2
        elem(idx2,2) = newNodeID(end); % start at B
        elem(idx2,3) = i2;
    else             % original orientation i2 -> k
        elem(idx2,2) = i2;
        elem(idx2,3) = newNodeID(end); % end at B
    end

    %% --- add arc elements between new arc nodes
    tCorner  = elem(idx1,4);    % thickness from leg 1
    idCorner = elem(idx1,5);    % matID    from leg 1

    nElemOld = size(elem,1);
    newElemID = (nElemOld+1):(nElemOld+nArc);

    templateE = elem(1,:);
    newElems  = zeros(nArc, size(elem,2));

    for kE = 1:nArc
        newElems(kE,:)   = templateE;
        newElems(kE,1)   = newElemID(kE);
        newElems(kE,2)   = newNodeID(kE);
        newElems(kE,3)   = newNodeID(kE+1);
        newElems(kE,4)   = tCorner;
        newElems(kE,5)   = idCorner;
    end

    elem = [elem; newElems];

    %% --- delete old corner node if now unused
    used = any(elem(:,2:3) == k, 2);
    if ~any(used)
        node(k,:) = [];
        % renumber node IDs above k
        for j = 1:size(node,1)
            node(j,1) = j;
        end
        % fix references in elem
        elem(elem(:,2) > k, 2) = elem(elem(:,2) > k, 2) - 1;
        elem(elem(:,3) > k, 3) = elem(elem(:,3) > k, 3) - 1;
    end
end

function d = wrap_pi(d)
%WRAP_PI  Wrap angle to (-pi,pi]
    d = mod(d + pi, 2*pi) - pi;
end