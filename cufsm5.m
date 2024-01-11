function [] = cufsm5()
    % CUFSM - Constrained and Unconstrained Finite Strip Method
    % High-level history of CUFSM can be found in NEWS.md file at https://github.com/thinwalled/cufsm-git.

    % MATLAB allows coding inside the GUI control callbacks
    % MATLAB Compiler for making standalone executable interfaces does not
    % In order for both versions to be the same (MATLAB and standalone) Callbacks must be in functions
    % In order for me to re-write the callbacks global variables are used extensively (this approach is generally discouraged)
    % newer versions of MATLAB have created other ways to handle this; however this is a legacy decision.

    %general
    global currentlocation fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen zoombtn panbtn rotatebtn
    %output from pre2
    global subfig ed_prop ed_node ed_elem ed_lengths axestop screen flags modeflag ed_springs ed_constraints
    %output from template
    global prop node elem lengths springs constraints h_tex b1_tex d1_tex q1_tex b2_tex d2_tex q2_tex r1_tex r2_tex r3_tex r4_tex t_tex C Z kipin Nmm axestemp subfig
    %output from propout and loading
    global A xcg zcg Ixx Izz Ixz thetap I11 I22 Cw J outfy_tex unsymm restrained Bas_Adv scale_w Xs Ys w scale_tex_w outPedit outMxxedit outMzzedit outM11edit outM22edit outTedit outBedit outL_Tedit outx_Tedit Pcheck Mxxcheck Mzzcheck M11check M22check Tcheck screen axesprop axesstres scale_tex maxstress_tex minstress_tex
    %output from boundary condition (Bound. Cond.)
    global ed_m ed_neigs solutiontype togglesignature togglegensolution popup_BC toggleSolution Plengths Pm_all Hlengths Hm_all HBC PBC subfig lengthindex axeslongtshape longitermindex hcontainershape txt_longterm len_cur len_longterm longshape_cur jScrollPane_edm jViewPort_edm jEditbox_edm hjScrollPane_edm
    %output from cFSM
    global toggleglobal toggledist togglelocal toggleother ed_global ed_dist ed_local ed_other NatBasis ModalBasis toggleCouple popup_load axesoutofplane axesinplane axes3d lengthindex modeindex spaceindex longitermindex b_v_view modename spacename check_3D cutface_edit len_cur mode_cur space_cur longterm_cur modes SurfPos scale twod threed undef scale_tex
    %output from compareout
    global pathname filename pathnamecell filenamecell propcell nodecell elemcell lengthscell curvecell clascell shapescell springscell constraintscell GBTconcell solutiontypecell BCcell m_allcell filedisplay files fileindex modes modeindex mmodes mmodeindex lengthindex axescurve togglelfvsmode togglelfvslength curveoption ifcheck3d minopt logopt threed undef axes2dshapelarge togglemin togglelog modestoplot_tex filetoplot_tex modestoplot_title filetoplot_title checkpatch len_plot lf_plot mode_plot SurfPos cutsurf_tex filename_plot len_cur scale_tex mode_cur mmode_cur file_cur xmin_tex xmax_tex ymin_tex ymax_tex filetoplot_tex screen popup_plot filename_title2 clasopt popup_classify times_classified toggleclassify classification_results plength_cur pfile_cur togglepfiles toggleplength mlengthindex mfileindex axespart_title axes2dshape axes3dshape axesparticipation axescurvemode modedisplay modestoplot_tex

    %path statements to functions and interface usful for organization in MATLAB, not useful in standalone version
    wpath = what;
    currentlocation = wpath.path;

    if ispc & ~isdeployed %pc %is deployed check added due to compiler not allowing addpath
        addpath([currentlocation]);
        addpath([currentlocation, '\analysis']);
        addpath([currentlocation, '\analysis\cFSM']);
        addpath([currentlocation, '\analysis\plastic']);
        addpath([currentlocation, '\helpers']);
        %addpath([currentlocation,'\holehelper']);
        addpath([currentlocation, '\interface']);
        addpath([currentlocation, '\plotters']);
        addpath([currentlocation, '\icons']);
        addpath([currentlocation, '\cutwp']);
        %addpath([currentlocation,'\abaqusmaker']);
    elseif ~isdeployed %mac! or unix
        addpath([currentlocation]);
        addpath([currentlocation, '/analysis']);
        addpath([currentlocation, '/analysis/cFSM']);
        addpath([currentlocation, '/analysis/plastic']);
        %addpath([currentlocation,'/holehelper']);
        addpath([currentlocation, '/helpers']);
        addpath([currentlocation, '/interface']);
        addpath([currentlocation, '/plotters']);
        addpath([currentlocation, '/icons']);
        addpath([currentlocation, '/cutwp']);
        %addpath([currentlocation,'/abaqusmaker']);
    end

    %-----------------------------------------------------------------------------------
    %Title and menus
    %-----------------------------------------------------------------------------------
    version = ['5.06'];
    name = ['CUFSM v', version, ' -- Constrained and Unconstrained Finite Strip Method (CUFSM) Buckling Analysis of Thin-Walled Members'];
    fig = figure('Name', name, ...
        'NumberTitle', 'off');
    fig.Visible = 'off';
    % set(fig,'Units','normalized')%
    set(fig, 'MenuBar', 'none');
    %
    %Set window size
    %This was set to pixels but causes problems in R2016 and on multiple
    %displays so set to simpler normalized units now.
    % %set units to pixels
    % set(0,'units','pixels');
    % %get size of current screen
    % pixelss = get(0,'screensize');
    % %set max width and height
    % widthmax=1280;
    % heightmax=800;
    % %set cufsmwindowsize
    % cufsmwindowsize=[1 1 min([pixelss(3);widthmax]) min([pixelss(4);heightmax])];
    % set(fig,'position',cufsmwindowsize);
    set(fig, 'units', 'normalized', 'position', [0.01 0.01 0.98 0.85]);
    %
    %set default font size
    set(0, 'DefaultUicontrolFontSize', 11);
    %Note some uictontrols do not use this, the following tabdlg, inputdlg and
    %msgbox so here the web recommends changing the built-in function and
    %changing FactoryUicontrolFontSize to DefaultFontSize, this is clumsy, for
    %now just living with very small font size, maybe future MATLAB cleans this
    %up.
    %

    %-----------------------------------------------------------------------------------
    %call the command bar
    %-----------------------------------------------------------------------------------
    screen = 0;
    commandbar;
    fig.Visible = 'on';
    %fire up the input page
    commandbar_cb(8);

    %
    %-------------------------------------------------------------------------------------
    %splash screen
    %-------------------------------------------------------------------------------------
    %
    %removed for now, 14 December 2015
    % axestop=axes('Units','pixels','Position',[(1000-682)/2 (690-564)/2 682 564],'visible','off');
    % apic=imread('title4p04.bmp','bmp');
    % image(apic);
    % axis('equal')
    % axis('off')
end
