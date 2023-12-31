function msuggest
%
%Z. Li, July 2010 (last modified)
%
%Suggested longitudinal terms are calculated based on the characteristic
%half-wave lengths of local, distortional, and global buckling from the
%signature curve.
%
%general
global fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen zoombtn panbtn rotatebtn
%output from boundary condition (Bound. Cond.)
global ed_m ed_neigs solutiontype togglesignature togglegensolution popup_BC toggleSolution Plengths Pm_all Hlengths Hm_all HBC PBC subfig lengthindex axeslongtshape hcontainershape longitermindex txt_longterm len_cur len_longterm longshape_cur jScrollPane_edm jViewPort_edm jEditbox_edm hjScrollPane_edm
%output from msuggest
global axessigncurve axes2dshape check_cFSM ed_lcrl ed_lcrd ed_msug xmax xmin ymax ymin ifilenamecell icurvecell iclascell ifiledisplay lengthindex icurve ishapes icurve_local ishapes_local icurve_dist ishapes_dist
%

subfig=figure;
name=['CUFSM v',version,' -- suggested longitudinal terms'];
set(subfig,'Name',name,'NumberTitle','off');
set(subfig,'MenuBar','none');
set(subfig,'position',[50 50 1024-50 620])%
% set(subfig,'Resize','off')
%DEFINE THE AXIS THAT WILL BE USED FOR THE TWO PLOTS
axessigncurve=axes('Units','normalized','Position',[0.05 0.67 0.7 0.3],'visible','on');
axes2dshape=axes('Units','normalized','Position',[0.75 0.67 0.25 0.3],'visible','off');
%get the inputs for signature curve
iGBTcon.ospace=1;iGBTcon.couple=1;iGBTcon.orth=1;
iGBTcon.local=0;
iGBTcon.dist=0;
iGBTcon.glob=0;
iGBTcon.other=0;
[icurve,ishapes]=signature_ss(prop,node,elem,iGBTcon);
% curve1=zeros(max(size(icurve)),2);
% for i=1:max(size(icurve))
%     curve1(i,1)=icurve{i}(1,1);
%     curve1(i,2)=icurve{i}(1,2);
% end
ifilenamecell{1}=['Signature curve (S-S, m=1)'];
icurvecell{1}=icurve;
ishapescell{1}=ishapes;
%Initial values for plot
ifiledisplay=[1];

for j=1:max(size(icurve));
    curve_sign(j,1)=icurve{j}(1,1);
    curve_sign(j,2)=icurve{j}(1,2);
end
xmin=min(curve_sign(:,1));
ymin=0;
xmax=max(curve_sign(:,1));
ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);
cr=0;
for xx=1:length(curve_sign(:,1))-2
    load1=curve_sign(xx,2);
    load2=curve_sign(xx+1,2);
    load3=curve_sign(xx+2,2);
    if (load2<load1)&(load2<=load3)
        cr=cr+1;
        lam_cr(cr)=load2;
        wl(cr)=curve_sign(xx+1,1);ncr(cr)=xx+1;
    end
end

lengthindex=ceil(length(curve_sign(:,1))/2);iBC='S-S';
picpoint=[icurve{lengthindex}(1,1) icurve{lengthindex}(1,2)];
thecurve_signature(icurvecell,ifilenamecell,ifiledisplay,1,1,axessigncurve,xmin,xmax,ymin,ymax,picpoint);
dispshap(1,node,elem,ishapes{lengthindex}(:,1),axes2dshape,1,0,1,iBC,0.5);
% %

%------------------------------------------------------------------------
leftbox=uicontrol(subfig,...
   'Style','frame','units','normalized',...
   'HorizontalAlignment','Left',...
	'Position',[0.0 0.0 0.3 0.58]);
txt_line=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','center',...
    'FontName','Arial','FontSize',12,...
    'Position',[0.01 0.51 0.28 0.06],...
    'String',['Half-wavelengths of local and distortional buckling']); 
txt_line=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','left',...
    'FontName','Arial','FontSize',11,...
    'Position',[0.01 0.43 0.28 0.06],...
    'String',['Non-unique minima (no distinct local or dist.):']); 
txt_line=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','left',...
    'Position',[0.01 0.37 0.28 0.06],...
    'String',['need user judgement to input or turn on cFSM if straightline cross section']); 

%
check_cFSM=uicontrol(subfig,...
	'Style','checkbox','units','normalized',...
	'HorizontalAlignment','Left',...
    'Position',[0.19 0.43 0.1 0.03],...
    'String','cFSM',...
    'Value',0,...
    'Callback',[...
 		'msuggest_cb(1);']); 
