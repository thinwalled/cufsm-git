function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)

%Material Properties
E=210000;
PoissonRto=0.3;
prop=[100 E E PoissonRto PoissonRto E/2/(1+PoissonRto)];
%
%Nodes
node=[1	90.00000000	20.00000000	1	1	1	1	1
2	90.00000000	10.00000000	1	1	1	1	1
3	88.66025404	5.00000000	1	1	1	1	1
4	85.00000000	1.33974596	1	1	1	1	1
5	80.00000000	0.00000000	1	1	1	1	1
6	56.66666667	0.00000000	1	1	1	1	1
7	33.33333333	0.00000000	1	1	1	1	1
8	10.00000000	0.00000000	1	1	1	1	1
9	5.00000000	1.33974596	1	1	1	1	1
10	1.33974596	5.00000000	1	1	1	1	1
11	0.00000000	10.00000000	1	1	1	1	1
12	0.00000000	35.71428571	1	1	1	1	1
13	0.00000000	61.42857143	1	1	1	1	1
14	0.00000000	87.14285714	1	1	1	1	1
15	0.00000000	112.85714286	1	1	1	1	1
16	0.00000000	138.57142857	1	1	1	1	1
17	0.00000000	164.28571429	1	1	1	1	1
18	0.00000000	190.00000000	1	1	1	1	1
19	1.33974596	195.00000000	1	1	1	1	1
20	5.00000000	198.66025404	1	1	1	1	1
21	10.00000000	200.00000000	1	1	1	1	1
22	33.33333333	200.00000000	1	1	1	1	1
23	56.66666667	200.00000000	1	1	1	1	1
24	80.00000000	200.00000000	1	1	1	1	1
25	85.00000000	198.66025404	1	1	1	1	1
26	88.66025404	195.00000000	1	1	1	1	1
27	90.00000000	190.00000000	1	1	1	1	1
28	90.00000000	180.00000000	1	1	1	1	1];


%
%Elements
elem=[1	1	2	2	100
2	2	3	2	100
3	3	4	2	100
4	4	5	2	100
5	5	6	2	100
6	6	7	2	100
7	7	8	2	100
8	8	9	2	100
9	9	10	2	100
10	10	11	2	100
11	11	12	2	100
12	12	13	2	100
13	13	14	2	100
14	14	15	2	100
15	15	16	2	100
16	16	17	2	100
17	17	18	2	100
18	18	19	2	100
19	19	20	2	100
20	20	21	2	100
21	21	22	2	100
22	22	23	2	100
23	23	24	2	100
24	24	25	2	100
25	25	26	2	100
26	26	27	2	100
27	27	28	2	100
];

%-----------------------------------------------------------------
%------------TWEAKING MODEL USING OTHER CUFSM FEATURES------------
%-----------------------------------------------------------------
%first calculate the global properties
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
thetap=thetap*180/pi; %degrees...
Bx=NaN; By=NaN;
%
%second set the refernce stress
fy=1;
%
%third calculate the P and M associated with the reference stress
unsymmetric=0; %i.e. do a restrained bending calculation
[P,Mxx,Mzz,M11,M22]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmetric);
%
%fourth apply just the P to the model
node=stresgen(node,P*1,Mxx*0,Mzz*0,M11*0,M22*0,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmetric);
%

%-----------------------------------------------------------------
%----------------additional input definitions---------------------
%-----------------------------------------------------------------
lengths=logspace(log10(20),log10(10240),145)';
BC='S-S';
for i=1:length(lengths)
    m_all{i}=[1];
end
springs=0;
constraints=0;
neigs=10;

cornerStrips=[2 3 4 8 9 10 18 19 20 24 25 26];%no curved corner