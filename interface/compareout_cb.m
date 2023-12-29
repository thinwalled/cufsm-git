function []=compareout_cb(num)
%BWS
%August 28,2000
%Z. Li, July 2010 (last modified to accomodate general boudanry condition solution)
%GUI control callbacks for the post-processor that compares several different runs
%
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
%Plot the mode shapes
axes(axes2dshape);
cla reset, axis off
axes(axes2dshapelarge);
cla reset, axis off
val = get(popup_plot,'Value');
if val == 1
    %in-plane
	scale=str2num(get(scale_tex,'String'));
	undefv=get(undef,'Value');
    SurfPos=str2num(get(cutsurf_tex,'String'));
    mode=shapes{lengthindex}(:,modeindex);
    if ifcheck3d==1
        dispshap(undefv,node,elem,mode,axes2dshape,scale,springs,m_all{lengthindex},BC,SurfPos);
    else
        dispshap(undefv,node,elem,mode,axes2dshapelarge,scale,springs,m_all{lengthindex},BC,SurfPos);
    end
	set(len_plot,'String',num2str(lengths(lengthindex)));
	set(lf_plot,'String',num2str(curve{lengthindex}(modeindex,2)));
	set(mode_plot,'String',num2str(modes(modeindex)));
	set(filename_title2,'String','Buckled shape for ');
	set(filename_plot,'String',filename);
elseif val == 2
    %out-of plane
    compareout_cb(21);
	set(filename_title2,'String','Longitudinal displacement for ');
elseif val == 3
    %strain energy
    compareout_cb(22);
	set(filename_title2,'String','Strain energy for ');
elseif val == 4
    %stress
    compareout_cb(9);
	set(filename_title2,'String','Applied stress distribution for ');
end

if clasopt==1 %add classification results as well
    GBTcon.norm =get(popup_classify,'Value');
    if GBTcon.norm ==1
        classify_norm=['vector norm '];
    elseif GBTcon.norm ==2
        classify_norm=['strain energy norm '];
    elseif GBTcon.norm ==3
        classify_norm=['work norm '];
    end
    results=['cFSM classification results: ',classify_norm,...
             'G=',num2str(clas{lengthindex}(modeindex,1),'%3.1f'),'% ',...
             'D=',num2str(clas{lengthindex}(modeindex,2),'%3.1f'),'% ',...
             'L=',num2str(clas{lengthindex}(modeindex,3),'%3.1f'),'% ',...
             'O=',num2str(clas{lengthindex}(modeindex,4),'%3.1f'),'%'];
	set(classification_results,'String',results);
else
	set(classification_results,'String','cFSM classification results: off');
end
if ifcheck3d==1
    scale=str2num(get(scale_tex,'String'));
    mode=shapes{lengthindex}(:,modeindex);
    undefv=get(undef,'Value');
    ifpatch=get(checkpatch,'Value');
    dispshp2(undefv,lengths(lengthindex),node,elem,mode,axes3dshape,scale,m_all{lengthindex},BC,ifpatch);
%     dispshap3dwaxial(undefv,lengths(lengthindex),node,elem,mode,axesshape,scale);	
else
    axes(axes3dshape);
    cla reset, axis off    
end
%------------------------------------------------------------------------------------------
case 3
%------------------------------------------------------------------------------------------
%3D toggle
ifcheck3d=get(threed,'Value');
if ifcheck3d==0
    set(checkpatch,'Value',0);
    set(checkpatch,'Enable','off');    
else 
    set(checkpatch,'Enable','on');
end
%------------------------------------------------------------------------------------------

% case 4
% %------------------------------------------------------------------------------------------
% %use the slider
% lengthindex=floor(get(sliderlength,'Value'));
% set(len_cur,'String',['half-wavelength = ',num2str(lengths(lengthindex))]);
% compareout_cb(10)
%------------------------------------------------------------------------------------------

case 5
%------------------------------------------------------------------------------------------
%move up a length  
lengthindex=min(lengthindex+1,length(lengths));
set(len_cur,'String',num2str(lengths(lengthindex)));
% set(len_cur,'String',['length = ',num2str(lengths(lengthindex))]);
modes=(1:1:length(curve{lengthindex}(:,2)));
% modeindex=1;
% set(mode_cur,'String',num2str(modes(modeindex)));

