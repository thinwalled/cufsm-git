function []=commandbar_cb(num)
%BWS
%August 28, 2000
%Z. Li, 7/20/2010
%BWS December 2015
%GUI control callbacks for commandbar
%top level buttons are the same for all parts of program, but the functionality of
%the button may change depending on the screen the user is within
%screen
%0=default start screen
%1=geometry screen
%2=input screen
%3=cFSM screen
%4=post processing screen --superceded by comparison post-processor
%5=comparison post-processor
%6=bound. cond. screen
%7=Applied Stress screen
%8=Plastic Surface Builder screen
%9=Hole Effect Analysis Tool
%top level commands for cufsm
%buttons are the same but functionality may chnage depending on the mode the user is in
%
%October 2001 minor cleanup for version 2.5
%December 2002 furthere cleanup for version 2.6
%Comparison Post Processor and "Post" Post-Processor combined into one.
%
%general
global currentlocation fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen zoombtn panbtn rotatebtn m3a m3b m3c p3a p3b p3c
%output from pre2
global subfig ed_prop ed_node ed_elem ed_lengths axestop screen flags modeflag ed_springs ed_constraints
%output from template
global prop node elem lengths springs constraints h_tex b1_tex d1_tex q1_tex b2_tex d2_tex q2_tex r1_tex r2_tex r3_tex r4_tex t_tex C Z kipin Nmm axestemp subfig
%output from propout and loading
global inode A xcg zcg Ixx Izz Ixz thetap I11 I22 Cw J outfy_tex unsymm restrained Bas_Adv scale_w Xs Ys w scale_tex_w outPedit outMxxedit outMzzedit outM11edit outM22edit outTedit outBedit outL_Tedit outx_Tedit Pcheck Mxxcheck Mzzcheck M11check M22check Tcheck screen axesprop axesstres scale_tex maxstress_tex minstress_tex
%output from boundary condition (Bound. Cond.)
global ed_m ed_neigs solutiontype togglesignature togglegensolution popup_BC toggleSolution Plengths Pm_all Hlengths Hm_all HBC PBC subfig lengthindex axeslongtshape longitermindex hcontainershape txt_longterm len_cur len_longterm longshape_cur jScrollPane_edm jViewPort_edm jEditbox_edm hjScrollPane_edm
%output from cFSM
global toggleglobal toggledist togglelocal toggleother ed_global ed_dist ed_local ed_other NatBasis ModalBasis toggleCouple popup_load axesoutofplane axesinplane axes3d lengthindex modeindex spaceindex longitermindex b_v_view modename spacename check_3D cutface_edit len_cur mode_cur space_cur longterm_cur modes SurfPos scale twod threed undef scale_tex
%output from compareout
global pathname filename pathnamecell filenamecell propcell nodecell elemcell lengthscell curvecell clascell shapescell springscell constraintscell GBTconcell solutiontypecell BCcell m_allcell filedisplay files fileindex modes modeindex mmodes mmodeindex lengthindex axescurve togglelfvsmode togglelfvslength curveoption ifcheck3d minopt logopt threed undef axes2dshapelarge togglemin togglelog modestoplot_tex filetoplot_tex modestoplot_title filetoplot_title checkpatch len_plot lf_plot mode_plot SurfPos cutsurf_tex filename_plot len_cur scale_tex mode_cur mmode_cur file_cur xmin_tex xmax_tex ymin_tex ymax_tex filetoplot_tex screen popup_plot filename_title2 clasopt popup_classify times_classified toggleclassify classification_results plength_cur pfile_cur togglepfiles toggleplength mlengthindex mfileindex axespart_title axes2dshape axes3dshape axesparticipation axescurvemode  modedisplay modestoplot_tex
%
%-------------------------------------------------------------------
%

switch num

case 1
%-------------------------------------------------------------------
%code for printing button
orient landscape
printdlg(fig);
%-------------------------------------------------------------------

case 2
%-------------------------------------------------------------------
%code for copy button
if ispc %pc
    print(fig,'-dmeta');
else %mac! or unix
    print(fig,'-djpeg100');
end
%-------------------------------------------------------------------

