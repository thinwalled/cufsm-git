function [constraints]=master_slave(master,slave,node,elem)
%master = master node
%slave = slave node(s)
%node = nodal matrix, defined elsewhere
%elem = element connectivity matrix defined elsewhere
%
%MASTER-SLAVE CONSTRAINT EQUATIONS
%for each slave, if the master undergoes rotation, q, determine the constraint condition
for i=1:length(slave)
    dz=node(slave(i),3)-node(master,3); %z distance between master and slave
    dx=node(slave(i),2)-node(master,2); %x distance between master and slave
    r=sqrt(dx^2 + dz^2); %radial distance between master and slave
    theta=atan2(dz,dx); %angle between master and slave
    %if q is the rotation of the master then we need to write constraint conditions
    %for the change in x and z due to master rotation q (dof 4)
    uq=-r*sin(theta); %u = uq*q
    wq=r*cos(theta); %note these are small angle approximations, to have linear constraint equations
    %we also need to consider translation of the master node
    %we may read the below as
    %slave node i, u disp (dof 1) = uq*master_rotation(dof 4) + 1.0*master_u(dof 1)
    constraints1(i,:)=[slave(i) 1 uq  master 4 1.0 master 1];
    %z displacements
    constraints2(i,:)=[slave(i) 2 wq  master 4 1.0 master 2];
    %rotations
    constraints3(i,:)=[slave(i) 4 1.0 master 4 0  0       0];
end
constraints(:,:)=[constraints1; constraints2; constraints3];
