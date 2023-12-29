function [BCFlag]=constr_BCFlag(node,constraints)
%
% this subroutine is to determine flags for user constraints and internal (at node) B.C.'s

%inputs:
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%constraints:: [node#e dofe coeff node#k dofk] e=dof to be eliminated k=kept dof dofe_node = coeff*dofk_nodek

%Output:
%BCFlag: 1 if there are user constraints or node fixities
       % 0 if there is no user constraints and node fixities
       
% Z. Li, June 2010
    
%Check for boundary conditions on the nodes
nnodes = length(node(:,1));
BCFlag=0;
for i=1:nnodes
    for j=4:7
        if node(i,j)==0
            BCFlag=1;
            return
        end
    end
end
%Check for user defined constraints too
if (isempty(constraints)|constraints==0)&(BCFlag==0)
    BCFlag=0;
else
    BCFlag=1;
end