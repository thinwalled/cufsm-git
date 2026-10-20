function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)
%This model is the same to the model 'C_120X80X15X1' except that the zdof of Node #5 and the xdof of Node #10 are fixed.

%So, we will read in the data from 'C_120X80X15X1' model, then fix the two DOFs.

inhertModelName='C_120X80X15X1';
curPath=pwd;
cd([pathCUFSM,'/examples/fcFSM_examples/',inhertModelName]);
[prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData();
cd(curPath);

node(5,5)=0; %UZ dof constraint at Node #5
node(10,4)=0; %UX dof constraint at Node #10
