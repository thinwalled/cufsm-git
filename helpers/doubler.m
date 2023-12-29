function [node_out,elem_out]=doubler(node,elem);
%BWS
%1998 (last modified)
%A function to double the number of elements to help
%out the discretization of the member somewhat.
%
%node=[node# x z dofx dofz dofy doftheta stress]
%elem=[elem# nodei nodej thickness]
%
old_num_elem=length(elem(:,1));
old_num_node=length(node(:,1));
elem_out=zeros(2*old_num_elem,5);
node_out=zeros(old_num_node+old_num_elem,8);
%
%For node_out set all the old numbers to odd numbers and fill in the
%new ones with even numbers.
for i=1:old_num_node
   node_out(2*i-1,:)=[2*node(i,1)-1 node(i,2:8)];
end
%
for i=1:old_num_elem
   elem_out(2*i-1,:)=[2*elem(i,1)-1 2*elem(i,2)-1 2*i elem(i,4) elem(i,5)];
   elem_out(2*i,:)=[2*i 2*i 2*elem(i,3)-1 elem(i,4) elem(i,5)];
   nnumi=elem(i,2);
   nnumj=elem(i,3);
   xcoord=mean([node(nnumi,2),node(nnumj,2)]);
   zcoord=mean([node(nnumi,3),node(nnumj,3)]);
   stress=mean([node(nnumi,8),node(nnumj,8)]);
   node_out(2*i,:)=[2*i xcoord zcoord node(nnumi,4:7) stress];
end   
%
%remove 0 node_out entries which occur in multi-cell closed sections
index=find(node_out(:,1)==0); %finds rows that lead with a zero node number
node_out(index,:)=[]; %deletes those rows

