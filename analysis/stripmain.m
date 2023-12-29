function [curve,shapes]=stripmain(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs)
%HISTORY
%June 2010, complete update to new Boundary conditions, Z. Li, B. Schafer
%2023 strip.m became a reserved function in Matlab changed name to stripmain.m to avoid conflict
%
%INPUTS
%prop: [matnum Ex Ey vx vy G] 6 x nmats
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t matnum] nelems x 5;
%lengths: [L1 L2 L3...] 1 x nlengths; lengths to be analyzed
%could be half-wavelengths for signiture curve
%or physical lengths for general b.c.
%springs: [node# d.o.f. kspring kflag] where 1=x dir 2= z dir 3 = y dir 4 = q dir (twist) flag says if k is a foundation stiffness or a total stiffness
%constraints:: [node#e dofe coeff node#k dofk] e=dof to be eliminated k=kept dof dofe_node = coeff*dofk_nodek
%GBTcon: GBTcon.glob,GBTcon.dist, GBTcon.local, GBTcon.other vectors of 1's
%  and 0's referring to the inclusion (1) or exclusion of a given mode from the analysis,
%  GBTcon.ospace - choices of ST/O mode
%         1: ST basis
%         2: O space (null space of GDL) with respect to K
%         3: O space (null space of GDL) with respect to Kg
%         4: O space (null space of GDL) in vector sense
%   GBTcon.norm - code for normalization (if normalization is done at all)
%         0: no normalization, 
%         1: vector norm
%         2: strain energy norm
%         3: work norm
%  GBTcon.couple - coupled basis vs uncoupled basis for general B.C. especially for non-simply supported B.C.
%         1: uncoupled basis, the basis will be block diagonal
%         2: coupled basis, the basis is fully spanned
%  GBTcon.orth - natural basis vs modal basis
%         1: natural basis
%         2: modal basis, axial orthogonality
%         3: modal basis, load dependent orthogonality
%BC: ['S-S'] a string specifying boundary conditions to be analyzed:
%'S-S' simply-pimply supported boundary condition at loaded edges
%'C-C' clamped-clamped boundary condition at loaded edges
%'S-C' simply-clamped supported boundary condition at loaded edges
%'C-F' clamped-free supported boundary condition at loaded edges
%'C-G' clamped-guided supported boundary condition at loaded edges
%m_all: m_all{length#}=[longitudinal_num# ... longitudinal_num#],longitudinal terms m for all the lengths in cell notation
% each cell has a vector including the longitudinal terms for this length
%neigs - the number of eigenvalues to be determined at length (default=10)

%OUTPUTS
%curve: buckling curve (load factor) for each length
%curve{l} = [ length mode#1
%             length mode#2
%             ...    ...
%             length mode#]
%shapes = mode shapes for each length
%shapes{l} = mode, mode is a matrix, each column corresponds to a mode.

%FUNCTIONS CALLED IN THIS ROUTINE
% \analysis\addspring.m : add springs to K
% \analysis\assemble.m : asseemble global K, Kg
% \analysis\elemprop.m : element properties
% \analysis\kglocal.m : element kg matrix
% \analysis\klocal.m : element k matrix
% \analysis\trans.m : trasnform k, kg matrix
% \analysis\msort.m : clean up 0's, multiple longitudinal terms. or out-of-order terms
% \analysis\constr_BCFlag.m : determine flags for user constraints and internal (at node) B.C.'s
% \analysis\cFSM\base_column : cFSM base vectors (natural basis, ST)
% \analysis\cFSM\base_update.m' : cFSM base vectors with selected basis,
%                                 orthogonalization, and normalization
% \analysis\cFSM\constr_user.m : user defined contraints in cFSM style
% \analysis\cFSM\mode_select.m : selection of modes for constraint matrix R


%GUI WAIT BAR FOR FINITE STRIP ANALYSIS
%wait_message=waitbar(0,'Performing Finite Strip Analysis','position',[150 300 384 68],...
%    'CreateCancelBtn',...
%    'setappdata(gcbf,''canceling'',1)');
%setappdata(wait_message,'canceling',0)
%MATRIX SIZES
nnodes = length(node(:,1));
nelems = length(elem(:,1));
nlengths = length(lengths);

%CLEAN UP INPUT
%clean up 0's, multiple terms. or out-of-order terms in m_all
[m_all]=msort(m_all);

%DETERMINE FLAGS FOR USER CONSTRAINTS AND INTERNAL (AT NODE) B.C.'s
[BCFlag]=constr_BCFlag(node,constraints);

%GENERATE STRIP WIDTH AND DIRECTION ANGLE
[elprop]=elemprop(node,elem,nnodes,nelems);

%---------------------------------------------------------------------------------

%LOOP OVER ALL THE LENGTHS TO BE INVESTIGATED
l=0; %length_index = one
while l<nlengths
    l=l+1; %length index = length index + one
    %
    %cancelled
      %if getappdata(wait_message,'canceling')
      %    break        
      %end
    %length to be analyzed
    a=lengths(l);
    %longitudinal terms to be included for this length
    m_a=m_all{l};
    %
    totalm=length(m_a);%Total number of longitudinal terms
    
    %SET SWITCH AND PREPARE BASE VECTORS (R) FOR cFSM ANALYSIS
    if sum(GBTcon.glob)+sum(GBTcon.dist)+sum(GBTcon.local)+sum(GBTcon.other)>0
        %turn on modal classification analysis
        cFSM_analysis=1;
        %generate natural base vectors for axial compression loading
        [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a);
    else
        %no modal classification constraints are engaged
        cFSM_analysis=0;
    end
    %test the time loop to see if we need the waitbar for assembly
       %if length(m_a)*length(node(:,1))>=120
       %    wait_message_elem=waitbar(0,'Assembling stiffness matrices','position',[150 300-68 384 68]);
       %end
    %ZERO OUT THE GLOBAL MATRICES
    K=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
    Kg=sparse(zeros(4*nnodes*totalm,4*nnodes*totalm));
    %
    %ASSEMBLE THE GLOBAL STIFFNESS MATRICES
    for i=1:nelems
        %Generate element stiffness matrix (k) in local coordinates
        t=elem(i,4);
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
        %WAITBAR MESSAGE for assmebly
           %if length(m_a)*length(node(:,1))>=120
           %    info=['Elememt ',num2str(i),' done.'];
           %    waitbar(i/nelems,wait_message_elem);
           %end
    end
    %if exist('wait_message_elem')==1
    %    if ishandle(wait_message_elem)
    %        delete(wait_message_elem);
    %    end
    %end
    
    %ADD SPRING CONTRIBUTIONS TO STIFFNESS 
    %Prior to version 4.3 this was the springs method
        %     if ~isempty(springs) %springs variable exists
        %         [K]=addspring(K,springs,nnodes,a,BC,m_a);
        %     end
    %Now from version 4.3 this is the new springs method
    if ~isempty(springs)&&length(springs(1,:))==10&&springs(1,1)~=0 %springs variable exists, is right length, and non-zero
        nsprings = length(springs(:,1));
        for i=1:nsprings
            %Generate spring stiffness matrix (ks) in local coordinates
            ku=springs(i,4);
            kv=springs(i,5);
            kw=springs(i,6);
            kq=springs(i,7);
            discrete=springs(i,9);
            ys=springs(i,10)*a;
            [ks_l]=spring_klocal(ku,kv,kw,kq,a,BC,m_a,discrete,ys);
            %Transform ks into global coordinates
            nodei = springs(i,2);
            nodej = springs(i,3);
            if nodej==0 %spring is to ground
                %handle the spring to ground during assembly
                alpha=0; %use global coordinates for spring
            else %spring is between nodes
                xi = node(nodei,2);
                zi = node(nodei,3);
                xj = node(nodej,2);
                zj = node(nodej,3);
                dx = xj - xi;
                dz = zj - zi;
                width = sqrt(dx^2 + dz^2);
                if width<1E-10 %coincident nodes
                    alpha=0; %use global coordinates for spring
                elseif springs(i,8)==0 %flagged for global
                    alpha=0; %use global coordinates for spring
                else
                    alpha = atan2(dz,dx); %local orientation for spring
                end
            end
            [ks]=spring_trans(alpha,ks_l,m_a);
            %Add element contribution of ks to full matrix K
            [K]=spring_assemble(K,ks,nodei,nodej,nnodes,m_a);
        end
    end
    
    %INTERNAL BOUNDARY CONDITIONS (ON THE NODES) AND USER DEFINED CONSTR.
    %Check for user defined constraints too
    if BCFlag==0
        %no user defined constraints and fixities.
        Ru0=0;
        nu0=0;
    else
        %size boundary conditions and user constraints for use in R format
        %d_constrained=Ruser*d_unconstrained, d=nodal DOF vector (note by
        %BWS June 5 2006)
        Ruser=constr_user(node,constraints,m_a);
        Ru0=null(Ruser');
        %Number of boundary conditiions and user defined constraints = nu0
        nu0=length(Ru0(1,:));
    end
    
    %GENERATION OF cFSM CONSTRAINT MATRIX
    if cFSM_analysis==1
        %PERFORM ORTHOGONALIZATION IF GBT-LIKE MODES ARE ENFORCED
        b_v=base_update(GBTcon.ospace,0,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,GBTcon.couple,GBTcon.orth);%no normalization is enforced: 0:  m
        %assign base vectors to constraints
        b_v=mode_select(b_v,ngm,ndm,nlm,GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other,4*nnodes,m_a);%m
        Rmode=b_v;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        %no modal constraints are activated therefore
        Rmode=eye(4*nnodes*totalm);%activate modal constraints
    end
    %
    %CREATE FINAL CONSTRAINT MATRIX
    %Determine the number of modal constraints, nm0
    if BCFlag==0
        %if no user defined constraints and fixities.
        R=Rmode;
    else
        %should performed uncoupled for block diagonal basis?
        if cFSM_analysis==1
            nm0=0;
            Rm0=null(Rmode');
            nm0=length(Rm0(1,:));
            R0=Rm0;
            if nu0>0
                R0(:,(nm0+1):(nm0+nu0))=Ru0;
            end
            R=null(R0');
        else
            R=null(Ru0');
        end
    end
    %
    %INTRODUDCE CONSTRAINTS AND REDUCE K MATRICES TO FREE PARTS ONLY
    Kff=R'*K*R;
    Kgff=R'*Kg*R;
    
    %SOLVE THE EIGENVALUE PROBLEM
    %Determine which solver to use
    %small problems usually use eig, and large problems use eigs.
    %the eigs solver is not as stable as the full eig solver...
    %LAPACK reciprocal condition estimator
    rcond_num=rcond(full(Kgff\Kff));
    %Here, assume when rcond_num is bigger than half of the eps, eigs can provide
    %reliable solution. Otherwise, eig, the robust solver should be used.
    if rcond_num>=eps/2
        eigflag=2;%eigs
    else
        eigflag=1;%eig
    end
    %determine if there is a user input neigs; otherwise set it to
    %default 10.
    if nargin<10|isempty(neigs)
        neigs=20;
    end
    if eigflag==1
        [modes,lf]=eig(full(Kff),full(Kgff));
    else
        N=max(min(2*neigs,length(Kff(1,:))),1);
        if N==1|N==length(Kff(1,:))
            [modes,lf]=eig(full(Kff),full(Kgff));
        else
        %pull out 10 eigenvalues
        [modes,lf]=eigs(full(Kgff\Kff),N,'SM');
        end
    end
    %CLEAN UP THE EIGEN SOLUTION
    %eigenvalues are along the diagonal of matrix lf
    lf=diag(lf);
    %find all the positive eigenvalues and corresponding vectors, squeeze out the rest
    index=find(lf>0 & imag(abs(lf))<0.00001);
    lf=lf(index);
    modes=modes(:,index);
    %sort from small to large
    [lf,index]=sort(lf);
    modes=modes(:,index);
    %only the real part is of interest (eigensolver may give some small nonzero imaginary parts)
    lf=real(lf);
    modes=real(modes);
    %
    %truncate down to reasonable number of modes to be kept
    num_pos_modes=length(lf);
    nummodes=min([neigs;num_pos_modes]);
    lf=lf(1:nummodes);
    modes=modes(:,1:nummodes);
    %
    %FORM THE FULL MODE SHAPE BY BRINGING BACK ELIMINATED DOF
    mode=R*modes;
    %
    %CLEAN UP NORMALIZATION OF MODE SHAPE
    %eig and eigs solver use different normalization
    %set max entry (absolute) to +1.0 and scale the rest
    for j=1:nummodes
        maxindex=find(abs(mode(:,j))==max(abs(mode(:,j))));
        mode(:,j)=mode(:,j)/mode(maxindex(1),j);
    end
    %
    
    %GENERATE OUTPUT VALUES
    %curve and shapes are changed to cells!!
    %curve: buckling curve (load factor)
    %curve{l} = [ length ... length
    %             mode#1 ... mode#]
    %shapes = mode shapes
    %shapes{l} = mode, each column corresponds to a mode.
    curve{l}(1:nummodes,1)=lengths(l);
    curve{l}(1:nummodes,2)=lf;
    %shapes(:,l,1:min([nummodes,num_pos_modes]))=modes;
    shapes{l}=mode;
    %
    %
    %WAITBAR MESSAGE
      %info=['Length ',num2str(lengths(l)),' done.'];
      %waitbar(l/nlengths,wait_message);
    %
end
%THAT ENDS THE LOOP OVER ALL THE LENGTHS
%--------------------------------------------------------------------------
  %if ishandle(wait_message)
  %    delete(wait_message);
  %end
% %
