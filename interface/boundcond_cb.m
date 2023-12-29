function boundcond_cb(num);
%Z. Li
%July, 2010
%boundcond pre-processor callbacks

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
    case 1
        %------------------------------------------------------------------------------------------
        %Signature curve toggle
        set(togglesignature,'Value',1);
        set(togglegensolution,'Value',0);
        solutiontype=1;
        boundcond;
        %-------------------------------------------------------------------
    case 2
        %------------------------------------------------------------------------------------------
        %General boundary condition solution toggle
        set(togglesignature,'Value',0);
        set(togglegensolution,'Value',1);
        solutiontype=2;
        boundcond;
        %-------------------------------------------------------------------
    case 3
        %set boundary conditions
        val_BC = get(popup_BC,'Value');
        if solutiontype==1
            if val_BC==1
                HBC='S-S';
            elseif val_BC==2
                HBC='C-C';
            elseif val_BC==3
                HBC='S-C';
            elseif val_BC==4
                HBC='C-F';
            elseif val_BC==5
                HBC='C-G';
            end
        elseif solutiontype==2
            if val_BC==1
                PBC='S-S';
            elseif val_BC==2
                PBC='C-C';
            elseif val_BC==3
                PBC='S-C';
            elseif val_BC==4
                PBC='C-F';
            elseif val_BC==5
                PBC='C-G';
            end
        end
        boundcond_cb(25);
        %
        %-------------------------------------------------------------------
    case 4
        %set the number of eigenvalues
        neigs=str2num(get(ed_neigs,'String'));
        set(ed_neigs,'String',sprintf('%i ',neigs));
        %-------------------------------------------------------------------
    case 5
        %set the lengths and longitudinal terms
        len_m_cell=get(ed_m,'String');        
        if solutiontype==1
            Hlengths=str2num(len_m_cell);
            [Hlengths]=sort(Hlengths);
            Hlengths=Hlengths';%make sure Hlengths is a row vector to be consistent
            for i=1:length(Hlengths)
                Hm_all{i}=[1];
            end
            set(ed_m,'String',sprintf('%.2f\n',Hlengths'));
            
            longitermindex=1;
            lengthindex=1;
            set(len_longterm,'String',['m = ',num2str(Hm_all{lengthindex}(longitermindex))]);
            set(len_cur,'String',['length = ',num2str(Hlengths(lengthindex))]);
            set(txt_longterm,'String',num2str(Hm_all{lengthindex}));
            boundcond_cb(25);
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
                        len_w_m{i}=[Plengths(i) Pm_all{i}];
                        len_w_m_str{i}=num2str(len_w_m{i});
                    end                   
                else
                    Plengths(1,1)=len_m{1}(1);
                    if size(len_m{1},2)==1
                        Pm_all{1}(1,1)=1;
                    else
                        Pm_all{1}(1,:)=len_m{1}(2:end);
                    end
                    [Pm_all]=msort(Pm_all);
                    len_w_m{1}=[Plengths(1) Pm_all{1}];
                    len_w_m_str{1}=num2str(len_w_m{1});                    
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
                    len_w_m{i}=[Plengths(i) Pm_all{i}];
                    len_w_m_str{i}=num2str(len_w_m{i});
                end                
            end
            set(ed_m,'String',len_w_m_str);
            longitermindex=1;
            lengthindex=1;
            set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
            set(len_cur,'String',['length = ',num2str(Plengths(lengthindex))]);
            set(txt_longterm,'String',num2str(Pm_all{lengthindex}));
            boundcond_cb(25);
            
            %check if there are noninteger longitudinal terms
            for i=1:length(Plengths)
                posint=(round(Pm_all{i})==Pm_all{i} & Pm_all{i}>0);
                if sum(posint)~=length(Pm_all{i})
                    warndlg('Noninteger longitudinal terms.','!! Warning !!');
                    break;
                end
            end
        end
        %  
        %-------------------------------------------------------------------
        %-------------------------------------------------------------------
        %-------------------------------------------------------------------
    case 10
        % Bring the half-wavelengths of signature curve and the associated longitudinal terms
        Plengths=Hlengths;
        Pm_all=Hm_all;
        for i=1:length(Plengths)
            len_w_m{i}=[Plengths(i) Pm_all{i}];
            len_m_str{i}=num2str(len_w_m{i});
        end
        set(ed_m,'String',len_m_str);
        lengths=Plengths;
        m_all=Pm_all;
        longitermindex=1;
        lengthindex=1;
        set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
        set(len_cur,'String',['length = ',num2str(Plengths(lengthindex))]);
        set(txt_longterm,'String',num2str(Pm_all{lengthindex}));
        boundcond_cb(25);
        %-------------------------------------------------------------------
    case 11
        % make all the longitudinal terms the same for each length based on
        % the element maximum element size or user choice
        choice = questdlg('Please choose a method:', ...
            'Method choices', ...
            'manually input m','Based on the max. element length','Cancel','manually input m');
        switch choice
            case 'manually input m'
                prompt={'Enter the longitudinal numbers (for example 1:10):'};
                def={'1'};
                dlgTitle='Input you own number';
                lineNo=1;
                answer=inputdlg(prompt,dlgTitle,lineNo,def);
                mylongtnumber=str2num(answer{1});
                len_m_cell=get(ed_m,'String');
                for i=1:max(size(len_m_cell))
                    len_m{i}=str2num(len_m_cell{i});
                    Plengths(1,i)=len_m{i}(1);
                end
                Plengths=sort(Plengths);
                for i=1:length(Plengths)
                    Pm_all{i}=mylongtnumber;
                    len_w_m{i}=[Plengths(i) Pm_all{i}];
                    len_m_str{i}=num2str(len_w_m{i});
                end
                set(ed_m,'String',len_m_str);
                
            case 'Based on the max. element length'
                Mw=0;%Maximum element length
                for i=1:length(elem(:,1))
                    hh1=abs(sqrt((node(elem(i,2),2)-node(elem(i,3),2))^2+(node(elem(i,2),3)-node(elem(i,3),3))^2));
                    if hh1>Mw
                        Mw=hh1;
                    end
                end
                len_m_cell=get(ed_m,'String');
                for i=1:max(size(len_m_cell))
                    len_m{i}=str2num(len_m_cell{i});
                    Plengths(1,i)=len_m{i}(1);
                end
                Plengths=sort(Plengths);
                for i=1:length(Plengths)
                    Pm_all{i}=[1:ceil(Plengths(i)/Mw)];
                    len_w_m{i}=[Plengths(i) Pm_all{i}];
                    len_m_str{i}=num2str(len_w_m{i});
                end
                set(ed_m,'String',len_m_str);
             case 'Cancel'
                
        end
        longitermindex=1;
        lengthindex=1;
        set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
        set(len_cur,'String',['length = ',num2str(Plengths(lengthindex))]);
        set(txt_longterm,'String',num2str(Pm_all{lengthindex}));
        boundcond_cb(25);
    case 12
        % generate the suggested longitudinal terms based on charateristic
        % half-wavelengths of local, dist., global buckling from the signature
        % curve
        msuggest;    
        %
    case 21
        %up one longitudinal term
        if solutiontype==2
            longitermindex=min(longitermindex+1,length(Pm_all{lengthindex}));
            set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
            boundcond_cb(25);
        end
        %------------------------------------------------------------------------------------------
    case 22
        %down one longitudinal term
        if solutiontype==2
            longitermindex=max(longitermindex-1,1);
            set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
            boundcond_cb(25);
        end
        %------------------------------------------------------------------------------------------
    case 23
        %up one length     
        if solutiontype==1
            lengthindex=min(lengthindex+1,length(Hlengths));
            set(len_cur,'String',['length = ',num2str(Hlengths(lengthindex))]);
            longitermindex=1;
            set(len_longterm,'String',['m = ',num2str(Hm_all{lengthindex}(longitermindex))]);
            set(txt_longterm,'String',num2str(Hm_all{lengthindex}));
        elseif solutiontype==2
            lengthindex=min(lengthindex+1,length(Plengths));
            set(len_cur,'String',['length = ',num2str(Plengths(lengthindex))]);
            longitermindex=1;
            set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
            set(txt_longterm,'String',num2str(Pm_all{lengthindex}));
        end
        boundcond_cb(25);
    case 24
        %down one length
        lengthindex=max(lengthindex-1,1);
        longitermindex=1;
        if solutiontype==1            
            set(len_cur,'String',['length = ',num2str(Hlengths(lengthindex))]);            
            set(len_longterm,'String',['m = ',num2str(Hm_all{lengthindex}(longitermindex))]);
            set(txt_longterm,'String',num2str(Hm_all{lengthindex}));
        elseif solutiontype==2
            set(len_cur,'String',['length = ',num2str(Plengths(lengthindex))]);
            set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
            set(txt_longterm,'String',num2str(Pm_all{lengthindex}));
        end
        boundcond_cb(25);
    case 25
        %shape function on the plot
        if solutiontype==1
            HPlengths=Hlengths;
            HPm_all=Hm_all;
            HPBC=HBC;
        else
            HPlengths=Plengths;
            HPm_all=Pm_all;
            HPBC=PBC;
        end
        if strcmp(HPBC,'S-S')
            labelStrshape = ['Y_{\itm} = sin({\itm}\piy/L), \color{red}{\itm}=', num2str(HPm_all{lengthindex}(longitermindex))];
        elseif strcmp(HPBC,'C-C')
            labelStrshape = ['Y_{\itm} = sin({\itm}\piy/L)sin(\piy/L), \color{red}{\itm}=', num2str(HPm_all{lengthindex}(longitermindex))];
        elseif strcmp(HPBC,'S-C')|strcmp(HPBC,'C-S')
            labelStrshape = ['Y_{\itm} = sin[({\itm+1})\piy/L]+({\itm+1})sin({\itm}\piy/L)/{\itm}, \color{red}{\itm}=', num2str(HPm_all{lengthindex}(longitermindex))];
        elseif strcmp(HPBC,'C-F')|strcmp(HPBC,'F-C')
            labelStrshape = ['Y_{\itm} = 1-cos[({\itm-0.5})\piy/L], \color{red}{\itm}=', num2str(HPm_all{lengthindex}(longitermindex))];
        elseif strcmp(HPBC,'C-G')|strcmp(HPBC,'G-C')
            labelStrshape = ['Y_{\itm} = sin[({\itm-0.5})\piy/L]sin(\piy/L/2), \color{red}{\itm}=', num2str(HPm_all{lengthindex}(longitermindex))];
        end
        %
        axes(hcontainershape)
        cla
        text('Interpreter','tex',...
            'String',labelStrshape,...
            'HorizontalAlignment','center',...
            'position',[0.5,0.5],...
            'FontSize',12)
%         jLabelshape = javaObjectEDT('javax.swing.JLabel',labelStrshape);
%         [hcomponentshape,hcontainershape] = javacomponent(jLabelshape,[],fig);
%         set(hcontainershape,'units','normalized','position',[0.63 0.44 0.3 0.03]);
        %         set(longshape_cur,'String',['Highlighted: ',longshapestring,', m = ',num2str(m_all{lengthindex}(longitermindex))]);
        %plot the shape function
        axes(axeslongtshape)
        cla
        x_length=[0:HPlengths(lengthindex)/200:HPlengths(lengthindex)];
        plot([0 HPlengths(lengthindex)],[0 0],'y','LineWidth',8);hold on
        for i=1:length(HPm_all{lengthindex})
            x_lengths(i,:)= x_length;
            if strcmp(HPBC,'S-S')
                y_shapes(i,:)=sin(HPm_all{lengthindex}(i)*pi*x_length/HPlengths(lengthindex));
            elseif strcmp(HPBC,'C-C')
                y_shapes(i,:)=sin(HPm_all{lengthindex}(i)*pi*x_length/HPlengths(lengthindex)).*sin(pi*x_length/HPlengths(lengthindex));
            elseif strcmp(HPBC,'S-C')|strcmp(HPBC,'C-S')
                y_shapes(i,:)=sin((HPm_all{lengthindex}(i)+1)*pi*x_length/HPlengths(lengthindex))+(HPm_all{lengthindex}(i)+1)*sin(HPm_all{lengthindex}(i)*pi*x_length/HPlengths(lengthindex))/HPm_all{lengthindex}(i);
            elseif strcmp(HPBC,'C-F')|strcmp(HPBC,'F-C')
                y_shapes(i,:)=1-cos((HPm_all{lengthindex}(i)-0.5)*x_length/HPlengths(lengthindex));
            elseif strcmp(HPBC,'C-G')|strcmp(HPBC,'G-C')
                y_shapes(i,:)=sin((HPm_all{lengthindex}(i)-0.5)*pi*x_length/HPlengths(lengthindex)).*sin(pi*x_length/HPlengths(lengthindex)/2);
            end
            legendm(i)=plot(x_lengths(i,:),y_shapes(i,:),'b-');hold on
        end
        set(legendm(longitermindex),'Color','r','LineWidth',4);hold on
        axis off
end