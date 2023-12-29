function [nodeo,elemo]=dup_model(mz,mx,x,z,q,node,elem);
%
%Function to duplicate the entire model
%26 October 2015
%
%node=[node# x z dofx dofz dofy doftheta stress]
%elem=[elem# nodei nodej t mat#] 
%
%find the max node number in the existing model
maxnode=max(node(:,1));
maxelem=max(elem(:,1));
%
node2=node;
node2(:,1)=node(:,1)+maxnode;
%
elem2=elem;
elem2(:,1)=elem(:,1)+maxelem;
elem2(:,2)=elem(:,2)+maxnode;
elem2(:,3)=elem(:,3)+maxnode;
%
%mirror about z axis
if isnan(mz)
else
    node2(:,2)=-(node2(:,2)-mz);
end
%
%mirror about x axis
if isnan(mx)
else
    node2(:,3)=-(node2(:,3)-mx);
end
%
%translate first
node2(:,2)=node2(:,2)+x;
node2(:,3)=node2(:,3)+z;
%then rotate
R=[cos(q) -sin(q); sin(q) cos(q)];
x=node2(:,2);
z=node2(:,3);
v=[x';z'];
V=R*v;
node2(:,2)=V(1,:)';
node2(:,3)=V(2,:)';
%
nodeo=[node;node2];
elemo=[elem;elem2];

