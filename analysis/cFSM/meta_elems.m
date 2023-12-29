function [m_node,m_elem,node_prop]=meta_elems(node,elem)

%this routine re-organises the basic input data 
%  to eliminate internal subdividing nodes
%  to form meta-elements (corner-to-corner or corner-to-free edge)
%  to identify main nodes (corner nodes and free edge nodes)
%
%important assumption: cross section is opened!
%
%input/output data
%   node, elem - same as elsewhere throughout this program
%   m_node <main nodes> - array of [nr, x, z, orig node nr, nr of adj meta-elems, m-el-1, m-el-2, ...]
%   m_elem <meta-elements> - array of [nr, main-node-1, main-node-2, nr of sub-nodes, sub-no-1, sub-nod-2, ...]
%   node_prop - array of [original node nr, new node nr, nr of adj elems, node type]
%   
%note:
%   m-el-? is positive if the starting node of m-el-? coincides with
%      the given m-node, otherwise negative
%   node types: 1-corner, 2-edge, 3-sub
%   sub-node numbers are the original ones, of course
%
% S. Adany, Feb 06, 2004
%
nnode=length(node(:,1));
nelem=length(elem(:,1));
%
%to count nr of elements connecting to each node
% + register internal nodes to be eliminated
% + set node type (node_prop(:,4))
node_prop(1:nnode,1)=[1:nnode]';
for i=1:nnode
    mel=0;
    els=[];
    for j=1:nelem
        if (elem(j,2)==i) | (elem(j,3)==i)
            mel=mel+1;
            els(mel)=j; %zli: element no. containing this node
        end
    end
    node_prop(i,3)=mel;
    if mel==1
        node_prop(i,4)=2;
    end
    if mel>=2
        node_prop(i,4)=1;
    end
    if mel==2
        n1=i;
        n2=elem(els(1),2);%zli: the first node of the first elem containing this node
        if n2==n1 
            n2=elem(els(1),3);
        end
        n3=elem(els(2),2);
        if n3==n1 
            n3=elem(els(2),3);
        end
        a1 = atan2((node(n2,3)-node(n1,3)),(node(n2,2)-node(n1,2)));%?
        a2 = atan2((node(n1,3)-node(n3,3)),(node(n1,2)-node(n3,2)));
        if abs(a1-a2)<0.0000001 
            node_prop(i,3)=0;
            node_prop(i,4)=3;
        end
    end
end
%
%to create meta-elements (with the original node numbers)
m_el=[];
m_el(:,1:3)=elem(:,1:3);
m_el(:,4)=zeros(nelem,1);
for i=1:nnode
    if node_prop(i,3)==0
        k=0;
        for j=1:nelem
            if (m_el(j,2)==i) | (m_el(j,3)==i)
                k=k+1;
                els(k)=j;
            end
        end
        no1=m_el(els(1),2);
        if no1==i
            no1=m_el(els(1),3);
        end
        no2=m_el(els(2),2);
        if no2==i
            no2=m_el(els(2),3);
        end
        m_el(els(1),2)=no1;
        m_el(els(1),3)=no2;
        m_el(els(2),2)=0;
        m_el(els(2),3)=0;
        m_el(els(1),4)=m_el(els(1),4)+1;%zli:
        m_el(els(1),(4+m_el(els(1),4)))=i;%zli:deleted elem no.
    end
end
%
%to eliminate disappearing elements (node numbers are still the original ones!)
nmel=0; %nr of meta-elems
m_elem=[];
for i=1:nelem
    if (m_el(i,2)~=0) & (m_el(i,3)~=0)
        nmel=nmel+1;
        m_elem(nmel,:)=m_el(i,:);
        m_elem(nmel,1)=nmel;%
    end
end
%
%to create array of main-nodes 
%(first and fourth columns assign the new vs. original numbering, 
% + node_assign tells the original vs. new numbering)
%
nmno=0; %nr of main nodes
m_node=[];
for i=1:nnode
    if node_prop(i,3)~=0
        nmno=nmno+1;
        m_node(nmno,1)=nmno;
        m_node(nmno,2:3)=node(i,2:3);
        m_node(nmno,4)=i;
        m_node(nmno,5)=node_prop(i,3);
        node_prop(i,2)=nmno;
    end
end
%
%to re-number nodes in the array m_elem (only for main nodes, of course)
for i=1:nnode
    if node_prop(i,3)~=0
        for j=1:nmel
            if m_elem(j,2)==i
                m_elem(j,2)=node_prop(i,2);
            end
            if m_elem(j,3)==i
                m_elem(j,3)=node_prop(i,2);
            end
        end
    end
end
%
%to assign meta-elems to main-nodes
for i=1:nmno
    k=5;
    for j=1:nmel
        if m_elem(j,2)==i
            k=k+1;
            m_node(i,k)=j;
        end
        if m_elem(j,3)==i
            k=k+1;
            m_node(i,k)=-j;
        end
    end
end
%
%to finish node_assign with the new numbers of subdividing nodes
nsno=0; %nr of subdividing nodes
for i=1:nnode
    if node_prop(i,3)==0
       nsno=nsno+1;
       node_prop(i,2)=nmno+nsno;
   end
end
%

