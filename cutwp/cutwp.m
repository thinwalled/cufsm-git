function cutwp(command_str)

if nargin == 0
    command_str = 'initialize';
end

if ~strcmp(command_str,'initialize')
    % RETRIEVE HANDLES AND REDEFINE THE HANDLE VARIABLES.
    % Assume that the current figure contains the 
    % cutwp GUI.
    h_fig = gcf;
    
    if ~strcmp(get(h_fig,'Tag'),'cutwp_figure')
        % If the current figure does not have the right
        % Tag, find the one that does.
        h_figs = get(0,'children');
        h_fig = findobj(h_figs,'flat',...
            'Tag','cutwp_figure');
        if length(h_fig) == 0
            % If the cutwp GUI does not exist
            % initialize it. Then run the command string
            % that was originally requested.
            cutwp('initialize');
            cutwp(command_str);
            return;
        end
    end
    
    % At this point we know that h_fig is the handle
    % to the figure containing the GUI of interest to
    % this function.  Therefore we can use this figure
    % handle to cut down on the number of objects
    % that need to be searched for Tag names as follows:
    
    ed_coord = findobj(h_fig(1),'Tag','ed_coord');
    ed_ends = findobj(h_fig(1),'Tag','ed_ends');
    ed_KL1 = findobj(h_fig(1),'Tag','ed_KL1');
    ed_KL2 = findobj(h_fig(1),'Tag','ed_KL2');
    ed_KL3 = findobj(h_fig(1),'Tag','ed_KL3');
    ed_exy = findobj(h_fig(1),'Tag','ed_exy');
    ed_c = findobj(h_fig(1),'Tag','ed_c');
    ed_E = findobj(h_fig(1),'Tag','ed_E');
    ed_v = findobj(h_fig(1),'Tag','ed_v');
    ed_dist = findobj(h_fig(1),'Tag','ed_dist');
    rad_Pe = findobj(h_fig(1),'Tag','rad_Pe');
    rad_Me = findobj(h_fig(1),'Tag','rad_Me');
    rad_Me1 = findobj(h_fig(1),'Tag','rad_Me1');
    rad_Me2 = findobj(h_fig(1),'Tag','rad_Me2');
    rad_Me12 = findobj(h_fig(1),'Tag','rad_Me12');
    rad_origin = findobj(h_fig(1),'Tag','rad_origin');
    rad_centroid = findobj(h_fig(1),'Tag','rad_centroid');
    rad_axisxy = findobj(h_fig(1),'Tag','rad_axisxy');
    rad_axis12 = findobj(h_fig(1),'Tag','rad_axis12');
    rad_shear = findobj(h_fig(1),'Tag','rad_shear');
    rad_axial = findobj(h_fig(1),'Tag','rad_axial');
    rad_deform = findobj(h_fig(1),'Tag','rad_deform');
    rad_node = findobj(h_fig(1),'Tag','rad_node');
    text_A = findobj(h_fig(1),'Tag','text_A');
    text_Ix = findobj(h_fig(1),'Tag','text_Ix');
    text_Iy = findobj(h_fig(1),'Tag','text_Iy');
    text_Ixy = findobj(h_fig(1),'Tag','text_Ixy');
    text_I1 = findobj(h_fig(1),'Tag','text_I1');
    text_I2 = findobj(h_fig(1),'Tag','text_I2');
    text_theta = findobj(h_fig(1),'Tag','text_theta');
    text_J = findobj(h_fig(1),'Tag','text_J');
    text_centroid = findobj(h_fig(1),'Tag','text_centroid');
    text_shear = findobj(h_fig(1),'Tag','text_shear');
    text_Cw = findobj(h_fig(1),'Tag','text_Cw');
    text_B1 = findobj(h_fig(1),'Tag','text_B1');
    text_B2 = findobj(h_fig(1),'Tag','text_B2');
    text_Pe = findobj(h_fig(1),'Tag','text_Pe');
    text_Me1 = findobj(h_fig(1),'Tag','text_Me1');
    text_Me2 = findobj(h_fig(1),'Tag','text_Me2');
    text_mode = findobj(h_fig(1),'Tag','text_mode');
    text_maxmode = findobj(h_fig(1),'Tag','text_maxmode');
    statictext_KL1 = findobj(h_fig(1),'Tag','statictext_KL1');
    statictext_KL2 = findobj(h_fig(1),'Tag','statictext_KL2');
    statictext_exy1 = findobj(h_fig(1),'Tag','statictext_exy1');
    statictext_exy2 = findobj(h_fig(1),'Tag','statictext_exy2');
    statictext_J = findobj(h_fig(1),'Tag','statictext_J');
    statictext_shear = findobj(h_fig(1),'Tag','statictext_shear');
    statictext_Cw = findobj(h_fig(1),'Tag','statictext_Cw');
    statictext_B1 = findobj(h_fig(1),'Tag','statictext_B1');
    statictext_B2 = findobj(h_fig(1),'Tag','statictext_B2');
    statictext_Pe = findobj(h_fig(1),'Tag','statictext_Pe');
    statictext_Me1 = findobj(h_fig(1),'Tag','statictext_Me1');
    statictext_Me2 = findobj(h_fig(1),'Tag','statictext_Me2');
    statictext_buck = findobj(h_fig(1),'Tag','statictext_buck');
    statictext_dist = findobj(h_fig(1),'Tag','statictext_dist');
    slider = findobj(h_fig(1),'Tag','slider');
    
