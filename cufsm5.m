function []=cufsm5()
%CUFSM=Constrained and Unconstrained Finite Strip Method
%version 1.0a 10/20/97
%             -Bug fixes in general input preprocessor
%             -Bug fixes in plotting displaced shape for non continuous sections        
%version 1.0b 10/22/97
%             -Changes to one member post-processor added 3D plotting
%             and plotting of deformed and undeformed geometry
%version 1.0c 11/6/97
%             -Menus taken off the top of the windows to avoid confusion
%             -num2str changed to sprintf in pre2.m so that input files will
%             be read in correctly.
%             -watch added for 3D plotting
%             -waitbar added for the analysis
%             -minimum plotting modified so that it shows the first min that occurs
%             -double the crosssection discretization button in input preprocessor
%version 1.0d 12/9/97
%             -Section properties and generation of stress distribution module added.
%version 2.0 as of 8/23/2000
%					-Completely redesigned and simplified interface with help buttons
%					-Copy and print inside the program
%					-template for C's and Z's
%					-normal right hand coordinate system used for input and results (no more positive z down)
%					-choice of eigensolvers when doing solutions
%					-higher modes may be displayed in the post processor
%					-continuous springs have been added for consideration of external stiffness on the buckling mode
%					-visualization of fixed conditions and springs added (symbols added)
%	`				-constraint equations may be written and imposed on the member (e.g. v1 = 2*v2)
%					-post processor for comparing the results of multiple analyses is provided
%version 2.0a as of 8/28/00
%					-version compatible between complied GUI and matlab GUI made, standalone DOS version created with trytobuild.m
%version 2.0b as of 10/2/00
%					-fixed bug with first node set to zero displacement
%version 2.0c as of 10/3/00
%					-fixed bug with saving while in the input screen
%version 2.0d as of 8/9/01
%					-fixed bug with springs and constraints in DOS version
%version 2.0e as of 10/01
%					-fixed bug with N&mm in template
%                   -added circle in the post-processing so you can tell what length you are at
%version 2.5 as of 10/01
%                   -updated to matlab version 6
%					-spring foundations that change with length are added to better model typical cases
%                   -input pages modified for ease of use
%                   -cross-section plotting improved to show thicknness
%                   -inputs modified to allow multiple materials in the same model
%version 2.6 as of 12/09/02
%                   -zoom and rotate added
%                   -double any element, delete any connected node
%                   -warping properties and bimoment stress generation added
%                   -automatic generation of master-slave constraints added for DB help
%version 2.6b as of 08/14/03
%                   -zoom and rotate cleaned up
%                   -after analysis the program jumps to the post-processor
%                   -translate a node with a text box instead 
%version 3.0 as of 04/30/04
%                   -warping section properties fixed and cutwp integrated
%                   -Application of modal constraints made available for use
%            as of 8/25/05
%                   -host of small interface problems eliminated
%                   -section properties won't bomb on arbitrary shapes
%                   -debugging done on Matlab version 7
%version 3.1 as of 10/06/06
%                   -cFSM features added to pre and post-processor
%                   -numerous small interface improvements
%version 3.12 as of 12/4/06
%                   -fixed cufsm 3.11 so that it could read old cufsm files
%                   -commented out beta calculation until CUTWP calcs are corrected                  
%version 4.03 as of 09/13/10
%                   -Major update, Zhanjie Li provided new source code with Schafer
%                   -CUFSM now handles a suite of general boundary
%                   conditions from fix-fix to simple-simple, this adds
%                   some complexity
%                   -Significant interface changes to the codeing.
%                   -Lots of small interface bugs removed, beta testing to
%                   start soon.
%version 4.04 as of 08/05/11
%                   - some small interface bugs removed          
%version 4.05 as of 03/05/12
%                   - bugs in loader.m are fixed
%                   - add digit precision for springs
%                   - bugs in post-processing are fixed
%version 4.10 as of 10/26/2015
%                   -add cross-section rotation for getting properties into MASTAN as desired
%                   -added export to MASTAN, either user.dat or replace a section in a model
%                   -added read from MASTAN into the forces for a CUFSM
%                   model, especially useful potentially for bimoment
%                   -upgraded template so that out to out or centerline can
%                   be used and upgraded plot of the template section.
%                   -added cross-section duplication for easing creation of
%                   builtup models.
%version 4.11 as of 10/26/2015
%                   -adding element discretization control to the
%                   template
%version 4.12 as of 11/6/2015-12/8/2015
%                   -adding sharp/round corner option to template
%                   -reworking applied load/stress generator to be more
%                   consistent with the beam-column effort and analysis.
%                   -applied stress generator completely reworked, now
%                   consistent with PMM beam-column efforts.
%version 4.2 as of 11 December 2015
%                   -working on menus and program workflow
%                   -added cutwp and abaqusmaker
%                   -traditional file menu across the top replaced old
%                   buttons
%version 4.3 as of 14 December 2015
%                   -working on node-to-node foundation and discrete springs
%                   -misc. other improvements.
%version 4.301 as of 26 Feb 2016
%                   -interface clean up and getting plastic section
%                   integrated into the code for beam-column.
%                   -plasticbuild added for plastic surface creation and
%                   beta p values for yield on the PMM plastic surface
%                   -contributions from Shahab Torabian in this effort
%version 4.501 as of 24 March 2016/28 Nov 2016
%                   -Bring in the holes tool for approximating members with
%                   holes using FSM and methods of Moen's dissertation
%                   -contributions from Junle Cai in this effort
%version 4.502 as of 17 May 2017
%                   -Debug springs to ground with general end bound cond
%version 5.00 as of 31 Jan 2018
%                   -Clean up and hide some features to create a version
%                   for release to end users.
%version5.01 as of 26 Feb 2018
%                   -Javascript bugs in boundcond cause crashses, fixed.
%version 5.02 as of 5 April 2018
%                   -Small bug fixes, reset went to cufsm4
%version 5.03 as of 16 May 2019
%                   -Fixed bug on discrete springs
%version 5.04 as of 6 April 2020
%                   -Debugging so version will compile on R2020a matlab and
%                   on mac and windows..
%version 5.04+ as of 8 July 2021
%                    -Fixed bug on plastic surface gridding, when thetap is
%                    nonzero, in plasticbuild_cb line 94 changed thetap to
%                    degrees to fix the error.
%version 5.04+ as of 7 July 2023
%                    -Fixed eigs call in strip which throws an error in
%                    R2022.
%version 5.05 as of 28 Dec 2023
%                    -Cleanups for R2023b
%                    -Criticall strip.m renamed to stripmain.m because
%                    strip has become reserved word - source of lots of
%                    user problems
%                    -Also removed analysis waitbar from analysis button,
%                    seemed to cause more problems and hung windows,
%                    possibly related to strip.m issue but removed.
%                    -Buggy code, with limited valued removed: holehelper,
%                    abaqus_me, and mastan in/out. Will separate into their
%                    own tools, or bring back in future version
%                    -changed cutwp to use global variables instead of load
%                    and save, this should now work in compiled versions
%                    bringing back this functionality to those users
%-------------------------------------------------------------------------------------------------
%
%
%Matlab allows coding inside the GUI control callbacks
%Matlab Compiler for making standalone executable interfaces does not
%In order for both versions to be the same (Matlab and standalone) Callbacks must be in functions
%In order for me to re-write the callbacks global variables are used extensively (this approach is generally discouraged)
%newer versions of matlab have created other ways to handle this; however this is a legacy decision.
%
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
global pathname filename pathnamecell filenamecell propcell nodecell elemcell lengthscell curvecell clascell shapescell springscell constraintscell GBTconcell solutiontypecell BCcell m_allcell filedisplay files fileindex modes modeindex mmodes mmodeindex lengthindex axescurve togglelfvsmode togglelfvslength curveoption ifcheck3d minopt logopt threed undef axes2dshapelarge togglemin togglelog modestoplot_tex filetoplot_tex modestoplot_title filetoplot_title checkpatch len_plot lf_plot mode_plot SurfPos cutsurf_tex filename_plot len_cur scale_tex mode_cur mmode_cur file_cur xmin_tex xmax_tex ymin_tex ymax_tex filetoplot_tex screen popup_plot filename_title2 clasopt popup_classify times_classified toggleclassify classification_results plength_cur pfile_cur togglepfiles toggleplength mlengthindex mfileindex axespart_title axes2dshape axes3dshape axesparticipation axescurvemode  modedisplay modestoplot_tex
%
%
%path statements to functions and interface usful for organization in matlab, not useful in standalone version
wpath=what;
currentlocation=wpath.path;
if ispc & ~isdeployed %pc   %is deployed check added due to compiler not allowing addpath
    addpath([currentlocation]);
    addpath([currentlocation,'\analysis']);
    addpath([currentlocation,'\analysis\cFSM']);
    addpath([currentlocation,'\analysis\plastic']);
    addpath([currentlocation,'\helpers']);
    %addpath([currentlocation,'\holehelper']);
    addpath([currentlocation,'\interface']);
    addpath([currentlocation,'\plotters']);
    addpath([currentlocation,'\icons']);
    addpath([currentlocation,'\cutwp']);
    %addpath([currentlocation,'\abaqusmaker']);
elseif ~isdeployed %mac! or unix
    addpath([currentlocation]);
    addpath([currentlocation,'/analysis']);
    addpath([currentlocation,'/analysis/cFSM']);
    addpath([currentlocation,'/analysis/plastic']);
    %addpath([currentlocation,'/holehelper']);
    addpath([currentlocation,'/helpers']);
    addpath([currentlocation,'/interface']);
    addpath([currentlocation,'/plotters']);
    addpath([currentlocation,'/icons']);
    addpath([currentlocation,'/cutwp']);
    %addpath([currentlocation,'/abaqusmaker']);
end

%-----------------------------------------------------------------------------------
%Title and menus
%-----------------------------------------------------------------------------------
version=['5.05'];
name=['CUFSM v',version,' -- Constrained and Unconstrained Finite Strip Method (CUFSM) Buckling Analysis of Thin-Walled Members'];
fig=figure('Name',name,...
   	'NumberTitle','off');
fig.Visible='off';
% set(fig,'Units','normalized')%
set(fig,'MenuBar','none');
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
set(fig,'units','normalized','position',[0.01 0.01 0.98 0.85]);
    %
%set default font size
set(0,'DefaultUicontrolFontSize',11);
%Note some uictontrols do not use this, the following tabdlg, inputdlg and
%msgbox so here the web recommends changing the built-in function and
%changing FactoryUicontrolFontSize to DefaultFontSize, this is clumsy, for
%now just living with very small font size, maybe future matlab cleans this
%up.
%


%-----------------------------------------------------------------------------------
%call the command bar
%-----------------------------------------------------------------------------------
screen=0;
commandbar;
fig.Visible='on';
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


