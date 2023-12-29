function [node_out,elem_out]=divide_one(divide_me,at_location,node,elem)
%
%Function to divide 1 element into 2 elements at a given location
%3 December 2002, BWS
%
%node=[node# x z dofx dofz dofy doftheta stress]
%elem=[elem# nodei nodej thickness mat#]
%divide_me=element to be divided
%at_location=number between 0 and 1 along the length
%
%error checking
if at_location>=1|at_location<=0
    at_location=0.5
end
if max(divide_me==elem(:,1)) %implies there is a match for the divided element
    %ok
else
    node_out=node;
    elem_out=elem;
    return
end

%FIRST THE NODE
%nodes i and k are the nodes of element divide_me
ni=elem(divide_me,2);
nix=node(find(node(:,1)==ni),2);
niz=node(find(node(:,1)==ni),3);
nidof=node(find(node(:,1)==ni),4:7);
nistress=node(find(node(:,1)==ni),8);
nk=elem(divide_me,3);
nkx=node(find(node(:,1)==nk),2);
nkz=node(find(node(:,1)==nk),3);
nkdof=node(find(node(:,1)==nk),4:7);
nkstress=node(find(node(:,1)==nk),8);
%now the new node j
nj=nk; %we will renumber k and all subsequent nodes by +1
njx=nix+at_location*(nkx-nix);
njz=niz+at_location*(nkz-niz);
njdof=nkdof;
njstress=nistress+at_location*(nkstress-nistress);
%for all nodes with numbers greater than or equal to nk add 1
node(find(node(:,1)>=nk),1)=node(find(node(:,1)>=nk),1)+1;
%assign the new node
node(length(node(:,1))+1,:)=[nj njx njz njdof njstress];
%sort
node=sortrows(node,1);
%
%NOW ON TO THE ELEMENT
%for all elements with numbers greater than divide_me add 1
elem(find(elem(:,1)>divide_me),1)=elem(find(elem(:,1)>divide_me),1)+1;
%for all nodes with numbers greater than or equal to nk add 1
elem(find(elem(:,2)>=nk),2)=elem(find(elem(:,2)>=nk),2)+1;
elem(find(elem(:,3)>=nk),3)=elem(find(elem(:,3)>=nk),3)+1;
%cleanup the old element
elem(find(elem(:,1)==divide_me),:)=[divide_me ni nj elem(find(elem(:,1)==divide_me),4:5)];
%add the new element
elem(length(elem(:,1))+1,:)=[divide_me+1 nj nj+1 elem(find(elem(:,1)==divide_me),4:5)];
%sort
elem=sortrows(elem,1);
%
node_out=node;
elem_out=elem;