%
txt_line=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','Left',...
    'FontName','Arial','FontSize',11,...
    'Position',[0.01 0.33 0.28 0.03],...
    'String',['Unique minima (distinct local and dist.):']); 
txt_line=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','Left',...
    'Position',[0.01 0.27 0.28 0.06],...
    'String',['use indicated half-wavelengths (automatically filled out below)']); 

%half-wave length
txt_line1=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','left',...
     'FontName','Arial','FontSize',11,...
    'Position',[0.01 0.20 0.28 0.03],...
    'String',['Half-wavelengths']);    

%set the text as java component so we are able to use latex font
if ispc %pc
    labelStrL = '<html>local buckling L<sub>cr<i><font name="mt extra">l</sub> = </html>';
    jLabelL = javaObjectEDT('javax.swing.JLabel',labelStrL);
    [hcomponentL,hcontainerL] = javacomponent(jLabelL,[],subfig);
    set(hcontainerL,'units','normalized','position',[0.01 0.15 0.22 0.04]);
    
    labelStrD = '<html>distortional buckling L<sub>crd</sub> = </html>';
    jLabelD = javaObjectEDT('javax.swing.JLabel',labelStrD);
    [hcomponentD,hcontainerD] = javacomponent(jLabelD,[],subfig);
    set(hcontainerD,'units','normalized','position',[0.01 0.10 0.22 0.04]);
    
    labelStrG = '<html>global buckling L<sub>cre</sub> = </html>';
    jLabelG = javaObjectEDT('javax.swing.JLabel',labelStrG);
    [hcomponentG,hcontainerG] = javacomponent(jLabelG,[],subfig);
    set(hcontainerG,'units','normalized','position',[0.01 0.05 0.22 0.04]);
else %mac! or unix
    txt_line1=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','left',...
    'Position',[0.01 0.15 0.22 0.04],...
    'String',['local buckling Lcrl = ']);  
    txt_line2=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','left',...
    'Position',[0.01 0.10 0.22 0.04],...
    'String',['distortional buckling Lcrd = ']);  
    txt_line3=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','left',...    
    'Position',[0.01 0.05 0.22 0.04],...
    'String',['global buckling Lcre = ']);  
end

if length(wl)==2
    Lcrl=wl(1);Lcrd=wl(2);
    ed_lcrl=uicontrol(subfig,...
        'Style','edit','units','normalized',...
        'HorizontalAlignment','Left',...
        'Position',[0.17 0.15 0.12 0.04],...
        'String',num2str(Lcrl),...
        'Callback',[...
 		'msuggest_cb(2);']);
    ed_lcrd=uicontrol(subfig,...
        'Style','edit','units','normalized',...
        'HorizontalAlignment','Left',...
        'Position',[0.17 0.10 0.12 0.04],...
        'String',num2str(Lcrd),...
        'Callback',[...
 		'msuggest_cb(2);']);
else
    Lcrl=0;Lcrd=0;
    ed_lcrl=uicontrol(subfig,...
        'Style','edit','units','normalized',...
        'HorizontalAlignment','Left',...
        'Position',[0.17 0.15 0.12 0.04],...
        'String',num2str(Lcrl),...
        'Callback',[...
 		'msuggest_cb(2);']);
    ed_lcrd=uicontrol(subfig,...
        'Style','edit','units','normalized',...
        'HorizontalAlignment','Left',...
        'Position',[0.17 0.10 0.12 0.04],...
        'String',num2str(Lcrd),...
        'Callback',[...
 		'msuggest_cb(2);']);
end
%
ed_line3=uicontrol(subfig,...
	'Style','edit','units','normalized',...
	'HorizontalAlignment','Left',...
    'Position',[0.17 0.05 0.12 0.04],...
    'String','physical length L'); 
%
rightbox=uicontrol(subfig,...
   'Style','frame','units','normalized',...
   'HorizontalAlignment','Left',...
	'Position',[0.3 0.0 0.7 0.58]);
txt_line4=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','center',...
    'FontName','Arial','FontSize',12,...
    'Position',[0.31 0.53 0.68 0.03],...
    'String',['Recommend longitudinal terms']); 
txt_line4=uicontrol(subfig,...
	'Style','text','units','normalized',...
	'HorizontalAlignment','Left',...
    'FontName','Arial','FontSize',11,...
    'Position',[0.31 0.47 0.1 0.03],...
    'String',['Rules: ']); %longitudinal terms of greatest interest: near L/Lcrl, L/Lcrd, L/Lcre
