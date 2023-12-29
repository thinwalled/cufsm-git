function [b_v_m]=base_vectors(dy,elem,elprop,a,m,node_prop,nmno,ncno,nsno,ngm,ndm,nlm,Rx,Rz,Rp,Rys,DOFperm)
%
%this routine creates the base vactors for global, dist., local and other modes 
% 
%assumptions
%   GBT-like assumptions are used
%   the cross-section must not be closed and must not contain closed parts
%  
%   must check whether 'Warp' works well for any open section !!! 
%
%
%input data
%   elem, elprop - same as elsewhere throughout this program
%   a, m - member length and number of half-waves, respectively
%   m_node [main nodes] - nodes of 'meta' cross-section
%   m_elem [meta-elements] - elements of 'meta' cross-section
%   node_prop - some properties of the nodes
%   nmno,ncno,nsno - number of main nodes, corner nodes and sub-nodes, respectively
%   ndm,nlm - number of distortional and local buckling modes, respectively
%   Rx,Rz,Rp,Rys, - constraint matrices
%   DOFperm - permutation matrix to re-order the DOFs
%
%output data
%   nom - nr of other modes
%   b_v_m - base vectors for single half-wave number m (each column corresponds to a certain mode)
%           columns 1..ngm: global modes
%           columns (ngm+1)..(ngm+ndm): dist. modes
%           columns (ngm+ndm+1)..(ngm+ndm+nlm): local modes
%           columns (ngm+ndm+nlm+1)..ndof: other modes
%
%note:
%   more details on the input variables can be found in the routines called
%      in this routine
%

% S. Adany, Mar 10, 2004, modified Aug 29, 2006
% Z. Li, Dec 22, 2009

%DATA PREPARATION
%
km=m*pi/a;
%
nno=length(node_prop(:,1));
ndof=4*nno; %nro of DOFs
neno=nmno-ncno;
%zero out
b_v_m=zeros(ndof);
%
%CALCULATION FOR GLOBAL AND DISTORTIONAL BUCKLING MODES
%to add global and dist y DOFs to base vectors
b_v_m = dy(:,1:(ngm+ndm));
%
%to add x DOFs of corner nodes to the base vectors
%Rx=Rx/km;
b_v_m((nmno+1):(nmno+ncno),1:(ngm+ndm)) = Rx * b_v_m(1:nmno,1:(ngm+ndm));
%
%to add z DOFs of corner nodes to the base vectors
%Rz=Rz/km;
b_v_m((nmno+ncno+1):(nmno+2*ncno),1:(ngm+ndm)) = Rz * b_v_m(1:nmno,1:(ngm+ndm));
%
%to add other planar DOFs to the base vectors
b_v_m((nmno+2*ncno+1):(ndof-nsno),1:(ngm+ndm)) = Rp * b_v_m((nmno+1):(nmno+2*ncno),1:(ngm+ndm));
%
%to add y DOFs of sub-nodes to the base vector
b_v_m((ndof-nsno+1):ndof,1:(ngm+ndm)) = Rys * b_v_m(1:nmno,1:(ngm+ndm));
%
%division by km
b_v_m((nmno+1):(ndof-nsno),1:(ngm+ndm))=b_v_m((nmno+1):(ndof-nsno),1:(ngm+ndm))/km;
%
%norm base vectors
for i=1:(ngm+ndm)
    b_v_m(:,i) = b_v_m(:,i)/norm(b_v_m(:,i));
end
%
%
%CALCULATION FOR LOCAL BUCKLING MODES
%
ngdm=ngm+ndm; %nr of global and dist. modes
%
%zeros
b_v_m(1:ndof,(ngdm+1):(ngdm+nlm))=zeros(ndof,nlm);

%rot DOFs for main nodes
b_v_m((3*nmno+1):(4*nmno),(ngdm+1):(ngdm+nmno))=eye(nmno);
%
%rot DOFs for sub nodes
if nsno>0
    b_v_m((4*nmno+2*nsno+1):(4*nmno+3*nsno),(ngdm+nmno+1):(ngdm+nmno+nsno))=eye(nsno);
end
%
%x,z DOFs for edge nodes
k=0;
for i=1:nno
    if node_prop(i,4)==2
        k=k+1;
        el=find((elem(:,2)==i) | (elem(:,3)==i)); %adjacent element
        alfa=elprop(el,3);
        b_v_m((nmno+2*ncno+k),(ngdm+nmno+nsno+k))=-sin(alfa); %x
        b_v_m((nmno+2*ncno+neno+k),(ngdm+nmno+nsno+k))=cos(alfa); %z
    end
