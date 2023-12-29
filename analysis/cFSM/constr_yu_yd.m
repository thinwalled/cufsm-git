function [Rud]=constr_yu_yd(m_node,m_elem)
%
%this routine creates the constraint matrix, Rud, that defines relationship 
% between y displ DOFs of undefinite main nodes
% and the y displ DOFs of definite main nodes
% (definite main nodes = those main nodes which unambigously defines the y displ. pattern
%  undefinite main node = those nodes the y DOF of which can be calculated from the y DOF of definite main nodes
%  note: for open sections with one single branch only there are no undefinite nodes)
%
%important assumption: cross section is opened!
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
% S. Adany, Mar 10, 2004
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
%to register definite and undefinite nodes
node_reg=zeros(nmno,1)+1;
for i=1:nmno
    if m_node(i,5)>2
        %
        %to select two non-parallel meta-elements (elem1, elem2)
        elem1=m_node(i,6);
        j=7;
        while sin(m_el_dat(abs(m_node(i,j)),3)-m_el_dat(abs(elem1),3))==0
            j=j+1;
        end
        elem2=m_node(i,j);
        %
        %to set far nodes of adjacent unselected elements to undefinite (node_reg==0)
        for j=2:m_node(i,5)
            elem3=abs(m_node(i,(j+5)));
            if elem3~=abs(elem2)
                if m_elem(elem3,2)~=i
                    node_reg(m_elem(elem3,2))=0;
                else
                    node_reg(m_elem(elem3,3))=0;
                end
            end
        end
    end
end
%
%to create Rud matrix
Rud=zeros(nmno);
%
%for definite nodes
for i=1:nmno
    if node_reg(i)==1
        Rud(i,i)=1;
    end
end
%
%for undefinite nodes
for i=1:nmno
    if m_node(i,5)>2
        %to select the two meta-elements that play (elem1, elem2)
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
        %to calculate data necessary for Rud 
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
        r=[r1 -r1   0
            0  r2 -r2];
        cs=[ sin2  -sin1
            -cos2   cos1];
        csr=cs*r/det;
        %
        for j=2:m_node(i,5)
            elem3=m_node(i,(j+5));
            if abs(elem3)~=abs(elem2)
                if m_elem(abs(elem3),2)~=i
                    mnode4=m_elem(abs(elem3),2);
                else
                    mnode4=m_elem(abs(elem3),3);
                end
                r3=m_el_dat(abs(elem3),2);
                alfa3=m_el_dat(abs(elem3),3);
                sin3=m_el_dat(abs(elem3),4);
                cos3=m_el_dat(abs(elem3),5);
                if elem3<0 
                    alfa3=alfa3-pi;
                    sin3=-sin3;
                    cos3=-cos3;
                end
                rud=-1/r3*[cos3 sin3]*csr;
                rud(1,2)=rud(1,2)+1;
                Rud(mnode4,mnode1)=rud(1,1);
                Rud(mnode4,mnode2)=rud(1,2);
                Rud(mnode4,mnode3)=rud(1,3);
            end
        end
    end
end
%
%to completely eliminate undefinite nodes from Rud (if necessary)
k=1;
while k==1
    k=0;
    for i=1:nmno
        if node_reg(i)==0
            if ~isempty(find(Rud(:,i)))
                k=1;
                ind=[];
                ind=find(Rud(:,i));
                for j=1:length(ind)
                    Rud(ind(j),:)=Rud(ind(j),:)+Rud(i,:)*Rud(ind(j),i);
                    Rud(ind(j),i)=0;
                end
            end
        end
    end
end
    
