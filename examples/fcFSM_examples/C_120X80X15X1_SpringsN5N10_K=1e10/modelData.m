function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)
%This model is the same to 'C_120X80X15X1' model except that there connect two springs with a stiffness of 1e10,
%One spring connects to a flange at Node5, the other to the web at Node 10. Both are perpendicular to the mid-planes of the walls.

%So, we will read in the data from 'C_120X80X15X1' model, then add the two springs.
inhertModelName='C_120X80X15X1';
curPath=pwd;
cd([pathCUFSM,'/examples/fcFSM_examples/',inhertModelName]);
[prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData();
cd(curPath);

springs=[	1    10     0     1e10  0     0     0     0     0     0
			2     5     0     0     0     1e10  0     0     0     0];

