function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)

%Material Properties
E=210000;
PoissonRto=0.3;
prop=[100 E E PoissonRto PoissonRto E/2/(1+PoissonRto)];
%
%Nodes
node=[1	80	15	1	1	1	1	1
	2	80	0	1	1	1	1	1
	3	60	0	1	1	1	1	1
	4	40	0	1	1	1	1	1
	5	20	0	1	1	1	1	1
	6	0	0	1	1	1	1	1
	7	0	20	1	1	1	1	1
	8	0	40	1	1	1	1	1
	9	0	60	1	1	1	1	1
	10	0	80	1	1	1	1	1
	11	0	100	1	1	1	1	1
	12	0	120	1	1	1	1	1
	13	20	120	1	1	1	1	1
	14	40	120	1	1	1	1	1
	15	60	120	1	1	1	1	1
	16	80	120	1	1	1	1	1
	17	80	105	1	1	1	1	1];


%
%Elements
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
	16	16	17	1	100];

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

cornerStrips=[];%no curved corner