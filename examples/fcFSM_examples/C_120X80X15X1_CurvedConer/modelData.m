function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)
%This model is the same to 'C_120X80X15X1' model except that the longitudinal term is 3,

%So, we will read in the data from 'C_120X80X15X1' model, then set m to 3.

inhertModelName='C_120X80X15X1';
curPath=pwd;
cd([pathCUFSM,'/examples/fcFSM_examples/',inhertModelName]);
[prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData();
cd(curPath);

node=[1	80					15					1	1	1	1	1
	2	80					10					1	1	1	1	1
	3	78.6602540378443	5					1	1	1	1	1
	4	75					1.33974596215561	1	1	1	1	1
	5	70					0					1	1	1	1	1
	6	50					0					1	1	1	1	1
	7	30					0					1	1	1	1	1
	8	10					0					1	1	1	1	1
	9	5					1.33974596215561	1	1	1	1	1
	10	1.33974596215561	5					1	1	1	1	1
	11	0					10					1	1	1	1	1
	12	0					30					1	1	1	1	1
	13	0					50					1	1	1	1	1
	14	0					70					1	1	1	1	1
	15	0					90					1	1	1	1	1
	16	0					110					1	1	1	1	1
	17	1.33974596215561	115					1	1	1	1	1
	18	5					118.660254037844	1	1	1	1	1
	19	10					120					1	1	1	1	1
	20	30					120					1	1	1	1	1
	21	50					120					1	1	1	1	1
	22	70					120					1	1	1	1	1
	23	75					118.660254037844	1	1	1	1	1
	24	78.6602540378443	115					1	1	1	1	1
	25	80					110					1	1	1	1	1
	26	80					105					1	1	1	1	1];

elem=[1	1	2	1	100
	2	2	3	1	100
	3	3	4	1	100
	4	4	5	1	100
	5	5	6	1	100
	6	6	7	1	100
	7	7	8	1	100
	8	8	9	1	100
	9	9	10	1	100
	10	10	11	1	100
	11	11	12	1	100
	12	12	13	1	100
	13	13	14	1	100
	14	14	15	1	100
	15	15	16	1	100
	16	16	17	1	100
	17	17	18	1	100
	18	18	19	1	100
	19	19	20	1	100
	20	20	21	1	100
	21	21	22	1	100
	22	22	23	1	100
	23	23	24	1	100
	24	24	25	1	100
	25	25	26	1	100];

cornerStrips=[2 3 4 8 9 10 16 17 18 22 23 24];