function [node_out,elem_out]=combine_one(lost_node,node,elem)
%
%Function to combine 2 elements into 1 element
%3 December 2002, BWS
%
%node=[node# x z dofx dofz dofy doftheta stress]
%elem=[elem# nodei nodej thickness mat#]
%lost_node=node to be eliminated
%
%error checking
%must be two and only two elements which call this node
if sum([elem(:,2)==lost_node ; elem(:,3)==lost_node])==2
    %ok we can continue
else
    node_out=node;
    elem_out=elem;
    return
end
%
%  i1--------j1i2----------j2   --> i1-----------------j2 
%Find element 1 which calls the lost node at its jth end
elem1_row=find(elem(:,3)==lost_node);
%Find element 2 which calls the lost node at its ith end
elem2_row=find(elem(:,2)==lost_node);
%Change element 1 into its new element by changing its jth node
elem(elem1_row,3)=elem(elem2_row,3);
%Remove the offending row
elem(elem2_row,:)=[];
%Remove the offending node
node(find(node(:,1)==lost_node),:)=[];
%Call the function renumbernodes to clean things up
[node,elem]=renumbernodes(node,elem);
%
node_out=node;
elem_out=elem;

