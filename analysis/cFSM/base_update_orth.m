function [b_v]=base_update_orth(opt,method,b_v_l,a,hwn,node,elem,prop,ngm,ndm,nlm,BC)
%
%this routine optionally makes orthogonalization and normalization of base vectors  
% for coupled basis
%
%assumptions
%   orthogonalization is done by solving the EV problem for each sub-space
%   three options for normalization is possible, set by 'methods' parameter
%
%input data
%   opt - calculation option
%         1: natural basis, 2: partially orthogonal, 3: fully orthogonal
%   method - code for normalization (if normalization is done at all)
%            0=no normalization, 1=vector norm, 2=strain energy norm, 3=work norm
%   b_v_ul - natural base vectors for unit length (each column corresponds to a certain mode)
%           columns 1..ngm: global modes
%           columns (ngm+1)..(ngm+ndm): dist. modes
%           columns (ngm+ndm+1)..(ngm+ndm+nlm): local modes
%           columns (ngm+ndm+nlm+1)..ndof_m: other modes
%   a - length
%   hwn,node,elem,prop - as usual
%   ngm,ndm,nlm - nr of modes
%
%output data
%   b_v - output base vectors (maybe natural, orthogonal or normalized,
%         depending on the selected options)
%
% S. Adany, Oct 11, 2006
% Z. Li modified on Jul 10, 2009

%
nnodes=length(node(:,1));
ndof_m=4*nnodes;
totalm = length(hwn); % Total number of longitudinal terms m
b_v=b_v_l;
%K/Kg
if method==2|method==3|opt==2|opt==3|opt==4|opt==5
    nelems=length(elem(:,1));
    [elprop]=elemprop(node,elem,nnodes,nelems);
    node(:,8)=node(:,8)*0+1; %set up stress to 1.0 (uniform)
    Gzeors=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
    %ZERO OUT THE GLOBAL MATRICES
    K=Gzeors;
    Kg=Gzeors;
    %
    %ASSEMBLE THE GLOBAL STIFFNESS MATRICES
    for i=1:nelems
        %Generate element stiffness matrix (k) in local coordinates
        t=elem(i,4);
        %     a=lengths(l);
        b=elprop(i,2);
        matnum=elem(i,5);
        row=find(matnum==prop(:,1));
        Ex=prop(row,2);
        Ey=prop(row,3);
        vx=prop(row,4);
        vy=prop(row,5);
        G=prop(row,6);
        [k_l]=klocal(Ex,Ey,vx,vy,G,t,a,b,hwn,BC);
        %Generate geometric stiffness matrix (kg) in local coordinates
        Ty1=node(elem(i,2),8)*t;
        Ty2=node(elem(i,3),8)*t;
        [kg_l]=kglocal(a,b,hwn,Ty1,Ty2,BC);
        %Transform k and kg into global coordinates
        alpha=elprop(i,3);
        [k,kg]=trans(alpha,k_l,kg_l,hwn);
        %Add element contribution of k to full matrix K and kg to Kg
        nodei=elem(i,2);
        nodej=elem(i,3);
        [K,Kg]=assemble(K,Kg,k,kg,nodei,nodej,nnodes,hwn,Gzeors);
    end
end

