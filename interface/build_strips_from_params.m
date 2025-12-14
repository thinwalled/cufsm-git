function strips = build_strips_from_params(templateID, P)
%BUILD_STRIPS_FROM_PARAMS  Convert GUI params -> SNAKEY strips struct.
%
% P.units       - 'in' or 'mm'  (not used yet, but available)
% P.nseg        - strips-per-segment multiplier (scalar)
% P.section.*   - template-specific fields, e.g. D,B,H,rin,t

nseg = max(1, round(P.nseg));

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
        if rin==0;
           r=0; %respect sharp corners
        else
            r = rin + 0.5*t;
        end
        %build snakey inputs
        strips.l  = [d,  b,  h,  b,  d];
        strips.q  = [270, 180, 90, 0, -90]*pi/180;  % degrees -> rad
        base_n    = [2,   4,   8,  4,   2];
        strips.n  = max(1,nseg) * base_n; %allows finder discretization
        strips.t  = t * ones(size(strips.l));
        strips.id = 100 * ones(size(strips.l));
        strips.closed = false;
        % Corner radii between each adjacent straight segment
        if r > 0
            strips.r   = r * ones(1,4);         % there are 4 corners
            strips.rn  = 4 * ones(1,4);         % 4 strips per arc
            strips.rt  = t * ones(1,4);
            strips.rid = 100 * ones(1,4);
        else
            % no corners
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end

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
        if rin==0;
           r=0; %respect sharp corners
        else
            r = rin + t/2;
        end
        %straight line segments (centerline)
        strips.l= [d c b a b c d];
        strips.q= [90 0 -90 180 90 0 -90]*pi/180;
        strips.n= [2 4 4 8 4 4 2]*max(1,nseg);
        strips.t= [t t t t t t t]; 
        strips.id=[100 100 100 100 100 100 100];
        strips.closed=false; %open shape
        %corner radius between segments (if desired)
        strips.r=[r r r r r r]; 
        strips.rn=[4 4 4 4 4 4];
        strips.rt=[t t t t t t];
        strips.rid=[100 100 100 100 100 100];

    case 'lippedz'
        % User inputs (out-to-out dims + inner radius)
        H   = P.section.H;
        B   = P.section.B;
        D   = P.section.D;
        q   = P.section.qlip
        rin = P.section.rin;
        t   = P.section.t;
        %convert to centerline
        d = D - t/2;
        b = B - t;
        h = H - t;
        if rin==0;
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
        strips.id = 100 * ones(size(strips.l));
        strips.closed = false;
        % Corner radii between each adjacent straight segment
        if r > 0
            strips.r   = r * ones(1,4);         % there are 4 corners
            strips.rn  = 4 * ones(1,4);         % 4 strips per arc
            strips.rt  = t * ones(1,4);
            strips.rid = 100 * ones(1,4);
        else
            % no corners
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end

    case 'sigma'
        % Section inputs
        B   = P.section.B;
        A   = P.section.A;
        C   = P.section.C;
        E   = P.section.E
        N   = P.section.N
        D1   = P.section.D1
        D2   = P.section.D2
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
        if rin==0;
           r=0; %respect sharp corners
        else
            r = rin + 0.5*t;
        end
        %build snakey inputs
        strips.l= [d2 d1 b a ce n ce a b d1 d2];
        strips.q= [90 180 -90 0 qce 0 -qce 0 90 180 -90]*pi/180;
        strips.n= [2 2 8 4 4 4 4 4 8 2 2]*max(1,nseg);
        strips.t  = t * ones(size(strips.l));
        strips.id = 9 * ones(size(strips.l));
        strips.closed = false; %open shape
        % Corner radii between each adjacent straight segment
        if r > 0
            strips.r   = r * ones(1,10);         % there are 10 corners
            strips.rn  = 4 * ones(1,10);         % 4 strips per arc
            strips.rt  = t * ones(1,10);
            strips.rid = 9 * ones(1,10);
        else
            % no corners
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end

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
        if rin==0;
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
        strips.id = 100 * ones(size(strips.l));
        strips.closed = false;
        % Corner radii between each adjacent straight segment
        if r > 0
            strips.r   = r * ones(1,4);         % there are 4 corners
            strips.rn  = 4 * ones(1,4);         % 4 strips per arc
            strips.rt  = t * ones(1,4);
            strips.rid = 100 * ones(1,4);
        else
            % no corners
            strips.r   = [];
            strips.rn  = [];
            strips.rt  = [];
            strips.rid = [];
        end

    case 'ndeck'
        % Section inputs
        w   = P.section.w;
        h   = P.section.h;
        bs   = P.section.bs;
        b2   = P.section.b2
        rin = P.section.rin;
        t   = P.section.t;
        %convert to centerline
        qc=atan2(h,(bs-b2)/2);
        c=h/sin(qc);
        b1=w/3-b2-2*h/tan(qc);
        if rin==0;
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
        strips.id=[9    9  9  9  9  9  9  9   9  9  9  9   9  9];
        strips.closed=false; %open shape
        %corner radius between segments (if desired)
        strips.r=  r*ones(1,13); 
        strips.rn= 4*ones(1,13);
        strips.rt= t*ones(1,13);
        strips.rid=9*ones(1,13);

    case 'rhs'
        % Section inputs
        H   = P.section.H;
        hf   = P.section.hf;
        B   = P.section.B;
        bf   = P.section.bf;
        t   = P.section.t;
        %RHS, centerline dimensions
        ro=mean([(H-hf)/2;(B-bf)/2]);
        if hf>=H | bf>B;
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
        strips.id=[100 100 100 100];
        strips.closed=true; %closed shape
        %corner radius between segments (if desired)
        strips.r=[r r r r]; 
        strips.rn=[4 4 4 4];
        strips.rt=[t t t t];
        strips.rid=[100 100 100 100];

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
        strips.id=[9 9];
        strips.closed=false; %open shape
        %corner radius between segments (if desired)
        strips.r=[r]; 
        strips.rn=[4];
        strips.rt=[t];
        strips.rid=[9];

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
        strips.id=9*ones(1,n);
        strips.closed=true; 

    otherwise
        error('build_strips_from_params:unknownTemplate',...
              'Template "%s" not implemented yet.',templateID);
end