%automatically change the limits of x-y axis
if curveoption==2
    xmin=1;
    ymin=0;
    xmax=length(curve{lengthindex}(:,2));
    ymax=min([max(curve{lengthindex}(:,2)),3*median(curve{lengthindex}(:,2))]);
        set(xmin_tex,'String',num2str(xmin));
    set(xmax_tex,'String',num2str(xmax));
    set(ymin_tex,'String',num2str(ymin));
    set(ymax_tex,'String',num2str(ymax));
end

%plot the curve with a new picked point
compareout_cb(10)

%------------------------------------------------------------------------------------------

case 6
%------------------------------------------------------------------------------------------
%move down a length
lengthindex=max(1,lengthindex-1);
set(len_cur,'String',num2str(lengths(lengthindex)));

modes=(1:1:length(curve{lengthindex}(:,2)));
% mmodes=(1:1:length(curve{1}(:,2)));
% modeindex=1;
% set(mode_cur,'String',num2str(modes(modeindex)));

%automatically change the limits of x-y axis
if curveoption==2
    xmin=1;
    ymin=0;
    xmax=length(curve{lengthindex}(:,2));
    ymax=min([max(curve{lengthindex}(:,2)),3*median(curve{lengthindex}(:,2))]);
    set(xmin_tex,'String',num2str(xmin));
    set(xmax_tex,'String',num2str(xmax));
    set(ymin_tex,'String',num2str(ymin));
    set(ymax_tex,'String',num2str(ymax));
end
%plot the curve with a new picked point
compareout_cb(10)
%------------------------------------------------------------------------------------------

case 7
%------------------------------------------------------------------------------------------
%move up a mode
modeindex=min(modeindex+1,length(modes));
set(mode_cur,'String',num2str(modes(modeindex)));
%plot the curve with a new picked point
compareout_cb(10)
% xmin=str2num(get(xmin_tex,'String'));
% xmax=str2num(get(xmax_tex,'String'));
% ymin=str2num(get(ymin_tex,'String'));
% ymax=str2num(get(ymax_tex,'String'));
% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 8
%------------------------------------------------------------------------------------------
%move down a mode
modeindex=max(1,modeindex-1);
set(mode_cur,'String',num2str(modes(modeindex)));
%plot the curve with a new picked point
compareout_cb(10)
% xmin=str2num(get(xmin_tex,'String'));
% xmax=str2num(get(xmax_tex,'String'));
% ymin=str2num(get(ymin_tex,'String'));
% ymax=str2num(get(ymax_tex,'String'));
% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 9
%------------------------------------------------------------------------------------------
%plot the stress distribution
scale=str2num(get(scale_tex,'String'));
if ifcheck3d==1
    strespic(node,elem,axes2dshape,scale);
else
    strespic(node,elem,axes2dshapelarge,scale);
end
set(len_plot,'String',num2str(lengths(lengthindex)));
set(lf_plot,'String',num2str(curve{lengthindex}(modeindex,2)));
set(mode_plot,'String',num2str(modes(modeindex)));
set(filename_plot,'String',filename);
%%%%Strain plots
%info=['changes to stress plot compareout_cb line 144']
%strainpic(node,elem,axesshape,scale,shapes(:,lengthindex,modeindex));
%[nstrain,estrain]=strain_recovery(node,elem,shapes(:,lengthindex,modeindex),lengths(lengthindex),lengths(lengthindex)/2);
%max(abs(nstrain))
%strainpic2(node,elem,axesshape,scale,nstrain(:,1));
%------------------------------------------------------------------------------------------

case 10
%------------------------------------------------------------------------------------------
% plot the load factor vs mode number curve
xmin=str2num(get(xmin_tex,'String'));
xmax=str2num(get(xmax_tex,'String'));
ymin=str2num(get(ymin_tex,'String'));
ymax=str2num(get(ymax_tex,'String'));

