function elemcorner = elemcornergen(node,elem)
% BWS, June 20, 2026 - with AI assistance for v1
% generate the element corner points for extreme fiber stress calculations
% for plotting etc. Assumes thickness is constant in element (true as of
% this writing).
%
% ELEMCORNERGEN Generate physical x-z corner coordinates for each element
%
% Four rows per element.
%
% elemcorner columns:
% 1 = element number
% 2 = corner number
% 3 = parent node number
% 4 = side, +1 or -1
% 5 = x coordinate of a corner point
% 6 = z coordinate of a corner point
%
% corner order follows crossect.m patch convention:
% 1 = i+
% 2 = j+
% 3 = j-
% 4 = i-

ne = size(elem,1);
elemcorner = zeros(4*ne,6);

row = 0;

for i = 1:ne
    elemnum = elem(i,1);
    nodei = elem(i,2);
    nodej = elem(i,3);
    t = elem(i,4);

    xi = node(node(:,1)==nodei,2);
    zi = node(node(:,1)==nodei,3);
    xj = node(node(:,1)==nodej,2);
    zj = node(node(:,1)==nodej,3);

    theta = atan2((zj-zi),(xj-xi));

    xplus_shift  = -sin(theta)*t/2;
    zplus_shift  =  cos(theta)*t/2;
    xminus_shift =  sin(theta)*t/2;
    zminus_shift = -cos(theta)*t/2;

    corners = [
        elemnum 1 nodei  1 xi+xplus_shift  zi+zplus_shift
        elemnum 2 nodej  1 xj+xplus_shift  zj+zplus_shift
        elemnum 3 nodej -1 xj+xminus_shift zj+zminus_shift
        elemnum 4 nodei -1 xi+xminus_shift zi+zminus_shift
    ];

    elemcorner(row+1:row+4,:) = corners;
    row = row + 4;
end