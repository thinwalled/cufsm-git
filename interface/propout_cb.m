function []=propout_cb(num)
%BWS
%August 2000 (last modified)
%December 2015 added mastan functionality and cleaned up some bits and
%pieces
%
%properties callbacks
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
%
%-------------------------------------------------------------------
%-------------------------------------------------------------------
%-------------------------------------------------------------------
switch num
    
    
    case 6
        %-------------------------------------------------------------------
        %Basic or advanced properties display switch
        b_a=get(Bas_Adv,'Value');
        if b_a==1
            propplot(node,elem,xcg,zcg,thetap,axesprop);
        else if b_a == 2
                scale_w=str2num(get(scale_tex_w,'String'));
                warppic(node,elem,scale_w,Xs,Ys,w,axesprop);
            end
        end
        
        
        
    case 7
        %save a text file
        [filename,pathname]=uiputfile('*.txt','Text Output Filename');
        if filename==0,return,else
            temp=[node(:,1) w];
            fwid = fopen([pathname,filename],'w');
            fprintf(fwid,'%d %24.12f \n',temp');
            fclose(fwid);
            %save([pathname,filename],'temp','-ascii')
        end
        
    case 100
        %Export section properties to Mastan
        %Name the section for use in MASTAN, have a default name
        if isempty(filename)
            def{1}=['cufsm',datestr(floor(now))];
        else
            def{1}=[filename(1:length(filename)-4)];
        end
        mas_name = inputdlg('Name of CUFSM section for use in MASTAN:','MASTAN section name',[1 50],def);
        %clean out any junk so mastan does not barf on the name later
        mas_name(ismember(mas_name,' ,.:;!')) = [];
        %If section is unsymmetric ask if we want to export Ixx,Izz or I11,I22
        if Ixx==I11 %symmetric
            %Generate the necessary section properties in MASTAN format
            mas_props=[A Ixx Izz J Cw Ixx Izz Inf Inf];
        else %unsymmetric
            choice = questdlg('Export principal or geometric axis bending properties?','Export to MASTAN','Principal','Geometric','Principal');
            switch choice
                case 'Principal'
                   mas_props=[A I11 I22 J Cw I11 I22 Inf Inf];
                case 'Geometric'
                   mas_props=[A Ixx Izz J Cw Ixx Izz Inf Inf];
            end
        end
        %Add to MASTAN's user.dat file or replace the section in an existing model?
        choice = questdlg('Select how to export your CUFSM section to MASTAN:','Export to MASTAN','Add section to MASTAN user database','Replace section in existing MASTAN model','Add section to MASTAN user database');
        switch choice
            case 'Add section to MASTAN user database'
                %Get the path to where the MASTAN user.dat file is
                [mas_path]=uigetdir('./','Select Mastan Directory / location of user.dat file');
                %Append the section data to the MASTAN user.dat file
                a=exist([mas_path,'/user.dat']);
                if a==2 %user.dat exists
                    %append the data to user.dat file
                    fid=fopen([mas_path,'/user.dat'],'a+');
                    fprintf(fid,'%s ',mas_name{1});
                    fprintf(fid,'%f %f %f %f %f %f %f %f %f\n',mas_props(1,:));
                    status=fclose(fid);
                else %user.dat does not exist, make a new file
                    fid=fopen([mas_path,'/user.dat'],'w+');
                    fprintf(fid,'%s\n',['%MASTAN ready cross-section properties consistent with CUFSM model']);
                    fprintf(fid,'%s\n',['%initial',mas_path,'/user.dat',' ',datestr(now)]);
                    fprintf(fid,'%s ',mas_name{1});
                    fprintf(fid,'%f %f %f %f %f %f %f %f %f\n',mas_props(1,:));
                    status=fclose(fid);
                end
                uiwait(msgbox('Current CUFSM section exported to user.dat, select database, user defined, in MASTAN to access the section in MASTAN','MASTAN Export Confirmation','modal'));
            case 'Replace section in existing MASTAN model'
                if isequal(filename,0)
                   return
                else
                   load([masPathName,masFileName],'sect_name','sect_info')
                   %get the MASTAN section number to be replaced by the CUFSM section
                   def{1}=['1'];
                   mas_sectionnum = inputdlg('Enter MASTAN section number to be replaced:','MASTAN Section Number',[1 50],def);
                   sectionnum=str2num(mas_sectionnum{1});
                   %Confirm replacement of MASTAN section properties with CUFSM section properties
                   prch={['Confirmation of section property change'];
                        [strjoin([{'name='};sect_name{sectionnum}]),' change to ',mas_name{1}];
                        ['A=',num2str(sect_info(sectionnum,1)),' change to ',num2str(A)];
                        ['Izz=',num2str(sect_info(sectionnum,2)),' change to ',num2str(Ixx)];
                        ['Iyy=',num2str(sect_info(sectionnum,3)),' change to ',num2str(Izz)];
                        ['J=',num2str(sect_info(sectionnum,4)),' change to ',num2str(J)];
                        ['Cw=',num2str(sect_info(sectionnum,5)),' change to ',num2str(Cw)];
                        ['Zzz=',num2str(sect_info(sectionnum,6)),' change to ',num2str(Ixx)];
                        ['Zyy=',num2str(sect_info(sectionnum,7)),' change to ',num2str(Izz)];
                        ['Ayy=',num2str(sect_info(sectionnum,8)),' change to ',num2str(Inf)];
                        ['Azz=',num2str(sect_info(sectionnum,9)),' change to ',num2str(Inf)]};
                    %Save the Results to MASTAN?
                    choice = questdlg(prch,'Export to MASTAN Confirmation','Yes','No','No');
                    switch choice
                        case 'Yes'
                            sect_name{sectionnum}=mas_name{1};
                            save junk sect_info sectionnum mas_props
                            sect_info(sectionnum,1:9)=mas_props;
                            save([masPathName,'/',masFileName],'sect_name','sect_info','-append')
                            uiwait(msgbox('Current CUFSM section exported to mastan model, you will need to re-run analyses in MASTAN now that the section properties have changed.','MASTAN Export Confirmation','modal'));

                        case 'No'
                            return
                    end        
                    %                 
                end                        
        end
        %Launch Mastan?
        choice = questdlg('Start MASTAN2 and close CUFSM?','Start MASTAN2','Yes','No','No');
        switch choice
            case 'Yes'
                %if you did not do the user.dat path then we don't know
                %where MASTAN is installed so we have to ask
                if ~exist('mas_path')
                    %Get the path to where MASTAN is located
                    [mas_path]=uigetdir('./','Select Mastan Install Directory');
                end
                close all
                eval(['cd ',mas_path])
                if exist('mastan2')==2
                    mastan2
                else
                    %Get the path to where MASTAN is located
                    [mas_path]=uigetdir('./','Select Mastan Install Directory');
                    close all
                    eval(['cd ',mas_path])
                    mastan2
                end
            case 'No'
                return
        end
end