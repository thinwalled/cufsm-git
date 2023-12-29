function [Ruser]=constr_user(node,cnstr,m_a)
%
%this routine creates the constraint matrix, Ruser, as defined by the user
%
%
%input/output data
%   node - same as elsewhere throughout this program
%   cnstr - same as 'constraints' throughout this program
%   m_a - longitudinal terms to be included for this length

%   Ruser - the constraint matrix (in other words: base vectors) so that
%               displ_orig = Ruser * displ_new

% S. Adany, Feb 26, 2004
% Z. Li, Aug 18, 2009 for general b.c.
% Z. Li, June 2010

nnode=length(node(:,1));
ndof_m=4*nnode;
DOFreg=zeros(ndof_m,1)+1;
totalm = length(m_a); %Total number of longitudinal terms m
% Ruser=eye(ndof_m*totalm);
for ml=1:totalm
    %
    Ruser_m=eye(ndof_m);
    %to consider free DOFs
    for i=1:nnode
        for j=4:7
            if node(i,j)==0
                if j==4
                    dofe=(i-1)*2+1;
                end
                if j==6
                    dofe=i*2;
                end
                if j==5
                    dofe=nnode*2+(i-1)*2+1;
                end
                if j==7
                    dofe=nnode*2+i*2;
                end
                DOFreg(dofe,1)=0;
            end
        end
    end
    %
    %to consider master-slave constraints
    for i=1:length(cnstr(:,1))
        if length(cnstr(i,:))>=5
            %
            %nr of eliminated DOF
            nodee=cnstr(i,1);
            if cnstr(i,2)==1
                dofe=(nodee-1)*2+1;
            end
            if cnstr(i,2)==3
                dofe=nodee*2;
            end
            if cnstr(i,2)==2
                dofe=nnode*2+(nodee-1)*2+1;
            end
            if cnstr(i,2)==4
                dofe=nnode*2+nodee*2;
            end
            %
            %nr of kept DOF
            nodek=cnstr(i,4);
            if cnstr(i,5)==1
                dofk=(nodek-1)*2+1;
            end
            if cnstr(i,5)==3
                dofk=nodek*2;
            end
            if cnstr(i,5)==2
                dofk=nnode*2+(nodek-1)*2+1;
            end
            if cnstr(i,5)==4
                dofk=nnode*2+nodek*2;
            end
            %
            %to modify Ruser
            Ruser_m(:,dofk)=Ruser_m(:,dofk)+cnstr(i,3)*Ruser_m(:,dofe);
            DOFreg(dofe,1)=0;
        end
    end
    %
    %to eliminate columns from Ruser
    k=0;
    for i=1:ndof_m
        if DOFreg(i,1)==1
            k=k+1;
            Ru(:,k)=Ruser_m(:,i);
        end
    end
    Ruser_m=[];
    Ruser_m=Ru(:,1:k);
    Ruser((ml-1)*ndof_m+1:ml*ndof_m,(ml-1)*k+1:ml*k)=Ruser_m;
end