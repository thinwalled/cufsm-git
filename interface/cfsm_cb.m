function []=cfsm_cb(num)
%cfsm_cb
%Z. Li, July 2010 (last modified)

%general
global fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen zoombtn panbtn rotatebtn
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

switch num
    %
    %---------------------------------------------------
    case 1
        %activate new plots
        
        %turn off the 3D plot each time when changes happen
        axes(axes3d);
        cla reset, axis off
       
        %Plot the mode shapes
        scale=str2num(get(scale_tex,'String'));
        ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
        m_a=m_all{lengthindex};
        %plot base vectors for 2D
        if GBTcon.couple==1
            mode=b_v_view((longitermindex-1)*ndof_m+1:1:longitermindex*ndof_m,modeindex);
            dispshap(1,node,elem,mode,axesinplane,scale,springs,m_a(longitermindex),BC,SurfPos);
            vdisppic(node,elem,axesoutofplane,scale,mode,m_a(longitermindex),BC,SurfPos);
        elseif GBTcon.couple==2
            mode=b_v_view(:,modeindex);
            dispshap(1,node,elem,mode,axesinplane,scale,springs,m_a,BC,SurfPos);
            vdisppic(node,elem,axesoutofplane,scale,mode,m_a,BC,SurfPos);
        end
        %
        %---------------------------------------------------
    case 2
        %up a length
        lengthindex=min(lengthindex+1,length(lengths));
        set(len_cur,'String',num2str(lengths(lengthindex)));
        m_a=m_all{lengthindex};
        a=lengths(lengthindex);
        %
        totalm=length(m_a);
        ndof_m=4*length(node(:,1));
        modes=[];
        modes=(1:1:totalm*ndof_m);
        for i=1:length(modes)
            j=rem(i,ndof_m);
            if j==0  %O
                modename{i}=['O',num2str(ndof_m-length([GBTcon.glob,GBTcon.dist,GBTcon.local]))];
            elseif j>0&j<=length(GBTcon.glob)
                modename{i}=['G',num2str(j)];
            elseif j>length(GBTcon.glob)&j<=length([GBTcon.glob,GBTcon.dist])
                modename{i}=['D',num2str(j-length(GBTcon.glob))];
            elseif j>length([GBTcon.glob,GBTcon.dist])&j<=length([GBTcon.glob,GBTcon.dist,GBTcon.local])
                modename{i}=['L',num2str(j-length([GBTcon.glob,GBTcon.dist]))];
            elseif j>length([GBTcon.glob,GBTcon.dist,GBTcon.local])
                modename{i}=['O',num2str(j-length([GBTcon.glob,GBTcon.dist,GBTcon.local]))];
            end
        end
        modeindex=1;
        set(mode_cur,'String',modename{modeindex});
        set(space_cur,'String',spacename{1});
        longitermindex=1;
        set(longterm_cur,'String',num2str(m_a(longitermindex)));
        
        %generate natural base vectors
        [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a);
        %orthonormal vectors
        b_v_view=base_update(GBTcon.ospace,1,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,GBTcon.couple,GBTcon.orth);
        cfsm_cb(1);
        %
        %---------------------------------------------------
    case 3
        %down a length
        
        lengthindex=max(lengthindex-1,1);
        set(len_cur,'String',num2str(lengths(lengthindex)));
        m_a=m_all{lengthindex};
        a=lengths(lengthindex);
        %
        totalm=length(m_a);
        ndof_m=4*length(node(:,1));
        modes=[];
        modes=(1:1:totalm*ndof_m);
        for i=1:length(modes)
            j=rem(i,ndof_m);
            if j==0  %O
                modename{i}=['O',num2str(ndof_m-length([GBTcon.glob,GBTcon.dist,GBTcon.local]))];
            elseif j>0&j<=length(GBTcon.glob)
                modename{i}=['G',num2str(j)];
            elseif j>length(GBTcon.glob)&j<=length([GBTcon.glob,GBTcon.dist])
                modename{i}=['D',num2str(j-length(GBTcon.glob))];
            elseif j>length([GBTcon.glob,GBTcon.dist])&j<=length([GBTcon.glob,GBTcon.dist,GBTcon.local])
                modename{i}=['L',num2str(j-length([GBTcon.glob,GBTcon.dist]))];
            elseif j>length([GBTcon.glob,GBTcon.dist,GBTcon.local])
                modename{i}=['O',num2str(j-length([GBTcon.glob,GBTcon.dist,GBTcon.local]))];
            end
        end
        modeindex=1;
        set(mode_cur,'String',modename{modeindex});
        set(space_cur,'String',spacename{1});
        longitermindex=1;
        set(longterm_cur,'String',num2str(m_a(longitermindex)));
        
        %generate natural base vectors
        m_a=m_all{lengthindex};
        a=lengths(lengthindex);
        [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a);
        %orthonormal vectors
        b_v_view=base_update(GBTcon.ospace,1,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,GBTcon.couple,GBTcon.orth);
        cfsm_cb(1);
        %
        %---------------------------------------------------
    case 4
        %up a mode number
        modeindex=min(modeindex+1,length(modes));
        set(mode_cur,'String',modename{modeindex});
        ndof_m=4*length(node(:,1));
        j=rem(modeindex,ndof_m);
        if j==0  %O
            spaceindex=4;
        elseif j<=length(GBTcon.glob) %G
            spaceindex=1;
        elseif j<=length(GBTcon.glob)+length(GBTcon.dist) %D
            spaceindex=2;
        elseif j<=length(GBTcon.glob)+length(GBTcon.dist)+length(GBTcon.local) %L
            spaceindex=3;
        else  %O
            spaceindex=4;
        end
        %
        set(space_cur,'String',spacename{spaceindex});
        
        if j==0
            longitermindex=fix(modeindex./ndof_m);
        else
            longitermindex=fix(modeindex./ndof_m)+1;
        end
        %
        m_a=m_all{lengthindex};
        set(longterm_cur,'String',num2str(m_a(longitermindex)));
        
        cfsm_cb(1);
        %
        %---------------------------------------------------
    case 5
        %down a mode number
        modeindex=max(1,modeindex-1);
        set(mode_cur,'String',modename{modeindex});
        ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
        j=rem(modeindex,ndof_m);
        if j==0  %O
            spaceindex=4;
        elseif j<=length(GBTcon.glob) %G
            spaceindex=1;
        elseif j<=length(GBTcon.glob)+length(GBTcon.dist) %D
            spaceindex=2;
        elseif j<=length(GBTcon.glob)+length(GBTcon.dist)+length(GBTcon.local) %L
            spaceindex=3;
        else  %O
            spaceindex=4;
        end
        %
        set(space_cur,'String',spacename{spaceindex});
        
        if j==0
            longitermindex=fix(modeindex./ndof_m);
        else
            longitermindex=fix(modeindex./ndof_m)+1;
        end
        %
        m_a=m_all{lengthindex};
        set(longterm_cur,'String',num2str(m_a(longitermindex)));
        
        cfsm_cb(1);
        %
        %---------------------------------------------------
    case 6
        %up a space number
        m_a=m_all{lengthindex};
        totalm=length(m_a);
        spaceindex=min(spaceindex+1,4*totalm);
        j=rem(spaceindex,4);
        if j==0
            longitermindex=fix(spaceindex./4);
            spacenameindex=4;
        else
            longitermindex=fix(spaceindex./4)+1;
            spacenameindex=j;
        end
        set(space_cur,'String',spacename{spacenameindex});
        
        ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
        if j==0 %O
            modeindex=1+length(GBTcon.glob)+length(GBTcon.dist)+length(GBTcon.local)+(longitermindex-1)*ndof_m;
        elseif j==1 %G
            modeindex=1+(longitermindex-1)*ndof_m;
        elseif j==2 %D
            modeindex=1+length(GBTcon.glob)+(longitermindex-1)*ndof_m;
        elseif j==3 %L
            modeindex=1+length(GBTcon.glob)+length(GBTcon.dist)+(longitermindex-1)*ndof_m;
        end
        set(mode_cur,'String',modename{modeindex});
        
        set(longterm_cur,'String',num2str(m_a(longitermindex)));
        
        cfsm_cb(1);
        %
        %---------------------------------------------------
    case 7
        %down a space number
        m_a=m_all{lengthindex};
        % totalm=length(m_a);
        
        spaceindex=max(1,spaceindex-1);
        j=rem(spaceindex,4);
        if j==0
            longitermindex=fix(spaceindex./4);
            spacenameindex=4;
        else
            longitermindex=fix(spaceindex./4)+1;
            spacenameindex=j;
        end
        set(space_cur,'String',spacename{spacenameindex});
        
        ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
        if j==0 %O
            modeindex=1+length(GBTcon.glob)+length(GBTcon.dist)+length(GBTcon.local)+(longitermindex-1)*ndof_m;
        elseif j==1 %G
            modeindex=1+(longitermindex-1)*ndof_m;
        elseif j==2 %D
            modeindex=1+length(GBTcon.glob)+(longitermindex-1)*ndof_m;
        elseif j==3 %L
            modeindex=1+length(GBTcon.glob)+length(GBTcon.dist)+(longitermindex-1)*ndof_m;
        end
        set(mode_cur,'String',modename{modeindex});
        
        m_a=m_all{lengthindex};
        set(longterm_cur,'String',num2str(m_a(longitermindex)));
        cfsm_cb(1);
        %
        %---------------------------------------------------
    case 8
        % up a longitudinal term
        m_a=m_all{lengthindex};
        totalm=length(m_a);
        if longitermindex==totalm
        else
            longitermindex=min(longitermindex+1,totalm);
            set(longterm_cur,'String',num2str(m_a(longitermindex)));
            ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
            modeindex=modeindex+ndof_m;
            spaceindex=spaceindex+4;
            cfsm_cb(1);
        end
        %
        %---------------------------------------------------
    case 9
        % down a longitudinal term
        m_a=m_all{lengthindex};
        % totalm=length(m_a);
        if longitermindex==1
        else
            longitermindex=max(longitermindex-1,1);
            set(longterm_cur,'String',num2str(m_a(longitermindex)));
            ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
            modeindex=modeindex-ndof_m;
            spaceindex=spaceindex-4;
            cfsm_cb(1);
        end
        %
        %---------------------------------------------------
    case 10
        % surface position for 2D plot along the length
        SurfPos=str2num(get(cutface_edit,'String'));
        set(cutface_edit,'String',num2str(SurfPos));
        %Plot the mode shapes
        scale=str2num(get(scale_tex,'String'));
        ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
        m_a=m_all{lengthindex};
        %plot
        mode=b_v_view((longitermindex-1)*ndof_m+1:1:longitermindex*ndof_m,modeindex);
        dispshap(1,node,elem,mode,axesinplane,scale,springs,m_a(longitermindex),BC,SurfPos);
        vdisppic(node,elem,axesoutofplane,scale,mode,m_a(longitermindex),BC,SurfPos);
        %
        %---------------------------------------------------
    case 11
        % update scale for 2D and 3D
        scale=str2num(get(scale_tex,'String'));
        set(scale_tex,'String',num2str(scale));
        %Plot the mode shapes
        ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
        m_a=m_all{lengthindex};
        %plot
        if GBTcon.couple==1
            mode=b_v_view((longitermindex-1)*ndof_m+1:1:longitermindex*ndof_m,modeindex);
            dispshap(1,node,elem,mode,axesinplane,scale,springs,m_a(longitermindex),BC,SurfPos);
            vdisppic(node,elem,axesoutofplane,scale,mode,m_a(longitermindex),BC,SurfPos);
        elseif GBTcon.couple==2
            mode=b_v_view(:,modeindex);
            dispshap(1,node,elem,mode,axesinplane,scale,springs,m_a,BC,SurfPos);
            vdisppic(node,elem,axesoutofplane,scale,mode,m_a,BC,SurfPos);
        end
        
