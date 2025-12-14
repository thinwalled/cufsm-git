function [node, elem] = merge_branch(node, elem, nodeB, elemB, tol)
%MERGE_BRANCH  Merge a secondary branch (nodeB,elemB) into (node,elem)
%   [node,elem] = MERGE_BRANCH(node,elem,nodeB,elemB,tol)
%
%   - node, elem  : existing model
%   - nodeB, elemB: branch to be merged in
%   - tol         : distance tolerance for welding nodes (default 1e-6)
%
%   Assumes:
%     node(:,1)  = node ID
%     node(:,2:3)= x,z coordinates
%     elem(:,1)  = element ID
%     elem(:,2:3)= node i, node j

    if nargin < 5 || isempty(tol)
        tol = 1e-6;
    end

    nOldNodes = size(node,1);
    nOldElems = size(elem,1);

    %--- build map from branch nodeID -> row index in nodeB
    maxIdB = max(nodeB(:,1));
    invB   = zeros(maxIdB,1);
    for r = 1:size(nodeB,1)
        invB(nodeB(r,1)) = r;
    end

    %--- for each node in nodeB, either weld with existing or append
    mapBtoMain = zeros(size(nodeB,1),1);  % row-indexed in nodeB

    for rB = 1:size(nodeB,1)
        xB = nodeB(rB,2);
        zB = nodeB(rB,3);

        % squared distance to all existing nodes
        dx  = node(:,2) - xB;
        dz  = node(:,3) - zB;
        d2  = dx.^2 + dz.^2;
        [dmin, iMin] = min(d2);

        if dmin <= tol^2
            % weld to existing node
            mapBtoMain(rB) = iMin;
        else
            % append a new node
            node = [node; nodeB(rB,:)];
            newId = size(node,1);
            node(end,1) = newId;      % update node ID column
            mapBtoMain(rB) = newId;
        end
    end

    %--- remap elements from branch and append
    newElems = elemB;
    nBranchElems = size(elemB,1);

    for e = 1:nBranchElems
        % original node IDs in elemB
        niB = elemB(e,2);
        njB = elemB(e,3);

        % row indices in nodeB
        riB = invB(niB);
        rjB = invB(njB);

        % mapped main node IDs
        niMain = mapBtoMain(riB);
        njMain = mapBtoMain(rjB);

        newElems(e,2) = niMain;
        newElems(e,3) = njMain;
    end

    % renumber element IDs to follow existing ones
    newElemIDs = (1:nBranchElems)' + nOldElems;
    newElems(:,1) = newElemIDs;

    % append
    elem = [elem; newElems];
end