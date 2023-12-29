function [nmno,ncno,nsno]=node_class(node_prop)
%
%this routine determines how many nodes of the various types exist 
% 
%input/output data
%   node_prop - array of [original node nr, new node nr, nr of adj elems, node type]
%   nmno,ncno,nsno - number of main nodes, corner nodes and sub-nodes, respectively
%   
%notes:
%   node types in node_prop: 1-corner, 2-edge, 3-sub
%   sub-node numbers are the original one, of course
%   
% S. Adany, Feb 09, 2004
%
%
%to count corner-, edge- and sub-nodes
nno=length(node_prop(:,1));
ncno=0;
neno=0;
nsno=0;
for i=1:nno
    if node_prop(i,4)==1
        ncno=ncno+1;
    end
    if node_prop(i,4)==2
        neno=neno+1;
    end
    if node_prop(i,4)==3
        nsno=nsno+1;
    end
end
nmno=ncno+neno; %nr of main nodes
%
