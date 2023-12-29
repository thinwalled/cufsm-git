function [b_v]=base_update(ospace,normal,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,couple,orth)
%
%this routine optionally makes orthogonalization and normalization of base vectors

%assumptions
%   orthogonalization is done by solving the EV problem for each sub-space
%   three options for normalization is possible, set by 'normal' parameter

%input data
%   ospace - by GBTcon.ospace, choices of ST/O mode
%         1: ST basis
%         2: O space (null space of GDL) with respect to K
%         3: O space (null space of GDL) with respect to Kg
%         4: O space (null space of GDL) in vector sense
%   normal - by GBTcon.norm, code for normalization (if normalization is done at all)
%         0: no normalization, 
%         1: vector norm
%         2: strain energy norm
%         3: work norm
%   b_v_l - natural base vectors for length (each column corresponds to a certain mode)
%   for each half-wave number m
%           columns 1..ngm: global modes
%           columns (ngm+1)..(ngm+ndm): dist. modes
%           columns (ngm+ndm+1)..(ngm+ndm+nlm): local modes
%           columns (ngm+ndm+nlm+1)..ndof_m: other modes
%   a - length
%   m_a,node,elem,prop - as usual
%   ngm,ndm,nlm - nr of modes
%   BC - boundary condition, 'S-S','C-C',...etc., as usual
%   couple - by GBTcon.couple, coupled basis vs uncoupled basis for general B.C. especially for non-simply supported B.C.
%         1: uncoupled basis, the basis will be block diagonal
%         2: coupled basis, the basis is fully spanned
%   orth - by GBTcon.orth, natural basis vs modal basis
%         1: natural basis
%         2: modal basis, axial orthogonality
%         3: modal basis, load dependent orthogonality

%output data
%   b_v - output base vectors (maybe natural, orthogonal or normalized,
%         depending on the selected options)

% S. Adany, Oct 11, 2006
% Z. Li modified on Jul 10, 2009
% Z. Li, June 2010

nnodes=length(node(:,1));
ndof_m=4*nnodes;
totalm = length(m_a); %Total number of longitudinal terms m
b_v=zeros(ndof_m*totalm);

