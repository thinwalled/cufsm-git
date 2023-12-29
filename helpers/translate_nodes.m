function [node_out]=translate_nodes(move_me,this_much,node)
%
%Function to translate nodes a fixed amount
%14 August 2003, BWS
%
%node=[node# x z dofx dofz dofy doftheta stress]
%elem=[elem# nodei nodej thickness mat#]
%divide_me=element to be divided
%at_location=number between 0 and 1 along the length
%
%error checking
if min(move_me)>0
else
    node_out=node;
    return
end

%Translate the nodes
%x change
node(move_me',2)=node(move_me',2)+this_much(1);
%z change
node(move_me',3)=node(move_me',3)+this_much(2);
%write the result
node_out=node;