%
%orthogonalization/normalization begins
if opt==2|opt==3|opt==4|opt==5
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
    nom=ndof_m-ngm-ndm-nlm;
    %
    for ml=1:totalm
        %
        %considering length-dependency on base vectors
        b_v_m=b_v_l(:,ndof_m*(ml-1)+1:ndof_m*ml);%(ndof_m*(ml-1)+1):ndof_m*ml
        b_v_GDL(:,(ml-1)*(ngm+ndm+nlm)+1:ml*(ngm+ndm+nlm))=b_v_m(:,dofindex(1,1):dofindex(3,2));
        b_v_G(:,(ml-1)*ngm+1:ml*ngm)=b_v_m(:,dofindex(1,1):dofindex(1,2));
        b_v_D(:,(ml-1)*ndm+1:ml*ndm)=b_v_m(:,dofindex(2,1):dofindex(2,2));
        b_v_L(:,(ml-1)*nlm+1:ml*nlm)=b_v_m(:,dofindex(3,1):dofindex(3,2));
        b_v_O(:,(ml-1)*nom+1:ml*nom)=b_v_m(:,dofindex(4,1):dofindex(4,2));
        %
    end
    
    %define vectors for other modes, opt=3 only
    if opt==3
        A=null(b_v_GDL');
        b_v_O=K\A;
        for ml=1:totalm
            b_v(:,(ml-1)*ndof_m+dofindex(4,1):(ml-1)*ndof_m+dofindex(4,2))=b_v_O(:,(ml-1)*nom+1:ml*nom);
        end
    end
    %define vectors for other modes, opt=4 only
    if opt==4
        A=null(b_v_GDL');
        b_v_O=Kg\A;
        for ml=1:totalm
            b_v(:,(ml-1)*ndof_m+dofindex(4,1):(ml-1)*ndof_m+dofindex(4,2))=b_v_O(:,(ml-1)*nom+1:ml*nom);
        end
    end
    %define vectors for other modes, opt=5 only
    if opt==5
        A=null(b_v_GDL');
        for ml=1:totalm
            b_v(:,(ml-1)*ndof_m+dofindex(4,1):(ml-1)*ndof_m+dofindex(4,2))=A(:,(ml-1)*nom+1:ml*nom);
        end
    end
    %
    %orthogonalization + normalization for methods 2/3
    for isub=1:4
        V=[];
        D=[];
        Ksub=[];
        Kgsub=[];
        if dofindex(isub,2)>=dofindex(isub,1)
            if isub==1
                Ksub=b_v_G' * K * b_v_G;
                Kgsub=b_v_G' * Kg *b_v_G;
            elseif isub==2
                Ksub=b_v_D' * K * b_v_D;
                Kgsub=b_v_D' * Kg *b_v_D;
            elseif isub==3
                Ksub=b_v_L' * K * b_v_L;
                Kgsub=b_v_L' * Kg *b_v_L;
            elseif isub==4
                Ksub=b_v_O' * K * b_v_O;
                Kgsub=b_v_O' * Kg *b_v_O;
            end
            [V,D]=eig(Ksub,Kgsub);
%                         [V,D]=eig(Kgsub\Ksub);
            if method==2|method==3
                if method==2
                    s=V'*Ksub*V;
                end
                if method==3
                    s=V'*Kgsub*V;
                end
                s=diag(s);
                s=sqrt(s);
                for i=1:(dofindex(isub,2)-dofindex(isub,1)+1)*totalm
                    V(:,i)=V(:,i)/s(i);
                end
            end
            
            for ml=1:totalm
                if isub==1
                    b_v(:,(ml-1)*ndof_m+dofindex(isub,1):(ml-1)*ndof_m+dofindex(isub,2))=b_v_orth(:,(ml-1)*ngm+1:ml*ngm);
                elseif isub==2
                    b_v(:,(ml-1)*ndof_m+dofindex(isub,1):(ml-1)*ndof_m+dofindex(isub,2))=b_v_orth(:,(ml-1)*ndm+1:ml*ndm);
                elseif isub==3
                    b_v(:,(ml-1)*ndof_m+dofindex(isub,1):(ml-1)*ndof_m+dofindex(isub,2))=b_v_orth(:,(ml-1)*nlm+1:ml*nlm);
                elseif isub==4
                    b_v(:,(ml-1)*ndof_m+dofindex(isub,1):(ml-1)*ndof_m+dofindex(isub,2))=b_v_orth(:,(ml-1)*nom+1:ml*nom);
                end
            end
        end
    end
end
%
%normalization for opt=1
if (method==2|method==3)&(opt==1)
    for i=1:1:(ndof_m*totalm)
        if method==2
            b_v(:,i)=b_v(:,i)/sqrt(b_v(:,i)'*K*b_v(:,i));
        end
        if method==3
            b_v(:,i)=b_v(:,i)/sqrt(b_v(:,i)'*Kg*b_v(:,i));
        end
    end

end
%
%normalization for method 1
if method==1
    for i=1:1:(ndof_m*totalm)
        b_v(:,i)=b_v(:,i)/sqrt(b_v(:,i)'*b_v(:,i));
    end
end
%     b_v((ndof_m*(ml-1)+1):ndof_m*ml,(ndof_m*(ml-1)+1):ndof_m*ml)=b_v_m;
end