if curveoption==1
    %plot the load factor vs length curve
    %clear axes
    axes(axescurvemode);
    cla reset, axis off
    %
    axes(axesparticipation);
    cla reset, axis off
    %
    set(axescurve,'visible','on');
    
    maxmode=modes(modeindex);
    filedisplay=str2num(get(filetoplot_tex,'String'));
    modedisplay=str2num(get(modestoplot_tex,'String'));
    set(filetoplot_tex,'String',num2str(filedisplay));
    set(modestoplot_tex,'String',num2str(modedisplay));
    picpoint=[curve{lengthindex}(modeindex,1) curve{lengthindex}(modeindex,2)]; 
    thecurve3(curvecell,filenamecell,clascell,filedisplay,minopt,logopt,clasopt,axescurve,xmin,xmax,ymin,ymax,modedisplay,fileindex,modeindex,picpoint)
elseif curveoption==2
    %plot the load factor vs mode number curve
    %and the participation of longitudinal terms
    %clear axes
    axes(axescurve); 
    cla reset, axis off
    %
    set(axescurvemode,'visible','on');
    set(axesparticipation,'visible','on');
    
    %plot the load factor vs mode number curve
    picpoint=[modes(modeindex) curve{lengthindex}(modeindex,2)]; 
    thecurve3mode(curvecell,filenamecell,clascell,fileindex,minopt,logopt,clasopt,axescurvemode,xmin,xmax,ymin,ymax,fileindex,lengthindex,picpoint);
    
    %plot the participation vs longitudinal terms
    mode=shapes{lengthindex}(:,modeindex);
    nnodes=length(node(:,1));
    m_a=m_all{lengthindex};
    [d_part]=longtermpart(nnodes,mode,m_a);
    axes(axesparticipation)
    cla
    bar(m_a,d_part);hold on
    xlabel('m, longitudinal term');hold on;
    ylabel('Participation');hold on;
    legendstring=[filenamecell{fileindex},', length = ',num2str(lengths(lengthindex)), ', mode = ', num2str(modeindex)];
        hlegend=legend(legendstring);hold on
    set(hlegend,'Location','best');
    hold off    
end

%------------------------------------------------------------------------------------------