end

% INITIALIZE THE GUI SECTION.
if strcmp(command_str,'initialize')
    % Create the figure
    
    W = 963.5; H = 423.5;
    
    h_fig = figure('Color','w', ... 
        'Name','CUTWP Global Buckling Analysis of Thin-Walled Sections - 2006,2015 Updates', ...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'Units','normalized', ...
        'Position',[(1-W/1024)/2 (1-H/768)/2 W/1024 H/768], ...
        'Visible','on', ...
        'Renderer','zbuffer', ...
        'Tag','cutwp_figure');
    
    set(h_fig,'Visible','on');
    
    AW = 384; AH = 240;
    im = load('imcutwp');
    t_axes = axes('Parent',h_fig,'Position',[0.5-AW/W/2 0.5-AH/H/2 AW/W AH/H]); 
    image(im.im); 
    axis off;
    clear im;
    pause(2);
    delete(t_axes);

    
    a1.Parent = h_fig;
    a1.Units = 'normalized';
    a1.Style = 'frame';
    a1.visible = 'off';
    
    a2.Parent = h_fig;
    %a2.FontUnits = 'normalized';
    a2.Units = 'normalized';
    a2.HorizontalAlignment = 'left';
    a2.visible = 'on';
    
    a3.Parent = h_fig;
    a3.FontUnits = 'normalized';
    a3.Units = 'normalized';
    a3.HorizontalAlignment = 'left';
    a3.Enable = 'inactive';
    a3.visible = 'on';
    
    uicontrol(a1,'Position',[5/W 5/H 265/W 413.5/H]);
    uicontrol(a1,'Position',[5/W 5/H 265/W 257.5/H]);
    uicontrol(a1,'Position',[5/W 5/H 265/W 208.5/H]);
    uicontrol(a1,'Position',[5/W 5/H 265/W 119.5/H]);      
    uicontrol(a1,'Position',[5/W 5/H 265/W 70/H]);
    uicontrol(a1,'Position',[275/W 5/H 358.5/W 50/H]);
    uicontrol(a1,'Position',[275/W 5/H 179/W 50/H]);
    uicontrol(a1,'Position',[638.5/W 5/H 320/W 270/H]); 
    uicontrol(a1,'Position',[638.5/W 280/H 320/W 138.5/H]); 
    uicontrol(a1,'Position',[638.5/W 280/H 190/W 138.5/H]); 
    uicontrol(a1,'Position',[638.5/W 280/H 190/W 30/H]); 
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[10/W 266.5/H 125/W 112/H],... 
        'BackgroundColor','w',...
        'Max',2, ...
        'String',...
        ['1.565 -0.795';	...
            '1.565 -1.5  ';	...
            '1.094 -1.5  ';	...
            '0.563 -1.5  '; ...
            '0     -1.5  ';	...
            '0     -0.952';	...
            '0     -0.44 ';	...
            '0      0.44 ';	...
            '0      0.952';	...
            '0      1.5  ';	...
            '0.563  1.5  ';	...
            '1.094  1.5  ';	...
            '1.565  1.5  ';	...
            '1.565  0.795'], ...  
        'Style','edit', ...
        'Tag','ed_coord');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[140/W 266.5/H 125/W 112/H],... 
        'BackgroundColor','w',...
        'Max',2, ...
        'String', ...
        ['1  2  0.091 ';	...   
            '2  3  0.091 ';	...   
            '3  4  0.073 ';	...  
            '4  5  0.091 ';	...   
            '5  6  0.091 ';	...  
            '6  7  0.0455';	... 
            '7  8  0.091 ';	...  
            '8  9  0.0455';	... 
            '9  10 0.091 ';	...   
            '10 11 0.091 ';	...   
            '11 12 0.073 ';	...   
            '12 13 0.091 ';	...    
            '13 14 0.091 '], ...
        'Style','edit', ...
        'Tag','ed_ends');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[175/W 237.5/H 90/W 20/H],... 
        'BackgroundColor','w',...
        'String','29500', ...
        'Style','edit', ...
        'Tag','ed_E');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[175/W 217.5/H 90/W 20/H],... 
        'BackgroundColor','w',...
        'String','0.3', ...
        'Style','edit', ...
        'Tag','ed_v');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[175/W 168.5/H 90/W 20/H],... 
        'BackgroundColor','w',...
        'String','60', ...
        'Style','edit', ...
        'Tag','ed_KL1');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[175/W 148.5/H 90/W 20/H],... 
        'BackgroundColor','w',...
        'String','60', ...
        'Style','edit', ...
        'Tag','ed_KL2');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[175/W 128.5/H 90/W 20/H],... 
        'BackgroundColor','w',...
        'String','60', ...
        'Style','edit', ...
        'Tag','ed_KL3');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[140/W 30/H 125/W 20/H],... 
        'BackgroundColor','w',...
        'String',['0 0'], ...
        'Style','edit', ...
        'Tag','ed_exy');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[175/W 10/H 90/W 20/H],... 
        'BackgroundColor','w',...
        'String','0', ...
        'Style','edit', ...
        'Tag','ed_c');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[759/W 285/H 64.5/W 20/H],... 
        'BackgroundColor','w',...
        'String','1', ...
        'Style','edit', ...
        'Tag','ed_dist');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''Pe'');', ...
        'Position',[15/W 99.5/H 245/W 20/H],... 
        'Value',1, ...
        'String','Elastic Critical Axial Force, Pe', ...
        'Style','radio', ...
        'Tag','rad_Pe');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''Me'');', ...
        'Position',[15/W 79.5/H 245/W 20/H],... 
        'Value',0, ...
        'String','Elastic Critical Moment, Me', ...
        'Style','radio', ...
        'Tag','rad_Me');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''Me1'');', ...
        'Position',[15/W 50/H 245/W 20/H],... 
        'Value',0, ...
        'String','Bending about the 1-axis, Me1', ...
        'Style','radio', ...
        'Tag','rad_Me1');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''Me2'');', ...
        'Position',[15/W 30/H 245/W 20/H],... 
        'Value',0, ...
        'String','Bending about the 2-axis, Me2', ...
        'Style','radio', ...
        'Tag','rad_Me2');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''Me12'');', ...
        'Position',[15/W 10/H 160/W 20/H],... 
        'Value',0, ...
        'String','Biaxial Bending, Me1/Me2:', ...
        'Style','radio', ...
        'Tag','rad_Me12');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[648.5/W 390/H 85/W 20/H],... 
        'Value',0, ...
        'String','Origin', ...
        'Style','checkbox', ...
        'Tag','rad_origin');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[648.5/W 365/H 85/W 20/H],... 
        'Value',0, ...
        'String','Centroid', ...
        'Style','checkbox', ...
        'Tag','rad_centroid');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[648.5/W 340/H 85/W 20/H],... 
        'Value',0, ...
        'String','Axis (x,y)', ...
        'Style','checkbox', ...
        'Tag','rad_axisxy');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[648.5/W 315/H 85/W 20/H],... 
        'Value',1, ...
        'String','Axis (1,2)', ...
        'Style','checkbox', ...
        'Tag','rad_axis12');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[719.5/W 390/H 85/W 20/H],... 
        'Value',1, ...
        'String','Shear Center', ...
        'Style','checkbox', ...
        'Tag','rad_shear');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[719.5/W 365/H 85/W 20/H],... 
        'Value',1, ...
        'String','Axial Force', ...
        'Style','checkbox', ...
        'Tag','rad_axial');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[719.5/W 340/H 100/W 20/H],... 
        'Value',1, ...
        'String','Deformed Shape', ...
        'Style','checkbox', ...
        'Tag','rad_deform');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');', ...
        'Position',[719.5/W 315/H 100/W 20/H],... 
        'Value',0, ...
        'String','Node & Segment', ...
        'Style','checkbox', ...
        'Tag','rad_node');
    
    uicontrol(a3, ...
        'Position',[828.5/W 250/H 125/W 20/H],... 
        'String','0.62043', ...
        'Style','edit',...
        'Tag','text_A');
    
    uicontrol(a3, ...
        'Position',[828.5/W 230/H 125/W 20/H],... 
        'String','0.95329', ...
        'Style','edit',...
        'Tag','text_Ix');
    
    uicontrol(a3, ...
        'Position',[828.5/W 210/H 125/W 20/H],... 
        'String','0.26512', ...
        'Style','edit',...
        'Tag','text_Iy');
    
    uicontrol(a3, ...
        'Position',[828.5/W 190/H 125/W 20/H],... 
        'String','1.3878e-017', ...
        'Style','edit',...
        'Tag','text_Ixy');   
    
    uicontrol(a3, ...
        'Position',[828.5/W 170/H 125/W 20/H],... 
        'String','0.95329', ...
        'Style','edit',...
        'Tag','text_I1');
    
    uicontrol(a3, ...
        'Position',[828.5/W 150/H 125/W 20/H],... 
        'String','0.26512', ...
        'Style','edit',...
        'Tag','text_I2');
    
    uicontrol(a3, ...
        'Position',[828.5/W 130/H 125/W 20/H],... 
        'String','-2.0166e-017', ...
        'Style','edit',...
        'Tag','text_theta');  
    
    uicontrol(a3, ...
        'Position',[828.5/W 110/H 125/W 20/H],... 
        'String','0.0015399', ...
        'Style','edit',...
        'Tag','text_J');  
    
    uicontrol(a3, ...
        'Position',[828.5/W 90/H 125/W 20/H],... 
        'String','(0.65736,2.2368e-017)', ...
        'Style','edit',...
        'Tag','text_centroid');  
    
    uicontrol(a3, ...
        'Position',[828.5/W 70/H 125/W 20/H],... 
        'String','(-0.92772,1.4878e-016)', ...
        'Style','edit',...
        'Tag','text_shear');  
    
    uicontrol(a3, ...
        'Position',[828.5/W 50/H 125/W 20/H],... 
        'String','0.76369', ...
        'Style','edit',...
        'Tag','text_Cw');  
    
    uicontrol(a3, ...
        'Position',[828.5/W 30/H 125/W 20/H],... 
        'String','-4.2181e-016', ...
        'Style','edit',...
        'Tag','text_B1');  
    
    uicontrol(a3, ...
        'Position',[828.5/W 10/H 125/W 20/H],... 
        'String','9.1616', ...
        'Style','edit',...
        'Tag','text_B2');  
    
    uicontrol(a2, ...
        'Position',[385/W 30/H 20/W 17/H], ... 
        'HorizontalAlignment','right', ...
        'String','1', ...
        'Style','text', ...
        'Tag','text_mode');
    
    uicontrol(a2, ...
        'Position',[405/W 30/H 30/W 17/H], ... 
        'String','/3', ...
        'Style','text', ...
        'Tag','text_maxmode');
    
    uicontrol(a2, ...
        'Position',[648.5/W 250/H 115/W 17/H],... 
        'String','Area:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 230/H 115/W 17/H],... 
        'String','Moment of Inertia, Ix:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 210/H 115/W 17/H],... 
        'String','Moment of Inertia, Iy:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 190/H 115/W 17/H],... 
        'String','Product of Inertia, Ixy:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 170/H 115/W 17/H],... 
        'String','Moment of Inertia, I1:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 150/H 115/W 17/H],... 
        'String','Moment of Inertia, I2:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 130/H 180/W 17/H],... 
        'String','Angle for Principal Direction, theta:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 110/H 180/W 17/H],... 
        'String','Torsion Constant-Open Section, J:', ...
        'Style','text', ...
        'Tag','statictext_J');
    
    uicontrol(a2, ...
        'Position',[648.5/W 90/H 180/W 17/H],... 
        'String','Centroid Coordinates, (x,y):', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 70/H 180/W 17/H],... 
        'String','Shear Center Coordinates, (x,y):', ...
        'Style','text', ...
        'Tag','statictext_shear');
    
    uicontrol(a2, ...
        'Position',[648.5/W 50/H 180/W 17/H],... 
        'String','Warping Constant, Cw:', ...
        'Style','text', ...
        'Tag','statictext_Cw');
    
    uicontrol(a2, ...
        'Position',[648.5/W 30/H 90/W 17/H],... 
        'String','B1:', ...
        'Style','text', ...
        'Tag','statictext_B1');
    
    uicontrol(a2, ...
        'Position',[648.5/W 10/H 90/W 17/H],... 
        'String','B2:', ...
        'Style','text', ...
        'Tag','statictext_B2');
    
    uicontrol(a2, ...
        'Position',[464/W 20/H 35/W 17/H],... 
        'String','Pe:', ...
        'Style','text', ...
        'Tag','statictext_Pe');
    
    uicontrol(a2, ...
        'Position',[464/W 30/H 35/W 17/H],... 
        'String','Me1:', ...
        'Style','text', ...
        'Tag','statictext_Me1');
    
    uicontrol(a2, ...
        'Position',[464/W 10/H 35/W 17/H],... 
        'String','Me2:', ...
        'Style','text', ...
        'Tag','statictext_Me2');
    
    uicontrol(a3, ...
        'Position',[495/W 20/H 133.5/W 20/H],... 
        'String','15.509', ...
        'Style','edit',...
        'Tag','text_Pe');  
    
    uicontrol(a3, ...
        'Position',[495/W 30/H 133.5/W 20/H],... 
        'Style','edit',...
        'Tag','text_Me1');  
    
    uicontrol(a3, ...
        'Position',[495/W 10/H 133.5/W 20/H],... 
        'Style','edit',...
        'Tag','text_Me2');  
    
    uicontrol(a2, ...
        'CallBack','cutwp(''slider'');', ...
        'Position',[285/W 10/H 159/W 17/H],... 
        'Style','slider', ...
        'sliderstep',[0.5 0.5], ...
        'value',1, ...
        'Min',1,'Max',3, ...
        'Tag','slider');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''Open'');',... 
        'Position',[838.5/W 369/H 110/W 39.5/H],...
        'String','Open...');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''Save'');',... 
        'Position',[838.5/W 329.5/H 110/W 39.5/H],...
        'String','Save As...');
    
    uicontrol(a2, ...
        'CallBack','cutwp(''apply'');',... 
        'Position',[838.5/W 290/H 110/W 39.5/H],...
        'String','Apply');
    
    uicontrol(a2, ...
        'Position',[15/W 393.5/H 100/W 17/H],... 
        'String','Node Data:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[15/W 378.5/H 100/W 17/H],... 
        'String','x-coord., y-coord.', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[145/W 393.5/H 100/W 17/H],... 
        'String','Element Data:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[145/W 378.5/H 120/W 17/H],... 
        'String','node-i, node-j, thickness', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[15/W 191/H 250/W 17/H],... 
        'HorizontalAlignment','center', ...
        'String','Effective Unbraced Length', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[15/W 168.5/H 160/W 17/H],... 
        'String','Bending about the 1-axis, KL1:', ...
        'Style','text', ...
        'Tag','statictext_KL1');
    
    uicontrol(a2, ...
        'Position',[15/W 148.5/H 160/W 17/H],... 
        'String','Bending about the 2-axis, KL2:', ...
        'Style','text', ...
        'Tag','statictext_KL2');
    
    uicontrol(a2, ...
        'Position',[15/W 128.5/H 160/W 17/H],... 
        'String','Twisting about the 3-axis, KL3:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[15/W 30/H 120/W 17/H],... 
        'String','Eccentricities about the:', ...
        'Style','text', ...
        'Tag','statictext_exy1');
    
    uicontrol(a2, ...
        'Position',[145/W 50/H 100/W 17/H],... 
        'String','x-axis, y-axis', ...
        'Style','text', ...
        'Tag','statictext_exy2');
    
    uicontrol(a2, ...
        'Position',[15/W 237.5/H 110/W 17/H],... 
        'String','Elastic Modulus, E:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[15/W 217.5/H 110/W 17/H],... 
        'String','Poisson''s ratio, v:', ...
        'Style','text');
    
    uicontrol(a2, ...
        'Position',[648.5/W 285/H 110/W 17/H],... 
        'String','Displacement Factor:', ...
        'Style','text', ...
        'Tag','statictext_dist');
    
    uicontrol(a2, ...
        'Position',[310/W 30/H 80/W 17/H],... 
        'String','Buckling Mode:', ...
        'Style','text', ...
        'Tag','statictext_buck');
    
    
    %set(h_fig,'Color',[0.5 0.5 0.5]);
    
    
    set(findobj(h_fig,'Type','ui control'),'visible','on');
    set(findobj(h_fig,'Tag','ed_c'),'visible','off');
    set(findobj(h_fig,'Tag','rad_Me1'),'visible','off');
    set(findobj(h_fig,'Tag','rad_Me2'),'visible','off');
    set(findobj(h_fig,'Tag','rad_Me12'),'visible','off');
    set(findobj(h_fig,'Tag','text_Me1'),'visible','off');
    set(findobj(h_fig,'Tag','text_Me2'),'visible','off');
    set(findobj(h_fig,'Tag','statictext_Me1'),'visible','off');
    set(findobj(h_fig,'Tag','statictext_Me2'),'visible','off');
    
    axes('Parent',h_fig, ...
        'TickLength',[0 0],'xtick',[],'ytick',[],... 
        'color','k', ...
        'xcolor','k', ...
        'ycolor','k', ...
        'Position',[275/W 60/H 358.5/W 358.5/H]); 
    
    % Initialize the plot
    cutwp('apply');

  
    
    