%         cfsm_cb(100);
    case 12
        %find the associated length based on user input
        Luser=str2num(get(len_cur,'String'));
        Lrel=abs(lengths-Luser);
        [Lindex]=find(min(Lrel)==Lrel);
        lengthindex=Lindex(1);
        set(len_cur,'String',num2str(lengths(lengthindex)));
        
        m_a=m_all{lengthindex};
        a=lengths(lengthindex);
        %
        totalm=length(m_a);
        ndof_m=4*length(node(:,1));
        modes=[];
        modes=(1:1:totalm*ndof_m);
        for i=1:length(modes)
            j=rem(i,ndof_m);
            if j==0  %O
                modename{i}=['O',num2str(ndof_m-length([GBTcon.glob,GBTcon.dist,GBTcon.local]))];
            elseif j>0&j<=length(GBTcon.glob)
                modename{i}=['G',num2str(j)];
            elseif j>length(GBTcon.glob)&j<=length([GBTcon.glob,GBTcon.dist])
                modename{i}=['D',num2str(j-length(GBTcon.glob))];
            elseif j>length([GBTcon.glob,GBTcon.dist])&j<=length([GBTcon.glob,GBTcon.dist,GBTcon.local])
                modename{i}=['L',num2str(j-length([GBTcon.glob,GBTcon.dist]))];
            elseif j>length([GBTcon.glob,GBTcon.dist,GBTcon.local])
                modename{i}=['O',num2str(j-length([GBTcon.glob,GBTcon.dist,GBTcon.local]))];
            end
        end
        modeindex=1;
        set(mode_cur,'String',modename{modeindex});
        set(space_cur,'String',spacename{1});
        longitermindex=1;
        set(longterm_cur,'String',num2str(m_a(longitermindex)));
        
        %generate natural base vectors
        m_a=m_all{lengthindex};
        a=lengths(lengthindex);
        [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a);
        %orthonormal vectors
        b_v_view=base_update(GBTcon.ospace,1,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,GBTcon.couple,GBTcon.orth);
        cfsm_cb(1);
        
        %---------------------------------------------------
    case 100
        % plot the 3D buckling shapes
        m_a=m_all{lengthindex};
        a=lengths(lengthindex);
        scale=str2num(get(scale_tex,'String'));
        ifpatch=get(checkpatch,'Value');
        ndof_m=4*length(node(:,1));%length([GBTcon.glob,GBTcon.dist,GBTcon.local,GBTcon.other])
        if GBTcon.couple==1
            mode=b_v_view((longitermindex-1)*ndof_m+1:1:longitermindex*ndof_m,modeindex);
            dispshp2(0,a,node,elem,mode,axes3d,scale,m_a(longitermindex),BC,ifpatch)
        elseif GBTcon.couple==2
            mode=b_v_view(:,modeindex);
            dispshp2(0,a,node,elem,mode,axes3d,scale,m_a,BC,ifpatch)
        end
        %
        %---------------------------------------------------
    case 101
        %exit
        close(subfig)
        %
    case 102
        %-------------------------------------------------------------------
        %code for the zoom button
        zoom
        %-------------------------------------------------------------------
        
    case 103
        %-------------------------------------------------------------------
        %code for the rotate button
        rotate3d
        %-------------------------------------------------------------------
    case 104
        %-------------------------------------------------------------------
        %code for the rotate button
        pan
        
        %-------------------------------------------------------------------
        %ACTIVATE GBT/MODAL CONSTRAINTS
    case 300
        %--------------
        if length(elem(:,1))>=length(node(:,1))
            %section is closed modal constraints won't go
            errordlg('Section appears closed #elements >= #nodes, modal constraints are not available for closed sections.','Closed section?')
            %deactivate the modal stuff
            GBTcon.glob=0;
            GBTcon.dist=0;
            GBTcon.local=0;
            GBTcon.other=0;
            %
            set(ed_global,'String',sprintf('%i ',GBTcon.glob'));
            set(ed_dist,'String',sprintf('%i ',GBTcon.dist'));
            set(ed_local,'String',sprintf('%i ',GBTcon.local'));
            set(ed_other,'String',sprintf('%i ',GBTcon.other'));
            %
            set(toggleglobal,'Value',0)
            set(toggledist,'Value',0)
            set(togglelocal,'Value',0)
            set(toggleother,'Value',0)
            modeflag=[0 0 0 0];
        else
            %section is open and modal constraints may be used or not
            if max(GBTcon.glob)+max(GBTcon.dist)+max(GBTcon.local)+max(GBTcon.other)>=1 %any 1's
                %deactivate the modal stuff
                GBTcon.glob=0;
                GBTcon.dist=0;
                GBTcon.local=0;
                GBTcon.other=0;
                %
                set(ed_global,'String',sprintf('%i ',GBTcon.glob'));
                set(ed_dist,'String',sprintf('%i ',GBTcon.dist'));
                set(ed_local,'String',sprintf('%i ',GBTcon.local'));
                set(ed_other,'String',sprintf('%i ',GBTcon.other'));
                %
                set(toggleglobal,'Value',0)
                set(toggledist,'Value',0)
                set(togglelocal,'Value',0)
                set(toggleother,'Value',0)
                modeflag=[0 0 0 0];
            else
                %Set the default values to include all modes!
                %
                %Generate unit length base vectors and number of modes
                [elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem);
                ngm=4;
                nom=2*(length(node(:,1))-1);
                GBTcon.glob=ones(1,ngm);
                GBTcon.dist=ones(1,ndm);
                GBTcon.local=ones(1,nlm);
                GBTcon.other=ones(1,nom);
                %
                %
                set(ed_global,'String',sprintf('%i ',GBTcon.glob'));
                set(ed_dist,'String',sprintf('%i ',GBTcon.dist'));
                set(ed_local,'String',sprintf('%i ',GBTcon.local'));
                set(ed_other,'String',sprintf('%i ',GBTcon.other'));
                %
                set(toggleglobal,'Value',1)
                set(toggledist,'Value',1)
                set(togglelocal,'Value',1)
                set(toggleother,'Value',1)
                modeflag=[1 1 1 1];
            end
        end
        %-------------------------------------------------------------------
    case 301
        %Global modes toggle
        if modeflag(1)
            set(toggleglobal,'Value',0)
            GBTcon.glob=0*GBTcon.glob;
            set(ed_global,'String',sprintf('%i ',GBTcon.glob'));
        else
            set(toggleglobal,'Value',1)
            GBTcon.glob=0*GBTcon.glob+1;
            set(ed_global,'String',sprintf('%i ',GBTcon.glob'));
        end
        if modeflag(1)==1, modeflag(1)=0;, else modeflag(1)=1;, end
        %-------------------------------------------------------------------
    case 302
        %Distortional modes toggle
        if modeflag(2)
            set(toggledist,'Value',0)
            GBTcon.dist=0*GBTcon.dist;
            set(ed_dist,'String',sprintf('%i ',GBTcon.dist'));
        else
            set(toggledist,'Value',1)
            GBTcon.dist=0*GBTcon.dist+1;
            set(ed_dist,'String',sprintf('%i ',GBTcon.dist'));
        end
        if modeflag(2)==1, modeflag(2)=0;, else modeflag(2)=1;, end
        %-------------------------------------------------------------------
    case 303
        %Local mode toggle
        if modeflag(3)
            set(togglelocal,'Value',0)
            GBTcon.local=0*GBTcon.local;
            set(ed_local,'String',sprintf('%i ',GBTcon.local'));
        else
            set(togglelocal,'Value',1)
            GBTcon.local=0*GBTcon.local+1;
            set(ed_local,'String',sprintf('%i ',GBTcon.local'));
        end
        if modeflag(3)==1, modeflag(3)=0;, else modeflag(3)=1;, end
        %-------------------------------------------------------------------
    case 304
        %Other modes toggle
        if modeflag(4)
            set(toggleother,'Value',0)
            GBTcon.other=0*GBTcon.other;
            set(ed_other,'String',sprintf('%i ',GBTcon.other'));
        else
            set(toggleother,'Value',1)
            GBTcon.other=0*GBTcon.other+1;
            set(ed_other,'String',sprintf('%i ',GBTcon.other'));
        end
        if modeflag(4)==1, modeflag(4)=0;, else modeflag(4)=1;, end
        %-------------------------------------------------------------------
    case 305
        %view modes
        if length(elem(:,1))>=length(node(:,1))
            %section is closed modal constraints won't go
            errordlg('Section appears closed #elements >= #nodes, modal constraints are not available for closed sections.','Closed section?')
        else
            GBTcon.glob=str2num(get(ed_global,'String'));
            GBTcon.dist=str2num(get(ed_dist,'String'));
            GBTcon.local=str2num(get(ed_local,'String'));
            GBTcon.other=str2num(get(ed_other,'String'));
            
            %Set default initial values
            if max(GBTcon.glob)+max(GBTcon.dist)+max(GBTcon.local)+max(GBTcon.other)<1
                cfsm_cb(300)
            end
            %
            lengthindex=1;
            longitermindex=1;
            modeindex=1;
            spaceindex=1;
            %
            m_a=m_all{lengthindex};
            a=lengths(lengthindex);
            %
            set(len_cur,'String',num2str(lengths(lengthindex)));
            set(mode_cur,'String',modename{modeindex});
            set(space_cur,'String',spacename{spaceindex});
            set(longterm_cur,'String',num2str(m_a(longitermindex)));
            %generate natural base vectors            
            [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a);
            %orthonormal vectors
            b_v_view=base_update(GBTcon.ospace,1,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,GBTcon.couple,GBTcon.orth);
            %
            if exist('springs')
            else
                springs=0;
            end
            %
            cfsm_cb(1);
        end
        %---------------------------------------------------------------------
        
    case 306
        %------------------------------------------------------------------------------------------
        %Natural/Modal Basis toggle
        set(NatBasis,'Value',1);
        set(ModalBasis,'Value',0);
        GBTcon.orth=1;
        %------------------------------------------------------------------------------------------
    case 307
        %------------------------------------------------------------------------------------------
        %Natural/Modal Basis toggle
        set(NatBasis,'Value',0);
        set(ModalBasis,'Value',1);
        val = get(popup_load,'Value');
        if val==1
            GBTcon.orth=2; %modal basis orthogonalized under uniform load
        elseif val==2
            GBTcon.orth=3; %modal basis orthogonalized under applied load
        end
        %------------------------------------------------------------------------------------------
    case 308
        %------------------------------------------------------------------------------------------
        %Modal Basis couple toggle
        valcouple = get(toggleCouple,'Value');
        if valcouple==0
            GBTcon.couple=1; %uncoupled basis, the basis will be block diagonal
        elseif valcouple==1
            GBTcon.couple=2; %coupled basis, the basis will be fully spanned
        end
end
