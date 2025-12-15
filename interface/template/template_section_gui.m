function template_section_gui(templateID, mainHandles)
%TEMPLATE_SECTION_GUI  Generic section-template GUI (multi-shape ready).
%
%   template_section_gui(templateID, mainHandles)
%
%   To start only 'lippedc' was implemented end-to-end:
%     - asks for dimensions, e.g. D,B,H,rin,t
%     - builds strips via build_strips_from_params
%     - calls snakey(strips)
%     - displays in crossect
%
%   mainHandles is reserved for integration with the main CUFSM GUI;
%   you can pass [] for now during testing.

if nargin < 1 || isempty(templateID)
    templateID = 'lippedc';
end
if nargin < 2
    mainHandles = [];
end

%---------------------- create figure -------------------------------
fig = figure('Name',['CUFSM Template: ' upper(templateID)],...
             'NumberTitle','off',...
             'MenuBar','none',...
             'ToolBar','none',...
             'Color',[0.95 0.95 0.95],...
             'Units','pixels',...
             'Resize','off',...
             'WindowStyle','modal');

fig.Position(3:4) = [1000 600]*1.2;   % width x height

% store shared state
S = struct();
S.templateID   = templateID;
S.mainHandles  = mainHandles;
S.node         = [];
S.elem         = [];
S.prop         = [];
S.lengths      = [];
S.springs      = [];
S.constraints  = [];
S.nseg_default = 1;       % strips-per-segment multiplier
S.flags        = [0 0 0 0 0 0 0 0 1 0]; %flags:[node# element# mat# stress# stresspic coord constraints springs origin propaxis] 1 means show
% --- material database entered row-wise:  name | E (ksi) | nu -----------
S.materialData = { ...
    'Steel cold-formed (AISI-Imperial)',    29500, 0.30; ...
    'Steel hot-rolled (AISC-Imperial)',     29000, 0.30; ...
    'Steel (EC3-SI)',                       210000, 0.30; ...
    'Aluminum 6061-T6 (ADM-Imperial)',      10000, 0.33  ...
};
% convert to struct array with fields: name, E, nu
S.materialDB = cell2struct(S.materialData, {'name','E','nu'}, 2);



%---------------------- layout panels -------------------------------
% left (controls)
S.leftPanel = uipanel('Parent',fig,'Units','normalized',...
                      'Position',[0.02 0.02 0.40 0.96],...
                      'BackgroundColor',get(fig,'Color'),...
                      'BorderType','none');

% right (preview)
S.axPanel = uipanel('Parent',fig,'Units','normalized',...
                    'Position',[0.45 0.08 0.53 0.88],...
                    'Title','Preview (with centerline dimensions)',...
                    'FontName','Helvetica',...
                    'FontSize',10);

S.ax = axes('Parent',S.axPanel,...
            'Units','normalized',...
            'Position',[0.08 0.10 0.88 0.80]);
axis(S.ax,'equal'); axis(S.ax,'off');

% plot options button in upper-right of preview
S.btnPlotOptions = uicontrol('Parent',fig,...
          'Style','pushbutton',...
          'Units','normalized',...
          'Position',[0.98-0.03 0.96-0.025 0.03 0.025],...  
          'String','...',...
          'TooltipString','plot options',...
          'FontName','Helvetica','FontSize',10,...
          'Callback',@(src,evt) togglePlotOptions(fig));

% plot options panel directly below that button, hidden by default
S.plotPanel = uipanel('Parent',S.axPanel,...
                      'Units','normalized',...
                      'Position',[0.8 0.62 0.20 0.38],... % just under the button
                      'Title','Toggle display',...
                      'FontName','Helvetica',...
                      'FontSize',10,...
                      'Visible','off');

%---------------------- common options (top of left) ----------------
S.commonPanel = uipanel('Parent',S.leftPanel,'Units','normalized',...
                        'Position',[0.02 0.70 0.96 0.28],...
                        'Title','Common options',...
                        'FontName','Helvetica',...
                        'FontSize',10);

%% Row 1: Material, E, nu
uicontrol('Parent',S.commonPanel,'Style','text',...
          'Units','normalized','Position',[0.05 0.70 0.18 0.20],...
          'String','Material:',...
          'BackgroundColor',get(fig,'Color'),...
          'HorizontalAlignment','left');

materialNames = S.materialData(:,1);   % first column: names

S.popupMaterial = uicontrol('Parent',S.commonPanel,'Style','popupmenu',...
          'Units','normalized','Position',[0.23 0.73 0.30 0.20],...
          'String',materialNames,...
          'Value',1,...
          'Callback',@(src,evt) onMaterialChanged(src,evt,fig));

uicontrol('Parent',S.commonPanel,'Style','text',...
          'Units','normalized','Position',[0.55 0.70 0.06 0.20],...
          'String','E =',...
          'BackgroundColor',get(fig,'Color'),...
          'HorizontalAlignment','left');

S.editE = uicontrol('Parent',S.commonPanel,'Style','edit',...
          'Units','normalized','Position',[0.61 0.73 0.14 0.20],...
          'String','29500',...     % default in ksi; adjust as needed
          'Callback',@(src,evt) onParamChanged(src,evt,fig));

uicontrol('Parent',S.commonPanel,'Style','text',...
          'Units','normalized','Position',[0.77 0.70 0.06 0.20],...
          'String','ν =',...
          'BackgroundColor',get(fig,'Color'),...
          'HorizontalAlignment','left');

S.editNu = uicontrol('Parent',S.commonPanel,'Style','edit',...
          'Units','normalized','Position',[0.83 0.73 0.12 0.20],...
          'String','0.30',...      % default Poisson's ratio; adjust as needed
          'Callback',@(src,evt) onParamChanged(src,evt,fig));

%% Row 2: Existing section
uicontrol('Parent',S.commonPanel,'Style','text',...
          'Units','normalized','Position',[0.05 0.40 0.25 0.20],...
          'String','Sections:',...
          'BackgroundColor',get(fig,'Color'),...
          'HorizontalAlignment','left');

S.popupExistingSection = uicontrol('Parent',S.commonPanel,'Style','popupmenu',...
          'Units','normalized','Position',[0.30 0.43 0.65 0.20],...
          'String',{'(none)'},...  % will be filled with section list later
          'Value',1,...
          'Callback',@(src,evt) onParamChanged(src,evt,fig));

%% Row 3: Strip density and number of lengths
uicontrol('Parent',S.commonPanel,'Style','text',...
          'Units','normalized','Position',[0.05 0.10 0.25 0.20],...
          'String','Strip density:',...
          'BackgroundColor',get(fig,'Color'),...
          'HorizontalAlignment','left');

S.popupStripDensity = uicontrol('Parent',S.commonPanel,'Style','popupmenu',...
          'Units','normalized','Position',[0.30 0.13 0.18 0.20],...
          'String',{'1','2','3','4'},...
          'Value',1,...
          'Callback',@(src,evt) onParamChanged(src,evt,fig));

uicontrol('Parent',S.commonPanel,'Style','text',...
          'Units','normalized','Position',[0.55 0.10 0.20 0.20],...
          'String','Lengths:',...
          'BackgroundColor',get(fig,'Color'),...
          'HorizontalAlignment','left');

S.editNlengths = uicontrol('Parent',S.commonPanel,'Style','edit',...
          'Units','normalized','Position',[0.72 0.13 0.23 0.20],...
          'String','100',...         % default number of lengths
          'Callback',@(src,evt) onParamChanged(src,evt,fig));

%---------------------- section parameters panel --------------------
S.paramPanel = uipanel('Parent',S.leftPanel,'Units','normalized',...
                       'Position',[0.02 0.08 0.96 0.60],...
                       'Title','Section dimensions',...
                       'FontName','Helvetica',...
                       'FontSize',10);

S.paramDefs  = [];
S.paramEdits = struct();


%---------------------- bottom buttons ------------------------------
btnY = 0.02;
btnH = 0.05;
gap  = 0.05;
btnW = (1 - 2*gap - 2*gap)/3;   % left gap, two internal gaps, right gap

x1 = gap;
x2 = gap + btnW + gap;
x3 = gap + 2*(btnW + gap);

S.btnUpdate = uicontrol('Parent',S.leftPanel,'Style','pushbutton',...
          'Units','normalized','Position',[x1 btnY btnW btnH],...
          'String','Update preview',...
          'Callback',@(src,evt) onUpdatePreview(fig));

S.btnSave = uicontrol('Parent',S.leftPanel,'Style','pushbutton',...
          'Units','normalized','Position',[x2 btnY btnW btnH],...
          'String','Save...',...
          'Callback',@(src,evt) onSaveModel(fig));

S.btnAccept = uicontrol('Parent',S.leftPanel,'Style','pushbutton',...
          'Units','normalized','Position',[x3 btnY btnW btnH],...
          'String','Close',...
          'Callback',@(src,evt) onClose(fig));

% save state
guidata(fig,S);

% build parameter fields for this templateID
buildParamFields(fig);
buildPlotOptionsPanel(fig);

% initial preview
onUpdatePreview(fig);

uiwait(fig);   % wait for Close

end  % template_section_gui main


%====================================================================
function buildParamFields(fig)
S = guidata(fig);

delete(get(S.paramPanel,'Children'));   % clear panel contents
S.paramEdits = struct();
S.paramDefs  = [];

if strcmpi(S.templateID,'general')
    buildGeneralFields(fig);   % NEW
    return;
else
    % existing behavior
    S.paramDefs = template_section_params(S.templateID);

    n = size(S.paramDefs,1);
    y0 = 0.88;
    dy = 0.105;

    for k = 1:n
        fieldName = S.paramDefs{k,1};
        label     = S.paramDefs{k,2};
        defVal    = S.paramDefs{k,3};
        y = y0 - (k-1)*dy;

        uicontrol('Parent',S.paramPanel,'Style','text',...
            'Units','normalized','Position',[0.05 y 0.55 0.08],...
            'String',label,'HorizontalAlignment','left',...
            'BackgroundColor',get(fig,'Color'));

        hEdit = uicontrol('Parent',S.paramPanel,'Style','edit',...
            'Units','normalized','Position',[0.65 y 0.30 0.10],...
            'String',num2str(defVal),'Tag',fieldName,...
            'Callback',@(src,evt) onParamChanged(src,evt,fig));

        S.paramEdits.(fieldName) = hEdit;
    end
end

guidata(fig,S);
end
% function buildParamFields(fig)
% % Build the editable fields in S.paramPanel from get_section_param_defs
% 
% S = guidata(fig);
% 
% % clear old controls
% delete(get(S.paramPanel,'Children'));
% 
% % get template-specific param list
% S.paramDefs = template_section_params(S.templateID);
% 
% n = size(S.paramDefs,1);
% S.paramEdits = struct();
% 
% % layout: 1 column of label+edit pairs, top to bottom
% y0 = 0.88;
% dy = 0.105;
% 
% for k = 1:n
%     fieldName = S.paramDefs{k,1};
%     label     = S.paramDefs{k,2};
%     defVal    = S.paramDefs{k,3};
% 
%     y = y0 - (k-1)*dy;
% 
%     % label
%     uicontrol('Parent',S.paramPanel,'Style','text',...
%               'Units','normalized',...
%               'Position',[0.05 y 0.55 0.08],...
%               'String',label,...
%               'HorizontalAlignment','left',...
%               'BackgroundColor',get(fig,'Color'));
% 
%     % edit
%     hEdit = uicontrol('Parent',S.paramPanel,'Style','edit',...
%               'Units','normalized',...
%               'Position',[0.65 y 0.30 0.10],...
%               'String',num2str(defVal),...
%               'Tag',fieldName,...
%               'Callback',@(src,evt) onParamChanged(src,evt,fig));
% 
%     S.paramEdits.(fieldName) = hEdit;
% end
% 
% guidata(fig,S);
% end

%====================================================================
function buildGeneralFields(fig)
S = guidata(fig);

% Column headers: ℓ, θ, t, n
colNames = {char(8467), char(952), 't', 'n'};   % ℓ and θ in unicode
colFormat = {'numeric','numeric','numeric','numeric'};
colEditable = [true true true true];

% reasonable default starter rows for genral case
data = [
    2    270   0.1   2
    4    180   0.1   4
    6     45   0.1   8
    4     90   0.1   4
    2      0   0.1   2
];

% --- Table (slightly narrower to make room for buttons) ---
S.paramEdits.generalTable = uitable('Parent',S.paramPanel,...
    'Units','normalized',...
    'Position',[0.05 0.18 0.82 0.75],...   % was 0.90 wide → now 0.82
    'Data',data,...
    'ColumnName',colNames,...
    'ColumnFormat',colFormat,...
    'ColumnEditable',colEditable,...
    'RowName',[],...
    'CellSelectionCallback',@(src,evt) onGeneralSelectRow(src,evt,fig),...
    'CellEditCallback',@(src,evt) onParamChanged(src,evt,fig));

% --- Button column on right of table ---
btnX = 0.89;     % column x
btnW = 0.07;     % button width
btnH = 0.08;     % button height
btnY0 = 0.82;    % top button y
btnDY = 0.10;    % spacing

S.paramEdits.btnAddRow = uicontrol('Parent',S.paramPanel,'Style','pushbutton',...
    'Units','normalized','Position',[btnX btnY0 btnW btnH],...
    'String','+',...                  % simple, readable
    'FontSize',12,...
    'TooltipString','Add row',...
    'Callback',@(src,evt) onGeneralAddRow(fig));

S.paramEdits.btnDelRow = uicontrol('Parent',S.paramPanel,'Style','pushbutton',...
    'Units','normalized','Position',[btnX btnY0-btnDY btnW btnH],...
    'String','-',...
    'FontSize',12,...
    'TooltipString','Delete selected row',...
    'Callback',@(src,evt) onGeneralDeleteRow(fig));

S.paramEdits.btnClear = uicontrol('Parent',S.paramPanel,'Style','pushbutton',...
    'Units','normalized','Position',[btnX btnY0-2*btnDY btnW btnH],...
    'String',char(8634),...            % ⟲ (looks like "reset/clear")
    'FontSize',12,...
    'TooltipString','Clear table',...
    'Callback',@(src,evt) onGeneralClearTable(fig));

% "centerline corner radius, r ="
uicontrol('Parent',S.paramPanel,'Style','text',...
    'Units','normalized','Position',[0.05 0.06 0.50 0.08],...
    'String','centerline corner radius, r =',...
    'HorizontalAlignment','right',...
    'BackgroundColor',get(fig,'Color'));

S.paramEdits.r = uicontrol('Parent',S.paramPanel,'Style','edit',...
    'Units','normalized','Position',[0.56 0.06 0.16 0.10],...
    'String','0',...
    'Callback',@(src,evt) onParamChanged(src,evt,fig));

guidata(fig,S);
end

%====================================================================
function onGeneralSelectRow(src, evt, fig)
S = guidata(fig);
if isempty(evt.Indices)
    set(src,'UserData',[]);
else
    set(src,'UserData',evt.Indices(1)); % store selected row
end
guidata(fig,S);
end

%====================================================================
function onGeneralAddRow(fig)
S = guidata(fig);
T = get(S.paramEdits.generalTable,'Data');
if isempty(T), T = zeros(0,4); end

% default new row (carry last thickness, n if possible)
newRow = [0 0 0.1 1];
if size(T,1) >= 1
    newRow(3) = T(end,3);
    newRow(4) = T(end,4);
end

T = [T; newRow];
set(S.paramEdits.generalTable,'Data',T);
guidata(fig,S);
onUpdatePreview(fig);
end

%====================================================================
function onGeneralDeleteRow(fig)
S = guidata(fig);
hT = S.paramEdits.generalTable;

T = get(hT,'Data');
if isempty(T), return; end

idx = get(hT,'UserData');  % we'll store last selected row here
if isempty(idx) || idx < 1 || idx > size(T,1)
    % if nothing selected, delete last row (least surprising)
    idx = size(T,1);
end

T(idx,:) = [];
set(hT,'Data',T);
set(hT,'UserData',[]); % clear selection
guidata(fig,S);
onUpdatePreview(fig);
end

%====================================================================
function onGeneralClearTable(fig)
S = guidata(fig);
set(S.paramEdits.generalTable,'Data',zeros(0,4));
set(S.paramEdits.generalTable,'UserData',[]);
guidata(fig,S);
onUpdatePreview(fig);
end


%====================================================================
function P = collectParams(fig)
% Read GUI fields into a simple struct P

S = guidata(fig);

% common
%P.units = S.units;
% strip density multiplier from dropdown (values 1,2,3,4)
strs = get(S.popupStripDensity,'String');
val  = get(S.popupStripDensity,'Value');
P.nseg = str2double(strs{val});
if isnan(P.nseg) || P.nseg <= 0
    P.nseg = 1;
end
% nlengths
strs = get(S.editNlengths,'String');
P.nlen = str2double(strs);
if isnan(P.nlen) || P.nlen <= 0
    P.nlen = 50;
end
% E
strs = get(S.editE,'String');
P.E = str2double(strs);
if isnan(P.E) || P.E <= 0
    P.E = 29500;
end
% nu
strs = get(S.editNu,'String');
P.nu = str2double(strs);
if isnan(P.nu) || P.nu <= 0
    P.nu = 0.3;
end


% section-specific
P.section = struct();

if strcmpi(S.templateID,'general')
    T = get(S.paramEdits.generalTable,'Data');

    % drop fully-empty rows (common when user adds rows)
    if isempty(T)
        T = zeros(0,4);
    end
    % keep rows where at least one entry is nonzero/nonempty
    keep = any(~isnan(T) & T~=0, 2);
    T = T(keep,:);

    P.section.l     = T(:,1);
    P.section.theta = T(:,2);   % degrees
    P.section.t     = T(:,3);
    P.section.n     = T(:,4);

    P.section.r = str2double(get(S.paramEdits.r,'String'));
    if isnan(P.section.r) || P.section.r < 0
        P.section.r = 0;
    end

    return; % skip normal template paramDefs parsing
end

%existing template
for k = 1:size(S.paramDefs,1)
    fname = S.paramDefs{k,1};
    hEdit = S.paramEdits.(fname);
    val   = str2double(get(hEdit,'String'));
    P.section.(fname) = val;
end

end


%====================================================================
function onUnitsChanged(src,~,fig)
S = guidata(fig);
choices = get(src,'String');
S.units = choices{ get(src,'Value') };
guidata(fig,S);
onUpdatePreview(fig);   % optional: re-run
end


%====================================================================
function onParamChanged(~,~,fig)
% For now: whenever any param changes, just recompute preview
onUpdatePreview(fig);
end


%====================================================================
function onUpdatePreview(fig)
S = guidata(fig);
P = collectParams(fig);

try
    % Build the full model (including dimensioning model)
    model = template_build_model(S.templateID, P);

    % Store for later use
    S.model       = model;
    S.node        = model.node;
    S.elem        = model.elem;
    S.prop        = model.prop;
    S.lengths     = model.lengths;
    S.springs     = getfield_default(model,'springs',0);
    S.constraints = getfield_default(model,'constraints',0);
    S.BC          = getfield_default(model,'BC',0);
    S.m_all       = getfield_default(model,'m_all',0);
    
    guidata(fig,S);

    springs     = S.springs;
    constraints = S.constraints;
    flags       = S.flags;

    % ---- Plot actual model (sharp or rounded) ----
    cla(S.ax);
    axes(S.ax); %#ok<LAXES>
    crossect(model.node, model.elem, S.ax, springs, constraints, flags);
    title(S.ax,'');

    % ---- Overlay dimensions using dimensioning model ----
    hold(S.ax,'on');

    nDim = size(model.elemD,1);

    for j = 1:nDim
        n1 = model.elemD(j,2);
        n2 = model.elemD(j,3);

        p1 = model.nodeD(n1,2:3);
        p2 = model.nodeD(n2,2:3);

        tLocal = model.elemD(j,4);
        offset = 2 * tLocal;

        dx = p2(1) - p1(1);
        dz = p2(2) - p1(2);
        L  = sqrt(dx*dx + dz*dz);
        label = sprintf('%.2f', L);

        draw_dimension(S.ax, p1, p2, offset, label);
    end

    hold(S.ax,'off');

catch ME
    cla(S.ax);
    axes(S.ax);
    text(0.5,0.5,ME.message,'HorizontalAlignment','center');
end
end





% function onUpdatePreview(fig)
% S = guidata(fig);
% 
% P = collectParams(fig);
% 
% try
%     % Build strips from params for this template
%     strips = build_strips_from_params(S.templateID, P);
% 
%     % Call your existing snakey
%     [node,elem] = snakey(strips);
% 
%     % ----------------------------------------------------
%     % Build a SHARP-CORNER version of the same geometry 
%     % ----------------------------------------------------
%     strips_sharp = strips;       % copy
%     strips_sharp.r   = [];       % no radii 
%     strips_sharp.rn  = [];
%     strips_sharp.rt  = [];
%     strips_sharp.rid = [];
% 
%     % run snakey again (sharp)
%     [nodeS, elemS] = snakey(strips_sharp);
%     nNodesS = size(nodeS,1);
% 
%     S.node = node;
%     S.elem = elem;
%     guidata(fig,S);
% 
%     % Simple material etc. just for preview
%     springs     = 0;
%     constraints = 0;
%     % flags: [node# elem# mat# stress# stresspic coord constraints springs origin propaxis]
%     flags = S.flags;
% 
%     cla(S.ax);
%     axes(S.ax); %#ok<LAXES>
%     crossect(node,elem,S.ax,springs,constraints,flags);
%     title(S.ax,'');
% 
%     %add dimensons to the plot based on strips.l
%     %build up correct node numbering indices
%     nodePtr = 1;
%     stripStart = zeros(length(strips.l),1);
%     stripEnd   = zeros(length(strips.l),1);    
%     for j = 1:length(strips.l)
%         stripStart(j) = nodePtr;
%         nodePtr = nodePtr + strips.n(j);    % flat subdivisions
%         %if j <= length(strips.r) && ~isempty(strips.r)
%         %    nodePtr = nodePtr + strips.rn(j); % arc subdivisions
%         %end
%         stripEnd(j) = nodePtr;
%     end
%     stripEnd(stripEnd > nNodesS) = 1; %closed shape loops back
%     %overlay plot
%     hold(S.ax,'on');   
%     for j = 1:length(strips.l)
%         % start/end nodes from SHARP model
%         p1 = [ nodeS(stripStart(j),2), nodeS(stripStart(j),3) ];
%         p2 = [ nodeS(stripEnd(j),2),   nodeS(stripEnd(j),3)   ];
%         % local thickness for this strip
%         tLocal = strips.t(j);
%         % make offset e.g. 2t away from the centerline
%         offset = 2 * tLocal;
%         draw_dimension(S.ax, p1, p2, offset, sprintf('%.2f', strips.l(j)));
%     end
%     hold(S.ax,'off');
% 
% 
% catch ME
%     cla(S.ax);
%     axes(S.ax);
%     text(0.5,0.5,ME.message,...
%          'HorizontalAlignment','center');
% end
% 
% end


%====================================================================
function onClose(fig)
if isvalid(fig)
    uiresume(fig);
    delete(fig);
end
end

%====================================================================
function buildPlotOptionsPanel(fig)
% Build checkboxes for plot flags inside S.plotPanel
% flags:[node# elem# mat# stress# stresspic coord constraints springs origin propaxis]

S = guidata(fig);

if ~isfield(S,'flags')
    % safety, but it really should exist
    S.flags = zeros(1,10);
end

labels = { ...
    'node #'; ...
    'element #'; ...
    'material #'; ...
    'stress mag.'; ...
    'stress dist.'; ...
    'coordinates'; ...
    'constraints'; ...
    'springs'; ...
    'origin'; ...
    'centroidal axes' };

nFlags = numel(S.flags);
if nFlags ~= numel(labels)
    error('buildPlotOptionsPanel:flagSize',...
          'S.flags must have 10 entries.');
end

% clear old controls if rebuilding
delete(get(S.plotPanel,'Children'));

% layout: one column, top to bottom (similar feel to pre2)
y0 = 0.90;
dy = 0.09;
w  = 0.90;
x  = 0.05;
h  = 0.08;

for k = 1:nFlags
    ypos = y0 - (k-1)*dy;

    uicontrol('Parent',S.plotPanel,...
              'Style','checkbox',...
              'Units','normalized',...
              'Position',[x ypos w h],...
              'String',labels{k},...
              'Value',S.flags(k),...
              'BackgroundColor',get(S.plotPanel,'BackgroundColor'),...
              'Callback',@(src,evt) onToggleFlag(fig,k,src));
end

end

%====================================================================
function togglePlotOptions(fig)
S = guidata(fig);
if strcmpi(get(S.plotPanel,'Visible'),'on')
    set(S.plotPanel,'Visible','off');
else
    set(S.plotPanel,'Visible','on');
end
end

%====================================================================
function onToggleFlag(fig, idx, src)
S = guidata(fig);
S.flags(idx) = logical(get(src,'Value'));
guidata(fig,S);
onUpdatePreview(fig);   % replot with new flags
end

%====================================================================
function onMaterialChanged(src,~,fig)
    S = guidata(fig);

    idx = get(src,'Value');      % which material is selected
    mat = S.materialDB(idx);     % struct with fields name, E, nu

    set(S.editE,  'String', num2str(mat.E));
    set(S.editNu, 'String', num2str(mat.nu));

    guidata(fig,S);
    onParamChanged(src,[],fig);  % if you want global update
end

%====================================================================
function onSaveModel(fig)
S = guidata(fig);

% Make sure we have a model (or build one if needed)
try
    P = collectParams(fig);
    S.model = template_build_model(S.templateID, P);

    % keep GUI state consistent too
    S.prop        = getfield_default(S.model,'prop',[]);
    S.lengths     = getfield_default(S.model,'lengths',[]);
    S.springs     = getfield_default(S.model,'springs',0);
    S.constraints = getfield_default(S.model,'constraints',0);
    guidata(fig,S);

catch ME
    errordlg(ME.message,'Save failed');
    return;
end
model = S.model;

% Pick filename
[fn, pn] = uiputfile('*.mat','Save CUFSM model as...');
if isequal(fn,0) || isequal(pn,0)
    return; % user cancelled
end
outfile = fullfile(pn,fn);

% Pull variables (use empty defaults if not present yet)
prop        = getfield_default(model,'prop',[]);
node        = getfield_default(model,'node',[]);
elem        = getfield_default(model,'elem',[]);
lengths     = getfield_default(model,'lengths',[]);
springs     = getfield_default(model,'springs',0);
constraints = getfield_default(model,'constraints',0);
BC          = getfield_default(model,'BC',0);
m_all       = getfield_default(model,'m_all',0);

save(outfile,'prop','node','elem','lengths','springs','constraints','BC','m_all');

figure(fig);
drawnow;
end

%====================================================================
function v = getfield_default(S, name, defaultVal)
if isstruct(S) && isfield(S,name) && ~isempty(S.(name))
    v = S.(name);
else
    v = defaultVal;
end
end