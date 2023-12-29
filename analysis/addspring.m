function [K]=addspring(K,springs,nnodes,a,BC,m_a)
%BWS
%August 2000

%[K]=addspring(K,springs,nnodes,a,m_a,BC)
%Add spring stiffness to global elastic stiffness matrix
%
%K is the complete elastic stiffness matrix
%springs is the definiton of any external springs added to the member
%springs=[node# DOF(x=1,z=2,y=3,theta=4) ks]

% modified by Z. Li, Aug. 09, 2009 for general B.C.
% Z. Li, June 2010

if springs==0|isempty(springs)
    %nothing to calculate
else
    totalm = length(m_a); %Total number of longitudinal terms m

    for i=1:size(springs,1)
        node=springs(i,1);
        dof=springs(i,2);
        k=springs(i,3);
        kflag=springs(i,4);

        if dof==1
            rc=2*node-1;
        elseif dof==2
            rc=2*nnodes+2*node-1;
        elseif dof==3
            rc=2*node;
        elseif dof==4
            rc=2*nnodes+2*node;
        else
            rc=1;
            ks=0;
        end
        for kk=1:1:totalm
            for nn=1:1:totalm
                if kflag==0
                    ks=k; %k is the total stiffness and may be added directly
                else
                    if dof==3
                        ks=0; %axial dof with a foundation stiffness has no net stiffness
                    else
                        [I1,I2,I3,I4,I5] = BC_I1_5(BC,m_a(kk),m_a(nn),a);
                        ks=k*I1; %k is a foundation stiffness and an equivalent total stiffness must be calculated
                    end
                end

                K(4*nnodes*(kk-1)+rc,4*nnodes*(nn-1)+rc)=K(4*nnodes*(kk-1)+rc,4*nnodes*(nn-1)+rc)+ks;
            end
        end
    end
end