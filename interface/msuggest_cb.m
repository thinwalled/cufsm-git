function msuggest_cb(num)
%
%Z. Li, July 2010 (last modified)
%
%msuggest Callback
%
%general
global fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen zoombtn panbtn rotatebtn
%output from boundary condition (Bound. Cond.)
global ed_m ed_neigs solutiontype togglesignature togglegensolution popup_BC toggleSolution Plengths Pm_all Hlengths Hm_all HBC PBC subfig lengthindex axeslongtshape hcontainershape longitermindex txt_longterm len_cur len_longterm longshape_cur jScrollPane_edm jViewPort_edm jEditbox_edm hjScrollPane_edm
%output from msuggest
global axessigncurve axes2dshape check_cFSM ed_lcrl ed_lcrd ed_msug xmax xmin ymax ymin ifilenamecell icurvecell iclascell ifiledisplay lengthindex icurve ishapes icurve_local ishapes_local icurve_dist ishapes_dist
%

switch num
    case 1
        %get the inputs for signature curve
        % iprop=str2num(get(ed_prop,'String'));
        % inode=str2num(get(ed_node,'String'));
        % ielem=str2num(get(ed_elem,'String'));
        %In this case we have no springs or constraints so
        ifchecked=get(check_cFSM,'Value');
        if ifchecked==1
            % add the cFSM solution on top of the signature curve
            iGBTcon.ospace=1;iGBTcon.couple=1;iGBTcon.orth=1;
            [elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem);
            ngm=4;
            nom=2*(length(node(:,1))-1);
            iGBTcon.local=ones(1,nlm);
            iGBTcon.dist=zeros(1,ndm);
            iGBTcon.glob=zeros(1,ngm);
            iGBTcon.other=zeros(1,nom);
            [icurve_local,ishapes_local]=signature_ss(prop,node,elem,iGBTcon);
            ifilenamecell{2}=['cFSM Local buckling'];
            icurvecell{2}=icurve_local;
                        %
            iGBTcon.local=zeros(1,nlm);
            iGBTcon.dist=ones(1,ndm);
            iGBTcon.glob=zeros(1,ngm);
            iGBTcon.other=zeros(1,nom);
            [icurve_dist,ishapes_dist]=signature_ss(prop,node,elem,iGBTcon);
            ifilenamecell{3}=['cFSM Distortional buckling'];
            icurvecell{3}=icurve_dist;
                        
            %plot pure local
            ifiledisplay=[1 2 3];
            picpoint=[icurve{lengthindex}(1,1) icurve{lengthindex}(1,2)];
            thecurve_signature(icurvecell,ifilenamecell,ifiledisplay,1,1,axessigncurve,xmin,xmax,ymin,ymax,picpoint);            
        end
    case 2
        hw_local=str2num(get(ed_lcrl,'String'));
        hw_dist=str2num(get(ed_lcrd,'String'));
        set(ed_lcrl,'String',sprintf('%.4f',hw_local));
        set(ed_lcrd,'String',sprintf('%.4f',hw_dist));
    case 3
        Lcrl=str2num(get(ed_lcrl,'String'));
        Lcrd=str2num(get(ed_lcrd,'String'));
        if Lcrl==0|Lcrd==0
            errordlg('Please input the half-wavelengths for local and distortional buckling','Half-wavelengths?')
        else
            %Lengths with suggested longitudinal terms
            title_m=uicontrol(subfig,...
                'Style','text','units','normalized',...
                'HorizontalAlignment','Left',...
                'FontName','Arial','FontSize',12,...
                'Position',[0.31 0.28 0.25 0.03],...%[0.01 0.48 0.35 0.03]
                'String','Longitudinal terms recommended');
            txt_m=uicontrol(subfig,...
                'Style','text','units','normalized',...
                'Position',[0.31 0.25 0.25 0.03],...%[0.01 0.45 0.35 0.03]
                'HorizontalAlignment','Left',...
                'String',' Length | 1  |  2  |  3  |  ...  |  m');
            ed_msug=uicontrol(subfig,...
                'Style','edit','units','normalized',...
                'HorizontalAlignment','Left',...
                'SelectionHighlight','on',...
                'Position',[0.31 0.01 0.68 0.24],...%[0.01 0.25 0.35 0.2]
                'Max',1000);
            %         idPlengths=str2num(get(ed_Plengths,'String'));
            %         iPlengths=idPlengths(:,2);
            imPlengths=Plengths;
            for i=1:length(imPlengths)
                imPm_all{i}=[];
                if ceil(imPlengths(i)/Lcrl)>4
                    imPm_all{i}=[ceil(imPlengths(i)/Lcrl)-3 ceil(imPlengths(i)/Lcrl)-2 ceil(imPlengths(i)/Lcrl)-1 ceil(imPlengths(i)/Lcrl) ...
                        ceil(imPlengths(i)/Lcrl)+1 ceil(imPlengths(i)/Lcrl)+2 ceil(imPlengths(i)/Lcrl)+3];
                else
                    imPm_all{i}=[1 2 3 4 5 6 7];
                end
                
                if ceil(imPlengths(i)/Lcrd)>4
                    imPm_all{i}=[imPm_all{i} ceil(imPlengths(i)/Lcrd)-3 ceil(imPlengths(i)/Lcrd)-2 ceil(imPlengths(i)/Lcrd)-1 ceil(imPlengths(i)/Lcrd) ...
                        ceil(imPlengths(i)/Lcrd)+1 ceil(imPlengths(i)/Lcrd)+2 ceil(imPlengths(i)/Lcrl)+3];
                else
                    imPm_all{i}=[imPm_all{i} 1 2 3 4 5 6 7];
                end
                imPm_all{i}=[imPm_all{i} 1 2 3];
            end
            [imPm_all]=msort(imPm_all);
            for i=1:max(size(imPm_all))
                lmlen{i}=[imPlengths(i) imPm_all{i}];
                mlen{i}=num2str(lmlen{i});
            end
            set(ed_msug,'String',mlen);
            %
        end
    case 4
        % sumbit suggested m to boud. cond.
        len_m_cell=get(ed_msug,'String');
        Plengths=[];Pm_all=[];
        lmlen=[];mlen=[];
        for i=1:max(size(len_m_cell))
            len_m{i}=str2num(len_m_cell{i});
            Plengths(1,i)=len_m{i}(1);
            Pm_all{i}(1,:)=len_m{i}(2:end);
        end
        for i=1:max(size(Pm_all))
            lmlen{i}=[Plengths(i) Pm_all{i}];
            mlen{i}=num2str(lmlen{i});
        end
        set(ed_msug,'String',mlen);
        longitermindex=1;
        lengthindex=1;
        set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
        set(len_cur,'String',['length = ',num2str(Plengths(lengthindex))]);
        
        lengths=Plengths;
        m_all=Pm_all;
        BC=PBC;
        close(subfig);
        figure(fig);
        boundcond;
    case 5
        close(subfig);