case 11
%------------------------------------------------------------------------------------------
%toggle whether or not the minimums are on the plot
%only for signature curve
if minopt==1,minopt=0;,else,minopt=1;,end
compareout_cb(10)
% xmin=str2num(get(xmin_tex,'String'));
% xmax=str2num(get(xmax_tex,'String'));
% ymin=str2num(get(ymin_tex,'String'));
% ymax=str2num(get(ymax_tex,'String'));
% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 12
%------------------------------------------------------------------------------------------
%toggle whether or not the x axis is in log scale
if logopt==1,logopt=0;,else,logopt=1;,end
compareout_cb(10)
% xmin=str2num(get(xmin_tex,'String'));
% xmax=str2num(get(xmax_tex,'String'));
% ymin=str2num(get(ymin_tex,'String'));
% ymax=str2num(get(ymax_tex,'String'));
% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 13
%------------------------------------------------------------------------------------------
%find the associated length based on user input
Luser=str2num(get(len_cur,'String'));
Lrel=abs(lengths-Luser); 
[Lindex]=find(min(Lrel)==Lrel);
lengthindex=Lindex(1);
modes=(1:1:length(curve{lengthindex}(:,2)));
set(len_cur,'String',num2str(lengths(lengthindex)));
%plot the curve with a new picked point
compareout_cb(10)
% xmin=str2num(get(xmin_tex,'String'));
% xmax=str2num(get(xmax_tex,'String'));
% ymin=str2num(get(ymin_tex,'String'));
% ymax=str2num(get(ymax_tex,'String'));
% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 14
%------------------------------------------------------------------------------------------
%find the associated mode based on user input
Modeuser=str2num(get(mode_cur,'String'));
modes=(1:1:length(curve{lengthindex}(:,2)));
moderel=abs(modes-Modeuser); 
[mindex]=find(min(moderel)==moderel);
modeindex=mindex(1);
set(mode_cur,'String',num2str(modes(modeindex)));
%plot the curve with a new picked point
compareout_cb(10)
% xmin=str2num(get(xmin_tex,'String'));
% xmax=str2num(get(xmax_tex,'String'));
% ymin=str2num(get(ymin_tex,'String'));
% ymax=str2num(get(ymax_tex,'String'));
% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 15
%------------------------------------------------------------------------------------------
%save a text file
[filename,pathname]=uiputfile('*.txt','Text Output Filename');
if filename==0,return,else
   temp=curve(:,:,1);
   fid = fopen([pathname,filename],'w');
   fprintf(fid,'%24.12f  %24.12f\n',temp');
   fclose(fid);
	%save([pathname,filename],'temp','-ascii')
end
%------------------------------------------------------------------------------------------

case 16
%------------------------------------------------------------------------------------------
%go up one file
fileindex=min(fileindex+1,length(files));
set(file_cur,'String',filenamecell{fileindex});
pathname=pathnamecell{fileindex};
filename=filenamecell{fileindex};
prop=propcell{fileindex};
node=nodecell{fileindex};
elem=elemcell{fileindex};
lengths=lengthscell{fileindex};
curve=curvecell{fileindex};
shapes=shapescell{fileindex};
springs=springscell{fileindex};
clas=clascell{fileindex};
lengthindex=min(size(lengths,2),lengthindex);
modes=(1:1:length(curve{lengthindex}(:,2)));
modeindex=1;
set(len_cur,'String',num2str(lengths(lengthindex)))
set(mode_cur,'String',num2str(modes(modeindex)));
BC=BCcell{fileindex};
m_all=m_allcell{fileindex};
solutiontype=solutiontypecell{fileindex};
%automatically change the limits of x-y axis
if curveoption==1
    xmin=min(lengths)*10/11;
    ymin=0;
    xmax=max(lengths)*11/10;
    for j=1:max(size(curve));
        curve_sign(j,1)=curve{j}(modeindex,1);
        curve_sign(j,2)=curve{j}(modeindex,2);
    end
    ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);
elseif curveoption==2
    xmin=1;
    ymin=0;
    xmax=length(curve{lengthindex}(:,2));
    ymax=min([max(curve{lengthindex}(:,2)),3*median(curve{lengthindex}(:,2))]);
end
    set(xmin_tex,'String',num2str(xmin));
    set(xmax_tex,'String',num2str(xmax));
    set(ymin_tex,'String',num2str(ymin));
    set(ymax_tex,'String',num2str(ymax));
%check if classification results are shown
if clasopt==1
    if isempty(clas{lengthindex})
    compareout_cb(30);
    end
end
%plot the curve with a new picked point
compareout_cb(10)

% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 17
%------------------------------------------------------------------------------------------
%go down one file
fileindex=max(1,fileindex-1);
set(file_cur,'String',filenamecell{fileindex});
pathname=pathnamecell{fileindex};
filename=filenamecell{fileindex};
prop=propcell{fileindex};
node=nodecell{fileindex};
elem=elemcell{fileindex};
lengths=lengthscell{fileindex};
curve=curvecell{fileindex};
shapes=shapescell{fileindex};
springs=springscell{fileindex};
clas=clascell{fileindex};
lengthindex=min(size(lengths,2),lengthindex);
modes=(1:1:length(curve{lengthindex}(:,2)));
lengthindex=min(size(lengths,2),lengthindex);
modeindex=1;
set(len_cur,'String',num2str(lengths(lengthindex)))
set(mode_cur,'String',num2str(modes(modeindex)));
BC=BCcell{fileindex};
m_all=m_allcell{fileindex};
solutiontype=solutiontypecell{fileindex};
%automatically change the limits of x-y axis
if curveoption==1
    xmin=min(lengths)*10/11;
    ymin=0;
    xmax=max(lengths)*11/10;
    for j=1:max(size(curve));
        curve_sign(j,1)=curve{j}(modeindex,1);
        curve_sign(j,2)=curve{j}(modeindex,2);
    end
    ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);
