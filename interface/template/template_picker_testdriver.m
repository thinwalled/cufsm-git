%test driving template picker
%BWS 12 6 2025

%fire up template picker
choice=template_picker('./template_icons');
if isempty(choice)
    return;    % user cancelled
end

%possible choices as of this writing
%{'lippedc'; 'hds'; 'sigma'; 'hat';
% 'lippedz'; 'ndeck';'L';'isect';
% 'tee';'rhs'; 'chs';}
switch choice
    case 'lippedc'
        template_section_gui(choice,[]);
    case 'lippedz'
        template_section_gui(choice,[]);
    case 'sigma'
        template_section_gui(choice,[]);
    case 'hat'
        template_section_gui(choice,[]);
    case 'ndeck'
        template_section_gui(choice,[]);
    case 'rhs'
        template_section_gui(choice,[]);
    case 'chs'
        template_section_gui(choice,[]);
    case 'isect'
        template_section_gui(choice,[]);
    case 'tee'
        template_section_gui(choice,[]);
    case 'hds'
        template_section_gui(choice,[]);
    case 'angle'
        template_section_gui(choice,[]);
    case 'general'
        template_section_gui(choice,[]);
end