end
%
%x,z DOFs for sub-nodes
if nsno>0
    k=0;
    for i=1:nno
        if node_prop(i,4)==3
            k=k+1;
            el=find((elem(:,2)==i) | (elem(:,3)==i)); %adjacent element
            alfa=elprop(el(1),3);
            b_v_m((4*nmno+k),(ngdm+nmno+nsno+neno+k))=-sin(alfa); %x
            b_v_m((4*nmno+nsno+k),(ngdm+nmno+nsno+neno+k))=cos(alfa); %z
        end
    end
end
%
%
%CALCULATION FOR OTHER BUCKLING MODES
%
% %first among the "others": uniform y  
% b_v_m(1:nmno,(ngdm+nlm+1)) = zeros(nmno,1)+sqrt(1/(nmno+nsno));
% b_v_m((ndof-nsno+1):ndof,(ngdm+nlm+1)) = zeros(nsno,1)+sqrt(1/(nmno+nsno));
%
%% old way
% nom=ndof-ngdm-nlm;
% nel=length(elem(:,1));
% b_v_m(1:ndof,(ngdm+nlm+1):(ngdm+nlm+2*nel)) = zeros(ndof,2*nel);
% temp_elem=elem(:,2:3);
% for i=1:nel
%     %
%     alfa=elprop(i,3);
%     %
%     %find nodes on the one side of the current element
%     nnod=1;
%     nods=[];
%     nods(1)=elem(i,2);
%     temp_elem=elem(:,2:3);
%     temp_elem(i,1)=0;
%     temp_elem(i,2)=0;
%     new=1;
%     while new>0
%         new=0;
%         for j=1:nel
%             for k=1:length(nods)
%                 if (nods(k)==temp_elem(j,1))
%                     nnod=nnod+1;
%                     new=new+1;
%                     nods(nnod)=temp_elem(j,2);
%                     temp_elem(j,1)=0;
%                     temp_elem(j,2)=0;
%                 end
%                 if (nods(k)==temp_elem(j,2))
%                     nnod=nnod+1;
%                     new=new+1;
%                     nods(nnod)=temp_elem(j,1);
%                     temp_elem(j,1)=0;
%                     temp_elem(j,2)=0;
%                 end
%             end
%         end
%     end
%     %
%     %create the base-vectors for membrane SHEAR modes
%     s=sqrt(1/nnod);
%     for j=1:nnod
%         old_dofy=2*(nods(j));
%         b_v_m(old_dofy,(ngdm+nlm+i)) = s;
%     end
%     %               
%     %create the base-vectors for membrane TRANSVERSE modes   
%     for j=1:nnod
%         old_dofx=2*(nods(j))-1;
%         old_dofz=2*nno+2*(nods(j))-1;
%         b_v_m(old_dofx,(ngdm+nlm+nel+i)) = s*cos(alfa);
%         b_v_m(old_dofz,(ngdm+nlm+nel+i)) = s*sin(alfa);
%     end
% 
% end
%% new way
nom=ndof-ngdm-nlm;
nel=length(elem(:,1));
b_v_m(1:ndof,(ngdm+nlm+1):(ngdm+nlm+2*nel)) = zeros(ndof,2*nel);
for i=1:nel
    %
    alfa=elprop(i,3);
    %
    %find nodes on the one side of the current element
    nnod1=elem(i,2);
    nnod2=elem(i,3);
    %
    %create the base-vectors for membrane SHEAR modes
    b_v_m((nnod1-1)*2+2,(ngdm+nlm+i)) = 0.5;
    b_v_m((nnod2-1)*2+2,(ngdm+nlm+i)) = -0.5;
    %               
    %create the base-vectors for membrane TRANSVERSE modes   
    b_v_m((nnod1-1)*2+1,(ngdm+nlm+nel+i)) = -0.5*cos(alfa);
    b_v_m((nnod2-1)*2+1,(ngdm+nlm+nel+i)) = 0.5*cos(alfa);
    b_v_m(2*nno+(nnod1-1)*2+1,(ngdm+nlm+nel+i)) = 0.5*sin(alfa);
    b_v_m(2*nno+(nnod2-1)*2+1,(ngdm+nlm+nel+i)) = -0.5*sin(alfa);

end
%    
%    
%
%RE_ORDERING DOFS
%
b_v_m(:,1:(ngdm+nlm)) = DOFperm*b_v_m(:,1:(ngdm+nlm));
%