elseif curveoption==2
    xmin=1;
    ymin=0;
    xmax=length(curve{lengthindex}(:,2));
    ymax=min([max(curve{lengthindex}(:,2)),3*median(curve{lengthindex}(:,2))]);
end
    set(xmin_tex,'String',num2str(xmin));
    set(xmax_tex,'String',num2str(xmax));
    set(ymin_tex,'String',num2str(ymin));
    set(ymax_tex,'String',num2str(ymax));
%check if classification results are shown
if clasopt==1
    if isempty(clas{lengthindex})
    compareout_cb(30);
    end
end
%plot the curve with a new picked point
compareout_cb(10)

% maxmode=mmodes(mmodeindex);
% filedisplay=str2num(get(filetoplot_tex,'String'));
% picpoint=[lengths(lengthindex) curve(lengthindex,2,modeindex)]; 
% thecurve2(curvecell,filenamecell,filedisplay,minopt,logopt,axescurve,xmin,xmax,ymin,ymax,maxmode,picpoint);
%------------------------------------------------------------------------------------------

case 18
%------------------------------------------------------------------------------------------
%load another file
filenumber=length(files)+1;
compareout(filenumber);
%------------------------------------------------------------------------------------------

case 19
%------------------------------------------------------------------------------------------
%Plot the selected mode in a new window
subfig=figure;
name=['CUFSM v4.0 -- Captured mode shape 2D'];
set(subfig,'Name',name,'NumberTitle','off');
%set(subfig,'MenuBar','none');
set(subfig,'position',[100 100 500 300])%
axescapture=axes('Units','normalized','Position',[0.01 0.09 0.98 0.91],'visible','off');
scale=str2num(get(scale_tex,'String'));
undefv=get(undef,'Value');
SurfPos=str2num(get(cutsurf_tex,'String'));
mode=shapes{lengthindex}(:,modeindex);
dispshap(undefv,node,elem,mode,axescapture,scale,springs,m_all{lengthindex},BC,SurfPos);
if solutiontype==1
    label=[filename,' half-wavelength=',num2str(lengths(lengthindex)),' load factor=',num2str(curve{lengthindex}(modeindex,2)),' mode=',num2str(modes(modeindex))];
elseif solutiontype==2
    label=[filename,' length=',num2str(lengths(lengthindex)),' load factor=',num2str(curve{lengthindex}(modeindex,2)),' mode=',num2str(modes(modeindex))];
end
label_title=uicontrol(subfig,...
    'Style','text','units','normalized',...
    'Position',[0.01 0.02 .98 .05],...
    'String',label);

ifcheck3d=get(threed,'Value');
if ifcheck3d
    subfig3d=figure;
    name=['CUFSM v4.0 -- Captured mode shape 3D'];
    set(subfig3d,'Name',name,'NumberTitle','off');
    set(subfig3d,'position',[100 100 500 300])%
    axescapture3d=axes('Units','normalized','Position',[0.01 0.09 0.98 0.91],'visible','off');	  
    ifpatch=get(checkpatch,'Value');
    dispshp2(undefv,lengths(lengthindex),node,elem,mode,axescapture3d,scale,m_all{lengthindex},BC,ifpatch);
    label_title=uicontrol(subfig3d,...
        'Style','text','units','normalized',...
        'Position',[0.01 0.02 .98 .05],...
        'String',label);
end

%------------------------------------------------------------------------------------------

case 20
%------------------------------------------------------------------------------------------
%dump curve to text file
prompt={'Enter the number of the file to take the buckling curve from:','Enter the mode number:'};
   def={'1','1'};
   dlgTitle='Dump buckling curve to text file';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
