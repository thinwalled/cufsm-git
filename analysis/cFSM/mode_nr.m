function [ndm,nlm]=mode_nr(nmno,ncno,nsno,m_node)
%
%this routine determines the number of distortional and local buckling modes 
% if GBT-like assumptions are used
%
%
%input/output data
%   nmno, nsno - number of main nodes and sub_nodes, respectively
%   m_node [main nodes] - array of [nr, x, z, orig node nr, nr of adj meta-elems, m-el-1, m-el-2, ...]
%   ndm,nlm - number of distortional and local buckling modes, respectively
%   
% S. Adany, Feb 09, 2004
%
%
%to count the number of distortional modes
ndm=nmno-4;
for i=1:nmno
    if m_node(i,5)>2
        ndm=ndm-(m_node(i,5)-2);
    end
end
if ndm<0
    ndm=0;
end
%
%to count the number of local modes
neno=nmno-ncno; %nr of edge nodes
nlm=nmno+2*nsno+neno;

