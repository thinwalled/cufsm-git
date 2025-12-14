function defs = template_section_params(templateID)
%Key variables and default values for the cross-section templates
% Return {fieldName, label, default} rows

switch lower(templateID)

    case 'lippedc'
        defs = {
            'H',    'out-to-out web depth, H=',       8.0;
            'B',    'out-to-out flange width, B=',    4.0;
            'D',    'out-to-out lip length, D=',      1.0;
            'rin',  'inner corner radius, rᵢₙ=',      0.20;
            't',    'thickness, t=',                  0.10;
        };

    case 'hds'
        defs = {
            'H',    'out-to-out web depth, H=',       8.0;
            'B',    'out-to-out flange width, B=',    4.0;
            'D1',    'out-to-out lip length, D=',      1.0;
            'D2',    'out-to-out return lip, D2=',     0.5;
            'rin',  'inner corner radius, rᵢₙ=',      0.20;
            't',    'thickness, t=',                  0.10;
        };

    case 'lippedz'
        defs = {
            'H',    'out-to-out web depth, H=',       8.0;
            'B',    'out-to-out flange width, B=',    4.0;
            'D',    'out-to-out lip length, D=',      1.0;
            'qlip', 'Lip angle (deg), θ=',            50.0;
            'rin',  'inner corner radius, rᵢₙ=',      0.20;
            't',    'thickness, t=',                  0.10;
        };

    case 'sigma'
        defs = {
            'B',  'out-to-out flange width, B=',    3.0;
            'A',  'out-to-CL web flat, A=',         1.25;
            'C',  'CL-to-CL web return inset, C=',      1.0;
            'E',  'CL-to-CL web return along, E=',        0.625;
            'N',  'CL-to-CL web inside flat, N=',   2.25;
            'D1', 'out-to-out flange lip, D1=',     0.7234;
            'D2', 'out-to-out flange return, D2=',  0.5;
            'rin','inner corner radius, rᵢₙ=',      0.105;
            't',  'thickness, t=',                  0.1017; 
        };

    case 'hat'
        defs = {
            'H',    'out-to-out web depth, H=',       8.0;
            'B',    'out-to-out flange width, B=',    4.0;
            'D',    'out-to-out lip length, D=',      1.0;
            'rin',  'inner corner radius, rᵢₙ=',      0.20;
            't',    'thickness, t=',                  0.10;
        };

    case 'ndeck'
        defs = {
            'w', 'CL-to-CL cover width, w=',    24.0;
            'h', 'CL-to-CL depth, h=',          3.0;
            'bs','CL-to-CL top flute gap, b_s=',  2.625;
            'b2','CL-to-CL rib bottom, b_2=',   1.875;
            'rin',  'inner corner radius, rᵢₙ=',      2*0.0474;
            't',    'thickness, t=',                  0.0474;
        };

    case 'rhs'
        defs = {
            'H','out-to-out depth, H=', 14.0;
            'hf','flat depth, hf=',     12.6;
            'B','out-to-out width, B=', 10.0;
            'bf','flat width, bf=',     8.6;
            't','thickness, t=',        0.465;
        };

    case 'angle'
        defs = {
            'D','out-to-out depth, D=', 6.0;
            'B','out-to-out width, B=', 4.0;
            'rin',  'inner corner radius, rᵢₙ=',      0;
            't','thickness, t=',        0.500;
        };

    case 'chs'
        defs = {
            'OD','outside diameter, OD=', 12.0;
            't','thickness, t=',        0.465;
        };

    case 'isect'
        defs = {
            'D','out-to-out overall depth, D=',   14.0;
            'bf','flange width, b_f=',  6.0;
            'tf','flange thickness, t_f=',        0.50;
            'tw','web thickness, t_w=',           0.25;
        };

    case 'tee'
        defs = {
            'D','out-to-out overall depth, D=',   10.0;
            'bf','flange width, b_f=',  6.0;
            'tf','flange thickness, t_f=',        0.50;
            'tw','web thickness, t_w=',           0.25;
        };

    otherwise  % 
        defs = {
        };
end
end