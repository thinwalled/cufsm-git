function [] = cufsm5()
    % CUFSM - Constrained and Unconstrained Finite Strip Method

    % ------------------------------
    % Version 1.0a - 10/20/97
    %           - Bug fixes in general input preprocessor.
    %           - Bug fixes in plotting displaced shape for non-continuous sections.
    % Version 1.0b - 10/22/97
    %           - Changes to one member post-processor added 3D plotting and plotting of deformed and undeformed geometry.
    % Version 1.0c - 11/06/97
    %           - Menus taken off the top of the windows to avoid confusion.
    %           - num2str() changed to sprintf() in pre2.m so that input files will be read in correctly.
    %           - Watch added for 3D plotting
    %           - Waitbar added for the analysis
    %           - Minimum plotting modified so that it shows the first minimum that occurs.
    %           - Double the cross-section discretization button in the input preprocessor.
    % Version 1.0d - 12/09/97
    %           - Section properties and generation of stress distribution module added.
    % Version 2.0 - 08/23/2000
    %           - Completely redesigned and simplified the interface with help buttons.
    %           - Copy and print inside the program.
    %           - Template for C's and Z's.
    %           - Normal right hand coordinate system used for input and results (no more positive z-axis downward).
    %           - Choice of eigensolvers when doing solutions.
    %           - Higher modes may be displayed in the post processor.
    %           - Continuous springs have been added for consideration of external stiffness on the buckling mode.
    %           - Visualization of fixed conditions and springs added (symbols added).
    %           - Constraint equations may be written and imposed on the member (e.g., v1 = 2 * v2).
    %           - Post-processor for comparing the results of multiple analyses is provided.
    % Version 2.0a - 08/28/00
    %           - Version compatible between complied GUI and MATLAB GUI made, standalone DOS version created with trytobuild.m.
    % Version 2.0b - 10/02/00
    %           - Fixed bug with first node set to zero displacement.
    % Version 2.0c - 10/03/00
    %           - Fixed bug with saving while in the input screen.
    % Version 2.0d - 08/09/01
    %           - Fixed bug with springs and constraints in DOS version.
    % Version 2.0e - 10/01
    %           - Fixed bug with N and mm in the template.
    %           - Added circle in the post-processing so you can tell what length you are at.
    % Version 2.5 - 10/01
    %           - Updated to MATLAB version 6.
    %           - Spring foundations that change with length are added to better model typical cases.
    %           - Input pages modified for ease of use.
    %           - Cross-section plotting improved to show thickness.
    %           - Inputs modified to allow multiple materials in the same model.
    % Version 2.6 - 12/09/02
    %           - Zoom and rotate added.
    %           - Double any element, delete any connected node.
    %           - Warping properties and bimoment stress generation added.
    %           - Automatic generation of master-slave constraints added for DB help.
    % Version 2.6b - 08/14/03
    %           - Zoom and rotate cleaned up.
    %           - After analysis the program jumps to the post-processor.
    %           - Translate a node with a text box instead.
    % Version 3.0 - 04/30/04
    %           - Warping section properties fixed and CUTWP integrated.
    %           - Application of modal constraints made available for use as of 08/25/05.
    %           - Host of small interface problems eliminated.
    %           - Section properties won't bomb on arbitrary shapes.
    %           - Debugging done on MATLAB version 7.
    % Version 3.1 - 10/06/06
    %           - cFSM features added to the pre- and post-processors.
    %           - Numerous small interface improvements.
    % Version 3.12 - 12/4/06
    %           - Fixed CUFSM 3.11 so that it could read old CUFSM files.
    %           - Commented out beta calculation until CUTWP calculations are corrected.
    % Version 4.03 - 09/13/10
    %           - Major update, Zhanjie Li provided new source code with Schafer
    %           - CUFSM now handles a suite of general boundary conditions from fix-fix to simple-simple, this adds some complexity
    %           - Significant interface changes.
    %           - Lots of small interface bugs removed, beta testing to start soon.
    % Version 4.04 - 08/05/11
    %           - Some small interface bugs removed.
    % Version 4.05 - 03/05/12
    %           - Bugs in loader.m are fixed.
    %           - Add digit precision for springs.
    %           - Bugs in the post-processing are fixed.
    % Version 4.10 - 10/26/2015
    %           - Add cross-section rotation for getting properties into MASTAN as desired.
    %           - Added export to MASTAN, either user.dat or replace a section in a model.
    %           - Added read from MASTAN into the forces for a CUFSM model, especially useful potentially for bimoment.
    %           - Upgraded template so that out to out or centerline can be used and upgraded plot of the template section.
    %           - Added cross-section duplication for easing creation of builtup models.
    % Version 4.11 - 10/26/2015
    %           - Adding element discretization control to the template.
    % Version 4.12 - 11/06/2015-12/08/2015
    %           - Adding sharp/round corner option to the template.
    %           - Reworking applied load/stress generator to be more consistent with the beam-column effort and analysis.
    %           - Applied stress generator completely reworked, now consistent with the PMM beam-column efforts.
    % Version 4.2 as of 11 December 2015
    %           - Working on menus and program workflow.
    %           - Added CUTWP and AbaqusMaker.
    %           - Traditional file menu across the top replaced old buttons.
    % Version 4.3 as of 14 December 2015
    %           -working on node-to-node foundation and discrete springs
    %           -misc. other improvements.
    % Version 4.301 as of 26 Feb 2016
    %           - interface clean up and getting plastic section integrated into the code for beam-column.
    %           - plasticbuild added for plastic surface creation and beta p values for yield on the PMM plastic surface
    %           - contributions from Shahab Torabian in this effort
    % Version 4.501 as of 24 March 2016/28 Nov 2016
    %           - Bring in the holes tool for approximating members with holes using FSM and methods of Moen's dissertation
    %           - contributions from Junle Cai in this effort
    % Version 4.502 as of 17 May 2017
    %           - Debug springs to ground with general end bound cond
    % Version 5.00 as of 31 Jan 2018
    %           - Clean up and hide some features to create a version for release to end users.
    % Version5.01 as of 26 Feb 2018
    %           - Javascript bugs in boundcond cause crashses, fixed.
    % Version 5.02 as of 5 April 2018
    %           - Small bug fixes, reset went to cufsm4
    % Version 5.03 as of 16 May 2019
    %           - Fixed bug on discrete springs
    % Version 5.04 as of 6 April 2020
    %           - Debugging so version will compile on R2020a MATLAB and on Mac and Windows.
    % Version 5.04+ as of 8 July 2021
    %           - Fixed bug on plastic surface gridding, when thetap is nonzero, in plasticbuild_cb line 94 changed thetap to degrees to fix the error.
    % Version 5.04+ as of 7 July 2023
    %           - Fixed eigs call in strip() which throws an error in R2022.
    % Version 5.05 as of 28 Dec 2023
    %           - Cleanups for R2023b.
    %           - Criticall strip.m renamed to stripmain.m because strip has become reserved word - source of lots of user problems.
    %           - Also removed analysis waitbar from analysis button, seemed to cause more problems and hung windows, possibly related to strip.m issue but removed.
    %           - Buggy code, with limited valued removed: holehelper, abaqus_me, and MASTAN in/out. Will separate into their own tools, or bring back in future version.
    %           - Changed CUTWP to use global variables instead of load and save, this should now work in compiled versions bringing back this functionality to those users.
    % Version 5.06 as of 2 Jan 2024
    %           - Moved management to github for the code.
    %           - Merged in Sheng Jin's 3D plotting code.
    % ------------------------------

    % General:
    global currentlocation fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen zoombtn panbtn rotatebtn
    % Output from pre2():
    global subfig ed_prop ed_node ed_elem ed_lengths axestop screen flags modeflag ed_springs ed_constraints
    % Output from template:
    global prop node elem lengths springs constraints h_tex b1_tex d1_tex q1_tex b2_tex d2_tex q2_tex r1_tex r2_tex r3_tex r4_tex t_tex C Z kipin Nmm axestemp subfig
    % Output from propout and loading:
    global A xcg zcg Ixx Izz Ixz thetap I11 I22 Cw J outfy_tex unsymm restrained Bas_Adv scale_w Xs Ys w scale_tex_w outPedit outMxxedit outMzzedit outM11edit outM22edit outTedit outBedit outL_Tedit outx_Tedit Pcheck Mxxcheck Mzzcheck M11check M22check Tcheck screen axesprop axesstres scale_tex maxstress_tex minstress_tex
    % Output from boundary condition:
    global ed_m ed_neigs solutiontype togglesignature togglegensolution popup_BC toggleSolution Plengths Pm_all Hlengths Hm_all HBC PBC subfig lengthindex axeslongtshape longitermindex hcontainershape txt_longterm len_cur len_longterm longshape_cur jScrollPane_edm jViewPort_edm jEditbox_edm hjScrollPane_edm
    % Output from cFSM:
    global toggleglobal toggledist togglelocal toggleother ed_global ed_dist ed_local ed_other NatBasis ModalBasis toggleCouple popup_load axesoutofplane axesinplane axes3d lengthindex modeindex spaceindex longitermindex b_v_view modename spacename check_3D cutface_edit len_cur mode_cur space_cur longterm_cur modes SurfPos scale twod threed undef scale_tex
    % Output from compareout():
    global pathname filename pathnamecell filenamecell propcell nodecell elemcell lengthscell curvecell clascell shapescell springscell constraintscell GBTconcell solutiontypecell BCcell m_allcell filedisplay files fileindex modes modeindex mmodes mmodeindex lengthindex axescurve togglelfvsmode togglelfvslength curveoption ifcheck3d minopt logopt threed undef axes2dshapelarge togglemin togglelog modestoplot_tex filetoplot_tex modestoplot_title filetoplot_title checkpatch len_plot lf_plot mode_plot SurfPos cutsurf_tex filename_plot len_cur scale_tex mode_cur mmode_cur file_cur xmin_tex xmax_tex ymin_tex ymax_tex filetoplot_tex screen popup_plot filename_title2 clasopt popup_classify times_classified toggleclassify classification_results plength_cur pfile_cur togglepfiles toggleplength mlengthindex mfileindex axespart_title axes2dshape axes3dshape axesparticipation axescurvemode modedisplay modestoplot_tex

    % Note:
    % MATLAB allows coding inside the GUI control callbacks.
    % MATLAB Compiler for making standalone executable interfaces does not.
    % In order for both versions to be the same (MATLAB and standalone) callbacks must be in functions.
    % In order for me to re-write the callbacks global variables are used extensively (this approach is generally discouraged).
    % Newer versions of MATLAB have created other ways to handle this; however, this is a legacy decision.

    % Path statements to functions and interface useful for organization in MATLAB, not useful in standalone version:
    wpath = what;
    currentlocation = wpath.path;

    if ispc & ~isdeployed % Windows
        % Note:
        % isdeployed check added due to compiler not allowing addpath().
        addpath([currentlocation]);
        addpath([currentlocation, '\analysis']);
        addpath([currentlocation, '\analysis\cFSM']);
        addpath([currentlocation, '\analysis\plastic']);
        addpath([currentlocation, '\helpers']);
        % addpath([currentlocation,'\holehelper']);
        addpath([currentlocation, '\interface']);
        addpath([currentlocation, '\plotters']);
        addpath([currentlocation, '\icons']);
        addpath([currentlocation, '\cutwp']);
        % addpath([currentlocation,'\abaqusmaker']);
    elseif ~isdeployed % Mac or Unix
        addpath([currentlocation]);
        addpath([currentlocation, '/analysis']);
        addpath([currentlocation, '/analysis/cFSM']);
        addpath([currentlocation, '/analysis/plastic']);
        % addpath([currentlocation,'/holehelper']);
        addpath([currentlocation, '/helpers']);
        addpath([currentlocation, '/interface']);
        addpath([currentlocation, '/plotters']);
        addpath([currentlocation, '/icons']);
        addpath([currentlocation, '/cutwp']);
        % addpath([currentlocation,'/abaqusmaker']);
    end

    % ------------------------------
    % Title and menus
    % ------------------------------
    version = ['5.06'];
    name = ['CUFSM V', version, ' -- Constrained and Unconstrained Finite Strip Method (CUFSM) Buckling Analysis of Thin-Walled Members'];
    fig = figure('Name', name, 'NumberTitle', 'off');
    fig.Visible = 'off';
    % set(fig,'Units','normalized')
    set(fig, 'MenuBar', 'none');

    % Set window size:
    set(fig, 'units', 'normalized', 'position', [0.01 0.01 0.98 0.85]);

    % Note:
    % This was set to pixels but causes problems in R2016 and on multiple displays so set to simpler normalized units now.
    % % Set units to pixels:
    % set(0, 'units', 'pixels');
    % % Get size of current screen:
    % pixelss = get(0, 'screensize');
    % % Set max width and height:
    % widthmax = 1280;
    % heightmax = 800;
    % % Set CUFSM window size:
    % cufsmwindowsize = [1 1 min([pixelss(3); widthmax]) min([pixelss(4); heightmax])];
    % set(fig, 'position', cufsmwindowsize);

    % Set default font size:
    set(0, 'DefaultUicontrolFontSize', 11);

    % Note:
    % Some UI controls do not use this, the following tabdlg, inputdlg and
    % msgbox so here the web recommends changing the built-in function and
    % changing FactoryUicontrolFontSize to DefaultFontSize, this is clumsy, for
    % now just living with very small font size, maybe future MATLAB cleans this
    % up.

    % ------------------------------
    % Call the command bar
    % ------------------------------
    screen = 0;
    commandbar;
    fig.Visible = 'on';

    % Fire up the input page:
    commandbar_cb(8);

    % ------------------------------
    % Splash screen
    % ------------------------------
    % axestop = axes('Units', 'pixels', 'Position', [(1000 - 682) / 2 (690 - 564) / 2 682 564], 'visible', 'off');
    % apic = imread('title4p04.bmp', 'bmp');
    % image(apic);
    % axis('equal')
    % axis('off')
    % Note:
    % Removed for now (14 December 2015).
end
