function [prop,node,elem,lengths,BC,m_all,springs,constraints,neigs,cornerStrips]=modelData(pathCUFSM)

%-----------------------------------------------------------------
%--------------------BASIC GEOMETRY DEFINITION--------------------
%-----------------------------------------------------------------
%Here we will just use the default section from CUFSM, but you could use
%the template to define a section or anything you like, basically all the
%screens in the CUFSM pre-processor are just variables that need to be
%defined.
%

%Material Properties
prop=[100 29500.00 29500.00 0.30 0.30 11346.15];
%
%Nodes
node=[1 5.00 1.00 1 1 1 1 33.33
    2 5.00 0.00 1 1 1 1 50.00
    3 2.50 0.00 1 1 1 1 50.00
    4 0.00 0.00 1 1 1 1 50.00
    5 0.00 3.00 1 1 1 1 16.67
    6 0.00 6.00 1 1 1 1 -16.67
    7 0.00 9.00 1 1 1 1 -50.00
    8 2.50 9.00 1 1 1 1 -50.00
    9 5.00 9.00 1 1 1 1 -50.00
    10 5.00 8.00 1 1 1 1 -33.33];
%
%Elements
elem=[1 1 2 0.100000 100
    2 2 3 0.100000 100
    3 3 4 0.100000 100
    4 4 5 0.100000 100
    5 5 6 0.100000 100
    6 6 7 0.100000 100
    7 7 8 0.100000 100
    8 8 9 0.100000 100
    9 9 10 0.100000 100];

%-----------------------------------------------------------------
%------------TWEAKING MODEL USING OTHER CUFSM FEATURES------------
%-----------------------------------------------------------------
%Features available in the GUI may also be used in these batch programs,
%for instance the mesh in this default file is rather course, let's double
%the number of elements
% [node,elem]=doubler(node,elem);
%
%In this example the stresses (last column of nodes) are already defined,
%but it is common to use the properties page to define these values instead
%of entering in the nodal stresses. Right now this problem applies a
%reference bending moment, let's apply a reference bending load using
%the subroutines normally used on the properties page of CUFSM
%
%first calculate the global properties
[A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
thetap=thetap*180/pi; %degrees...
Bx=NaN; By=NaN;
%
%second set the refernce stress
fy=50;
%
%third calculate the P and M associated with the reference stress
unsymmetric=0; %i.e. do a restrained bending calculation
[P,Mxx,Mzz,M11,M22]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmetric);
%
%fourth apply just the P to the model
node=stresgen(node,P*0,Mxx*1,Mzz*0,M11*0,M22*0,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmetric);
%

%-----------------------------------------------------------------
%----------------additional input definitions---------------------
%-----------------------------------------------------------------

%Lengths:
%for signiture curve, the length is interpreted as half-wave length the same as older cufsm version (3.x and previous)
%lengths=[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 ];
lengths=logspace(0,3,100)';
% %for general boundary conditions, the length is interpreted as physical member length
% lengths=[92 192];

%Boundary conditions: a string specifying boundary conditions to be analyzed
%'S-S' simply-pimply supported boundary condition at loaded edges
%'C-C' clamped-clamped boundary condition at loaded edges
%'S-C' simply-clamped supported boundary condition at loaded edges
%'C-F' clamped-free supported boundary condition at loaded edges
%'C-G' clamped-guided supported boundary condition at loaded edges
BC='S-S';
%note, the signiture curve soultion is only meaningful when BC is S-S. Be sure to set your BC as S-S when performing signiture curve analysis.

%Longitudinal terms in cell: associated with each length
%for signiture curve: longitudinal term is defaultly 1 for each length
for i=1:length(lengths)
    m_all{i}=[1];
end
%for general boundary conditions
% multiple longitudinal terms are defined
% the longitudinal terms for each length can be different
% for each length, longitudinal terms are not necessarily consecutive as shown here
% (always recommend) the recommended longitudinal terms can be defined by calling:
% [m_all]=m_recommend(prop,node,elem,lengths);
% careful here, you likely want m's around L/Lcre, L/Lcrd, L/Lcrl.. maybe be
% quite high in terms of m, and usually much less terms than brute force..
% for i=1:length(lengths)
%     m_all{i}=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
% end

%In this case we have no springs
%if any, springs should be defined in this format (kflag: 1 or 0):
%springs=[node# dof stiffness kflag
%          ...  ...    ...     ... ];
springs=0;

%In this case we have no constraint
% if any, constraint should be defined in this format:
% constraints=[node#e DOFe coeff. noder#k DOFk
%               ...   ...   ...    ...    ... ];
constraints=0;

%set the eigenmode you want to output, optional
neigs=10; %GUI default is 20

cornerStrips=[];%no curved corners
