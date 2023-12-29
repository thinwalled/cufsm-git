function [Rx,Rz]=constr_xz_y(m_node,m_elem)
%
%this routine creates the constraint matrix, Rxz, that defines relationship 
% between x,z displ DOFs [for internal main nodes, referred also as corner nodes] 
% and the longitudinal y displ DOFs [for all the main nodes]
% if GBT-like assumptions are used
%
%to make this routine length-independent, Rxz is not multiplied here by
% (1/km), thus it has to be multiplied outside of this routine!
%
%additional assumption: cross section is opened!
%
%
%input/output data
%   m_node [main nodes] - array of [nr, x, z, orig node nr, nr of adj meta-elems, m-el-1, m-el-2, ...]
%   m_elem [meta-elements] - array of [nr, main-node-1, main-node-2, nr of sub-nodes, sub-no-1, sub-nod-2, ...]
%   
%   note:
%   m-el-? is positive if the starting node of m-el-? coincides with
%   the given m-node, otherwise negative
%
% S. Adany, Feb 05, 2004
%
%
%to calculate some data of main elements (stored in m_el_dat)
for i=1:length(m_elem(:,1))
    node1 = m_elem(i,2);
    node2 = m_elem(i,3);
    x1 = m_node(node1,2);	   
    x2 = m_node(node2,2);
	z1 = m_node(node1,3);	   
    z2 = m_node(node2,3);
    bi = sqrt((x2-x1)^2+(z2-z1)^2);
    ai = atan2(z2-z1,x2-x1);
    si = (z2-z1)/bi;
    ci = (x2-x1)/bi;
    m_el_dat(i,1) = bi; %elem width, b
    m_el_dat(i,2)= 1/m_el_dat(i,1); %1/b
    m_el_dat(i,3) = ai; %elem inclination
    m_el_dat(i,4) = si; %sin
    m_el_dat(i,5) = ci; %cos
%     m_el_dat(i,6) = si/bi; %sin/b
%     m_el_dat(i,7) = ci/bi; %cos/b
end    
%
%
%to count the number of corner nodes, and of main nodes
nmno=length(m_node(:,1));
ncno=0;
for i=1:length(m_node(:,1))
    if m_node(i,5)>1 
        ncno=ncno+1;
    end
end
%
Rx=zeros(ncno,nmno);
Rz=zeros(ncno,nmno);
k=0;
for i=1:nmno
    if m_node(i,5)>1
        %
        %to select two non-parallel meta-elements (elem1, elem2)
        k=k+1;
        elem1=m_node(i,6);
        j=7;
        while sin(m_el_dat(abs(m_node(i,j)),3)-m_el_dat(abs(elem1),3))==0
            j=j+1;
        end
        elem2=m_node(i,j);
        %
        %to define main-nodes that play (order: mnode1, mnode2, mnode3)
        mnode2=i;
        if elem1>0
            mnode1=m_elem(elem1,3);
        else
            mnode1=m_elem(-elem1,2);
        end
        if elem2>0
            mnode3=m_elem(elem2,3);
        else
            mnode3=m_elem(-elem2,2);
        end
        %
        %to calculate elements of Rxz matrix
        r1=m_el_dat(abs(elem1),2);
        alfa1=m_el_dat(abs(elem1),3);
        sin1=m_el_dat(abs(elem1),4);
        cos1=m_el_dat(abs(elem1),5);
        if elem1>0 
            alfa1=alfa1-pi;
            sin1=-sin1;
            cos1=-cos1;
        end
        r2=m_el_dat(abs(elem2),2);
        alfa2=m_el_dat(abs(elem2),3);
        sin2=m_el_dat(abs(elem2),4);
        cos2=m_el_dat(abs(elem2),5);
        if elem2<0 
            alfa2=alfa2-pi;
            sin2=-sin2;
            cos2=-cos2;
        end
        det=sin(alfa2-alfa1);
	    %    
        %to form Rxz matrix
        Rx(k,mnode1) = sin2*r1/det;
        Rx(k,mnode2) = (-sin1*r2-sin2*r1)/det;
        Rx(k,mnode3) = sin1*r2/det;
	    %    
        Rz(k,mnode1) = -cos2*r1/det;
        Rz(k,mnode2) = (cos1*r2+cos2*r1)/det;
        Rz(k,mnode3) = -cos1*r2/det;
    end
end
%
