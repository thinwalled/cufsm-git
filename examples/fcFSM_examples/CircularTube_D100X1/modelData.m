function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)

%Material Properties
E=210000;
PoissonRto=0.3;
prop=[100 E E PoissonRto PoissonRto E/2/(1+PoissonRto)];
%
%going to generate the geometry of a circular cylindrical tube with a diameter of 100 and a thickness of 1
%there will be 32 nodes evenly distributed in the circular wall
%then 32 strips (straight in cross-section mid-line) connect these nodes one by one
radius=50;%diameter of this circular cylindrical tube is 100
nElement=32;
nNodes=nElement;
thickness=1;
%Nodes
cenAng=2*pi*(0:(nNodes-1))'/nNodes;
node=[(1:nNodes)',radius*cos(cenAng),radius*sin(cenAng),ones(nNodes,5)];%axially compressed
%
%Elements
%note this is a clossed cell
elem=[(1:nElement)',(1:nNodes)',[2:nNodes,1]',ones(nElement,1)*thickness,ones(nElement,1)*100];

%-----------------------------------------------------------------
%----------------additional input definitions---------------------
%-----------------------------------------------------------------
lengths=logspace(log10(6),log10(3072),145)';
BC='S-S';
for i=1:length(lengths)
    m_all{i}=[1];
end
springs=0;
constraints=0;
neigs=10;

cornerStrips=[];