function [GDLO_DirectSum,GDLO_WeightedFactor]=mode_class2(b_v,displ,ngm,ndm,nlm,hwn,ndof_m)
%
%to determine mode contribution in the current displacement
%
%input data
%   b_v - base vectors (each column corresponds to a certain mode)
%           columns 1..ngm: global modes
%           columns (ngm+1)..(ngm+ndm): dist. modes
%           columns (ngm+ndm+1)..(ngm+ndm+nlm): local modes
%           columns (ngm+ndm+nlm+1)..ndof: other modes
%   displ - vector of nodal displacements
%   ngm,ndm,nlm - number of global, distortional and local buckling modes, respectively
%
%output data
%   cl_gdlo - array with the contributions of the modes in percentage
%               elem1: global, elem2: dist, elem3: local, elem4: other
%
% S. Adany, Mar 10, 2004
%
%
%     b_v_m=b_v((ndof_m*(ml-1)+1):ndof_m*ml,(ndof_m*(ml-1)+1):ndof_m*ml);
%     ndof=length(b_v_m(:,1));
%
%indices
dofindex(1,1)=1;
dofindex(1,2)=ngm;
dofindex(2,1)=ngm+1;
dofindex(2,2)=ngm+ndm;
dofindex(3,1)=ngm+ndm+1;
dofindex(3,2)=ngm+ndm+nlm;
dofindex(4,1)=ngm+ndm+nlm+1;
dofindex(4,2)=ndof_m;
%

%classification
clas=b_v\displ;
clas=abs(clas);
totalm = length(hwn); %number of longitudinal terms m
for i=1:4
    for j=1:totalm
        cl_gdlo(i,j)=sum(clas((j-1)*ndof_m+dofindex(i,1):(j-1)*ndof_m+dofindex(i,2)));
    end
    clas_gdlo(i)=sum(cl_gdlo(i,:));
end
GDLO_DirectSum=clas_gdlo/sum(clas)*100;
GDLO_WeightedFactor=0;