case 3
%-------------------------------------------------------------------
%code for reset button
question=questdlg('Warning! All current work will be replaced by original default geometry.');
switch question
    case 'Yes'
        closereq;
        prop=[];
        node=[];
        elem=[];
        lengths=[];
        springs=[];
        constraints=[];
        GBTcon=[];
        curve=[];
        shapes=[];
        clas=[];
        BC=[];
        m_all=[];
        Hlengths=[];
        HBC=[];
        Hm_all=[];
        Plengths=[];
        PBC=[];
        Pm_all=[];
        neigs=[];
        cufsm5;
end

%-------------------------------------------------------------------

case 4
%-------------------------------------------------------------------
%code for exit button
closereq;
%-------------------------------------------------------------------

case 5
%-------------------------------------------------------------------
%code for comparison post processor button
% question=questdlg('Comparison requires previously saved files, unsaved analysis will be lost, continue?');
% switch question
% case 'Yes'
%   compareout(1);
% end
if ~isempty(prop)&~isempty(node)&~isempty(elem)&~isempty(lengths)&~isempty(m_all)&~isempty(BC)&~isempty(curve)&~isempty(shapes)%&curve{1}(1,1)~=0&shapes{1}(1,1)~=0
	compareout(1);
else
	msgbox('No data available for post-processing. Use Load or Analyze, then Post','Data unavailable','help'),
end
%-------------------------------------------------------------------

case 6
%-------------------------------------------------------------------
%This code is obsolete as this button has been commented out of commandbar.m
%code for post processor button
%if ~isempty(prop)&~isempty(node)&~isempty(elem)&~isempty(lengths)&~isempty(curve)&~isempty(shapes)&curve(1,1,1)~=0
%	cuout;
%else
%	msgbox('No data available for post-processing. Use Load or Analyze, then Post','Data unavailable','help'),
%end
%-------------------------------------------------------------------

case 7
%-------------------------------------------------------------------
%code for the load button
global screen
if ~isempty(screen)
else
    screen=0;
end
if screen==5
	%load another file for multiple post-processing
    filenumber=length(files)+1;
    compareout(filenumber);
elseif screen==9
    %hole effect screen no loading to this screen
    msgbox('Currently CUFSM does not save variables related to hole effect analysis, you must load from another screen','Load from Hole Effect Analysis Tool')