myfilenumber=str2num(answer{1});
mymodenumber=str2num(answer{2});
[filenametxt,pathnametxt]=uiputfile('*.txt','Text Output Filename');
if filename==0,return,else
   for i=1:max(size(curvecell{myfilenumber}))
   temp(i,1:2)=curvecell{myfilenumber}{i}(mymodenumber,1:2);
   end
   fid = fopen([pathnametxt,filenametxt],'w');
   fprintf(fid,'%24.12f  %24.12f\n',temp');
   fclose(fid);
	%save([pathname,filename],'temp','-ascii')
end
%------------------------------------------------------------------------------------------
case 21
%------------------------------------------------------------------------------------------
%plot the longitudinal displacement distribution
scale=str2num(get(scale_tex,'String'));
SurfPos=str2num(get(cutsurf_tex,'String'));
if ifcheck3d==1
    vdisppic(node,elem,axes2dshape,scale,shapes{lengthindex}(:,modeindex),m_all{lengthindex},BC,SurfPos);
else
    vdisppic(node,elem,axes2dshapelarge,scale,shapes{lengthindex}(:,modeindex),m_all{lengthindex},BC,SurfPos);
end
set(len_plot,'String',num2str(lengths(lengthindex)));
set(lf_plot,'String',num2str(curve{lengthindex}(modeindex,2)));
set(mode_plot,'String',num2str(modes(modeindex)));
set(filename_plot,'String',filename);
%------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------
case 22
%------------------------------------------------------------------------------------------
%plot the strain energy distribution
scale=str2num(get(scale_tex,'String'));
if ifcheck3d==1
    strainEpic(prop,node,elem,axes2dshape,scale,shapes{lengthindex}(:,modeindex),lengths(lengthindex),BC,m_all{lengthindex});
else
    strainEpic(prop,node,elem,axes2dshapelarge,scale,shapes{lengthindex}(:,modeindex),lengths(lengthindex),BC,m_all{lengthindex});
end
set(len_plot,'String',num2str(lengths(lengthindex)));
set(lf_plot,'String',num2str(curve{lengthindex}(modeindex,2)));
set(mode_plot,'String',num2str(modes(modeindex)));
set(filename_plot,'String',filename);
%------------------------------------------------------------------------------------------
case 23
%------------------------------------------------------------------------------------------
%Pop-up menu for a variety of different types of cross-section plots
compareout_cb(1)
%
%------------------------------------------------------------------------------------------
case 24
%curve plot option
set(togglelfvslength,'Value',1);
set(togglelfvsmode,'Value',0);
xmin=1;
ymin=0;
xmax=max(lengths);
for j=1:max(size(curve));
    curve_sign(j,1)=curve{j}(modeindex,1);
    curve_sign(j,2)=curve{j}(modeindex,2);
end
ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);

set(xmin_tex,'String',num2str(xmin));
set(xmax_tex,'String',num2str(xmax));
set(ymin_tex,'String',num2str(ymin));
set(ymax_tex,'String',num2str(ymax));

set(togglemin,'Enable','on');
set(togglelog,'Enable','on');
set(modestoplot_tex,'Enable','on');
set(filetoplot_tex,'Enable','on');
set(modestoplot_title,'Enable','on');
set(filetoplot_title,'Enable','on');

curveoption=1;
compareout_cb(10)
%------------------------------------------------------------------------------------------
case 25
%curve plot option
set(togglelfvslength,'Value',0);
set(togglelfvsmode,'Value',1);
xmin=1;
ymin=0;
xmax=length(curve{lengthindex}(:,2));
ymax=min([max(curve{lengthindex}(:,2)),3*median(curve{lengthindex}(:,2))]);

set(xmin_tex,'String',num2str(xmin));
set(xmax_tex,'String',num2str(xmax));
set(ymin_tex,'String',num2str(ymin));
set(ymax_tex,'String',num2str(ymax));

set(togglemin,'Enable','off');
set(togglelog,'Enable','off');
set(modestoplot_tex,'Enable','off');
set(filetoplot_tex,'Enable','off');
set(modestoplot_title,'Enable','off');
set(filetoplot_title,'Enable','off');

curveoption=2;
compareout_cb(10)
%-----------------------------------------------------------------------------------------
case 26
%Click on load-factor vs length plot to get the spot you want
pickpoint=get(axescurve,'CurrentPoint');

