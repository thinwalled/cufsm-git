function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)
%This model is the same to 'C_120X80X15X1' model except that
%(i) multiple longitudinal terms are considered: 1,2,3,4,5,
%(ii) the zdof of Node #5 is fixed, and
%(iii) the Ux of Node #7 is equal to the Uz of Node #15 (u7 = w15) 

%So, we will read in the data from 'C_120X80X15X1' model, then set m as 1:5, 
%and then the internal boundary conditions (on the nodes) and user defined constraints (equation constraints).

inhertModelName='C_120X80X15X1';
curPath=pwd;
cd([pathCUFSM,'/examples/fcFSM_examples/',inhertModelName]);
[prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData();
cd(curPath);

for i=1:length(lengths)
    m_all{i}=1:5;
end

node(5,5)=0; %UZ dof constraint at Node #5

constraints = [7 1 1.000 15 2 0.000 0 0]; %u7 = w15