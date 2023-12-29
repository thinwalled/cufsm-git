function []=pre2_cb(num)
%BWS
%August 2000 (last modified)
%Z. Li, 7/20/2010
%pre2 pre-processor callbacks
%modified 2015 BWS
%
%general
global fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen zoombtn panbtn rotatebtn
%output from pre2
global subfig ed_prop ed_node ed_elem ed_lengths axestop screen flags modeflag ed_springs ed_constraints popanelpre
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

%-------------------------------------------------------------------
%-------------------------------------------------------------------
switch num

case 1
%-------------------------------------------------------------------
%start the template
template
%-------------------------------------------------------------------
%
case 2
%-------------------------------------------------------------------
%double the elements
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
node=sortrows(node,1);
[node,elem]=doubler(node,elem);
set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
set(ed_elem,'String',sprintf('%i %i %i %.6f %i\n',elem'));
pre2_cb(3);
%-------------------------------------------------------------------
%
case 101
%-------------------------------------------------------------------
%double one element
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
node=sortrows(node,1);
prompt={'Enter the element to be divided:','Enter the relative location of the divide (0.5 = half-way):'};
   def={'2','0.5'};
   dlgTitle='Element Subdivision';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
divide_me=str2num(answer{1});
at_location=str2num(answer{2});
[node,elem]=divide_one(divide_me,at_location,node,elem);
set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
set(ed_elem,'String',sprintf('%i %i %i %.6f %i\n',elem'));
pre2_cb(3);
%-------------------------------------------------------------------
%
case 102
%-------------------------------------------------------------------
%delete one node
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
node=sortrows(node,1);
prompt={'Enter the node to be eliminated'};
   def={'3'};
   dlgTitle='Remove nodes';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
lost_node=str2num(answer{1});
[node,elem]=combine_one(lost_node,node,elem);
set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
set(ed_elem,'String',sprintf('%i %i %i %.6f %i\n',elem'));
pre2_cb(3)
%-------------------------------------------------------------------
%
case 103
%-------------------------------------------------------------------
%Translate nodes
node=str2num(get(ed_node,'String'));
node=sortrows(node,1);
prompt={'Enter the nodes to be translated:','Enter the x and z translations to be made:'};
   def={'2 3','1 1'};
   dlgTitle='Nodal Translation';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
move_me=str2num(answer{1});
this_much=str2num(answer{2});
[node]=translate_nodes(move_me,this_much,node);
set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
pre2_cb(3)
%-------------------------------------------------------------------
%
case 104
%-------------------------------------------------------------------
%Move or Rotate the Entire Model
node=str2num(get(ed_node,'String'));
node=sortrows(node,1);
prompt={'Enter the x translation:','Enter the z translation:','Enter the rotation (deg):'};
   def={'0','0','0'};
   dlgTitle='Translation and Rotation of Entire Model';
   lineNo=[1 100];
answer=inputdlg(prompt,dlgTitle,lineNo,def);
delx=str2num(answer{1});
delz=str2num(answer{2});
delq=str2num(answer{3})*pi/180;
[node2]=trans_or_rot_model(delx,delz,delq,node);
subfig=figure;
name=['CUFSM v',version,' -- Trans./Rotate Confirmation'];
set(subfig,'Name',name,'NumberTitle','off');
set(subfig,'MenuBar','none');
set(subfig,'position',[100 100 400 600])%
axesconfirm=axes('Units','normalized','Position',[0.01 0.01 0.98 0.98],'visible','off');
crossect(node2,elem,axesconfirm,springs,constraints,flags);
confirm=questdlg('Keep trans./rot. model?','Trans./rot. confirmation','Yes','No','No')
switch confirm
    case 'Yes'
        node=node2;
        close(subfig);
    case 'No'
        close(subfig);
end
set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
pre2_cb(3)
%-------------------------------------------------------------------
%
case 105
%-------------------------------------------------------------------
%Duplicate the Model
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
prompt={'Mirror about z axis at x=','Mirror about x axis at z=','Enter x translation for duplicate:','Enter z translation for duplicate:','Enter rotation (deg) about origin for duplicate:'};
   def={'NaN','NaN','0','0','0'};
   dlgTitle='Duplicate the Entire Model';
   lineNo=[1 100];
answer=inputdlg(prompt,dlgTitle,lineNo,def);
mirrorz=str2num(answer{1});
mirrorx=str2num(answer{2});
delx=str2num(answer{3});
delz=str2num(answer{4});
delq=str2num(answer{5})*pi/180;
[node2,elem2]=dup_model(mirrorz,mirrorx,delx,delz,delq,node,elem);
subfig=figure;
name=['CUFSM v',version,' -- Duplicate Cross-Section Confirmation'];
set(subfig,'Name',name,'NumberTitle','off');
set(subfig,'MenuBar','none');
set(subfig,'position',[100 100 400 600])%
axesconfirm=axes('Units','normalized','Position',[0.01 0.01 0.98 0.98],'visible','off');
crossect(node2,elem2,axesconfirm,springs,constraints,flags);
confirm=questdlg('Keep duplicated model?','Duplication confirmation','Yes','No','No')
switch confirm
    case 'Yes'
        node=node2;
        elem=elem2;
        close(subfig);
    case 'No'
        close(subfig);
end
set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
set(ed_elem,'String',sprintf('%i %i %i %.6f %i\n',elem'));
pre2_cb(3)
%-------------------------------------------------------------------
%
case 3
%-------------------------------------------------------------------
%update all quantities and plot
prop=str2num(get(ed_prop,'String'));
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
springs=str2num(get(ed_springs,'String'));
    if isempty(springs)
        springs=0;
    end
constraints=str2num(get(ed_constraints,'String'));
    if isempty(constraints)
        constraints=0;
    elseif constraints==0
    else
        %constraints must have enough entries to match master-slave or be
        %padded with zeros, for more entries things won't work well yet
        [rcon,ccon]=size(constraints);
        if ccon<8
            constraints(:,ccon+1:8)=zeros(rcon,8-ccon);
        end
    end
% halfwavelengths=str2num(get(ed_lengths,'String'));
% halfwavelengths=sort(unique(halfwavelengths));
[node,elem]=renumbernodes(node,elem);
set(ed_prop,'String',sprintf('%i %.2f %.2f %.2f %.2f %.2f\n',prop'));
set(ed_node,'String',sprintf('%i %.4f %.4f %i %i %i %i %.3f\n',node'));
set(ed_elem,'String',sprintf('%i %i %i %.6f %i\n',elem'));
set(ed_springs,'String',sprintf('%i %i %i %.6f %.6f %.6f %.6f %i %i %.3f\n',springs'));
set(ed_constraints,'String',sprintf('%i %i %.3f %i %i %.3f %i %i\n',constraints'));
crossect(node,elem,axestop,springs,constraints,flags);
%if geometry changes may influence modal constraints, update as needed
%are modal constraints on?
if max(GBTcon.glob)+max(GBTcon.dist)+max(GBTcon.local)+max(GBTcon.other)>=1 %any 1's
    %yes they are on, check the number of modes
    %Determine number of modes for modal constraints
    [elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem);
    ngm=4;
    nom=2*(length(node(:,1))-1);
    GBTcon.glob=ones(1,ngm);
    GBTcon.dist=ones(1,ndm);
    GBTcon.local=ones(1,nlm);
    GBTcon.other=ones(1,nom);
end
%-------------------------------------------------------------------
%
%Set the various plotting option flags
%flags:[node# element# mat# stress# stresspic coord constraints springs origin] 1 means show
case 4 
if flags(1)==1, flags(1)=0;, else flags(1)=1;, end
pre2_cb(3);
case 5 
if flags(2)==1, flags(2)=0;, else flags(2)=1;, end
pre2_cb(3);
case 6 
if flags(3)==1, flags(3)=0;, else flags(3)=1;, end
pre2_cb(3);
case 7 
if flags(4)==1, flags(4)=0;, else flags(4)=1;, end
pre2_cb(3);
case 8 
if flags(5)==1, flags(5)=0;, else flags(5)=1;, end
pre2_cb(3);
case 9 
if flags(6)==1, flags(6)=0;, else flags(6)=1;, end
pre2_cb(3);
case 10 
if flags(7)==1, flags(7)=0;, else flags(7)=1;, end
pre2_cb(3);
case 11 
if flags(8)==1, flags(8)=0;, else flags(8)=1;, end
pre2_cb(3);
case 12 
if flags(9)==1, flags(9)=0;, else flags(9)=1;, end
pre2_cb(3);
case 13 
if flags(10)==1, flags(10)=0;, else flags(10)=1;, end
pre2_cb(3);
case 20
    if strcmp(popanelpre.Visible,'off')
        popanelpre.Visible = 'on';
    else
        popanelpre.Visible = 'off';
    end 

%
case 201
%-------------------------------------------------------------------
%Slave nodes to a master node
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
constraints=str2num(get(ed_constraints,'String'));
prompt={'Enter the master node:','Enter the nodes to be slaved to the master:'};
   def={'4','1 2 3'};
   dlgTitle='Slaving nodes to a master nodes';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
master=str2num(answer{1});
slave=str2num(answer{2});
[constraints2]=master_slave(master,slave,node,elem);
if constraints==0
    constraints=constraints2; 
else
    constraints=[constraints; constraints2];
end
set(ed_constraints,'String',sprintf('%i %i %.3f %i %i %.3f %i %i\n',constraints'));
pre2_cb(3)
%
case 202
%-------------------------------------------------------------------
%generate applied nodal stresses (loading)
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
loading;
%
case 203
%-------------------------------------------------------------------
%generate applied nodal stresses (loading)
node=str2num(get(ed_node,'String'));
elem=str2num(get(ed_elem,'String'));
propout;

end
