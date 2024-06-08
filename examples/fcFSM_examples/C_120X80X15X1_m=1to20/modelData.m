function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)
%This model is the same to 'C_120X80X15X1' model except that multiple longitudinal terms are considered: 1,2,3,...,20.

%So, we will read in the data from 'C_120X80X15X1' model, then set m as 1:20.

inhertModelName='C_120X80X15X1';
curPath=pwd;
cd([pathCUFSM,'/examples/fcFSM_examples/',inhertModelName]);
[prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData();
cd(curPath);

for i=1:length(lengths)
    m_all{i}=1:20;
end