elseif strcmp(command_str,'slider')  
    set(text_mode,'string',num2str(round(get(slider,'value'))));
    cutwp('apply');
elseif strcmp(command_str,'Pe')
    set(rad_Pe,'value',1);
    set(rad_Me,'value',0);
    set(rad_Me1,'value',0);
    set(rad_Me2,'value',0);
    set(rad_Me12,'value',0);
    set(text_mode,'string','1');
    set(slider,'value',1);
    cutwp('apply');
elseif strcmp(command_str,'Me')
    set(rad_Pe,'value',0);
    set(rad_Me,'value',1);
    set(rad_Me1,'value',1);
    set(rad_Me2,'value',0);
    set(rad_Me12,'value',0);
    set(text_mode,'string','1');
    set(slider,'value',1);
    cutwp('apply');
elseif strcmp(command_str,'Me1')
    set(rad_Pe,'value',0);
    set(rad_Me,'value',1);
    set(rad_Me1,'value',1);
    set(rad_Me2,'value',0);
    set(rad_Me12,'value',0);
    set(text_mode,'string','1');
    set(slider,'value',1);
    cutwp('apply');
elseif strcmp(command_str,'Me2')
    set(rad_Pe,'value',0);
    set(rad_Me,'value',1);
    set(rad_Me1,'value',0);
    set(rad_Me2,'value',1);
    set(rad_Me12,'value',0);
    set(text_mode,'string','1');
    set(slider,'value',1);
    cutwp('apply');
