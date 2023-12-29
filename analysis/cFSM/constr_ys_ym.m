function [Rys]=constr_ys_ym(node,m_node,m_elem,node_prop)
%
%this routine creates the constraint matrix, Rys, that defines relationship 
% between y DOFs of sub-nodes, 
% and the y displ DOFs of main nodes
% by linear interpolation
%
%
%input/output data
%   node - same as elsewhere throughout this program
%   m_node [main nodes] - array of [nr, x, z, orig node nr, nr of adj meta-elems, m-el-1, m-el-2, ...]
%   m_elem [meta-elements] - array of [nr, main-node-1, main-node-2, nr of sub-nodes, sub-no-1, sub-nod-2, ...]
%   node_prop - array of [original node nr, new node nr, nr of adj elems, node type]
%   
% S. Adany, Feb 06, 2004
%
nsno=0;
for i=1:length(node(:,1))
    if node_prop(i,4)==3
        nsno=nsno+1;
    end
end
nmno=length(m_node(:,1));
%
Rys=zeros(nsno,nmno);
%
for i=1:length(m_elem(:,1))
    if m_elem(i,4)>0
        nod1=m_node(m_elem(i,2),4);
        nod3=m_node(m_elem(i,3),4);
        x1 = node(nod1,2);	   x3 = node(nod3,2);
	    z1 = node(nod1,3);	   z3 = node(nod3,3);
        bm = sqrt((x3-x1)^2+(z3-z1)^2);
        nnew1=node_prop(nod1,2);
        nnew3=node_prop(nod3,2);
        for j=1:m_elem(i,4)
            nod2=m_elem(i,(j+4));
            x2 = node(nod2,2);	   
	        z2 = node(nod2,3);	  
            bs = sqrt((x2-x1)^2+(z2-z1)^2);
            nnew2=node_prop(nod2,2);
            Rys((nnew2-nmno),nnew1)=(bm-bs)/bm;
            Rys((nnew2-nmno),nnew3)=bs/bm;
        end
    end
end