%
if ispc %pc
    labelStrrule = '<html>longitudinal terms of greatest interest: near L/L<sub>cr<i><font name="mt extra">l</sub>, L/L<sub>crd</sub>, L/L<sub>cre</sub></html>';
    jLabelrule = javaObjectEDT('javax.swing.JLabel',labelStrrule);
    [hcomponentrule,hcontainerrule] = javacomponent(jLabelrule,[],subfig);
    set(hcontainerrule,'units','normalized','position',[0.32 0.43 0.68 0.03]);
    
    labelStr1 = '<html>near L/L<sub>cr<i><font name="mt extra">l</sub> and also L<sub>crd</sub>: both choose 7 longitudinal terms </html>';
    jLabel1 = javaObjectEDT('javax.swing.JLabel',labelStr1);
    [hcomponent1,hcontainer1] = javacomponent(jLabel1,[],subfig);
    set(hcontainer1,'units','normalized','position',[0.32 0.40 0.68 0.03]);
    
    % labelStr2 = '<html>near L/L<sub>crd</sub>: choose 7 longitudinal terms</html>';
    % jLabel2 = javaObjectEDT('javax.swing.JLabel',labelStr2);
    % [hcomponent2,hcontainer2] = javacomponent(jLabel2,[0.32*900 0.37*600 0.68*900 0.03*600],subfig);
    % set(hcontainer2,'units','normalized');%[0.32 0.37 0.68 0.03]
    
    labelStr3 = '<html>near L/L<sub>cre</sub>: choose 3 longitudinal terms</html>';
    jLabel3 = javaObjectEDT('javax.swing.JLabel',labelStr3);
    [hcomponent3,hcontainer3] = javacomponent(jLabel3,[],subfig);
    set(hcontainer3,'units','normalized','position',[0.32 0.37 0.68 0.03]);
    
    labelStr4 = '<html>then, sort the longitudinal terms to get rid of duplicate terms. </html>';
    jLabel4 = javaObjectEDT('javax.swing.JLabel',labelStr4);
    [hcomponent4,hcontainer4] = javacomponent(jLabel4,[],subfig);
    set(hcontainer4,'units','normalized','position',[0.32 0.34 0.68 0.03]);
else %mac! or unix
    txt_line1=uicontrol(subfig,...
        'Style','text','units','normalized',...
        'HorizontalAlignment','left',...
        'Position',[0.32 0.43 0.68 0.03],...
        'String',['longitudinal terms of greatest interest: near L/Lcrl, L/Lcrd, L/Lcre']);
    txt_line2=uicontrol(subfig,...
        'Style','text','units','normalized',...
        'HorizontalAlignment','left',...
        'Position',[0.32 0.40 0.68 0.03],...
        'String',['near L/Lcrl and also Lcrd: both choose 7 longitudinal terms ']);
    txt_line3=uicontrol(subfig,...
        'Style','text','units','normalized',...
        'HorizontalAlignment','left',...
        'Position',[0.32 0.37 0.68 0.03],...
        'String',['near L/Lcre: choose 3 longitudinal terms']);
    txt_line4=uicontrol(subfig,...
        'Style','text','units','normalized',...
        'HorizontalAlignment','left',...
        'Position',[0.32 0.34 0.68 0.03],...
        'String',['then, sort the longitudinal terms to get rid of duplicate terms. ']);
end

push_genm=uicontrol(subfig,...
	'Style','push','units','normalized',...
    'Position',[0.4 0.47 0.14 0.04],...
    'FontName','Arial','FontSize',11,...
    'String','Recommend m',...
    'Tooltip','Generate suggested m by selecting 7 terms around each, then merge together',...
    'Callback',[...
      'msuggest_cb(3);']);
push_subm=uicontrol(subfig,...
      'Style','push','units','normalized',...
      'Position',[0.54 0.47 0.21 0.04],...
      'FontName','Arial','FontSize',11,...
      'String','Submit recommended m',...
      'Tooltip','submit the recommended longitudinal terms back to bound. cond. inputs',...
      'Callback',[...
      'msuggest_cb(4);']);
push_closem=uicontrol(subfig,...
    'Style','push','units','normalized',...
    'FontName','Arial','FontSize',11,...
    'Position',[0.75 0.47 0.21 0.04],...
    'String','Close (don''t Submit)',...
    'Callback',[...
      'msuggest_cb(5);']);
%help
btn_halfwavehelp=uicontrol(subfig,...
    'Style','push','units','normalized',...
    'Position',[0.26 0.52 0.036 0.05],...
    'String','?',...
    'Callback',[...
    'cufsmhelp(72);']);