else
    %standard load
    [pathname,filename,prop,node,elem,lengths,curve,shapes,springs,constraints,GBTcon,clas,BC,m_all]=loader;
    %initial Hlengths, Plengths
    Hlengths=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800 900 1000];
    for i=1:length(Hlengths)
        Hm_all{i}=[1];
    end
    HBC='S-S';
    neigs=20;
    solutiontype=1;
    %
    Plengths=[92 192];
    for i=1:length(Plengths)
        Pm_all{i}=[1:20];
    end
    PBC='S-S';
    %
    %
    if screen==2
        set(ed_prop,'String',sprintf('%i %.2f %.2f %.2f %.2f %.2f',prop'));
        set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
        set(ed_elem,'String',sprintf('%i %i %i %.6f %i\n',elem'));
        set(ed_springs,'String',sprintf('%i %i %i %.6f %.6f %.6f %.6f %i %i %.3f\n',springs'));
        set(ed_constraints,'String',num2str(constraints));
        crossect(node,elem,axestop,springs,constraints,flags);
    end
    %
    if screen==6
        if ~isempty(prop)&~isempty(node)&~isempty(elem)
            boundcond;
        else
            msgbox('No data available for advance boundary condition input. Use Load, or Input, then boundary conditions','Data unavailable','help');
        end
    end
    %
    if screen==3
        if ~isempty(prop)&~isempty(node)&~isempty(elem)&~isempty(lengths)&~isempty(BC)&~isempty(m_all)
            cfsm;
        else
            msgbox('The file you attempted to load does not have data for constrained Finite Strip Method (cFSM), Use Load, or Input, after setting the bound. cond., then cFSM','Data unavailable','warn')
            waitforbuttonpress
            closereq
            cufsm5
        end
    end
    %
    if screen==4
        if ~isempty(prop)&~isempty(node)&~isempty(elem)&~isempty(lengths)&~isempty(curve)&~isempty(shapes)&~isempty(BC)&~isempty(m_all),
            compareout(1);
        else
            msgbox('The file you attempted to load does not have data for post-processing available. Use Load or Analyze, then Post, CUFSM resetting','Data unavailable','warn')
            waitforbuttonpress
            closereq
            cufsm5
        end
    end
    %
    if screen==0
        pre2
    end
end
%-------------------------------------------------------------------


case 8
%-------------------------------------------------------------------
%code for the input button
commandbar_cb(24) %if selected from applied stress gen, check stress
pre2
%-------------------------------------------------------------------

case 9
%-------------------------------------------------------------------
%code for the save button
commandbar_cb(24) %if selected from applied stress gen, check stress
if screen==5
    [pathname,filename]=saver(prop,node,elem,lengths,curve,shapes,springs,constraints,GBTcon,clas,BC,m_all);
    compareout(0);
elseif screen==9
    %hole effect screen no daving from this screen
    msgbox('Currently CUFSM does not save variables related to hole effect analysis, you can use the generate files button to save all cross-sections created for local and distortional buckling analysis','Save from Hole Effect Analysis Tool')
else
    if screen==2
        if ~isempty(curve)|~isempty(shapes)
            question=questdlg('Analysis results already exist, do you want to save them with this input?');
            switch question
                case 'No'
                    curve=[];, shapes=[];
            end
        else
            curve=[];, shapes=[];
        end
        prop=str2num(get(ed_prop,'String'));
        node=str2num(get(ed_node,'String'));
        elem=str2num(get(ed_elem,'String'));
        springs=str2num(get(ed_springs,'String'));
        constraints=str2num(get(ed_constraints,'String'));
        node=sortrows(node,1);
        crossect(node,elem,axestop,springs,constraints,flags);
        if isempty(lengths)|isempty(m_all)|isempty(BC)
            question=questdlg('No lengths and boundary condition data, do you want to proceed to bound. cond. setting?');
            switch question
                case 'Yes'
                    boundcond;
            end
        end
    end
    if screen==6
        if ~isempty(curve)|~isempty(shapes)
            question=questdlg('Analysis results already exist, do you want to save them with this input?');
            switch question
                case 'No'
                    curve=[];, shapes=[];
            end
        else
            curve=[];, shapes=[];
        end
        %boundary conditions
        val_BC = get(popup_BC,'Value');
        if solutiontype==1
            if val_BC==1, HBC='S-S';, elseif val_BC==2, HBC='C-C';,
            elseif val_BC==3, HBC='S-C';, elseif val_BC==4, HBC='C-F';,
            elseif val_BC==5, HBC='C-G';, end
            BC=HBC;
        elseif solutiontype==2
            if val_BC==1, PBC='S-S';, elseif val_BC==2, PBC='C-C';,
            elseif val_BC==3, PBC='S-C';, elseif val_BC==4, PBC='C-F';,
            elseif val_BC==5, PBC='C-G';, end
            BC=PBC;
        end
        
        len_m_cell=get(ed_m,'String');
        if solutiontype==1
            Hlengths=str2num(len_m_cell);
            [Hlengths]=sort(Hlengths);
            Hlengths=Hlengths';%make sure Hlengths is a row vector to be consistent
            for i=1:length(Hlengths)
                Hm_all{i}=[1];
            end
            lengths=Hlengths;
            m_all=Hm_all;
        elseif solutiontype==2
            len_w_m=[];len_w_m_str=[];len_m=[];
            Plengths=[];Pm_all=[];
            if ischar(len_m_cell)|max(size(len_m_cell))==1
                if ischar(len_m_cell)
                    len_m{1}=str2num(len_m_cell);
                elseif max(size(len_m_cell))==1
                    len_m{1}=str2num(len_m_cell{1});
                end
                if size(len_m{1},1)>1
                    for i=1:length(len_m{1})
                        Plengths(1,i)=len_m{1}(i);
                        Pm_all{i}=[1];
                    end
                else
                    Plengths(1,1)=len_m{1}(1);
                    if size(len_m{1},2)==1
                        Pm_all{1}(1,1)=1;
                    else
                        Pm_all{1}(1,:)=len_m{1}(2:end);
                    end
                    [Pm_all]=msort(Pm_all);
                end
            else
                for i=1:max(size(len_m_cell))
                    len_m{i}=str2num(len_m_cell{i});
                    Plengths(1,i)=len_m{i}(1);
                    if size(len_m{i},2)==1
                        iPm_all{i}(1,1)=1;
                    else
                        iPm_all{i}(1,:)=len_m{i}(2:end);
                        [iPm_all]=msort(iPm_all);
                    end
                end
                
                [Plengths,Plengths_index]=sort(Plengths);
                for i=1:length(Plengths)
                    Pm_all{i}=iPm_all{Plengths_index(i)};
                end
            end
            lengths=Plengths;
            m_all=Pm_all;
        end
        neigs=str2num(get(ed_neigs,'String'));
    end
    [pathname,filename]=saver(prop,node,elem,lengths,curve,shapes,springs,constraints,GBTcon,clas,BC,m_all);
end
%-------------------------------------------------------------------

case 10
%-------------------------------------------------------------------
%code for the cFSM button
commandbar_cb(24) %if selected from applied stress gen, check stress
if screen==2
	prop=str2num(get(ed_prop,'String'));
	node=str2num(get(ed_node,'String'));
	elem=str2num(get(ed_elem,'String'));
	springs=str2num(get(ed_springs,'String'));
	constraints=str2num(get(ed_constraints,'String'));
	node=sortrows(node,1);
	crossect(node,elem,axestop,springs,constraints,flags);
end
if screen==6
    %boundary conditions
    val_BC = get(popup_BC,'Value');
    if solutiontype==1
        if val_BC==1, HBC='S-S';, elseif val_BC==2, HBC='C-C';,
        elseif val_BC==3, HBC='S-C';, elseif val_BC==4, HBC='C-F';,
        elseif val_BC==5, HBC='C-G';, end
        if ~strcmp(HBC,'S-S')
            question=questdlg('Signature curve (m=1) loses its original meaning for boundary conditions other than simply supported (S-S). Continue to cFSM anyway?','Boundary condition changed');
            switch question
                case 'No'
                    return;
                case 'Cancel'
                    return;
            end
        end
        BC=HBC;
    elseif solutiontype==2
        if val_BC==1, PBC='S-S';, elseif val_BC==2, PBC='C-C';,
        elseif val_BC==3, PBC='S-C';, elseif val_BC==4, PBC='C-F';,
        elseif val_BC==5, PBC='C-G';, end
        BC=PBC;
    end
    
    len_m_cell=get(ed_m,'String');
    if solutiontype==1
        Hlengths=str2num(len_m_cell);
        [Hlengths]=sort(Hlengths);
        Hlengths=Hlengths';%make sure Hlengths is a row vector to be consistent
        for i=1:length(Hlengths)
            Hm_all{i}=[1];
        end
        lengths=Hlengths;
        m_all=Hm_all;
    elseif solutiontype==2
        len_w_m=[];len_w_m_str=[];len_m=[];
        Plengths=[];Pm_all=[];
        if ischar(len_m_cell)|max(size(len_m_cell))==1
            if ischar(len_m_cell)
                len_m{1}=str2num(len_m_cell);
            elseif max(size(len_m_cell))==1
                len_m{1}=str2num(len_m_cell{1});
            end
            if size(len_m{1},1)>1
                for i=1:length(len_m{1})
                    Plengths(1,i)=len_m{1}(i);
                    Pm_all{i}=[1];
                end
            else
                Plengths(1,1)=len_m{1}(1);
                if size(len_m{1},2)==1
                    Pm_all{1}(1,1)=1;
                else
                    Pm_all{1}(1,:)=len_m{1}(2:end);
                end
                [Pm_all]=msort(Pm_all);
            end
        else
            for i=1:max(size(len_m_cell))
                len_m{i}=str2num(len_m_cell{i});
                Plengths(1,i)=len_m{i}(1);
                if size(len_m{i},2)==1
                    iPm_all{i}(1,1)=1;
                else
                    iPm_all{i}(1,:)=len_m{i}(2:end);
                    [iPm_all]=msort(iPm_all);
                end
            end
            
            [Plengths,Plengths_index]=sort(Plengths);
            for i=1:length(Plengths)
                Pm_all{i}=iPm_all{Plengths_index(i)};
            end
        end
        lengths=Plengths;
        m_all=Pm_all;
    end
    neigs=str2num(get(ed_neigs,'String'));
end

if ~isempty(prop)&~isempty(node)&~isempty(elem)&~isempty(lengths)&~isempty(BC)&~isempty(m_all)
    cfsm;
else
    if screen==2
        msgbox('No boundary condition data available for constrained finite strip method.  Go Bound. Cond. first, then cFSM','Data unavailable','help');
    else
        msgbox('No data available for constrained Finite Strip Method (cFSM). Use Load, or Input, after setting the bound. cond., then cFSM','Data unavailable','help');
    end
end
%-------------------------------------------------------------------


case 11
%-------------------------------------------------------------------
%code for the analysis button
commandbar_cb(24) %if selected from applied stress gen, check stress
%
if screen==2
	prop=str2num(get(ed_prop,'String'));
	node=str2num(get(ed_node,'String'));
	elem=str2num(get(ed_elem,'String'));
	springs=str2num(get(ed_springs,'String'));
	constraints=str2num(get(ed_constraints,'String'));
	node=sortrows(node,1);
	crossect(node,elem,axestop,springs,constraints,flags);
end
if screen==6
    %boundary conditions
    val_BC = get(popup_BC,'Value');
    if solutiontype==1
        if val_BC==1, HBC='S-S';, elseif val_BC==2, HBC='C-C';,
        elseif val_BC==3, HBC='S-C';, elseif val_BC==4, HBC='C-F';,
        elseif val_BC==5, HBC='C-G';, end        
        if strcmp(HBC,'C-C')
            question=questdlg('Use of signature curve (m=1) for clamped-clamped (C-C) boundary condition loses its original meaning, results should be used with care, or change to General boundary condition solution and use multiple "m" longitudinal terms. Proceed anyway?','Boundary condition changed');
            switch question
                case 'No'
                    return;
                case 'Cancel'
                    return;
            end
        elseif strcmp(HBC,'S-C')
            question=questdlg('Use of signature curve (m=1) for simple-clamped (S-C) boundary condition loses its original meaning, results should be used with care, or change to General boundary condition solution and use multiple "m" longitudinal terms. Proceed anyway?','Boundary condition changed');
            switch question
                case 'No'
                    return;
                case 'Cancel'
                    return;
            end
        elseif strcmp(HBC,'C-F')
            question=questdlg('Use of signature curve (m=1) for clamped-free (C-F) boundary condition loses its original meaning, results should be used with care, or change to General boundary condition solution and use multiple "m" longitudinal terms. Proceed anyway?','Boundary condition changed');
            switch question
                case 'No'
                    return;
                case 'Cancel'
                    return;
            end
        elseif strcmp(HBC,'C-G')
            question=questdlg('Use of signature curve (m=1) for clamped-guided (C-G) boundary condition loses its original meaning, results should be used with care, or change to General boundary condition solution and use multiple "m" longitudinal terms. Proceed anyway?','Boundary condition changed');
            switch question
                case 'No'
                    return;
                case 'Cancel'
                    return;
            end
        end
        BC=HBC;
    elseif solutiontype==2
        if val_BC==1, PBC='S-S';, elseif val_BC==2, PBC='C-C';,
        elseif val_BC==3, PBC='S-C';, elseif val_BC==4, PBC='C-F';,
        elseif val_BC==5, PBC='C-G';, end
        BC=PBC;
    end
    
    len_m_cell=get(ed_m,'String');
    if solutiontype==1
        Hlengths=str2num(len_m_cell);
        [Hlengths]=sort(Hlengths);
        Hlengths=Hlengths';%make sure Hlengths is a row vector to be consistent
        for i=1:length(Hlengths)
            Hm_all{i}=[1];
        end
        lengths=Hlengths;
        m_all=Hm_all;
    elseif solutiontype==2
        len_w_m=[];len_w_m_str=[];len_m=[];
        Plengths=[];Pm_all=[];
        if ischar(len_m_cell)|max(size(len_m_cell))==1
            if ischar(len_m_cell)
                len_m{1}=str2num(len_m_cell);
            elseif max(size(len_m_cell))==1
                len_m{1}=str2num(len_m_cell{1});
            end
            if size(len_m{1},1)>1
                for i=1:length(len_m{1})
                    Plengths(1,i)=len_m{1}(i);
                    Pm_all{i}=[1];
                end
            else
                Plengths(1,1)=len_m{1}(1);
                if size(len_m{1},2)==1
                    Pm_all{1}(1,1)=1;
                else
                    Pm_all{1}(1,:)=len_m{1}(2:end);
                end
                [Pm_all]=msort(Pm_all);
            end
        else
            for i=1:max(size(len_m_cell))
                len_m{i}=str2num(len_m_cell{i});
                Plengths(1,i)=len_m{i}(1);
                if size(len_m{i},2)==1
                    iPm_all{i}(1,1)=1;
                else
                    iPm_all{i}(1,:)=len_m{i}(2:end);
                end
            end
            [iPm_all]=msort(iPm_all);
            [Plengths,Plengths_index]=sort(Plengths);
            for i=1:length(Plengths)
                Pm_all{i}=iPm_all{Plengths_index(i)};
            end
        end
        lengths=Plengths;
        m_all=Pm_all;
    end
    neigs=str2num(get(ed_neigs,'String'));
    boundcond_cb(25);
end
if screen==3
    GBTcon.glob=str2num(get(ed_global,'String'));
    GBTcon.dist=str2num(get(ed_dist,'String'));
    GBTcon.local=str2num(get(ed_local,'String'));
    GBTcon.other=str2num(get(ed_other,'String'));
end

if ~isempty(curve)&~isempty(shapes)%&curve{1}(1,1)~=0&shapes{1}(1,1)~=0
    question=questdlg('Analysis results already exist, perform analysis anyway?');
    switch question
        case 'Yes'
            %question2=questdlg('Select a solver for the analysis. The Alternate solver is good for bigger problems, but is less accurate than the Robust solver. If resulting buckling curve is not smooth try the Robust solver.','Choose a Solver','Alternate Solver','Robust Solver','Cancel');
            %switch question2, case 'Alternate Solver',watchon;,[curve,shapes]=strip(prop,node,elem,lengths,2,springs,constraints);,watchoff;
            %                  case 'Robust Solver',watchon;,[curve,shapes]=strip(prop,node,elem,lengths,1,springs,constraints);,watchoff;,end,
            %watchon;,[curve,shapes]=stripmain(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs);,watchoff;
            [curve,shapes]=stripmain(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs);
            compareout(1);
    end
elseif ~isempty(prop)&~isempty(node)&~isempty(elem)&~isempty(lengths)&~isempty(BC)&~isempty(m_all)
    %question2=questdlg('Select a solver for the analysis. The Alternate solver is good for bigger problems, but is less accurate than the Robust solver. If resulting buckling curve is not smooth try the Robust solver.','Choose a Solver','Alternate Solver','Robust Solver','Cancel');
    %switch question2, case 'Alternate Solver',watchon;,[curve,shapes]=strip(prop,node,elem,lengths,2,springs,constraints);,watchoff;
    %				   case 'Robust Solver',watchon;,[curve,shapes]=strip(prop,node,elem,lengths,1,springs,constraints);,watchoff;,end,
    %watchon;,[curve,shapes]=stripmain(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs);,watchoff;
    [curve,shapes]=stripmain(prop,node,elem,lengths,springs,constraints,GBTcon,BC,m_all,neigs);
    compareout(1);
else
    if screen==2
        msgbox('No boundary condition data available for analysis.  Go Bound. Cond. first, then Analyze','Data unavailable','help');
    else
        msgbox('No data available for analysis. Use Load, or Input, and Bound. Cond., then Analyze','Data unavailable','help');
    end
end
if screen==4;
    compareout;
end

%-------------------------------------------------------------------

case 12
%-------------------------------------------------------------------
%code for the zoom button
zoom_state=get(zoombtn,'Value');
if zoom_state == get(zoombtn,'Max')
    zoom
    set(panbtn,'Value',0);
    set(rotatebtn,'Value',0);
elseif zoom_state == get(zoombtn,'Min')
    zoom off
    set(zoombtn,'Value',0);
end

%-------------------------------------------------------------------

case 13
%-------------------------------------------------------------------
%code for the rotate button
rot_state=get(rotatebtn,'Value');
if rot_state == get(rotatebtn,'Max')
    rotate3d
    set(panbtn,'Value',0);
    set(zoombtn,'Value',0);
elseif rot_state == get(rotatebtn,'Min')
    rotate3d off
    set(rotatebtn,'Value',0);
end

%-------------------------------------------------------------------

case 14
%-------------------------------------------------------------------
%code for the pan button
pan_state=get(panbtn,'Value');
if pan_state == get(panbtn,'Max')
    pan on
    set(zoombtn,'Value',0);
    set(rotatebtn,'Value',0);
elseif pan_state == get(panbtn,'Min')
    pan off
    set(panbtn,'Value',0);
end


%-------------------------------------------------------------------
%-------------------------------------------------------------------
case 20
%-------------------------------------------------------------------
%code for the boundary condition button (Bound. Cond.)
commandbar_cb(24) %if selected from applied stress gen, check stress
if screen==2
	prop=str2num(get(ed_prop,'String'));
	node=str2num(get(ed_node,'String'));
	elem=str2num(get(ed_elem,'String'));
	springs=str2num(get(ed_springs,'String'));
	constraints=str2num(get(ed_constraints,'String'));
	node=sortrows(node,1);
	crossect(node,elem,axestop,springs,constraints,flags);
end
if ~isempty(prop)&~isempty(node)&~isempty(elem)
	boundcond;
else
  	msgbox('No data available for advance input. Use Load, or Input, then Bound. Cond.','Data unavailable','help');
end


%-------------------------------------------------
case 21
%code for the template called from the main menu
%call pre-processor
commandbar_cb(8);
%call template
pre2_cb(1);
%-----------------------------------------------

%-------------------------------------------------
case 22
%code for section properties called from the main menu
propout;
%-----------------------------------------------

%-------------------------------------------------
case 23
%call applied stress generator
loading;
%-----------------------------------------------

case 24        
%-----catches potential change in applied stresses when leaving applied
%stress generator..
    if screen==7 %on stress generation page and want to leave it
        if min(node(:,8)==inode(:,8))
            %all stresses matched no need to move applied stress into pre
        else
            %not all stressed matched so need to find out if user wants to move
            %the applied stresses into the pre-processor / save as input
            % Construct a questdlg with three options
            choice = questdlg('Stress created in generator has not been saved for input, would you like to use generated stress in the model?', ...
                'Import Generated Stress', ...
                'Yes','No','No');
            % Handle response
            switch choice
                case 'Yes'
                    node(:,8)=inode(:,8);
                case 'No'
                    %all good, nothing to do
            end
        end
    end
%------

%-------------------------------------------------
case 25
%call applied stress generator
plasticbuild;
%-----------------------------------------------

%-------------------------------------------------
case 26
%call hole helper analysis tool
holehelper;
%----------------------------------------------


%-------------------------------------------------
case 31
%import MASTAN forces
%loading;
%loading_cb(300);
%-----------------------------------------------

%-------------------------------------------------
case 32
%Export section to MASTAN
%propout;
%propout_cb(100);
%-----------------------------------------------

%-------------------------------------------------
case 33
%Fire up CUTWP
if screen==0
    pre2;
end
%if lengths empty (since it is done in a separate step)
if isempty(lengths)
    lengths(1)=1;
end
%save key variable to temp file in cutwp directory
%use global variables instead..
    % if ispc %pc
    %     %save([currentlocation,'\cutwp\fromcufsm'],'prop','node','elem','lengths');
    %     save(['fromcufsm'],'prop','node','elem','lengths');
    % else %mac! or unix
    %     %save([currentlocation,'/cutwp/fromcufsm'],'prop','node','elem','lengths');
    %     save(['fromcufsm'],'prop','node','elem','lengths');
    % end
cutwp;
cutwp('FromCUFSM');
%-----------------------------------------------

%-------------------------------------------------
case 34
%Fire up Abaqusmaker
% if screen==0
%     pre2;
% end
% %if lengths empty (since it is done in a separate step)
% if isempty(lengths)
%     lengths(1)=1;
% end
% if isempty(curve)
%     curve=[1 1];
% end
% %save key variable to temp file in cutwp directory
% %using globals instead...
%     % if ispc %pc
%     %     %save([currentlocation,'\abaqusmaker\abaqus_me_subs\fromcufsm'],'prop','node','elem','lengths','curve','shapes');
%     %     save([currentlocation,'\fromcufsm'],'prop','node','elem','lengths','curve','shapes');
%     % else %mac! or unix
%     %     %save([currentlocation,'/abaqusmaker/abaqus_me_subs/fromcufsm'],'prop','node','elem','lengths','curve','shapes');
%     %     save([currentlocation,'/fromcufsm'],'prop','node','elem','lengths','curve','shapes');
%     % end
% abaqus_me;
% cufsmhelp(500)
%-----------------------------------------------

case 51
%-------------------------------------------------------------------
%code for the pan menu
pan_state=get(m3a,'Checked');
if strcmp(pan_state,'off')
    pan on
    set(m3a,'Checked','on');
    set(m3b,'Checked','off');
    set(m3c,'Checked','off');
    set(p3a,'State','on');
    set(p3b,'State','off');
    set(p3c,'State','off');
elseif strcmp(pan_state,'on')
    pan off
    set(m3a,'Checked','off');
    set(p3a,'State','off');
end
pan_state2=get(p3a,'State');
if strcmp(pan_state2,'on')
    pan on
    set(m3a,'Checked','on');
    set(m3b,'Checked','off');
    set(m3c,'Checked','off');
    set(p3a,'State','on');
    set(p3b,'State','off');
    set(p3c,'State','off');
elseif strcmp(pan_state2,'off')
    pan off
    set(m3a,'Checked','off');
    set(p3a,'State','off');
end

case 52
%-------------------------------------------------------------------
%code for the zoom menu
zoom_state=get(m3b,'Checked');
if strcmp(zoom_state,'off')
    zoom on
    set(m3b,'Checked','on');
    set(m3a,'Checked','off');
    set(m3c,'Checked','off');
    set(p3b,'State','on');
    set(p3a,'State','off');
    set(p3c,'State','off');
elseif strcmp(zoom_state,'on')
    zoom off
    set(m3b,'Checked','off');
    set(p3b,'State','off');
end
zoom_state2=get(p3b,'State');
if strcmp(zoom_state2,'on')
    zoom on
    set(m3b,'Checked','on');
    set(m3a,'Checked','off');
    set(m3c,'Checked','off');
    set(p3b,'State','on');
    set(p3a,'State','off');
    set(p3c,'State','off');
elseif strcmp(zoom_state2,'off')
    zoom off
    set(m3b,'Checked','off');
    set(p3b,'State','off');
end


%-------------------------------------------------------------------

case 53
%-------------------------------------------------------------------
%code for the rotate menu
rot_state=get(m3c,'Checked');
if strcmp(rot_state,'off')
    rotate3d on
    set(m3c,'Checked','on');
    set(m3a,'Checked','off');
    set(m3b,'Checked','off');
    set(p3c,'State','on');
    set(p3a,'State','off');
    set(p3b,'State','off');
elseif strcmp(rot_state,'on')
    rotate3d off
    set(m3c,'Checked','off');
    set(p3c,'State','off');
end
rot_state2=get(p3c,'State');
if strcmp(rot_state2,'on')
    rotate3d on
    set(m3c,'Checked','on');
    set(m3a,'Checked','off');
    set(m3b,'Checked','off');
    set(p3c,'State','on');
    set(p3a,'State','off');
    set(p3b,'State','off');
elseif strcmp(rot_state2,'off')
    rotate3d off
    set(m3c,'Checked','off');
    set(p3c,'State','off');
end


%-------------------------------------------------------------------






%-------------------------------------------------------------------
case 200
%-------------------------------------------------------------------
%code for the about button
cufsmhelp(200)
%-------------------------------------------------------------------
end



