function []=loading_cb(num);
%zli
%August 2010
%
%general
global fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen
%output from pre2
global subfig ed_prop ed_node ed_elem ed_lengths axestop screen flags modeflag ed_springs ed_constraints
%output from template
global prop node elem lengths springs constraints h_tex b1_tex d1_tex q1_tex b2_tex d2_tex q2_tex r1_tex r2_tex r3_tex r4_tex t_tex C Z kipin Nmm axestemp subfig
%output from propout and loading
global A xcg zcg Ixx Izz Ixz thetap I11 I22 Cw J outfy_tex unsymm restrained Bas_Adv scale_w Xs Ys w scale_tex_w outPedit outMxxedit outMzzedit outM11edit outM22edit outTedit outBedit outL_Tedit outx_Tedit Pcheck Mxxcheck Mzzcheck M11check M22check Tcheck screen axesprop axesstres scale_tex maxstress_tex minstress_tex
%output from boundary condition (Bound. Cond.)
global ed_m ed_neigs solutiontype togglesignature togglegensolution popup_BC toggleSolution Plengths Pm_all Hlengths Hm_all subfig lengthindex axeslongtshape longitermindex txt_longterm len_cur len_longterm longshape_cur jScrollPane_edm jViewPort_edm jEditbox_edm hjScrollPane_edm
%output from cFSM
global toggleglobal toggledist togglelocal toggleother ed_global ed_dist ed_local ed_other NatBasis ModalBasis toggleCouple popup_load axesoutofplane axesinplane axes3d lengthindex modeindex spaceindex longitermindex b_v_view modename spacename check_3D cutface_edit len_cur mode_cur space_cur longterm_cur modes SurfPos scale twod threed undef scale_tex
%output from compareout
global pathname filename pathnamecell filenamecell propcell nodecell elemcell lengthscell curvecell clascell shapescell springscell constraintscell GBTconcell solutiontypecell BCcell m_allcell filedisplay files fileindex modes modeindex mmodes mmodeindex lengthindex axescurve togglelfvsmode togglelfvslength curveoption ifcheck3d minopt logopt threed undef len_plot lf_plot mode_plot SurfPos cutsurf_tex filename_plot len_cur scale_tex mode_cur mmode_cur file_cur xmin_tex xmax_tex ymin_tex ymax_tex filetoplot_tex screen popup_plot filename_title2 clasopt popup_classify times_classified toggleclassify classification_results plength_cur pfile_cur togglepfiles toggleplength mlengthindex mfileindex axespart_title axes2dshape axes3dshape axesparticipation axescurvemode  modedisplay modestoplot_tex


