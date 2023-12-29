function [node,elem]=renumbernodes(node,elem)
%BWS
%August 2000 (last modified)
%
%renumber the nodes so that they are 1 to n
%number of nodes
n=size(node,1);
%lookup table
table=[node(:,1) (1:1:n)'];
%renumber nodes
node(:,1)=(1:1:n)';
%number of elements
ne=size(elem,1);
%cleanup element numbers
elem(:,1)=(1:1:ne)';
%use table to correct node numbering in element
for i=1:ne
elem(i,:)=[elem(i,1) table(find(elem(i,2)==table(:,1)),2) table(find(elem(i,3)==table(:,1)),2) elem(i,4) elem(i,5)];
end