for j=1:max(size(curve));
    curve_sign(j,1)=curve{j}(modedisplay(1),1);
    curve_sign(j,2)=curve{j}(modedisplay(1),2);
    if length(modedisplay)>1
        for mn=2:length(modedisplay)
            templ(j,modedisplay(mn))=curve{j}(modedisplay(mn),1);
            templf(j,modedisplay(mn))=curve{j}(modedisplay(mn),2);
        end
    end
end
if length(modedisplay)>1
    [reldiff(1),pickminindex(1)]=min(sqrt((curve_sign(:,1)-pickpoint(1,1)).^2+(curve_sign(:,2)-pickpoint(1,2)).^2));
    for i=2:length(modedisplay)
        [reldiff(i),pickminindex(i)]=min(sqrt((templ(:,i)-pickpoint(1,1)).^2+(templf(:,i)-pickpoint(1,2)).^2));
    end
    [minreldiff,mindiffindex]=min(reldiff);
    modeindex=mindiffindex;
    lengthindex=pickminindex(modeindex);
else
    [reldiff,pickminindex]=min(sqrt((curve_sign(:,1)-pickpoint(1,1)).^2+(curve_sign(:,2)-pickpoint(1,2)).^2));
    lengthindex=pickminindex;
    % modeindex=1;
end
set(len_cur,'String',num2str(lengths(lengthindex)));
% set(len_cur,'String',['length = ',num2str(lengths(lengthindex))]);
modes=(1:1:length(curve{lengthindex}(:,2)));
set(mode_cur,'String',num2str(modes(modeindex)));

%automatically change the limits of x-y axis
if curveoption==2
    xmin=1;
    ymin=0;
    xmax=length(curve{lengthindex}(:,2));
    ymax=min([max(curve{lengthindex}(:,2)),3*median(curve{lengthindex}(:,2))]);
        set(xmin_tex,'String',num2str(xmin));
    set(xmax_tex,'String',num2str(xmax));
    set(ymin_tex,'String',num2str(ymin));
    set(ymax_tex,'String',num2str(ymax));
end

%plot the curve with a new picked point
compareout_cb(10);
%plot the mode shape
compareout_cb(1);
%--------------------------------------------------------------------------
%---------------

case 30
%------------------------------------------------------------------------------------------
%cFSM Classification
%check to see if cFSM was activated
if sum(GBTcon.glob)+sum(GBTcon.dist)+sum(GBTcon.local)+sum(GBTcon.other)>0
    cFSM_analysis=1;
else
    cFSM_analysis=0;
end
if cFSM_analysis==0
    %if cFSM is not activated inform user
    question=questdlg('cFSM is not activated in the pre-processor.   Want to activate it?        (Note, if ''Yes'', after activate the base vectors in cFSM, go back to Post and try to classify again.)','cFSM not activated');
    switch question
        case 'Yes'
            cfsm;
        case 'No'
            clasopt=0;
        case 'Cancel'
           clasopt=0;
    end    
elseif cFSM_analysis==1
    %if cFSM activated perform classification
    %determine what norm is to be used
    GBTcon.norm=get(popup_classify,'Value');
    
    if GBTcon.orth==3&GBTcon.norm==3        
        msgbox('Work norm doesn''t work for applied-load mode basis.  Use vector norm or strain energy norm instead.','Work norm','help');
    else        
        %perform the classification
        wait_message=waitbar(0,'Performing Modal Classification');
        %generate unit length natural base vectors
        
        %loop over the length
        for l=1:length(lengths);
            %generate base vectors with appropriate basis and norm
            a=lengths(l);
            m_a=m_all{l};
            [b_v_l,ngm,ndm,nlm]=base_column(node,elem,prop,a,BC,m_a);
            %orthonormal vectors
            b_v=base_update(GBTcon.ospace,GBTcon.norm,b_v_l,a,m_a,node,elem,prop,ngm,ndm,nlm,BC,GBTcon.couple,GBTcon.orth);
            %classification
            ndof_m=4*length(node(:,1));
            for mod=1:length(shapes{l}(1,:))
                mode=shapes{l}(:,mod);
                clas{l}(mod,1:4)=mode_class(b_v,mode,ngm,ndm,nlm,m_a,ndof_m,GBTcon.couple);
            end
            
            waitbar(l/length(lengths));
        end
        %delete waitbar
        if ishandle(wait_message)
            delete(wait_message);
        end
        %assign results
        clascell{fileindex}=clas;
        %call the plotter
        clasopt=1;
        set(toggleclassify,'Value',1)
        curveplotupdate=1;
        compareout_cb(10)
    end