switch num
    
    
    case 1
        %-------------------------------------------------------------------
        %unsymmetric bending or restrained bending switch
        set(unsymm,'Value',1);
        set(restrained,'Value',0);
        %-------------------------------------------------------------------
        
    case 2
        %-------------------------------------------------------------------
        %unsymmetric bending or restrained bending switch
        set(unsymm,'Value',0);
        set(restrained,'Value',1);
        %-------------------------------------------------------------------
    case 3
        %-------------------------------------------------------------------
        %calculate loads based on a yield stress
        fy=str2num(get(outfy_tex,'String'));
        unsymmflag=get(unsymm,'Value');
        [Py,Mxx_y,Mzz_y,M11_y,M22_y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmflag);
        T=str2num(get(outTedit,'String'));
        L=str2num(get(outL_Tedit,'String'));
        x=str2num(get(outx_Tedit,'String'));
        if isnan(Cw)
            %section is not a simple open section no Bimoment calcualtions...
        else
            B=0; %zero out any old B value, initialize if new
            node=warp_stress(node,prop,1,T,B,L,x,Cw,J,w,1); %outBedit is updated in this function
        end
        set(outPedit,'String',num2str(Py));
        set(outMxxedit,'String',num2str(Mxx_y));
        set(outMzzedit,'String',num2str(Mzz_y));
        set(outM11edit,'String',num2str(M11_y));
        set(outM22edit,'String',num2str(M22_y));
        
        loading_cb(6)
        %-------------------------------------------------------------------
    case 4
        %-------------------------------------------------------------------
        %generate a stress distribution for use in analysis
        P=str2num(get(outPedit,'String'));
        Mxx=str2num(get(outMxxedit,'String'));
        Mzz=str2num(get(outMzzedit,'String'));
        M11=str2num(get(outM11edit,'String'));
        M22=str2num(get(outM22edit,'String'));
        T=str2num(get(outTedit,'String'));
        L=str2num(get(outL_Tedit,'String'));
        x=str2num(get(outx_Tedit,'String'));
        B=str2num(get(outBedit,'String'));
        Pflag=get(Pcheck,'Value');
        Mxxflag=get(Mxxcheck,'Value');
        Mzzflag=get(Mzzcheck,'Value');
        M11flag=get(M11check,'Value');
        M22flag=get(M22check,'Value');
        Tflag=get(Tcheck,'Value');
        unsymmflag=get(unsymm,'Value');
        node=stresgen(node,P*Pflag,Mxx*Mxxflag,Mzz*Mzzflag,M11*M11flag,M22*M22flag,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmflag);
        node=warp_stress(node,prop,Tflag,T,B,L,x,Cw,J,w,0);
        scale=str2num(get(scale_tex,'String'));
        maxstress=max([node(:,8);0]);
        set(maxstress_tex,'String',num2str(maxstress));
        minstress=min([node(:,8);0]);
        set(minstress_tex,'String',num2str(minstress));
        strespic(node,elem,axesstres,scale)
        %
        %     set(ed_node,'String',sprintf('%i %.2f %.2f %i %i %i %i %.2f\n',node'));
        %     set(ed_elem,'String',sprintf('%i %i %i %.6f %i\n',elem'));
        close(subfig);
        flags=[1 0 0 0 1 0 1 1 1]; 
        figure(fig);
        pre2;
        %-------------------------------------------------------------------
    case 5
        close(subfig);
        flags=[1 0 0 0 1 0 1 1 1]; 
        figure(fig);
        pre2;
        %-------------------------------------------------------------------
    case 6
         %plot the stress distribution based on checks
        P=str2num(get(outPedit,'String'));
        Mxx=str2num(get(outMxxedit,'String'));
        Mzz=str2num(get(outMzzedit,'String'));
        M11=str2num(get(outM11edit,'String'));
        M22=str2num(get(outM22edit,'String'));
        T=str2num(get(outTedit,'String'));
        L=str2num(get(outL_Tedit,'String'));
        x=str2num(get(outx_Tedit,'String'));
        B=str2num(get(outBedit,'String'));
        Pflag=get(Pcheck,'Value');
        Mxxflag=get(Mxxcheck,'Value');
        Mzzflag=get(Mzzcheck,'Value');
        M11flag=get(M11check,'Value');
        M22flag=get(M22check,'Value');
        Tflag=get(Tcheck,'Value');
        unsymmflag=get(unsymm,'Value');
        inode=stresgen(node,P*Pflag,Mxx*Mxxflag,Mzz*Mzzflag,M11*M11flag,M22*M22flag,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymmflag);
        inode=warp_stress(inode,prop,Tflag,T,B,L,x,Cw,J,w,0);
        scale=str2num(get(scale_tex,'String'));
        maxstress=max([inode(:,8);0]);
        set(maxstress_tex,'String',num2str(maxstress));
        minstress=min([inode(:,8);0]);
        set(minstress_tex,'String',num2str(minstress));
        strespic(inode,elem,axesstres,scale)
        %-------------------------------------------------------------------
    case 100
        %read forces from a mastan analysis into the applied load generator
        %
        %get path to mastan file
        [masFileName,masPathName] = uigetfile('*.mat','Select the MASTAN mat file');
        %
        %load mastan file
        load([masPathName,masFileName]);
        %
        %get element number and location along the element
        prompt={'Enter the element number:','Enter the normalized x/L location along the length [0-1]:','Enter the MASTAN analysis step:'};
        def={'1','0','1'};
        dlgTitle='MASTAN Element Number and location along length';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        maselenum=str2num(answer{1});
        maseleloc=str2num(answer{2});
        masstep=str2num(answer{3});
        %
        %read the forces from the mastan model
        ratio=maseleloc;
        startpt = node_info(elem_info(maselenum,1),1:3);
        endpt = node_info(elem_info(maselenum,2),1:3);
        L = norm(startpt - endpt);
        elfor = ele_for(maselenum,:,masstep);
        mP  = ratio*L*(( elfor(1) + elfor(7) )/L ) - elfor(1);
        mVy = elfor(2) - ratio*L*( elfor(2) + elfor(8) )/L;
        mVz = elfor(3) - ratio*L*( elfor(3) + elfor(9) )/L;
        mTx = ratio*L*(( elfor(10)+elfor(4))/L ) - elfor(4);
        mMy = elfor(5) + ratio*L*elfor(3) - ((ratio*L)^2) * ( elfor(11) + elfor(5) + L*elfor(3) )/(L^2);
        mMz = ((ratio*L)^2) * ( elfor(12) + elfor(6) - L*elfor(2) )/(L^2) + ratio*L*elfor(2) - elfor(6);
        mB  = ratio*L*(( elfor(14)-elfor(13))/L ) + elfor(13); 
        %
        %CUFSM sign convention is axial compression is positive
        mP=-mP;
        %
        %provide section properties from MASTAN and CUFSM, confirm load
        %cufsm section properties
        %name
        if isempty(filename)
            mas_name=['cufsm',datestr(floor(now))];
        else
            mas_name=[filename(1:length(filename)-4)];
        end
        %properties - use globals for now..
        %mastan
        sectionnum=elem_info(maselenum,3);
        %Confirm replacement of MASTAN section properties with CUFSM section properties
        prch={['Confirm that selected element matches current CUFSM section'];
            [strjoin([{'MASTAN name='};sect_name{sectionnum}]),' CUFSM= ',mas_name];
            ['MASTAN A=',num2str(sect_info(sectionnum,1)),' CUFSM= ',num2str(A)];
            ['MASTAN Izz=',num2str(sect_info(sectionnum,2)),' CUFSM= ',num2str(Ixx)];
            ['MASTAN Iyy=',num2str(sect_info(sectionnum,3)),' CUFSM= ',num2str(Izz)];
            ['MASTAN J=',num2str(sect_info(sectionnum,4)),' CUFSM= ',num2str(J)];
            ['MASTAN Cw=',num2str(sect_info(sectionnum,5)),' CUFSM= ',num2str(Cw)];
            ['MASTAN Zzz=',num2str(sect_info(sectionnum,6)),' CUFSM= ',num2str(Ixx)];
            ['MASTAN Zyy=',num2str(sect_info(sectionnum,7)),' CUFSM= ',num2str(Izz)];
            ['MASTAN Ayy=',num2str(sect_info(sectionnum,8)),' CUFSM= ',num2str(Inf)];
            ['MASTAN Azz=',num2str(sect_info(sectionnum,9)),' CUFSM= ',num2str(Inf)];
            ['--------------------------------------------------------------------'];
            ['Raw MASTAN output to be read into CUFSM'];
            ['Filename=',masPathName,masFileName];
            ['Element=',num2str(maselenum)];
            ['Section=',num2str(sectionnum)];
            ['Nodes=',num2str(elem_info(maselenum,1)),':',num2str(elem_info(maselenum,2))];
            ['x/L=',num2str(ratio)];
            ['P=',num2str(-mP)];
            ['Vy=',num2str(mVy)];
            ['Vz=',num2str(mVz)];
            ['Tx=',num2str(mTx)];
            ['My=',num2str(mMy)];
            ['Mz=',num2str(mMz)];
            ['B=',num2str(mB)]};
        choice = questdlg(prch,'Continue with loading MASTAN forces','Yes','No','No');
        switch choice
            case 'Yes'
                %ok...
            case 'No'
                return
        end        
        %
        %
        %load P,M,B
        set(outPedit,'String',num2str(mP));
        set(outMxxedit,'String',num2str(mMz));
        set(outMzzedit,'String',num2str(mMy));
        set(outM11edit,'String',num2str(0));
        set(outM22edit,'String',num2str(0));
        set(outBedit,'String',num2str(mB));
        %
        %set the flags
        set(Pcheck,'Value',1);
        set(Mxxcheck,'Value',1);
        set(Mzzcheck,'Value',1);
        set(M11check,'Value',0);
        set(M22check,'Value',0);
        set(Tcheck,'Value',1);
        %
        %plot the results
        loading_cb(6)    
        %-------------------------------------------------------------------
end