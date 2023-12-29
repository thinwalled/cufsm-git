function [b_v_red]=mode_select(b_v,ngm,ndm,nlm,if_g,if_d,if_l,if_o,ndof_m,m_a)
%
%this routine selects the required base vectors  
%   b_v_red forms a reduced space for the calculation, including the
%       selected modes only
%   b_v_red itself is the final constraint matrix for the selected modes
% 
%
%input data
%   b_v - base vectors (each column corresponds to a certain mode)
%           columns 1..ngm: global modes
%           columns (ngm+1)..(ngm+ndm): dist. modes
%           columns (ngm+ndm+1)..(ngm+ndm+nlm): local modes
%           columns (ngm+ndm+nlm+1)..ndof: other modes
%   ngm,ndm,nlm - number of global, distortional and local buckling modes, respectively
%   if_g - indicator which global modes are selected
%   if_d - indicator which dist. modes are selected
%   if_l - indicator whether local modes are selected
%   if_o - indicator whether other modes are selected
%   ndof_m: 4*nnodes, total DOF for a singal longitudinal term

%output data
%   b_v_red - reduced base vectors (each column corresponds to a certain mode)

%
%note:
%   for all if_* indicator: 1 if selected, 0 if eliminated
%
%
% S. Adany, Mar 22, 2004
% BWS May 2004
% modifed on Jul 10, 2009 by Z. Li for general BC
% Z. Li, June 2010

totalm=length(m_a);
for ml=1:totalm
%     b_v_m=b_v((ndof_m*(ml-1)+1):ndof_m*ml,(ndof_m*(ml-1)+1):ndof_m*ml);
    nom=ndof_m-ngm-ndm-nlm; %nr of other modes
    %
    nmo=0;
    for i=1:ngm
        if if_g(i)==1
            nmo=nmo+1;
            b_v_red_m(:,nmo)=b_v(:,ndof_m*(ml-1)+i);
        end
    end
    for i=1:ndm
        if if_d(i)==1
            nmo=nmo+1;
            b_v_red_m(:,nmo)=b_v(:,(ndof_m*(ml-1)+ngm+i));
        end
    end
    % if if_l==1
    %     b_v_red(:,(nmo+1):(nmo+nlm))=b_v(:,(ngm+ndm+1):(ngm+ndm+nlm));
    %     nmo=nmo+nlm;
    % end
    for i=1:nlm
        if if_l(i)==1
            nmo=nmo+1;
            b_v_red_m(:,nmo)=b_v(:,(ndof_m*(ml-1)+ngm+ndm+i));
        end
    end
    for i=1:nom
        if if_o(i)==1
            nmo=nmo+1;
            b_v_red_m(:,nmo)=b_v(:,(ndof_m*(ml-1)+ngm+ndm+nlm+i));
        end
    end
    % if if_o==1
    %     nom=length(b_v(:,1))-ngm-ndm-nlm; %nr of other modes
    %     b_v_red(:,(nmo+1):(nmo+nom))=b_v(:,(ngm+ndm+nlm+1):(ngm+ndm+nlm+nom));
    %     %b_v_red(:,(nmo+1))=b_v(:,(ngm+ndm+nlm+1));
    % end
    b_v_red(:,(nmo*(ml-1)+1):nmo*ml)=b_v_red_m;
end
