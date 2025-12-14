%BWS
%2025 12 6
%Create png files from matlab input files that can be used as icons for
%input to templates

matFiles = {
'I_test.mat'		
'chs_test.mat'		
'lippedz_test.mat'
'Ndeck_test.mat'		
'hat_test.mat'		
'sigma_test.mat'
'RHS_test.mat'		
'hds_test.mat'
'T_test.mat'		
'lippedc_test.mat'
'L_test.mat'
    };

outDir = 'template_icons';
if ~exist(outDir,'dir'), mkdir(outDir); end

for k = 1:numel(matFiles)
    [~,name] = fileparts(matFiles{k});
    pngFile = fullfile(outDir, ['icon_' name '.png']);
    make_cufsm_template_icon(matFiles{k}, pngFile, 128);
end



function make_cufsm_template_icon(matFile, pngFile, iconSize)
%MAKE_CUFSM_ICON Create a square padded PNG icon from CUFSM .mat section
%
%   make_cufsm_icon('lippedc_test.mat','icon_lippedc_test.png',128)

    if nargin < 3
        iconSize = 128;
    end

    % ----- load -----
    S = load(matFile);
    node = S.node;
    elem = S.elem;
    if isfield(S,'springs'),      springs = S.springs;      else, springs = []; end
    if isfield(S,'constraints'),  constraints = S.constraints; else, constraints = []; end
    if isequal(springs,0), springs=[]; end
    if isequal(constraints,0), constraints=[]; end

    % Flags for drawing, see crosssect for each flag
    flags = [0 0 0 0 0 0 0 0 1 0];

    % ----- draw CUFSM cross-section -----
    fig = figure('Visible','off','Color','w','Units','pixels',...
                 'Position',[100 100 400 400]);
    ax = axes('Parent',fig,'Position',[0 0 1 1]); hold(ax,'on');
    crossect(node,elem,fig,springs,constraints,flags);
    axis(ax,'equal','off');

    drawnow;
    frame = getframe(fig);
    [im,~] = frame2im(frame);
    close(fig);

    % ----- pad to square -----
    [h,w,~] = size(im);
    Smax = max(h,w);
    sq = uint8(255*ones(Smax,Smax,3));

    y0 = floor((Smax-h)/2)+1;
    x0 = floor((Smax-w)/2)+1;
    sq(y0:y0+h-1, x0:x0+w-1, :) = im;

    % ----- ADD EXTRA BORDER (IMPORTANT) -----
    border = 50;  % pixels of padding to avoid edge clipping
    big = uint8(255*ones(Smax+2*border, Smax+2*border, 3));
    big(border+1:border+Smax, border+1:border+Smax, :) = sq;

    % ----- resize to final icon -----
    icon = imresize(big,[iconSize iconSize],'bicubic');

    imwrite(icon, pngFile);
end