%         if ~isempty(Pm_all{lengthindex})
%             set(len_longterm,'String',['m = ',num2str(Pm_all{lengthindex}(longitermindex))]);
%             set(len_cur,'String',['length = ',num2str(Plengths(lengthindex))]);
%             set(txt_longterm,'String',num2str(Pm_all{lengthindex}));
%             boundcond_cb(25);
%         end
    case 6
        %
%         dcm_obj = datacursormode(subfig);
%         set(dcm_obj,'DisplayStyle','datatip',...
%             'SnapToDataVertex','off','Enable','on')
%         set(dcm_obj,'UpdateFcn',@myupdatefcn);
    case 7
        pickpoint=get(axessigncurve,'CurrentPoint');        
        for j=1:max(size(icurve));
            curve_sign(j,1)=icurve{j}(1,1);
            curve_sign(j,2)=icurve{j}(1,2);
            if length(ifiledisplay)>1
                curve_local(j,1)=icurve_local{j}(1,1);
                curve_local(j,2)=icurve_local{j}(1,2);
                curve_dist(j,1)=icurve_dist{j}(1,1);
                curve_dist(j,2)=icurve_dist{j}(1,2);
            end
        end
        [reldiff(1),pickminindexs]=min(sqrt((curve_sign(:,1)-pickpoint(1,1)).^2+(curve_sign(:,2)-pickpoint(1,2)).^2));
        if length(ifiledisplay)>1
            [reldiff(2),pickminindexl]=min(sqrt((curve_local(:,1)-pickpoint(1,1)).^2+(curve_local(:,2)-pickpoint(1,2)).^2));
            [reldiff(3),pickminindexd]=min(sqrt((curve_dist(:,1)-pickpoint(1,1)).^2+(curve_dist(:,2)-pickpoint(1,2)).^2));
        end
        [minreldiff,mindiffindex]=min(reldiff);picpoint=[icurve{lengthindex}(1,1) icurve{lengthindex}(1,2)];
        iBC='S-S';
        if mindiffindex==1
            picpoint=[icurve{pickminindexs}(1,1) icurve{pickminindexs}(1,2)];            
            dispshap(1,node,elem,ishapes{pickminindexs}(:,1),axes2dshape,1,0,1,iBC,0.5);
        elseif mindiffindex==2
            picpoint=[icurve_local{pickminindexl}(1,1) icurve_local{pickminindexl}(1,2)];
            dispshap(1,node,elem,ishapes_local{pickminindexl}(:,1),axes2dshape,1,0,1,iBC,0.5);
        else
            picpoint=[icurve_dist{pickminindexd}(1,1) icurve_dist{pickminindexd}(1,2)];
            dispshap(1,node,elem,ishapes_dist{pickminindexd}(:,1),axes2dshape,1,0,1,iBC,0.5);
        end
        thecurve_signature(icurvecell,ifilenamecell,ifiledisplay,1,1,axessigncurve,xmin,xmax,ymin,ymax,picpoint);
        

end

%     function txt = myupdatefcn(empt,event_obj)
%         % Customizes text of data tips
%         
%         pos = get(event_obj,'Position');
%         txt = {['Half-wave length: ',num2str(pos(1))],...
%             ['Load factor: ',num2str(pos(2))]};
%     
