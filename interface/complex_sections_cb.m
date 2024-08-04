function []=complex_sections_cb(num)
%BWS
%August 2000
%template callbacks
%general
global fig screen     curve shapes clas   GBTcon BC m_all neigs version screen
%output from pre2
global subfig ed_prop ed_node ed_elem ed_lengths axestop screen modeflag ed_springs ed_constraints
%output from template
global h_title h_tex b1_title b1_tex d1_title d1_tex q1_title q1_tex b2_title b2_tex d2_title d2_tex q2_title q2_tex r1_title r1_tex r2_title r2_tex r3_title r3_tex r4_title r4_tex t_title t_tex nh_tex nb1_tex nd1_tex nb2_tex nd2_tex nr1_tex nr2_tex nr3_tex nr4_tex C Z kipin Nmm outer centerline roundc sharpc axestemp subfig sfia aisc
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


case 1
%-------------------------------------------------------------------
% h=str2num(get(h_tex,'String'));
% b1=str2num(get(b1_tex,'String'));
% d1=str2num(get(d1_tex,'String'));
% q1=str2num(get(q1_tex,'String'));
% b2=str2num(get(b2_tex,'String'));
% d2=str2num(get(d2_tex,'String'));
% q2=str2num(get(q2_tex,'String'));
% r1=str2num(get(r1_tex,'String'));
% r2=str2num(get(r2_tex,'String'));
% r3=str2num(get(r3_tex,'String'));
% r4=str2num(get(r4_tex,'String'));
% t=str2num(get(t_tex,'String'));
% nh=str2num(get(nh_tex,'String'));
% nb1=str2num(get(nb1_tex,'String'));
% nd1=str2num(get(nd1_tex,'String'));
% nb2=str2num(get(nb2_tex,'String'));
% nd2=str2num(get(nd2_tex,'String'));
% nr1=str2num(get(nr1_tex,'String'));
% nr2=str2num(get(nr2_tex,'String'));
% nr3=str2num(get(nr3_tex,'String'));
% nr4=str2num(get(nr4_tex,'String'));
% Cv=get(C,'Value');
% if Cv==1, CorZ=1;, else, CorZ=2;, end
% kipinv=get(kipin,'Value');
% centerv=get(centerline,'Value');
% [prop,node,elem,halfwavelengths,springs,constraints,geom,cz]=templatecalc(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,q1,q2,t,nh,nb1,nb2,nd1,nd2,nr1,nr2,nr3,nr4,kipinv,centerv);
% %flags:[node# element# mat# stress# stresspic coord constraints springs origin propplot] 1 means show
saveFileName_node = 'complex_node.mat';
saveFileName_elem = 'complex_elem.mat';
saveFileName_constraints = 'complex_constraints.mat';
load(saveFileName_node, 'node');
load(saveFileName_elem, 'elem');
load(saveFileName_constraints, 'constraints');
load('helpers\complex_sections_data\unitsystemunit', 'unitsystemunit');
node(:, 2:3) = node(:, 2:3) * unitsystemunit;
elem(:, 4) = elem(:, 4) * unitsystemunit;
if unitsystemunit == 1
    prop=[100	29000	29000	0.3	0.3	11153];
else
    prop=[100 200000.00 200000.00 0.30 0.30 76923];
end
flags=[0 0 0 0 0 0 0 0 1 0];
lengths=logspace(0,3,100)';
springs=0;
if length(constraints) == 1
    constraints = 0;
end
crossect(node,elem,axestemp,springs,constraints,flags);
% templatepic(node,elem,axestemp,geom,h,b1,d1,q1,b2,d2,q2,r1,r2,r3,r4,t,cz,centerv);
%-------------------------------------------------------------------

case 2
%-------------------------------------------------------------------
set(C,'Value',1);
set(Z,'Value',0);
complex_sections_cb(1);
%-------------------------------------------------------------------

case 3
%-------------------------------------------------------------------
set(C,'Value',0);
set(Z,'Value',1);
complex_sections_cb(1);
%-------------------------------------------------------------------

case 4
%-------------------------------------------------------------------
%get geometry
% h=str2num(get(h_tex,'String'));
% b1=str2num(get(b1_tex,'String'));
% d1=str2num(get(d1_tex,'String'));
% q1=str2num(get(q1_tex,'String'));
% b2=str2num(get(b2_tex,'String'));
% d2=str2num(get(d2_tex,'String'));
% q2=str2num(get(q2_tex,'String'));
% r1=str2num(get(r1_tex,'String'));
% r2=str2num(get(r2_tex,'String'));
% r3=str2num(get(r3_tex,'String'));
% r4=str2num(get(r4_tex,'String'));
% t=str2num(get(t_tex,'String'));
% nh=str2num(get(nh_tex,'String'));
% nb1=str2num(get(nb1_tex,'String'));
% nd1=str2num(get(nd1_tex,'String'));
% nb2=str2num(get(nb2_tex,'String'));
% nd2=str2num(get(nd2_tex,'String'));
% nr1=str2num(get(nr1_tex,'String'));
% nr2=str2num(get(nr2_tex,'String'));
% nr3=str2num(get(nr3_tex,'String'));
% nr4=str2num(get(nr4_tex,'String'));
% Cv=get(C,'Value');
% if Cv==1
% 	CorZ=1;
% else
% 	CorZ=2;
% end
% kipinv=get(kipin,'Value');
% centerv=get(centerline,'Value');
% [prop,node,elem,lengths,springs,constraints,~,~]=templatecalc(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,q1,q2,t,nh,nb1,nb2,nd1,nd2,nr1,nr2,nr3,nr4,kipinv,centerv);
load('helpers\complex_sections_data\unitsystemunit', 'unitsystemunit');
if unitsystemunit == 1
    complex_sections_cb(5);
else
    complex_sections_cb(6);
end


saveFileName_node = 'complex_node.mat';
saveFileName_elem = 'complex_elem.mat';
saveFileName_constraints = 'complex_constraints.mat';
load(saveFileName_node, 'node');
load(saveFileName_elem, 'elem');
load(saveFileName_constraints, 'constraints');
load('helpers\complex_sections_data\unitsystemunit', 'unitsystemunit');
node(:, 2:3) = node(:, 2:3) * unitsystemunit;
elem(:, 4) = elem(:, 4) * unitsystemunit;
if unitsystemunit == 1
    prop=[100	29000	29000	0.3	0.3	11153];
else
    prop=[100 200000.00 200000.00 0.30 0.30 76923];
end


flags=[0 0 0 0 0 0 0 0 1 0];
lengths=logspace(0,3,100)';
springs=0;
if length(constraints) == 1
    constraints = 0;
end
% lengths=[logspace(log10(6/10),log10(6*1000),50)];
submitTemplate2Input(prop,node,elem,lengths,springs,constraints);
close(subfig);
figure(fig);
pre2;
%-------------------------------------------------------------------

case 5
%-------------------------------------------------------------------
set(kipin,'Value',1);
set(Nmm,'Value',0);
%-------------------------------------------------------------------
%load selected sfia section
%-------------------------------------------------------------------
% complex_sections_cb(2); %C
% complex_sections_cb(5); %kip in
% complex_sections_cb(9); %outer
% complex_sections_cb(11); %round corners
unitsystemunit = 1;
save('helpers\complex_sections_data\unitsystemunit', 'unitsystemunit');

index=get(sfia,'Value');
hdf5_filename = 'all_complex_sections_data.h5';
[labels, ~] = complexdata();
%complex_folderPath = 'helpers\complex_sections_data\';
section_id = labels(index);
% Extract the string from the cell array
sectionString = section_id{1};

% Construct the dataset name
dataset_name_node = ['/' sectionString '-node'];
dataset_name_elem = ['/' sectionString '-elem'];
dataset_name_constraints = ['/' sectionString '-constraints'];

node = h5read(hdf5_filename, dataset_name_node);
elem = h5read(hdf5_filename, dataset_name_elem);
constraints = h5read(hdf5_filename, dataset_name_constraints);
saveFileName_node = 'complex_node.mat';
saveFileName_elem = 'complex_elem.mat';
saveFileName_constraints = 'complex_constraints.mat';
save(saveFileName_node, 'node');
save(saveFileName_elem, 'elem');
save(saveFileName_constraints, 'constraints');

% t=data(index,2);
% ri=data(index,3);	
% H=data(index,4);	
% B=data(index,5);	
% D=data(index,6);
% set(h_tex,'String',num2str(H));
% set(b1_tex,'String',num2str(B));
% set(d1_tex,'String',num2str(D));
% set(b2_tex,'String',num2str(B));
% set(d2_tex,'String',num2str(D));
% set(r1_tex,'String',num2str(ri));
% set(r2_tex,'String',num2str(ri));
% set(r3_tex,'String',num2str(ri));
% set(r4_tex,'String',num2str(ri));
% set(t_tex,'String',num2str(t));
% set(q1_tex,'String',num2str(90));
% set(q2_tex,'String',num2str(90));
% set(nh_tex,'String',num2str(8));
% set(nb1_tex,'String',num2str(4));
% set(nd1_tex,'String',num2str(2));
% set(nb2_tex,'String',num2str(4));
% set(nd2_tex,'String',num2str(2));
% set(nr1_tex,'String',num2str(4));
% set(nr2_tex,'String',num2str(4));
% set(nr3_tex,'String',num2str(4));
% set(nr4_tex,'String',num2str(4));
complex_sections_cb(1);
%-------------------------------------------------------------------
%-------------------------------------------------------------------

case 6
%-------------------------------------------------------------------
set(kipin,'Value',0);
set(Nmm,'Value',1);
%-------------------------------------------------------------------
%load selected sfia section
%-------------------------------------------------------------------
% complex_sections_cb(2); %C
% complex_sections_cb(5); %kip in
% complex_sections_cb(9); %outer
% complex_sections_cb(11); %round corners
unitsystemunit = 25.4;
save('helpers\complex_sections_data\unitsystemunit', 'unitsystemunit');
index=get(sfia,'Value');
hdf5_filename = 'all_complex_sections_data.h5';
[labels, ~] = complexdata();
complex_folderPath = 'helpers\complex_sections_data\';
section_id = labels(index);
% Extract the string from the cell array
sectionString = section_id{1};

% Construct the dataset name
dataset_name_node = ['/' sectionString '-node'];
dataset_name_elem = ['/' sectionString '-elem'];
dataset_name_constraints = ['/' sectionString '-constraints'];


% Combine with the current directory to form the full file path
% fullFilePath_node = fullfile(pwd, fullFilePath_node);
% fullFilePath_elem = fullfile(pwd, fullFilePath_elem);
% fullFilePath_constraints = fullfile(pwd, fullFilePath_elem);

node = h5read(hdf5_filename, dataset_name_node);
elem = h5read(hdf5_filename, dataset_name_elem);
constraints = h5read(hdf5_filename, dataset_name_constraints);
saveFileName_node = 'complex_node.mat';
saveFileName_elem = 'complex_elem.mat';
saveFileName_constraints = 'complex_constraints.mat';
save(saveFileName_node, 'node');
save(saveFileName_elem, 'elem');
save(saveFileName_constraints, 'constraints');

% t=data(index,2);
% ri=data(index,3);	
% H=data(index,4);	
% B=data(index,5);	
% D=data(index,6);
% set(h_tex,'String',num2str(H));
% set(b1_tex,'String',num2str(B));
% set(d1_tex,'String',num2str(D));
% set(b2_tex,'String',num2str(B));
% set(d2_tex,'String',num2str(D));
% set(r1_tex,'String',num2str(ri));
% set(r2_tex,'String',num2str(ri));
% set(r3_tex,'String',num2str(ri));
% set(r4_tex,'String',num2str(ri));
% set(t_tex,'String',num2str(t));
% set(q1_tex,'String',num2str(90));
% set(q2_tex,'String',num2str(90));
% set(nh_tex,'String',num2str(8));
% set(nb1_tex,'String',num2str(4));
% set(nd1_tex,'String',num2str(2));
% set(nb2_tex,'String',num2str(4));
% set(nd2_tex,'String',num2str(2));
% set(nr1_tex,'String',num2str(4));
% set(nr2_tex,'String',num2str(4));
% set(nr3_tex,'String',num2str(4));
% set(nr4_tex,'String',num2str(4));
complex_sections_cb(1);
%-------------------------------------------------------------------
%-------------------------------------------------------------------

case 7
%-------------------------------------------------------------------
close(subfig)
%-------------------------------------------------------------------

case 8
%-------------------------------------------------------------------
set(centerline,'Value',1);
set(outer,'Value',0);
set(h_title,'String','h');
set(b1_title,'String','b1');
set(d1_title,'String','d1');
set(q1_title,'String','theta1');
set(r1_title,'String','rcL1');
set(r2_title,'String','rcL2');
set(t_title,'String','t');
set(b2_title,'String','b2');
set(d2_title,'String','d2');
set(q2_title,'String','theta2');
set(r3_title,'String','rcL3');
set(r4_title,'String','rcL4');
complex_sections_cb(1);
%-------------------------------------------------------------------

case 9
%-------------------------------------------------------------------
set(centerline,'Value',0);
set(outer,'Value',1);
set(h_title,'String','H');
set(b1_title,'String','B1');
set(d1_title,'String','D1');
set(q1_title,'String','Theta1');
set(r1_title,'String','ri1');
set(r2_title,'String','ri2');
set(t_title,'String','t');
set(b2_title,'String','B2');
set(d2_title,'String','D2');
set(q2_title,'String','Theta2');
set(r3_title,'String','ri3');
set(r4_title,'String','ri4');
complex_sections_cb(1);
%-------------------------------------------------------------------

case 10
%-------------------------------------------------------------------
set(roundc,'Value',0);
set(sharpc,'Value',1);
r1=0;set(r1_tex,'String',num2str(r1));
r2=0;set(r2_tex,'String',num2str(r2));
r3=0;set(r3_tex,'String',num2str(r3));
r4=0;set(r4_tex,'String',num2str(r4));
complex_sections_cb(1);
%-------------------------------------------------------------------

case 11
%-------------------------------------------------------------------
set(roundc,'Value',1);
set(sharpc,'Value',0);
t=str2num(get(t_tex,'String'));
r1=2*t;set(r1_tex,'String',num2str(r1));
r2=2*t;set(r2_tex,'String',num2str(r2));
r3=2*t;set(r3_tex,'String',num2str(r3));
r4=2*t;set(r4_tex,'String',num2str(r4));
complex_sections_cb(1);
%-------------------------------------------------------------------

case 12
%-------------------------------------------------------------------
%save section
%get geometry
h=str2num(get(h_tex,'String'));
b1=str2num(get(b1_tex,'String'));
d1=str2num(get(d1_tex,'String'));
q1=str2num(get(q1_tex,'String'));
b2=str2num(get(b2_tex,'String'));
d2=str2num(get(d2_tex,'String'));
q2=str2num(get(q2_tex,'String'));
r1=str2num(get(r1_tex,'String'));
r2=str2num(get(r2_tex,'String'));
r3=str2num(get(r3_tex,'String'));
r4=str2num(get(r4_tex,'String'));
t=str2num(get(t_tex,'String'));
nh=str2num(get(nh_tex,'String'));
nb1=str2num(get(nb1_tex,'String'));
nd1=str2num(get(nd1_tex,'String'));
nb2=str2num(get(nb2_tex,'String'));
nd2=str2num(get(nd2_tex,'String'));
nr1=str2num(get(nr1_tex,'String'));
nr2=str2num(get(nr2_tex,'String'));
nr3=str2num(get(nr3_tex,'String'));
nr4=str2num(get(nr4_tex,'String'));
Cv=get(C,'Value');
if Cv==1, CorZ=1;, else, CorZ=2;, end
kipinv=get(kipin,'Value');
centerv=get(centerline,'Value');
[prop,node,elem,lengths,springs,constraints,geom,cz]=templatecalc(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,q1,q2,t,nh,nb1,nb2,nd1,nd2,nr1,nr2,nr3,nr4,kipinv,centerv);
GBTcon=[];,curve=[];,shapes=[];,BC=[];,m_all=[];,
%save geoemtry
%buildup filename
if CorZ==1
    cxtype=['C_'];
else
    cxtype=['Z_'];
end
if centerv==1
    %centerline dimensions, lowercare
    if kipinv
        dimensions=['h',num2str(round(h*100)),'b',num2str(round(b1*100)),'d',num2str(round(d1*100)),'t',num2str(round(t*1000))];
    else
        dimensions=['h',num2str(round(h)),'b',num2str(round(b1)),'d',num2str(round(d)),'t',num2str(round(t*10))];
    end
else
    %out-to-out, uppercase;
    if kipinv
        dimensions=['H',num2str(round(h*100)),'B',num2str(round(b1*100)),'D',num2str(round(d1*100)),'t',num2str(round(t*1000))];
    else
        dimensions=['H',num2str(round(h)),'B',num2str(round(b1)),'D',num2str(round(d1)),'t',num2str(round(t*10))];
    end
end
if r1==0&&r2==0&&r3==0&&r4==0
    corners=['_sharp'];
else
    corners=['_round'];
end
trialname=[cxtype,dimensions,corners];

[filename,pathname,Filterindex]=uiputfile([trialname,'.mat'],'Save CUFSM section as');
if Filterindex~=0
    save([pathname,filename],'prop','node','elem','lengths','springs','constraints','GBTcon','curve','shapes','BC','m_all');
end
%-------------------------------------------------------------------

case 13
%-------------------------------------------------------------------
%load selected sfia section
%-------------------------------------------------------------------
% complex_sections_cb(2); %C
% complex_sections_cb(5); %kip in
% complex_sections_cb(9); %outer
% complex_sections_cb(11); %round corners
index=get(sfia,'Value');
hdf5_filename = 'all_complex_sections_data.h5';
[labels, ~] = complexdata();
complex_folderPath = 'helpers\complex_sections_data\';
section_id = labels(index);
% Extract the string from the cell array
sectionString = section_id{1};

% Construct the dataset name
dataset_name_node = ['/' sectionString '-node'];
dataset_name_elem = ['/' sectionString '-elem'];
dataset_name_constraints = ['/' sectionString '-constraints'];

% Read the data from the HDF5 file
node = h5read(hdf5_filename, dataset_name_node);
elem = h5read(hdf5_filename, dataset_name_elem);
constraints = h5read(hdf5_filename, dataset_name_constraints);
saveFileName_node = 'complex_node.mat';
saveFileName_elem = 'complex_elem.mat';
saveFileName_constraints = 'complex_constraints.mat';
save(saveFileName_node, 'node');
save(saveFileName_elem, 'elem');
save(saveFileName_constraints, 'constraints');

% t=data(index,2);
% ri=data(index,3);	
% H=data(index,4);	
% B=data(index,5);	
% D=data(index,6);
% set(h_tex,'String',num2str(H));
% set(b1_tex,'String',num2str(B));
% set(d1_tex,'String',num2str(D));
% set(b2_tex,'String',num2str(B));
% set(d2_tex,'String',num2str(D));
% set(r1_tex,'String',num2str(ri));
% set(r2_tex,'String',num2str(ri));
% set(r3_tex,'String',num2str(ri));
% set(r4_tex,'String',num2str(ri));
% set(t_tex,'String',num2str(t));
% set(q1_tex,'String',num2str(90));
% set(q2_tex,'String',num2str(90));
% set(nh_tex,'String',num2str(8));
% set(nb1_tex,'String',num2str(4));
% set(nd1_tex,'String',num2str(2));
% set(nb2_tex,'String',num2str(4));
% set(nd2_tex,'String',num2str(2));
% set(nr1_tex,'String',num2str(4));
% set(nr2_tex,'String',num2str(4));
% set(nr3_tex,'String',num2str(4));
% set(nr4_tex,'String',num2str(4));
complex_sections_cb(1);
%-------------------------------------------------------------------
case 14
%-------------------------------------------------------------------
%load selected sfia section
%-------------------------------------------------------------------
% complex_sections_cb(2); %C
% complex_sections_cb(5); %kip in
% complex_sections_cb(9); %outer
% complex_sections_cb(11); %round corners
index2=get(aisc,'Value');
% [labels,data] = complexdata();
% complex_folderPath = 'helpers\complex_sections_data\';
[aisc_section_type] = {'W'; 'M'; 'S'; 'HP'; 'C'; 'MC'; 'L'; 'WT'; 'MT'; 'ST'; 'HSS'; 'PIPE'};
section_type_id = aisc_section_type(index2);
% Extract the string from the cell array
section_type_String = section_type_id{1};



save('helpers\complex_sections_data\section_type_String', 'section_type_String');
    

% t=data(index,2);
% ri=data(index,3);	
% H=data(index,4);	
% B=data(index,5);	
% D=data(index,6);
% set(h_tex,'String',num2str(H));
% set(b1_tex,'String',num2str(B));
% set(d1_tex,'String',num2str(D));
% set(b2_tex,'String',num2str(B));
% set(d2_tex,'String',num2str(D));
% set(r1_tex,'String',num2str(ri));
% set(r2_tex,'String',num2str(ri));
% set(r3_tex,'String',num2str(ri));
% set(r4_tex,'String',num2str(ri));
% set(t_tex,'String',num2str(t));
% set(q1_tex,'String',num2str(90));
% set(q2_tex,'String',num2str(90));
% set(nh_tex,'String',num2str(8));
% set(nb1_tex,'String',num2str(4));
% set(nd1_tex,'String',num2str(2));
% set(nb2_tex,'String',num2str(4));
% set(nd2_tex,'String',num2str(2));
% set(nr1_tex,'String',num2str(4));
% set(nr2_tex,'String',num2str(4));
% set(nr3_tex,'String',num2str(4));
% set(nr4_tex,'String',num2str(4));
%complex_sections_cb(1);
%-------------------------------------------------------------------     

%-------------------------------------------------------------------
end
end

function []=submitTemplate2Input(prop_temp,node_temp,elem_temp,lengths_temp,springs_temp,constraints_temp)
	global prop node elem lengths springs constraints
	prop=prop_temp;
	node=node_temp;
	elem=elem_temp;
	lengths=lengths_temp;
	springs=springs_temp;
	constraints=constraints_temp;
end