end


%------------------------------------------------------------------------------------------
case 31
%------------------------------------------------------------------------------------------
%selection from popup classification set toggle and show results
%set(toggle_clas,'Value',1)
%clasopt=0;
compareout_cb(30);
%
%
%------------------------------------------------------------------------------------------

%------------------------------------------------------------------------------------------
case 32
%------------------------------------------------------------------------------------------
%toggle classification addition to plot
if clasopt==1,clasopt=0;,else,clasopt=1;,end
compareout_cb(10)
%------------------------------------------------------------------------------------------

%------------------------------------------------------------------------------------------
case 40
%------------------------------------------------------------------------------------------
%Additional separate window classification plot
subfig=figure;
name=['CUFSM v4.0 -- Modal Classification Participation Plot'];
set(subfig,'Name',name,'NumberTitle','off');
set(subfig,'position',[100 100 600 400])%
%top plot, normal halfwavelength plot
axestop=subplot(2,1,1);
xmin=str2num(get(xmin_tex,'String'));
xmax=str2num(get(xmax_tex,'String'));
ymin=str2num(get(ymin_tex,'String'));
ymax=str2num(get(ymax_tex,'String'));
maxmode=mmodes(mmodeindex);
if curveoption==1
filedisplay=str2num(get(filetoplot_tex,'String'));
picpoint=[curve{lengthindex}(modeindex,1) curve{lengthindex}(modeindex,2)]; 
thecurve3(curvecell,filenamecell,clascell,filedisplay,minopt,logopt,clasopt,axestop,xmin,xmax,ymin,ymax,modedisplay,fileindex,modeindex,picpoint);
%bottom plot, classification breakdown plot
axesbot=subplot(2,1,2);
classifycurve(curvecell,filenamecell,clascell,filedisplay,axesbot,logopt,xmin,xmax,ymin,ymax,fileindex,modeindex)
elseif curveoption==2
    picpoint=[modes(modeindex) curve{lengthindex}(modeindex,2)];
    thecurve3mode(curvecell,filenamecell,clascell,fileindex,minopt,logopt,clasopt,axestop,xmin,xmax,ymin,ymax,fileindex,lengthindex,picpoint);
    axesbot=subplot(2,1,2);
classifycurvemode(curvecell,filenamecell,clascell,axesbot,logopt,xmin,xmax,ymin,ymax,fileindex,lengthindex)
end
%heading
if sum(GBTcon.glob)+sum(GBTcon.dist)+sum(GBTcon.local)+sum(GBTcon.other)>0 %cFSM analysis is on
    if GBTcon.orth==1
        basis_string=['Natural basis (ST)'];
    elseif GBTcon.orth==2|GBTcon.couple==1
        basis_string=['Uncoupled axial mode basis (ST)'];
    elseif GBTcon.orth==2|GBTcon.couple==2
        basis_string=['Coupled axial mode basis (ST)'];
    elseif GBTcon.orth==3|GBTcon.couple==1
        basis_string=['Uncoupled applied-load mode basis (ST)'];
    elseif GBTcon.orth==3|GBTcon.couple==2
        basis_string=['Coupled applied-load mode basis (ST)'];
    end
else
    basis_string=['cFSM analysis is off'];
end
GBTcon.norm=get(popup_classify,'Value');
if GBTcon.norm==1
    norm=['vector norm'];
elseif GBTcon.norm==2
    norm=['strain energy norm'];
elseif GBTcon.norm==3
    norm=['work norm'];
end
label=[filename,' -  BASIS:',basis_string,'  NORM:',norm];
label_title=uicontrol(subfig,...
	'Style','text','units','normalized',...
    'Position',[0.01 0.95 .98 .03],...
	'String',label);
%------------------------------------------------------------------------------------------

end