elseif strcmp(command_str,'Me12')
    set(rad_Pe,'value',0);
    set(rad_Me,'value',1);
    set(rad_Me1,'value',0);
    set(rad_Me2,'value',0);
    set(rad_Me12,'value',1);
    set(text_mode,'string','1');
    set(slider,'value',1);
    cutwp('apply');

elseif strcmp(command_str,'Open')
    %modified in November 2005 to allow CUFSM input files to be read into
    %CUTWP, thus allowing CUFSM users to use CUTWP more conveniently
    %use the existence of the variable "lengths" to determine if we are
    %reading in a CUFSM input file or a CUTWP input file
    [file,path] = uigetfile('*.mat', 'Open');
    if file~=0;
        load([path,file]);
        if exist('lengths')
            %CUFSM input file, need to do some translating to CUTWP
            %variable names
            coord=node(:,2:3);
            ends=elem(:,2:4);
            KL1=lengths(1);
            KL2=lengths(1);
            KL3=lengths(1);
            exy=[0 0];
            c=0;
            E=prop(1,2);
            v=prop(1,4);
            dist=1;
            force=1;
        else
            %CUTWP input file, can continue
        end
    else
        return
    end
    
    set(h_fig,'Name',['CUTWP Global Buckling Analysis of Thin-Walled Sections - ',file]);
    set(ed_coord,'String',sprintf('% -13.6G % -13.6G\n',coord'));
    set(ed_ends,'String',sprintf('%-3i %-3i %-13.6G\n',ends'));
    set(ed_KL1,'String',sprintf('%-13.6G',KL1'));
    set(ed_KL2,'String',sprintf('%-13.6G',KL2'));
    set(ed_KL3,'String',sprintf('%-13.6G',KL3'));
    set(ed_exy,'String',sprintf('%-13.6G %-13.6G',exy'));
    set(ed_c,'String',sprintf('%-13.6G',c'));
    set(ed_E,'String',sprintf('%-13.6G',E'));
    set(ed_v,'String',sprintf('%-13.6G',v'));
    set(ed_dist,'String',sprintf('%-13.6G',dist'));
    cutwp(force);
    cutwp('apply')

elseif strcmp(command_str,'FromCUFSM')
    %modified Open code to handle data coming from CUFSM 
    file=['fromcufsm'];
    %load(file);
    global prop node elem lengths %call from the global variable space
    coord=node(:,2:3);
    ends=elem(:,2:4);
    KL1=lengths(1);
    KL2=lengths(1);
    KL3=lengths(1);
    exy=[0 0];
    c=0;
    E=prop(1,2);
    v=prop(1,4);
    dist=1;
    force=1;  
    set(h_fig,'Name',['CUTWP Global Buckling Analysis of Thin-Walled Sections - ',file]);
    set(ed_coord,'String',sprintf('% -13.6G % -13.6G\n',coord'));
    set(ed_ends,'String',sprintf('%-3i %-3i %-13.6G\n',ends'));
    set(ed_KL1,'String',sprintf('%-13.6G',KL1'));
    set(ed_KL2,'String',sprintf('%-13.6G',KL2'));
    set(ed_KL3,'String',sprintf('%-13.6G',KL3'));
    set(ed_exy,'String',sprintf('%-13.6G %-13.6G',exy'));
    set(ed_c,'String',sprintf('%-13.6G',c'));
    set(ed_E,'String',sprintf('%-13.6G',E'));
    set(ed_v,'String',sprintf('%-13.6G',v'));
    set(ed_dist,'String',sprintf('%-13.6G',dist'));
    cutwp(force);
    cutwp('apply')
    
elseif strcmp(command_str,'Save')
    
    coord = str2num(get(ed_coord,'String'));
    ends = str2num(get(ed_ends,'String'));
    KL1 = str2num(get(ed_KL1,'String'));
    KL2 = str2num(get(ed_KL2,'String'));
    KL3 = str2num(get(ed_KL3,'String'));
    if get(rad_Pe,'Value');
        force = 'Pe';
    elseif get(rad_Me1,'Value');
        force = 'Me1';
    elseif get(rad_Me2,'Value');
        force = 'Me2';
    elseif get(rad_Me12,'Value');
        force = 'Me12';
    end
    exy = str2num(get(ed_exy,'String'));
    c = str2num(get(ed_c,'String'));
    E = str2num(get(ed_E,'String'));
    v = str2num(get(ed_v,'String'));
    dist = str2num(get(ed_dist,'String'));
    
    [newmatfile,newpath] = uiputfile('*.mat', 'Save As');
    if newmatfile~=0;
        save([newpath,newmatfile],'coord','ends','KL1','KL2','KL3','force','exy','E','v','dist','c');
        
        if (size(newmatfile,2)>3)&(strcmp(newmatfile((end-3):end),'.mat'))
            cutwp_print([newpath,newmatfile(1:(end-4))],coord,ends,KL1,KL2,KL3,exy,E,v,c);     
        else
            cutwp_print([newpath,newmatfile],coord,ends,KL1,KL2,KL3,exy,E,v,c);
        end
        
    end
    set(h_fig,'Name',['CUTWP Global Buckling Analysis of Thin-Walled Sections - ',newmatfile]);
    
elseif strcmp(command_str,'apply')
    
    if get(rad_Pe,'Value');
        force = 'Pe';
        set(rad_Me1,'Visible','off');
        set(rad_Me2,'Visible','off');
        set(rad_Me12,'Visible','off');   
        set(text_Pe,'Visible','on');
        set(text_Me1,'Visible','off');
        set(text_Me2,'Visible','off');
        set(statictext_Pe,'Visible','on','string','Pe:');
        set(statictext_Me1,'Visible','off');
        set(statictext_Me2,'Visible','off');                        
        set(statictext_KL1,'Visible','on');
        set(statictext_KL2,'Visible','on');
        set(statictext_exy1,'Visible','on');
        set(statictext_exy2,'Visible','on');
        set(ed_KL1,'Visible','on');
        set(ed_KL2,'Visible','on');
        set(ed_exy,'Visible','on');
        set(ed_c,'Visible','off');
        set(text_maxmode,'String','/3');
        set(slider,'Max',3,'sliderstep',[0.5 0.5]);
    elseif get(rad_Me,'Value');
        set(rad_Me1,'Visible','on');
        set(rad_Me2,'Visible','on');
        set(rad_Me12,'Visible','on'); 
        set(statictext_exy1,'Visible','off');
        set(statictext_exy2,'Visible','off');
        set(ed_exy,'Visible','off');
        set(ed_c,'Visible','on');
        set(text_maxmode,'String','/2');
        set(slider,'Max',2,'sliderstep',[1 1]);
        if get(rad_Me1,'Value');
            force = 'Me1';
            set(text_Pe,'Visible','on');
            set(text_Me1,'Visible','off');
            set(text_Me2,'Visible','off');
            set(statictext_Pe,'Visible','on','string','Me1:');
            set(statictext_Me1,'Visible','off');
            set(statictext_Me2,'Visible','off');             
            set(statictext_KL1,'Visible','off');
            set(statictext_KL2,'Visible','on');
            set(ed_KL1,'Visible','off');
            set(ed_KL2,'Visible','on');
        elseif get(rad_Me2,'Value');
            force = 'Me2';
            set(text_Pe,'Visible','on');
            set(text_Me1,'Visible','off');
            set(text_Me2,'Visible','off');
            set(statictext_Pe,'Visible','on','string','Me2:');
            set(statictext_Me1,'Visible','off');
            set(statictext_Me2,'Visible','off');     
            set(statictext_KL1,'Visible','on');
            set(statictext_KL2,'Visible','off');
            set(ed_KL1,'Visible','on');
            set(ed_KL2,'Visible','off');
        elseif get(rad_Me12,'Value');
            force = 'Me12';
            set(text_Pe,'Visible','off');
            set(text_Me1,'Visible','on');
            set(text_Me2,'Visible','on');
            set(statictext_Pe,'Visible','off');
            set(statictext_Me1,'Visible','on');
            set(statictext_Me2,'Visible','on');              
            set(statictext_KL1,'Visible','on');
            set(statictext_KL2,'Visible','on');
            set(ed_KL1,'Visible','on');
            set(ed_KL2,'Visible','on');
        end
    end
    
    % check input data   
    coord = str2num(get(ed_coord,'String'));
    ends = str2num(get(ed_ends,'String'));
    KL1 = str2num(get(ed_KL1,'String'));
    KL2 = str2num(get(ed_KL2,'String'));
    KL3 = str2num(get(ed_KL3,'String'));
    exy = str2num(get(ed_exy,'String'));
    c = str2num(get(ed_c,'String'));
    E = str2num(get(ed_E,'String'));
    v = str2num(get(ed_v,'String'));
    dist = str2num(get(ed_dist,'String'));
    mode = str2num(get(text_mode,'string'));
    
    if (~strcmp(class(coord),'double'))|isempty(coord)|(size(coord,2)~=2)
        msgbox('Please redefine Node Data','Error Message','error')
        return
    elseif (~strcmp(class(ends),'double'))|isempty(ends)|(size(ends,2)~=3)|(size(ends,1)==1)|(size(coord,1)<max(max(ends(:,1:2))))|(1>min(min(ends(:,1:2))))|any(ends(:,3)<0)
        msgbox('Please redefine Element Data','Error Message','error')
        return
    elseif (~strcmp(class(KL1),'double'))|isempty(KL1)|(KL1 <= 0)|(size(KL1,2)~=1)|(size(KL1,1)~=1)
        msgbox('Please redefine KL1','Error Message','error')
        return
    elseif (~strcmp(class(KL2),'double'))|isempty(KL2)|(KL2 <= 0)|(size(KL2,2)~=1)|(size(KL2,1)~=1)
        msgbox('Please redefine KL2','Error Message','error')
        return
    elseif (~strcmp(class(KL3),'double'))|isempty(KL3)|(KL3 <= 0)|(size(KL3,2)~=1)|(size(KL3,1)~=1)
        msgbox('Please redefine KL3','Error Message','error')
        return
    elseif (~strcmp(class(exy),'double'))|isempty(exy)|(size(exy,2)~=2)|(size(exy,1)~=1)
        msgbox('Please redefine Eccentricity coordinate','Error Message','error')
        return
    elseif (~strcmp(class(c),'double'))|isempty(c)|(size(c,2)~=1)|(size(c,1)~=1)
        msgbox('Please redefine Me1/Me2','Error Message','error')
        return
    elseif (~strcmp(class(E),'double'))|isempty(E)|(E <= 0)|(size(E,2)~=1)|(size(E,1)~=1)
        msgbox('Please redefine Elastic Modulus','Error Message','error')
        return
    elseif (~strcmp(class(v),'double'))|isempty(v)|(size(v,2)~=1)|(size(v,1)~=1)
        msgbox('Please redefine Poisson''s ratio','Error Message','error')
        return
    elseif (~strcmp(class(dist),'double'))|isempty(dist)|(size(dist,2)~=1)|(size(dist,1)~=1)
        msgbox('Please redefine Displacement Factor','Error Message','error')
        return
    end       
    
    if get(rad_Me12,'Value');
        [A,xc,yc,Ix,Iy,Ixy,theta,I1,I2,J,xs,ys,Cw,B1,B2,Pe,dcoord] = cutwp_prop(coord,ends,KL1,KL2,KL3,force,c,E,v,dist);
    else
        [A,xc,yc,Ix,Iy,Ixy,theta,I1,I2,J,xs,ys,Cw,B1,B2,Pe,dcoord] = cutwp_prop(coord,ends,KL1,KL2,KL3,force,exy,E,v,dist);
    end
    
    set(text_A,'string',sprintf('%-13.6G',A));
    set(text_Ix,'string',sprintf('%-13.6G',Ix));
    set(text_Iy,'string',sprintf('%-13.6G',Iy));
    set(text_Ixy,'string',sprintf('%-13.6G',Ixy));
    set(text_I1,'string',sprintf('%-13.6G',I1));
    set(text_I2,'string',sprintf('%-13.6G',I2));
    set(text_theta,'string',sprintf('%-13.6G',theta));
    set(text_J,'string',sprintf('%-13.6G',J));
    set(text_centroid,'string',sprintf('( %6.6G, %6.6G )',xc,yc)); 
    
    if isnan(Cw)
        set(statictext_J,'string','Torsion Constant-Closed Section, J:');
        set(statictext_shear,'Visible','off'); 
        set(statictext_Cw,'Visible','off'); 
        set(statictext_B1,'Visible','off'); 
        set(statictext_B2,'Visible','off'); 
        set(statictext_Pe,'Visible','off'); 
        set(statictext_Me1,'Visible','off');
        set(statictext_Me2,'Visible','off');
        set(text_shear,'Visible','off'); 
        set(text_Cw,'Visible','off');
        set(text_B1,'Visible','off');
        set(text_B2,'Visible','off');
        set(text_Pe,'Visible','off');
        set(text_Me1,'Visible','off');
        set(text_Me2,'Visible','off');
        set(rad_shear,'Visible','off','Value',0);
        set(rad_axial,'Visible','off','Value',0);
        set(rad_deform,'Visible','off','Value',0);
        set(slider,'Visible','off');
        set(statictext_dist,'Visible','off');
        set(statictext_buck,'Visible','off');
        set(text_mode,'Visible','off');
        set(text_maxmode,'Visible','off');
        set(ed_dist,'Visible','off');
        
    else
        
        set(statictext_J,'string','Torsion Constant-Open Section, J:');
        set(statictext_shear,'Visible','on'); 
        set(statictext_Cw,'Visible','on'); 
        set(statictext_B1,'Visible','on'); 
        set(statictext_B2,'Visible','on'); 
        
        set(text_shear,'Visible','on','string',sprintf('( %6.6G, %6.6G )',xs,ys));
        set(text_Cw,'Visible','on','string',sprintf('%-13.6G',Cw));
        set(text_B1,'Visible','on','string',sprintf('%-13.6G',B1));
        set(text_B2,'Visible','on','string',sprintf('%-13.6G',B2));
        
        set(rad_shear,'Visible','on');
        if get(rad_Pe,'Value')|get(rad_Me1,'Value')|get(rad_Me2,'Value')
            set(statictext_Pe,'Visible','on'); 
            set(statictext_Me1,'Visible','off');
            set(statictext_Me2,'Visible','off');
            set(text_Pe,'Visible','on','string',sprintf('%-13.6G',Pe(mode)));
            set(text_Me1,'Visible','off');
            set(text_Me2,'Visible','off');
        elseif get(rad_Me12,'Value')
            set(statictext_Pe,'Visible','off'); 
            set(statictext_Me1,'Visible','on');
            set(statictext_Me2,'Visible','on');
            set(text_Pe,'Visible','off');
            set(text_Me1,'Visible','on','string',sprintf('%-13.6G',Pe(mode)*c));
            set(text_Me2,'Visible','on','string',sprintf('%-13.6G',Pe(mode)));
        end
        if get(rad_Pe,'Value')
            set(rad_axial,'Visible','on');
        else
            set(rad_axial,'Visible','off','Value',0);
        end
        
        set(rad_deform,'Visible','on');
        set(slider,'Visible','on');
        set(statictext_dist,'Visible','on');
        set(statictext_buck,'Visible','on');
        set(text_mode,'Visible','on');
        set(text_maxmode,'Visible','on');
        set(ed_dist,'Visible','on');
    end
    
    
    origin = get(rad_origin,'Value');
    centroid = get(rad_centroid,'Value');
    axisxy = get(rad_axisxy,'Value');
    axis12 = get(rad_axis12,'Value');
    shear = get(rad_shear,'Value');
    axial = get(rad_axial,'Value');
    deform = get(rad_deform,'Value');
    node = get(rad_node,'Value');
    
    cla; 
    cutwp_draw(coord,ends,exy,xc,yc,theta,xs,ys,dcoord,origin,centroid,axisxy,axis12,shear,axial,deform,node,mode);
    
end
