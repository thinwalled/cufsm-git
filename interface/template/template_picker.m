function templateID = template_picker(iconDir)
%BWS and ChatGPT 12 6 2025
%TEMPLATE_PICKER  GUI to choose a CUFSM template by icon.
%   templateID = TEMPLATE_PICKER() opens a modal window with a grid of
%   section icons and returns a short string ID for the chosen template.
%
%   templateID = '' if the user closes or presses Cancel.

    if nargin < 1 || isempty(iconDir)
        iconDir = fileparts(mfilename('fullpath'));
    end

    % ---------------------------------------------------------------------
    % 1) Templates: [icon filename, long label, ID]
    % ---------------------------------------------------------------------
    templates = {
        'icon_lippedc_test.png',  'Lipped Channel',   'lippedc';
        'icon_hds_test.png',      'Heavy Duty Stud',  'hds';
        'icon_sigma_test.png',    'Sigma',             'sigma';
        'icon_hat_test.png',      'Hat',               'hat';
        'icon_lippedz_test.png',  'Lipped Zee',       'lippedz';
        'icon_Ndeck_test.png',    'N Deck',           'ndeck';
        'icon_L_test.png',        'Angle',            'angle';
        'icon_I_test.png',        'I Section',        'isect';
        'icon_T_test.png',        'T Section',        'tee';
        'icon_RHS_test.png',      'RHS / SHS',        'rhs';
        'icon_chs_test.png',      'CHS',              'chs';
        'icon_general_test.png',       'General',          'general';
    };

    nTemplates = size(templates,1);

    % ---------------------------------------------------------------------
    % 2) Create modal figure
    % ---------------------------------------------------------------------
    fig = figure('Name','CUFSM Cross-Section Templates',...
                 'NumberTitle','off',...
                 'MenuBar','none',...
                 'ToolBar','none',...
                 'Color',[0.95 0.95 0.95],...
                 'Units','normalized',...
                 'Resize','off',...
                 'WindowStyle','modal');

    fig.Position(3:4) = [0.5 0.6];   % width x height in pixels

    % ---------------------------------------------------------------------
    % 3) Grid layout
    % ---------------------------------------------------------------------
    nCols = 4;
    nRows = ceil(nTemplates / nCols);

    leftMargin   = 0.06;
    rightMargin  = 0.06;
    bottomMargin = 0.12;
    topMargin    = 0.10;
    hSpacing     = 0.06;
    vSpacing     = 0.10;

    % fraction of each cell reserved vertically for the icon;
    % the rest is for the label below.
    iconFracHeight = 0.75;  % 75% icon, 25% text

    % Maximum cell size from available space
    maxCellHeight = (1 - topMargin - bottomMargin - (nRows-1)*vSpacing) / nRows;
    maxCellWidth  = (1 - leftMargin - rightMargin - (nCols-1)*hSpacing) / nCols;

    cellHeight = maxCellHeight;
    cellWidth  = maxCellWidth;

    % Now enforce SQUARE ICONS inside each cell.
    % The icon side must fit inside (cellWidth x (cellHeight*iconFracHeight)).
    maxIconWidth  = cellWidth;
    maxIconHeight = cellHeight * iconFracHeight;

    iconSide = min(maxIconWidth, maxIconHeight);   % normalized units
    iconWidth  = iconSide;
    iconHeight = iconSide;

    % ---------------------------------------------------------------------
    % 4) Title
    % ---------------------------------------------------------------------
    uicontrol('Style','text',...
              'Parent',fig,...
              'Units','normalized',...
              'Position',[0.05 0.93 0.9 0.05],...
              'String','Select a cross-section template:',...
              'FontName','Helvetica',...
              'FontSize',12,...
              'HorizontalAlignment','left',...
              'BackgroundColor',get(fig,'Color'));

    % ---------------------------------------------------------------------
    % 5) Create buttons
    % ---------------------------------------------------------------------
    for k = 1:nTemplates
        row = nRows - floor((k-1)/nCols);   % top row has highest y
        col = mod(k-1, nCols) + 1;

        xCell = leftMargin  + (col-1)*(cellWidth + hSpacing);
        yCell = bottomMargin + (row-1)*(cellHeight + vSpacing);

        iconFile = fullfile(iconDir, templates{k,1});
        if ~exist(iconFile,'file')
            warning('template_picker:missingIcon',...
                    'Icon file not found: %s', iconFile);
            img = 0.8*ones(64,64,3);
        else
            [img,~,alpha] = imread(iconFile);

            % Blend any transparency with the figure background
            if ~isempty(alpha)
                img = im2double(img);
                alphaNorm = double(alpha)/255;
                bg = repmat(reshape(get(fig,'Color'),1,1,3), ...
                            size(img,1), size(img,2), 1);
                for c = 1:3
                    img(:,:,c) = img(:,:,c).*alphaNorm + ...
                                 bg(:,:,c).*(1-alphaNorm);
                end
            end
        end

        if isa(img,'uint8'),   img = double(img)/255;   end
        if isa(img,'uint16'),  img = double(img)/65535; end

        % Square icon centered horizontally at the top of the cell
        btnX = xCell + (cellWidth - iconWidth)/2;
        btnY = yCell + (cellHeight - iconHeight);

        uicontrol('Style','pushbutton',...
                  'Parent',fig,...
                  'Units','normalized',...
                  'Position',[btnX btnY iconWidth 1.2*iconHeight],...
                  'CData',img,...
                  'Tag',templates{k,3},...
                  'TooltipString',templates{k,2},...
                  'BackgroundColor',[1 1 1],...
                  'Callback',@(src,evt) template_picker_cb(src,evt,fig));
        
        % label under button (full cell width)
        uicontrol('Style','text',...
                  'Parent',fig,...
                  'Units','normalized',...
                  'Position',[xCell yCell-0.01 cellWidth 0.03],...
                  'String',templates{k,2},...
                  'HorizontalAlignment','center',...
                  'FontName','Helvetica',...
                  'FontSize',10,...
                  'BackgroundColor',get(fig,'Color'));
    end

    % ---------------------------------------------------------------------
    % 6) Cancel button
    % ---------------------------------------------------------------------
    uicontrol('Style','pushbutton',...
              'Parent',fig,...
              'Units','normalized',...
              'Position',[0.75 0.02 0.2 0.06],...
              'String','Cancel',...
              'FontName','Helvetica',...
              'FontSize',10,...
              'Callback',@(src,evt) cancelPicker(fig));

    % default output
    setappdata(fig,'TemplateID','');
    uiwait(fig);

    if isvalid(fig)
        templateID = getappdata(fig,'TemplateID');
        delete(fig);
    else
        templateID = '';
    end
end

function cancelPicker(fig)
    if isvalid(fig)
        setappdata(fig,'TemplateID','');
        uiresume(fig);
    end
end