if couple==1
    
    if length(m_a)*length(node(:,1))>=300
        wait_message_base=waitbar(0,'Base vectors are updating....',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
        setappdata(wait_message_base,'canceling',0)
    end
    % uncoupled basis
    for ml=1:totalm
        %cancelled
        if exist('wait_message_base')==1
            if getappdata(wait_message_base,'canceling')
                break
            end
        end
        %
        b_v_m=b_v_l((ndof_m*(ml-1)+1):ndof_m*ml,(ndof_m*(ml-1)+1):ndof_m*ml);
        %
        %K/Kg
        if normal==2|normal==3|ospace==2|ospace==3|orth==2|orth==3
            nelems=length(elem(:,1));
            [elprop]=elemprop(node,elem,nnodes,nelems);
            % axial loading or real loading by either orth=2 or orth=3
            if orth==1|orth==2
                node(:,8)=node(:,8)*0+1; %set up stress to 1.0 (axial)
            end
            
            [K,Kg]=create_Ks(m_a(ml),node,elem,elprop,prop,a,BC);
        end
        
        %orthogonalization/normalization begins
        %
        if orth==2|orth==3|ospace==2|ospace==3|ospace==4
            %
            %indices
            dofindex(1,1)=1;
            dofindex(1,2)=ngm;
            dofindex(2,1)=ngm+1;
            dofindex(2,2)=ngm+ndm;
            dofindex(3,1)=ngm+ndm+1;
            dofindex(3,2)=ngm+ndm+nlm;
            if ospace==1
                dofindex(4,1)=ngm+ndm+nlm+1;
                dofindex(4,2)=ngm+ndm+nlm+nnodes-1;
                dofindex(5,1)=ngm+ndm+nlm+nnodes;
                dofindex(5,2)=ndof_m;
            else
                dofindex(4,1)=ngm+ndm+nlm+1;
                dofindex(4,2)=ndof_m;
            end
            %
            %define vectors for other modes, ospace=2,3,4
            if ospace==2
                A=null((b_v_m(:,dofindex(1,1):dofindex(3,2)))');
                b_v_m(:,dofindex(4,1):dofindex(4,2))=K\A;
            end
            if ospace==3
                A=null((b_v_m(:,dofindex(1,1):dofindex(3,2)))');
                b_v_m(:,dofindex(4,1):dofindex(4,2))=Kg\A;
            end
            if ospace==4
                A=null((b_v_m(:,dofindex(1,1):dofindex(3,2)))');
                b_v_m(:,dofindex(4,1):dofindex(4,2))=A;
            end
            %
            %orthogonalization for modal basis 2/3 + normalization for normals 2/3
            for isub=1:length(dofindex(:,1))
                V=[];
                D=[];
                if dofindex(isub,2)>=dofindex(isub,1)
                    Ksub=b_v_m(:,dofindex(isub,1):dofindex(isub,2))' * K * b_v_m(:,dofindex(isub,1):dofindex(isub,2));
                    Kgsub=b_v_m(:,dofindex(isub,1):dofindex(isub,2))' * Kg * b_v_m(:,dofindex(isub,1):dofindex(isub,2));
                    [V,D]=eig(Ksub,Kgsub);
                    lfsub=real(diag(D));
                    [lfsub,indexsub]=sort(lfsub);
                    V=real(V(:,indexsub));
                    if normal==2|normal==3
                        if normal==2
                            s=V'*Ksub*V;
                        end
                        if normal==3
                            s=V'*Kgsub*V;
                        end
                        s=diag(s);
                        s=sqrt(s);
                        for i=1:(dofindex(isub,2)-dofindex(isub,1)+1)
                            V(:,i)=V(:,i)/s(i);
                        end
                    end
                    b_v_m(:,dofindex(isub,1):dofindex(isub,2))=b_v_m(:,dofindex(isub,1):dofindex(isub,2))*V;
                end
            end
        end
        %
        %normalization for ospace=1
        if (normal==2|normal==3)&(ospace==1)
            for i=1:ndof_m
                if normal==2
                    b_v_m(:,i)=b_v_m(:,i)/sqrt(b_v_m(:,i)'*K*b_v_m(:,i));
                end
                if normal==3
                    b_v_m(:,i)=b_v_m(:,i)/sqrt(b_v_m(:,i)'*Kg*b_v_m(:,i));
                end
            end
            
        end
        %
        %normalization for normal 1
        if normal==1
            for i=1:ndof_m
                b_v_m(:,i)=b_v_m(:,i)/sqrt(b_v_m(:,i)'*b_v_m(:,i));
            end
        end
        b_v((ndof_m*(ml-1)+1):ndof_m*ml,(ndof_m*(ml-1)+1):ndof_m*ml)=b_v_m;
        
        if length(m_a)*length(node(:,1))>=300
            waitbar(ml/totalm,wait_message_base);
        end        
    end
    
else
    %coupled basis
    if length(m_a)*length(node(:,1))>=120
        wait_message_base=waitbar(0,'Base vectors are updating....',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
        setappdata(wait_message_base,'canceling',0)
    end
    %K/Kg
    if normal==2|normal==3|ospace==2|ospace==3|orth==2|orth==3
        nelems=length(elem(:,1));
        [elprop]=elemprop(node,elem,nnodes,nelems);
        % axial loading or real loading by either orth=2 or orth=3
        if orth==1|orth==2
            node(:,8)=node(:,8)*0+1; %set up stress to 1.0 (axial)
        end
       
        %ZERO OUT THE GLOBAL MATRICES
        K=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
        Kg=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
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
            [k_l]=klocal(Ex,Ey,vx,vy,G,t,a,b,BC,m_a);
            %Generate geometric stiffness matrix (kg) in local coordinates
            Ty1=node(elem(i,2),8)*t;
            Ty2=node(elem(i,3),8)*t;
            [kg_l]=kglocal(a,b,Ty1,Ty2,BC,m_a);
            %Transform k and kg into global coordinates
            alpha=elprop(i,3);
            [k,kg]=trans(alpha,k_l,kg_l,m_a);
            %Add element contribution of k to full matrix K and kg to Kg
            nodei=elem(i,2);
            nodej=elem(i,3);
            [K,Kg]=assemble(K,Kg,k,kg,nodei,nodej,nnodes,m_a);
        end
    end
    
    %
    %orthogonalization/normalization begins
    if orth==2|orth==3|ospace==2|ospace==3|ospace==4
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
        nom=ndof_m-(ngm+ndm+nlm);
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
        %define vectors for other modes, ospace=3 only
        if ospace==3
            A=null(b_v_GDL');
            b_v_O=K\A;
            for ml=1:totalm
                b_v(:,(ml-1)*ndof_m+dofindex(4,1):(ml-1)*ndof_m+dofindex(4,2))=b_v_O(:,(ml-1)*nom+1:ml*nom);
            end
        end
        %define vectors for other modes, ospace=4 only
        if ospace==4
            A=null(b_v_GDL');
            b_v_O=Kg\A;
            for ml=1:totalm
                b_v(:,(ml-1)*ndof_m+dofindex(4,1):(ml-1)*ndof_m+dofindex(4,2))=b_v_O(:,(ml-1)*nom+1:ml*nom);
            end
        end
        %define vectors for other modes, ospace=5 only
        if ospace==5
            A=null(b_v_GDL');
            for ml=1:totalm
                b_v(:,(ml-1)*ndof_m+dofindex(4,1):(ml-1)*ndof_m+dofindex(4,2))=A(:,(ml-1)*nom+1:ml*nom);
            end
        end
        %
        %orthogonalization + normalization for normals 2/3
        for isub=1:4
            %if cancelled
            if exist('wait_message_base')==1
                if getappdata(wait_message_base,'canceling')
                    break
                end
            end
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
                lfsub=real(diag(D));
                [lfsub,indexsub]=sort(lfsub);
                V=real(V(:,indexsub));
                %[V,D]=eig(Kgsub\Ksub);
                if normal==2|normal==3
                    if normal==2
                        s=V'*Ksub*V;
                    end
                    if normal==3
                        s=V'*Kgsub*V;
                    end
                    s=diag(s);
                    s=sqrt(s);
                    for i=1:(dofindex(isub,2)-dofindex(isub,1)+1)*totalm
                        V(:,i)=V(:,i)/s(i);
                    end
                end
                if isub==1
                    b_v_orth=b_v_G*V;
                elseif isub==2
                    b_v_orth=b_v_D*V;
                elseif isub==3
                    b_v_orth=b_v_L*V;
                elseif isub==4
                    b_v_orth=b_v_O*V;
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
            if length(m_a)*length(node(:,1))>=120
                waitbar(isub/4,wait_message_base);
            end
        end
    end
    %
    %normalization for ospace=1
    if (normal==2|normal==3)&(ospace==1)
        for i=1:1:(ndof_m*totalm)
            if normal==2
                b_v(:,i)=b_v(:,i)/sqrt(b_v(:,i)'*K*b_v(:,i));
            end
            if normal==3
                b_v(:,i)=b_v(:,i)/sqrt(b_v(:,i)'*Kg*b_v(:,i));
            end
        end
        
    end
    %
    %normalization for normal 1
    if normal==1
        for i=1:1:(ndof_m*totalm)
            b_v(:,i)=b_v(:,i)/sqrt(b_v(:,i)'*b_v(:,i));
        end
    end
    %     b_v((ndof_m*(ml-1)+1):ndof_m*ml,(ndof_m*(ml-1)+1):ndof_m*ml)=b_v_m;
end
if exist('wait_message_base')==1
    if ishandle(wait_message_base)
        delete(wait_message_base);
    end
end



