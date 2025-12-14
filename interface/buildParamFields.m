function buildParamFields(fig)
%Creates uicontrols for template as a function of the defined
%parameter fields

S = guidata(fig);

% clear any existing controls in paramPanel
delete(get(S.paramPanel,'Children'));

% get definition of params for this template
% each row: { fieldName, label, defaultValue }
S.paramDefs = get_section_param_defs(S.templateID);

n = size(S.paramDefs,1);
S.paramEdits = struct();

% layout: 2 columns of labels/edits
nCols = 2;
nRows = ceil(n / nCols);

for k = 1:n
    fieldName = S.paramDefs{k,1};
    label     = S.paramDefs{k,2};
    defVal    = S.paramDefs{k,3};

    col = mod(k-1,nCols) + 1;
    row = nRows - floor((k-1)/nCols);

    w = 0.45;  % width of each column
    h = 1/(nRows+0.5);
    x0 = 0.05 + (col-1)*(w+0.05);
    y0 = 0.05 + (row-1)*h;

    % label
    uicontrol('Parent',S.paramPanel,'Style','text',...
              'Units','normalized',...
              'Position',[x0 y0+0.45*h w 0.4*h],...
              'String',label,...
              'HorizontalAlignment','left',...
              'BackgroundColor',get(fig,'Color'));

    % edit
    hEdit = uicontrol('Parent',S.paramPanel,'Style','edit',...
              'Units','normalized',...
              'Position',[x0 y0 w 0.45*h],...
              'String',num2str(defVal),...
              'Tag',fieldName,...
              'Callback',@(src,evt) onParamChanged(src,evt,fig));

    S.paramEdits.(fieldName) = hEdit;
end

guidata(fig,S);
end