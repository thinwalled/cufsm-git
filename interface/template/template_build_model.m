function model = template_build_model(templateID, P)
%Build CUFSM model inputs from basic section parameters for templates
%Also, build straight line inputs for later dimensioning and segment start
%and end points for the dimensioning
%
%Inputs
%P.nseg - strips-per-segment multiplier (scalar)
%P.section.*   - template-specific fields, e.g. D,B,H,rin,t
%Outputs
%model.templateID
%model.P
%model.strips,      model.node,      model.elem        (sharp or rounded actual model)
%model.stripsD,     model.nodeD,     model.elemD       (sharp n=1 model for dimensioning)

%Inputs used across all models
nseg = max(1, round(P.nseg));
nlen = max(1, round(P.nlen));
E = P.E;
nu = P.nu;
mid=111; %hardcode material id from the template

%see bottom of main file for output across all mdoels
%specifically definition of prop, springs, and constraints


switch lower(templateID)

    case 'lippedc'
        % User inputs (out-to-out dims + inner radius)
        D   = P.section.D;
        B   = P.section.B;
        H   = P.section.H;
        rin = P.section.rin;
        t   = P.section.t;
        %convert to centerline
        d = D - t/2;
        b = B - t;
        h = H - t;
        if rin==0
           r=0; %respect sharp corners
        else
            r = rin + t/2;
        end
        %build snakey inputs
        strips.l= [d   b   h  b  d];
        strips.q= [270 180 90 0 -90]*pi/180;  % degrees -> rad
        strips.n= [2   4   8  4  2]*max(1,nseg);
        strips.t= [t   t   t  t  t ];
        strips.id=[mid mid mid mid mid];
        strips.closed = false;
        %corner radius between segments (if desired)
        strips.r=[r r r r ]; 
        strips.rn=[4 4 4 4];
        strips.rt=[t t t t ];
        strips.rid=[mid mid mid mid];
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);
        
    case 'hds'
        % User inputs (out-to-out dims + inner radius)
        H   = P.section.H;
        B   = P.section.B;
        D1   = P.section.D1;
        D2   = P.section.D2;
        rin = P.section.rin;
        t   = P.section.t;
        %Heavy Duty Studs Like ClarkDietrich, centerline dimensions
        a=H-t;
        b=B-t;
        c=D1-t;
        d=D2-t/2;
        if rin==0
           r=0; %respect sharp corners
        else
            r = rin + t/2;
        end
        %straight line segments (centerline)
        strips.l= [d c b a b c d];
        strips.q= [90 0 -90 180 90 0 -90]*pi/180;
        strips.n= [2 4 4 8 4 4 2]*max(1,nseg);
        strips.t= [t t t t t t t]; 
        strips.id=[mid mid mid mid mid mid mid];
        strips.closed=false; %open shape
        %corner radius between segments (if desired)
        strips.r=[r r r r r r]; 
        strips.rn=[4 4 4 4 4 4];
        strips.rt=[t t t t t t];
        strips.rid=[mid mid mid mid mid mid];
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'lippedz'
        % User inputs (out-to-out dims + inner radius)
        H   = P.section.H;
        B   = P.section.B;
        D   = P.section.D;
        q   = P.section.qlip;
        rin = P.section.rin;
        t   = P.section.t;
        %convert to centerline
        d = D - t/2;
        b = B - t;
        h = H - t;
        if rin==0
           r=0; %respect sharp corners
        else
            r = rin + 0.5*t;
        end
        %build snakey inputs
        strips.l  = [d,  b,  h,  b,  d];
        strips.q  = [-q, 0, 90, 0, -q]*pi/180;  % degrees -> rad
        base_n    = [2,   4,   8,  4,   2];
        strips.n  = max(1,nseg) * base_n; %allows finder discretization
        strips.t  = t * ones(size(strips.l));
        strips.id = mid * ones(size(strips.l));
        strips.closed = false;
        % Corner radii between each adjacent straight segment
        if r > 0
            strips.r   = r * ones(1,4);         % there are 4 corners
            strips.rn  = 4 * ones(1,4);         % 4 strips per arc
            strips.rt  = t * ones(1,4);
            strips.rid = mid * ones(1,4);
        else
            % no corners
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'sigma'
        % Section inputs
        B   = P.section.B;
        A   = P.section.A;
        C   = P.section.C;
        E   = P.section.E;
        N   = P.section.N;
        D1   = P.section.D1;
        D2   = P.section.D2;
        rin = P.section.rin;
        t   = P.section.t;
        %convert to centerline
        d2=D2-t/2;
        d1=D1-t;
        b=B-t;
        a=A-t/2;
        ce=sqrt((C)^2+(E)^2);
        qce=atan2(C,E)*180/pi;
        n=N;
        r=rin+t/2;
        if rin==0
           r=0; %respect sharp corners
        else
            r = rin + 0.5*t;
        end
        %build snakey inputs
        strips.l= [d2 d1 b a ce n ce a b d1 d2];
        strips.q= [90 180 -90 0 qce 0 -qce 0 90 180 -90]*pi/180;
        strips.n= [2 2 8 4 4 4 4 4 8 2 2]*max(1,nseg);
        strips.t  = t * ones(size(strips.l));
        strips.id = mid * ones(size(strips.l));
        strips.closed = false; %open shape
        % Corner radii between each adjacent straight segment
        if r > 0
            strips.r   = r * ones(1,10);         % there are 10 corners
            strips.rn  = 4 * ones(1,10);         % 4 strips per arc
            strips.rt  = t * ones(1,10);
            strips.rid = mid * ones(1,10);
        else
            % no corners
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'hat'
        % User inputs (out-to-out dims + inner radius)
        D   = P.section.D;
        B   = P.section.B;
        H   = P.section.H;
        rin = P.section.rin;
        t   = P.section.t;
        %convert to centerline
        d = D - t/2;
        b = B - t;
        h = H - t;
        if rin==0
           r=0; %respect sharp corners
        else
            r = rin + 0.5*t;
        end
        %build snakey inputs
        strips.l  = [d,  b,  h,  b,  d];
        strips.q  = [0 90 0 -90 0]*pi/180;  % degrees -> rad
        base_n    = [2,   4,   8,  4,   2];
        strips.n  = max(1,nseg) * base_n; %allows finder discretization
        strips.t  = t * ones(size(strips.l));
        strips.id = mid * ones(size(strips.l));
        strips.closed = false;
        % Corner radii between each adjacent straight segment
        if r > 0
            strips.r   = r * ones(1,4);         % there are 4 corners
            strips.rn  = 4 * ones(1,4);         % 4 strips per arc
            strips.rt  = t * ones(1,4);
            strips.rid = mid * ones(1,4);
        else
            % no corners
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'ndeck'
        % Section inputs
        w   = P.section.w;
        h   = P.section.h;
        bs   = P.section.bs;
        b2   = P.section.b2;
        rin = P.section.rin;
        t   = P.section.t;
        %convert to centerline
        qc=atan2(h,(bs-b2)/2);
        c=h/sin(qc);
        b1=w/3-b2-2*h/tan(qc);
        if rin==0
           r=0; %respect sharp corners
        else
            r = rin + 0.5*t;
        end
        qc=qc*180/pi;
        %straight line segments (centerline)
        strips.l= [b2/2 c  b1 c  b2 c  b1 c   b2 c  b1 c   b2 b2/2];
        strips.q= [0    qc 0 -qc 0  qc 0  -qc 0  qc 0  -qc 0  qc]*pi/180;
        strips.n= [2    6  4  6  2  6  4  6   2  6  4  6   2  2]*max(1,nseg);
        strips.t= [t    t  t  t  t  t  t  t   t  t  t  t   t  t]; 
        strips.id=mid*ones(1,14);
        strips.closed=false; %open shape
        %corner radius between segments (if desired)
        strips.r=  r*ones(1,13); 
        strips.rn= 4*ones(1,13);
        strips.rt= t*ones(1,13);
        strips.rid=mid*ones(1,13);
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'rhs'
        % Section inputs
        H   = P.section.H;
        hf   = P.section.hf;
        B   = P.section.B;
        bf   = P.section.bf;
        t   = P.section.t;
        %RHS, centerline dimensions
        ro=mean([(H-hf)/2;(B-bf)/2]);
        if hf>=H || bf>B
           r=0; %force sharp corners
        else
           r = ro - t/2;
        end
        h=H-t;
        b=B-t;
        %straight line segments (centerline)
        strips.l= [b h b h];
        strips.q= [0 90 180 270]*pi/180;
        strips.n= [4 8 4 8]*max(1,nseg);
        strips.t= [t t t t]; 
        strips.id=[mid mid mid mid];
        strips.closed=true; %closed shape
        %corner radius between segments (if desired)
        strips.r=[r r r r]; 
        strips.rn=[4 4 4 4];
        strips.rt=[t t t t];
        strips.rid=[mid mid mid mid];
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'angle'
        % Section inputs
        D   = P.section.D;
        B   = P.section.B;
        rin   = P.section.rin;
        t   = P.section.t;
        %centerline       
        d=D-t/2;
        b=B-t/2;
        if rin==0
            r=0;
        else
            r=rin+t/2;
        end
        %angle
        strips.l= [d b];
        strips.q= [-90 0]*pi/180;
        strips.n= [6 6]*max(1,nseg);
        strips.t= [t t]; 
        strips.id=[mid mid];
        strips.closed=false; %open shape
        %corner radius between segments (if desired)
        strips.r=[r]; 
        strips.rn=[4];
        strips.rt=[t];
        strips.rid=[mid];
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'chs'
        % Section inputs
        OD   = P.section.OD;
        t   = P.section.t;
        %CHS, centerline flat approximation
        r=(OD-t)/2;
        n=32*max(1,nseg);
        dq=2*pi/(n-1);
        %straight line segments (centerline)
        strips.l= dq*r*ones(1,n);
        strips.q= pi/2:dq:2*pi+pi/2;
        strips.n= 1*ones(1,n);
        strips.t= t*ones(1,n); 
        strips.id=mid*ones(1,n);
        strips.closed=true; 
        %build model
        [node,elem]=snakey(strips);
        %build sharp model variant for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1; %1 strip per dimension
        stripsD.r=[]; stripsD.rn=[]; stripsD.rt=[]; stripsD.rid=[]; %no radius
        [nodeD,elemD]=snakey(stripsD);
        %lengths
        %lengths=make_lengths(strips,nlen); %no flats so do circle differently
        lengths=logspace(log10(OD/64),log10(OD*20),nlen)';
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'isect'
        % Section inputs
        D=P.section.D;
        bf=P.section.bf;
        tf=P.section.tf;
        tw=P.section.tw;
        %I-section, centerline dimensions
        h=D-tf;
        %branch of the I-section without half flanges
        strips.l= [bf/2 h bf/2];
        strips.q= [0 90 180]*pi/180;
        strips.n= [3 8 3]*max(1,nseg);
        strips.t= [tf tw tf]; 
        strips.id=[mid mid mid];
        strips.closed=false; %open shape
        %call snakey to generate strips
        [node,elem]=snakey(strips);
        %generate top 1/2 flange
        strips2.l= [bf/2];
        strips2.q= [0]*pi/180;
        strips2.n= [3]*max(1,nseg);
        strips2.t= [tf]; 
        strips2.id=[mid];
        strips2.origin.type='start'; %or 'lowerleft'
        strips2.origin.x=bf/2; %x coordinate of the start or lowerleft
        strips2.origin.z=h;    %z coordinate of the start or lowerleft
        [node2,elem2]=snakey(strips2);
        %generate bottom 1/2 flange
        strips3=strips2;
        strips3.origin.z=0;
        [node3,elem3]=snakey(strips3);
        %merge node and elem with node2 and elem2
        tol=min([tw tf])/100; %to find nodes to be merged
        [node, elem] = merge_branch(node, elem, node2, elem2, tol);
        %merge node ane elem with node3 and elem3
        [node, elem] = merge_branch(node, elem, node3, elem3, tol);
        %repeat for sharp corner model
        stripsD=strips;
        stripsD.n=0*strips.n+1;
        [nodeD,elemD]=snakey(stripsD);
        stripsD2=strips2;
        stripsD2.n=0*stripsD2.n+1;
        [nodeD2,elemD2]=snakey(stripsD2);
        stripsD3=strips3;
        stripsD3.n=0*stripsD3.n+1;
        [nodeD3,elemD3]=snakey(stripsD3);
        [nodeD, elemD] = merge_branch(nodeD, elemD, nodeD2, elemD2, tol);
        [nodeD, elemD] = merge_branch(nodeD, elemD, nodeD3, elemD3, tol);
        %package up for output back to template
        %note for strips we are giving just the first branch, not merged
        %not sure we need to pass strips back to GUI, for now we do
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'tee'
        % Section inputs
        D=P.section.D;
        bf=P.section.bf;
        tf=P.section.tf;
        tw=P.section.tw;
        %Tee-section, centerline dimensions
        h=D-tf;
        %branch of the T-section without half flange
        strips.l= [h bf/2];
        strips.q= [90 180]*pi/180;
        strips.n= [8 3]*max(1,nseg);
        strips.t= [tw tf]; 
        strips.id=[mid mid];
        strips.closed=false; %open shape
        %call snakey to generate strips
        [node,elem]=snakey(strips);
        %generate top 1/2 flange
        strips2.l= [bf/2];
        strips2.q= [0]*pi/180;
        strips2.n= [3]*max(1,nseg);
        strips2.t= [tf]; 
        strips2.id=[mid];
        strips2.origin.type='start'; %or 'lowerleft'
        strips2.origin.x=bf/2; %x coordinate of the start or lowerleft
        strips2.origin.z=h;    %z coordinate of the start or lowerleft
        [node2,elem2]=snakey(strips2);
        %merge node and elem with node2 and elem2
        tol=min([tw tf])/100; %to find nodes to be merged
        [node, elem] = merge_branch(node, elem, node2, elem2, tol);
        %repeat for sharp corner n=1 model for dimensioning
        stripsD=strips;
        stripsD.n=0*strips.n+1;
        [nodeD,elemD]=snakey(stripsD);
        stripsD2=strips2;
        stripsD2.n=0*stripsD2.n+1;
        [nodeD2,elemD2]=snakey(stripsD2);
        [nodeD, elemD] = merge_branch(nodeD, elemD, nodeD2, elemD2, tol);
        %package up for output back to template
        %note for strips we are giving just the first branch, not merged
        %not sure we need to pass strips back to GUI, for now we do
        %lengths
        lengths=make_lengths(strips,nlen);       
        %package up for output back to template
        model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths);

    case 'general'
        % User-defined open, singly-branched polyline (centerline)
        l_deg   = P.section.l(:)';       % row
        th_deg  = P.section.theta(:)';   % degrees, absolute
        t_vec   = P.section.t(:)';       % row
        n_vec   = P.section.n(:)';       % row
        r0      = P.section.r;           % single corner radius (centerline)
        % Basic validation / cleanup
        % Remove any zero/NaN length rows
        good = isfinite(l_deg) & isfinite(th_deg) & isfinite(t_vec) & isfinite(n_vec) & (l_deg > 0);
        l_deg  = l_deg(good);
        th_deg = th_deg(good);
        t_vec  = t_vec(good);
        n_vec  = n_vec(good);
        if isempty(l_deg)
            error('General template: no valid segments. Provide at least one row with l>0.');
        end
        % Build strips
        strips.l      = l_deg;
        strips.q      = th_deg * pi/180;                 % degrees -> radians
        strips.n      = max(1, round(n_vec)) * max(1,nseg);
        strips.t      = t_vec;
        strips.id     = mid * ones(size(strips.l));
        strips.closed = false;
        % Corner radii between adjacent segments (N-1 corners)
        if numel(strips.l) >= 2 && isfinite(r0) && r0 > 0
            strips.r   = r0 * ones(1, numel(strips.l)-1);
            strips.rn  = 4  * ones(1, numel(strips.l)-1);
            % For now, use "adjacent thickness" convention (take t of the *first* segment)
            strips.rt  = strips.t(1:end-1);
            strips.rid = mid * ones(1, numel(strips.l)-1);
        else
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end
        % Build model
        [node, elem] = snakey(strips);
        % Dimensioning model: sharp, one element per segment
        stripsD       = strips;
        stripsD.n     = 0*strips.n + 1;
        stripsD.r     = [];
        stripsD.rn    = [];
        stripsD.rt    = [];
        stripsD.rid   = [];
        [nodeD, elemD] = snakey(stripsD);
        % Lengths (same logic)
        lengths = make_lengths(strips, nlen);
        %make the model
        model = make_model(templateID, P, strips, node, elem, stripsD, nodeD, elemD, lengths);


    otherwise
        error('build_strips_from_params:unknownTemplate',...
              'Template "%s" not implemented yet.',templateID);
end

%output used across all models, add to model
model.prop=[mid E E nu nu E/(2*(1+nu))];
model.springs=0;
model.constraints=0;
model.BC='S-S';
for i=1:length(model.lengths)
    model.m_all{i}=[1];
end
model.neigs=10; %GUI default is 20

end

%========================================================================
function lengths=make_lengths(strips,nlen)
        lenmin=min(strips.l)/2;
        lenmax=max(strips.l)*20;
        lengths=logspace(log10(lenmin),log10(lenmax),nlen)';
end


%========================================================================
function model=make_model(templateID,P,strips,node,elem,stripsD,nodeD,elemD,lengths)
    model.templateID=templateID;
    model.P=P;
    model.strips=strips;
    model.node=node;
    model.elem=elem;
    model.stripsD=stripsD;
    model.nodeD=nodeD;
    model.elemD=elemD;
    model.lengths=lengths;
end
