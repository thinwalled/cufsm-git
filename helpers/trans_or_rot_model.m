function [node_out]=trans_or_rot_model(x,z,q,node)
%
%Function to translate or rotate entire model
%26 October 2015
%
%node=[node# x z dofx dofz dofy doftheta stress]
%
%translate first
node(:,2)=node(:,2)+x;
node(:,3)=node(:,3)+z;
%then rotate
R=[cos(q) -sin(q); sin(q) cos(q)];
x=node(:,2);
z=node(:,3);
v=[x';z'];
V=R*v;
node(:,2)=V(1,:)';
node(:,3)=V(2,:)';
%
%save new nodes
node_out=node;

