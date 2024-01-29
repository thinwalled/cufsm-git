function []=dispshp2(L,node,elem,mode,axesnum,scalem,m_a,BC,ifpatch,Item3D,color4what_3D,Style3D,ifColorBar,y2L_specificSec)
%BWS
%1998 originated
%2010 BWS and Z.Li improvements for speed and generality
%Jan 2024. S. Jin. 3D surface graphics objects are used for speed
%L=length
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
%mode: vector of displacements global dof [u1 v1...un vn w1 01...wn 0n]'
%Item3D: objects to be plotted: 1 - Deformed shape only, 2 - Undeformed shape only, 3 - Deformed shape & undeformed mesh
%color4what_3D: the value used to render the color of the surface.
	%1: Vector sum of Displacement, 2: X-Component of displacement, 3: Y-Component of displacement, 4: Z-Component of displacement
	%5: Y-Component of Normal Strain, 6: In-strip-plane of Shear Strain
	%7: No Color
%Style3D: 1: surface, 2: mesh, 3: curved lines(nodal lines and specific crose-section lines)
%ifColorBar: display a vertical colorbar or not
%y2L_specificSec: location of the cross-section drawn in the "curved lines" style figure 

%determine if there are user input for y2L_specificSec
if nargin<14
	y2L_specificSec=0.5;
end

%To determine the ergodic path(s) of the cross-section, "Euler path"
listNd=node(:,1);%list of the nodes
listEdge=elem(:,1:3);%list of the edges
nNd=size(listNd,1);%number of nodes
nEdge=size(listEdge,1);%number of edges
PathNodes={};%Node sequence on the path(s).The paths traverse over all the nodes with no overlap
PathElems={};%element sequence on the path(s)
PathDirects={};%is the element direction consistent to the path direction? 
while size(listEdge,1)>=1
	curPathNodes=[];
	curPathElems=[];
	curPathDirects=[];
	
	curPathNodes=listEdge(1,2:3);%just get one
	curPathElems=listEdge(1,1);
	curPathDirects=true;
	listEdge(1,:)=[];

	while 1
		%number of the remainder edge(s) connect to the current end point of the path
		[rowB,colB]=find(listEdge(:,2:3)==curPathNodes(end),2);
		if length(rowB)==1%only one edge left
			curPathNodes(end+1)=listEdge(rowB,4-colB);
			curPathElems(end+1)=listEdge(rowB,1);
			curPathDirects(end+1)=(colB==1);
			listEdge(rowB,:)=[];
			continue
		end
		%number of the remainder edge(s) connecting to the current start point of the path
		[rowA,colA]=find(listEdge(:,2:3)==curPathNodes(1),2);
		if length(rowA)==1%no other choice
			curPathNodes=horzcat(listEdge(rowA,4-colA),curPathNodes);
			curPathElems=[listEdge(rowA,1),curPathElems];
			curPathDirects=[(colA==2),curPathDirects];
			listEdge(rowA,:)=[];
			continue
		end
		if length(rowB)>=2%at least two remainder edges connect to the current end point of the path 
			curPathNodes(end+1)=listEdge(rowB(1),4-colB(1));
			curPathElems(end+1)=listEdge(rowB(1),1);
			curPathDirects(end+1)=(colB(1)==1);
			listEdge(rowB(1),:)=[];
			continue
		end
		if length(rowA)>=2%at least 2 remainder edges to the start point
			curPathNodes=horzcat(listEdge(rowA(1),4-colA(1)),curPathNodes);
			curPathElems=[listEdge(rowA(1),1),curPathElems];
			curPathDirects=[(colA(1)==2),curPathDirects];
			listEdge(rowA(1),:)=[];
			continue
		end
		%so far both the end nodes of the current path has no edge connected to them
		PathNodes{end+1}=curPathNodes;
		PathElems{end+1}=curPathElems;
		PathDirects{end+1}=curPathDirects;
		break
	end
end

transSeg=4;%transverse segments of a strip
longiSeg=4;%longitudinal segments for a quarter wave
modeDisp=reshape(mode,4*nNd,[]);

%determine the number of longitudinal segments

%norm of the sub-deformation corresponding to each longi-function
%dispNorm_lgFuncs=vecnorm(modeDisp); %function "vecnorm" is not supported by Matlab2016
dispNorm_lgFuncs=zeros(1,size(modeDisp,2));
for iFunc=1:size(modeDisp,2)
	dispNorm_lgFuncs(iFunc)=norm(modeDisp(:,iFunc));
end

%if the deformation corresponding to a longi-function is very small (let's say smaller than 1/50 of the largest one), we don't need to care much about this small sub-deformation when plotting
%so for all the longi-functions the corresponding sub-deformations are enough significant, the largest wave-number is what we need to take care of.
%so this is it: Number of longitudinal segments = Largest halfwave number of the significant functions * longitudinal segments for a quarter wave *2
km=2*longiSeg*max(m_a(dispNorm_lgFuncs>=0.02*max(dispNorm_lgFuncs)))+1; %number of cross-section

nM_a=length(m_a);% number of the longitudinal functions
nStrip=nEdge;% strip number (same to the edges)

nd1=elem(:,2);
nd2=elem(:,3);
X1=node(nd1,2);X2=node(nd2,2);
Z1=node(nd1,3);Z2=node(nd2,3);
bStrip=sqrt((X2-X1).^2+(Z2-Z1).^2);
sinStrip=(Z2-Z1)./bStrip;
cosStrip=(X2-X1)./bStrip;

ptVect=(1:(transSeg-1))'/transSeg;
SubNodeX=[1-ptVect,ptVect]*[X1';X2'];%i-row j-column£ºX-coordinate of the i-th subnode on the j-th strip
SubNodeZ=[1-ptVect,ptVect]*[Z1';Z2'];%Z-coordinate


%displacement of the nodes
modeU=modeDisp(1:2:2*nNd,:);%the i-row j-column element: the U of the i-th node j-th function
modeV=modeDisp(2:2:2*nNd,:);
modeW=modeDisp(2*nNd+1:2:end,:);
modeR=modeDisp(2*nNd+2:2:end,:);

% displacement of the subnodes of the strips
SubNodeUW=zeros((transSeg-1)*2,nM_a,nStrip); %the (2i-1)-th row,j-th column,k-th page element: the coefficient of the j-th function of the i-th equidistant subnode's U on the k-th strip

%the i-th row,j-th column,k-th page element: V, Equidistant Subnode i, Function j, Strip k
SubNodeV=zeros(transSeg-1,nM_a,nStrip); 

%to calculate the displacement of the subnodes, strip by strip
for i=1:nStrip
	UWR2uwr=eye(6);
	UWR2uwr(1:2,1:2)=[cosStrip(i),sinStrip(i);-sinStrip(i),cosStrip(i)];
	UWR2uwr(4:5,4:5)=[cosStrip(i),sinStrip(i);-sinStrip(i),cosStrip(i)];
	
	uwrNd2uwSd=zeros(2*(transSeg-1),6);
	uwrNd2uwSd(1:2:2*(transSeg-1),1)=1-ptVect;
	uwrNd2uwSd(1:2:2*(transSeg-1),4)=ptVect;
	uwrNd2uwSd(2:2:2*(transSeg-1),2)=  ptVect.^3.*2-ptVect.^2.*3.+1;
	uwrNd2uwSd(2:2:2*(transSeg-1),3)=( ptVect.^3   -ptVect.^2.*2+ptVect).*bStrip(i);
	uwrNd2uwSd(2:2:2*(transSeg-1),5)= -ptVect.^3.*2+ptVect.^2.*3;
	uwrNd2uwSd(2:2:2*(transSeg-1),6)=( ptVect.^3   -ptVect.^2).*bStrip(i);
	
	uwSd2UWsd=zeros(2*(transSeg-1));
	for iSd=1:transSeg-1
		uwSd2UWsd(2*iSd-1:2*iSd,2*iSd-1:2*iSd)=[cosStrip(i),-sinStrip(i);sinStrip(i),cosStrip(i)];
	end
	SubNodeUW(:,:,i)=uwSd2UWsd*uwrNd2uwSd*UWR2uwr*[modeU(elem(i,2),:);modeW(elem(i,2),:);modeR(elem(i,2),:);modeU(elem(i,3),:);modeW(elem(i,3),:);modeR(elem(i,3),:)];
	
	SubNodeV(:,:,i)=[1-ptVect,ptVect]*[modeV(elem(i,2),:);modeV(elem(i,3),:)];
end

%to calculate the values of the longitudinal functions at positions the cross-sections
%number of cross-section: km
%total segments along the length: (km-1)
y2L=linspace(0,1,km);%y/L

if strcmp(BC,'S-S')
	funcUWR=sin(pi.*m_a'*y2L);
	funcV=cos(pi.*m_a'*y2L);
elseif strcmp(BC,'C-C')
	funcUWR=sin(pi.*m_a'*y2L).*sin(pi.*y2L);
	funcV=cos(pi.*m_a'*y2L).*sin(pi.*y2L)+sin(pi.*m_a'*y2L).*cos(pi.*y2L)./m_a';
elseif strcmp(BC,'S-C')||strcmp(BC,'C-S')
	funcUWR=sin(pi.*(m_a'+1)*y2L)+(m_a'+1)./m_a'.*sin(pi.*m_a'*y2L);
	funcV=(m_a'+1)./m_a'.*(cos(pi.*(m_a'+1)*y2L)+cos(pi.*m_a'*y2L));
elseif strcmp(BC,'F-C')||strcmp(BC,'C-F')
	funcUWR=1-cos(pi.*(m_a'-0.5)*y2L);
	funcV=(m_a'-0.5)./m_a'.*sin(pi.*(m_a'-0.5)*y2L);
elseif strcmp(BC,'G-C')||strcmp(BC,'C-G')
	funcUWR=sin(pi.*(m_a'-0.5)*y2L).*sin(pi/2.*y2L);
	funcV=(m_a'-.5)./m_a'.*cos(pi.*(m_a'-.5)*y2L).*sin(pi/2.*y2L)+sin(pi.*(m_a'-.5)*y2L).*cos(pi/2.*y2L)./m_a'./2;
else
	fprintf('\nError: Unrecognized boundary conditions.');
end

%Determine a scaling factor for the displaced shape
dispmax=(max(abs(mode(:,:))));
membersize=max(max(node(:,2:3)))-min(min(node(:,2:3)));
scale=scalem*1/10*membersize/dispmax;

watchon;
%
%
%
axes(axesnum);
cla 
axis off
hold on
colormap(axesnum,jet(256));
nPath=length(PathNodes);

%Format of the data for graphic object:
%Mode shapes can be expressed using curved lines or curved surfaces.
%A mode shape figure might consist of sever parts (several surfaces or several lines) or only one (e.g. one surface object) 
%One sort of data (e.g. X-direction displacement U***) is stored in a one-dimensional cell array
%	each cell in this array for one part of the figure.
%Each cell is a two-dimensional matrix, of this 2-dimensional matrix,
%	row number = cross-section number (i.e. number of longitudinal segmented sections),
%	column number = nodes in each cross-sectin of this part.
%So, if a part is a nodal line, the column number should be 1,
%if a part is a cross-section line, the row number should be 1,
%if a part is a strip, the row number is km, the column number is (transSeg+1)
%if a part contains all the strips, the row number is km, the column number is (nStrip*transSeg+1)


%if Style3D is 3 (using nodal lines and cross-section lines to express the mode shape)
%in this case,colors will be set in accordance with 2D plotting, thus color4what_3D value will be ignore.
if Style3D==3%curved lines
	NodalLinesX=cell(nNd,1);
	NodalLinesY=cell(nNd,1);
	NodalLinesZ=cell(nNd,1);
	NodalLineU=cell(nNd,1);
	NodalLineV=cell(nNd,1);
	NodalLineW=cell(nNd,1);
	for iNd=1:nNd
		NodalLinesX{iNd}=node(iNd,2)*ones(km,1);
		NodalLinesY{iNd}=linspace(0,L,km)';
		NodalLinesZ{iNd}=node(iNd,3)*ones(km,1);
		NodalLineU{iNd}=funcUWR'*modeU(iNd,:)';
		NodalLineV{iNd}=funcV'*modeV(iNd,:)';
		NodalLineW{iNd}=funcUWR'*modeW(iNd,:)';
	end

	%undeformed nodal lines
	if Item3D==2||Item3D==3
		for iNd=1:nNd
			plot3(NodalLinesX{iNd},NodalLinesY{iNd},NodalLinesZ{iNd},'Color','black','LineWidth',.5,'LineStyle',':');
		end
	end
	
	%deformed nodal lines
	if Item3D==1||Item3D==3
		for iNd=1:nNd
			plot3(NodalLineU{iNd}.*scale+NodalLinesX{iNd},NodalLineV{iNd}.*scale+NodalLinesY{iNd},NodalLineW{iNd}.*scale+NodalLinesZ{iNd},'Color','blue','LineWidth',.5);
		end
	end
	
	%will calculate the data of specific cross-section, as well as both end cross-sections.
	y2L_secs=[0 y2L_specificSec 1];
	if strcmp(BC,'S-S')
		secUWR=sin(pi.*m_a'*y2L_secs);
		secV=cos(pi.*m_a'*y2L_secs);
	elseif strcmp(BC,'C-C')
		secUWR=sin(pi.*m_a'*y2L_secs).*sin(pi.*y2L_secs);
		secV=cos(pi.*m_a'*y2L_secs).*sin(pi.*y2L_secs)+sin(pi.*m_a'*y2L_secs).*cos(pi.*y2L_secs)./m_a';
	elseif strcmp(BC,'S-C')||strcmp(BC,'C-S')
		secUWR=sin(pi.*(m_a'+1)*y2L_secs)+(m_a'+1)./m_a'.*sin(pi.*m_a'*y2L_secs);
		secV=(m_a'+1)./m_a'.*(cos(pi.*(m_a'+1)*y2L_secs)+cos(pi.*m_a'*y2L_secs));
	elseif strcmp(BC,'F-C')||strcmp(BC,'C-F')
		secUWR=1-cos(pi.*(m_a'-0.5)*y2L_secs);
		secV=(m_a'-0.5)./m_a'.*sin(pi.*(m_a'-0.5)*y2L_secs);
	elseif strcmp(BC,'G-C')||strcmp(BC,'C-G')
		secUWR=sin(pi.*(m_a'-0.5)*y2L_secs).*sin(pi/2.*y2L_secs);
		secV=(m_a'-.5)./m_a'.*cos(pi.*(m_a'-.5)*y2L_secs).*sin(pi/2.*y2L_secs)+sin(pi.*(m_a'-.5)*y2L_secs).*cos(pi/2.*y2L_secs)./m_a'./2;
	else
		fprintf('\nError: Unrecognized boundary conditions.');
	end

	sVec=linspace(0,1,transSeg+1)';
	UStripSec=cell(nStrip,1);
	VStripSec=cell(nStrip,1);
	WStripSec=cell(nStrip,1);
	XStripSec=cell(nStrip,1);
	YStripSec=cell(nStrip,1);
	ZStripSec=cell(nStrip,1);
	for iStrip=1:nStrip
		UStripSec{iStrip}=secUWR'*[modeU(nd1(iStrip),:)',SubNodeUW(1:2:end,:,iStrip)',modeU(nd2(iStrip),:)'];
		WStripSec{iStrip}=secUWR'*[modeW(nd1(iStrip),:)',SubNodeUW(2:2:end,:,iStrip)',modeW(nd2(iStrip),:)'];
		VStripSec{iStrip}=secV'*[modeV(nd1(iStrip),:)',modeV(nd2(iStrip),:)']*[1-sVec';sVec'];
		XStripSec{iStrip}=repmat([X1(iStrip),X2(iStrip)]*[1-sVec';sVec'],3,1);
		YStripSec{iStrip}=y2L_secs'*L*ones(1,transSeg+1);
		ZStripSec{iStrip}=repmat([Z1(iStrip),Z2(iStrip)]*[1-sVec';sVec'],3,1);
	end
	for iStrip=1:nStrip
		if Item3D==2||Item3D==3
			%undeformed cross-section lines at both ends
			plot3(XStripSec{iStrip}(1,:),YStripSec{iStrip}(1,:),ZStripSec{iStrip}(1,:),'Color','black','LineStyle',':','LineWidth',.05);
			plot3(XStripSec{iStrip}(end,:),YStripSec{iStrip}(end,:),ZStripSec{iStrip}(end,:),'Color','black','LineStyle',':','LineWidth',.05);
			%undeformed cross-section lines at the specific location
			plot3(XStripSec{iStrip}(2,:),YStripSec{iStrip}(2,:),ZStripSec{iStrip}(2,:),'Color','black','LineWidth',2);
			plot3(XStripSec{iStrip}(2,:),YStripSec{iStrip}(2,:),ZStripSec{iStrip}(2,:),'Color','yellow','LineWidth',1);
		end
		if Item3D==1||Item3D==3
			%deformed cross-section lines at both ends
			plot3(UStripSec{iStrip}(1,:)*scale+XStripSec{iStrip}(1,:),VStripSec{iStrip}(1,:)*scale+YStripSec{iStrip}(1,:),WStripSec{iStrip}(1,:)*scale+ZStripSec{iStrip}(1,:),'Color','black','LineStyle',':','LineWidth',.05);
			plot3(UStripSec{iStrip}(end,:)*scale+XStripSec{iStrip}(end,:),VStripSec{iStrip}(end,:)*scale+YStripSec{iStrip}(end,:),WStripSec{iStrip}(end,:)*scale+ZStripSec{iStrip}(end,:),'Color','black','LineStyle',':','LineWidth',.05);
			%deformed cross-section lines at the specific location
			plot3(UStripSec{iStrip}(2,:)*scale+XStripSec{iStrip}(2,:),VStripSec{iStrip}(2,:)*scale+YStripSec{iStrip}(2,:),WStripSec{iStrip}(2,:)*scale+ZStripSec{iStrip}(2,:),'Color','black','LineWidth',2);
			plot3(UStripSec{iStrip}(2,:)*scale+XStripSec{iStrip}(2,:),VStripSec{iStrip}(2,:)*scale+YStripSec{iStrip}(2,:),WStripSec{iStrip}(2,:)*scale+ZStripSec{iStrip}(2,:),'Color','red','LineWidth',1);
		end
	end
	settings3dPloting(false);
	view(0,0)
	return
end

if Item3D==3
    % plot the undeformed mesh
	plot3([node(:,2)';node(:,2)'],[zeros(1,nNd);ones(1,nNd)*L],[node(:,3)';node(:,3)'],'Color',[.7 .7 .7],'LineStyle',':');
	for iPath=1:nPath
		plot3(node(PathNodes{iPath},2),zeros(length(PathNodes{iPath}),1) ,node(PathNodes{iPath},3),'Color',[.7 .7 .7],'LineStyle',':');
		plot3(node(PathNodes{iPath},2),ones(length(PathNodes{iPath}),1)*L,node(PathNodes{iPath},3),'Color',[.7 .7 .7],'LineStyle',':');
	end
end

%Usually, the color4data should be continuously distributed in the cross-section, but sometimes it might not
%When it is continuously distributed, the surface can be constructed according to the "path", which span multiple strips.
%When it is discontinuously across nodes, each surface should contain only one strip.
if color4what_3D==6 %for the in-strip-plan shear strain (the shear strain value is discontinuous across nodes, so the plotting procedure is different to others that are continous in value over nodes)
	if strcmp(BC,'S-S')
		d_funcUWR=pi/L.*m_a'.*cos(pi.*m_a'*y2L);
	elseif strcmp(BC,'C-C')
		d_funcUWR=pi/L.*m_a'.*cos(pi.*m_a'*y2L).*sin(pi.*y2L)+pi/L.*sin(pi.*m_a'*y2L).*cos(pi.*y2L);
	elseif strcmp(BC,'S-C')||strcmp(BC,'C-S')
		d_funcUWR=pi/L.*(m_a'+1).*(cos(pi.*(m_a'+1)*y2L)+cos(pi.*m_a'*y2L));
	elseif strcmp(BC,'F-C')||strcmp(BC,'C-F')
		d_funcUWR=pi/L.*(m_a'-0.5).*sin(pi.*(m_a'-0.5)*y2L);
	elseif strcmp(BC,'G-C')||strcmp(BC,'C-G')
		d_funcUWR=pi/L.*(m_a'-.5).*cos(pi.*(m_a'-.5)*y2L).*sin(pi/2.*y2L)+pi*.5/L.*sin(pi.*(m_a'-.5)*y2L).*cos(pi/2.*y2L);
	else
		fprintf('\nError: Unrecognized boundary conditions.');
	end
	%calculate the shear strains strip by strip
	shearStrainStripMesh=cell(nStrip,1);
	sVec=linspace(0,1,transSeg+1)';
	V1=modeV(nd1,:);%the V value of the 1st node of each strip
	V2=modeV(nd2,:);% that for the 2nd node of each strip
	U1=modeU(nd1,:);
	U2=modeU(nd2,:);
	W1=modeW(nd1,:);
	W2=modeW(nd2,:);
	u1=[diag(cosStrip),diag(sinStrip)]*[U1;W1];
	u2=[diag(cosStrip),diag(sinStrip)]*[U2;W2];
	dV2ds_All=(V2-V1)./bStrip;%the rotations of the cross-sections of the strips in their strip-plane
	xStripMesh=cell(nStrip,1);
	zStripMesh=cell(nStrip,1);
	yStripMesh=cell(nStrip,1);
	VStripMesh=cell(nStrip,1);
	UStripMesh=cell(nStrip,1);
	WStripMesh=cell(nStrip,1);
	for iStrip=1:nStrip
		dV2ds_curStrip=repmat(dV2ds_All(iStrip,:),(transSeg+1),1);
		uMesh_curStrip=[1-sVec,sVec]*[u1(iStrip,:);u2(iStrip,:)];
		shearStrainStripMesh{iStrip}=funcV'*dV2ds_curStrip'+d_funcUWR'*uMesh_curStrip';
		xStripMesh{iStrip}=repmat([X1(iStrip),X2(iStrip)]*[1-sVec';sVec'],km,1);%it is km-row (transSeg+1)-colum
		zStripMesh{iStrip}=repmat([Z1(iStrip),Z2(iStrip)]*[1-sVec';sVec'],km,1);
		yStripMesh{iStrip}=repmat(linspace(0,L,km)',1,transSeg+1);
		VStripMesh{iStrip}=funcV'*[V1(iStrip,:);V2(iStrip,:)]'*[1-sVec,sVec]';
		UStripMesh{iStrip}=funcUWR'*[modeU(nd1(iStrip),:)',SubNodeUW(1:2:end,:,iStrip)',modeU(nd2(iStrip),:)'];
		WStripMesh{iStrip}=funcUWR'*[modeW(nd1(iStrip),:)',SubNodeUW(2:2:end,:,iStrip)',modeW(nd2(iStrip),:)'];
	end

	
	if Style3D==1
		if Item3D==1 || Item3D==3
            %in this case, the deformed surface(s) will be plotted. Signature meshes will be plotted in the deformed surface(s), Signature meshes are kind of sparse.
			isMajorSec=false(km,1);
			isMajorSec(1:longiSeg:end)=true;% one cross-section each quarter-wave for the sparse meshes 
			xStrMesh_Skeleton=xStripMesh;
			for iStrip=1:nStrip
				xStrMesh_Skeleton{iStrip}(~isMajorSec,2:transSeg)=nan;
			end
			for iStrip=1:nStrip
				mesh(UStripMesh{iStrip}.*scale+xStrMesh_Skeleton{iStrip},VStripMesh{iStrip}.*scale+yStripMesh{iStrip},WStripMesh{iStrip}.*scale+zStripMesh{iStrip},zeros(km,transSeg+1),'EdgeColor',[.6 .6 .6],'LineStyle',':','FaceColor','none');
				surf(UStripMesh{iStrip}.*scale+xStripMesh{iStrip},VStripMesh{iStrip}.*scale+yStripMesh{iStrip},WStripMesh{iStrip}.*scale+zStripMesh{iStrip},shearStrainStripMesh{iStrip},'EdgeColor','none','FaceColor','interp','FaceAlpha',1.0,'FaceLighting','flat');
			end
		else %Undeformed shape only
			for iStrip=1:nStrip
				surf(xStripMesh{iStrip},yStripMesh{iStrip},zStripMesh{iStrip},shearStrainStripMesh{iStrip},'EdgeColor','none','FaceColor','interp','FaceAlpha',1.0,'FaceLighting','flat');
			end
		end
    else
        %The figure is in mesh style
		%going to generate the mesh grid
		xStrMesh_Skeleton=xStripMesh;
		for iStrip=1:nStrip
			if Item3D==1 || Item3D==3
				mesh(UStripMesh{iStrip}.*scale+xStrMesh_Skeleton{iStrip},VStripMesh{iStrip}.*scale+yStripMesh{iStrip},WStripMesh{iStrip}.*scale+zStripMesh{iStrip},shearStrainStripMesh{iStrip},'EdgeColor','interp','FaceColor','none','FaceAlpha',1.0,'FaceLighting','flat');
			else
				mesh(xStrMesh_Skeleton{iStrip},yStripMesh{iStrip},zStripMesh{iStrip},shearStrainStripMesh{iStrip},'EdgeColor','interp','FaceColor','none','FaceAlpha',1.0,'FaceLighting','flat');
			end
		end
	end
	
	settings3dPloting(ifColorBar);
	return;
end

%Now, the Data are continuously distributed across the cross-section, so the plotting will be based on paths, not strips.

%undeformed mesh
pathNdX=cell(nPath,1);
pathNdZ=cell(nPath,1);
pathVexClas=cell(nPath,1);
Xmesh=cell(nPath,1);
Ymesh=cell(nPath,1);
Zmesh=cell(nPath,1);
for iPath=1:nPath
	pathNdX{iPath}=node(PathNodes{iPath},2);
	pathNdZ{iPath}=node(PathNodes{iPath},3);
	%Path vertex type:  true-node  false-sub-node
	pathVexClas{iPath}=false(1,transSeg*length(PathElems{iPath})+1);
	pathVexClas{iPath}(1:transSeg:end)=true;
	
	pathSdX=SubNodeX(:,PathElems{iPath});
	pathSdX(:,~PathDirects{iPath})=flipud(pathSdX(:,~PathDirects{iPath}));
	pathSdX=reshape(pathSdX,[],1);
	
	pathSdZ=SubNodeZ(:,PathElems{iPath});
	pathSdZ(:,~PathDirects{iPath})=flipud(pathSdZ(:,~PathDirects{iPath}));
	pathSdZ=reshape(pathSdZ,[],1);
	
	Xmesh{iPath}=nan(km,transSeg*length(PathElems{iPath})+1);
	Ymesh{iPath}=nan(km,transSeg*length(PathElems{iPath})+1);
	[Xmesh{iPath}(:,pathVexClas{iPath}),Ymesh{iPath}(:,pathVexClas{iPath})]=meshgrid(pathNdX{iPath},linspace(0,L,km));
	[Xmesh{iPath}(:,~pathVexClas{iPath}),Ymesh{iPath}(:,~pathVexClas{iPath})]=meshgrid(pathSdX,linspace(0,L,km));
	
	Zmesh{iPath}=nan(km,transSeg*length(PathElems{iPath})+1);
	Zmesh{iPath}(:,pathVexClas{iPath})=repmat(pathNdZ{iPath}',km,1);
	Zmesh{iPath}(:,~pathVexClas{iPath})=repmat(pathSdZ',km,1);
end


%deformations at the mesh grids
dispUmesh=cell(nPath,1);
dispWmesh=cell(nPath,1);
dispVmesh=cell(nPath,1);
for iPath=1:nPath
	pathNdU=modeU(PathNodes{iPath},:);
	pathNdW=modeW(PathNodes{iPath},:);
	pathNdV=modeV(PathNodes{iPath},:);
	
	pathSdU=SubNodeUW(1:2:end,:,PathElems{iPath});
	pathSdU(:,:,~PathDirects{iPath})=flipud(pathSdU(:,:,~PathDirects{iPath}));
	pathSdU=reshape(permute(pathSdU,[1,3,2]),[],nM_a);
	
	pathSdW=SubNodeUW(2:2:end,:,PathElems{iPath});
	pathSdW(:,:,~PathDirects{iPath})=flipud(pathSdW(:,:,~PathDirects{iPath}));
	pathSdW=reshape(permute(pathSdW,[1,3,2]),[],nM_a);
	
	pathSdV=SubNodeV(:,:,PathElems{iPath});
	pathSdV(:,:,~PathDirects{iPath})=flipud(pathSdV(:,:,~PathDirects{iPath}));
	pathSdV=reshape(permute(pathSdV,[1,3,2]),[],nM_a);
	
	%store and gather the data
	dispUmesh{iPath}=nan(km,transSeg*length(PathElems{iPath})+1);
	dispUmesh{iPath}(:,pathVexClas{iPath})=funcUWR'*pathNdU';
	dispUmesh{iPath}(:,~pathVexClas{iPath})=funcUWR(:,:)'*pathSdU'; % for the equidistant nodes on the real cross-sections
	
	dispWmesh{iPath}=nan(km,transSeg*length(PathElems{iPath})+1);
	dispWmesh{iPath}(:,pathVexClas{iPath})=funcUWR'*pathNdW';
	dispWmesh{iPath}(:,~pathVexClas{iPath})=funcUWR(:,:)'*pathSdW';
	
	dispVmesh{iPath}=nan(km,transSeg*length(PathElems{iPath})+1);
	dispVmesh{iPath}(:,pathVexClas{iPath})=funcV'*pathNdV';
	dispVmesh{iPath}(:,~pathVexClas{iPath})=funcV(:,:)'*pathSdV';
end


isMajorSec=false(km,1);
isMajorSec(1:longiSeg:end)=true;%the sparse mesh will be four sections for one wave
XMeshSkeleton=Xmesh;
for iPath=1:nPath
	XMeshSkeleton{iPath}(~isMajorSec,~pathVexClas{iPath})=nan;
end
if (Item3D==1 || Item3D==3) && Style3D ==1 % draw the signature mesh for the deformed surface.
	for iPath=1:nPath
		mesh(dispUmesh{iPath}.*scale+XMeshSkeleton{iPath},dispVmesh{iPath}.*scale+Ymesh{iPath},dispWmesh{iPath}.*scale+Zmesh{iPath},zeros(size(XMeshSkeleton{iPath})),'EdgeColor',[0.6 0.6 0.6],'LineStyle',':','FaceColor','none');
	end
end


if color4what_3D==7 %no color data
	for iPath=1:nPath
		if Item3D==1 || Item3D==3
			if Style3D==1
				surf(dispUmesh{iPath}.*scale+Xmesh{iPath},dispVmesh{iPath}.*scale+Ymesh{iPath},dispWmesh{iPath}.*scale+Zmesh{iPath},zeros(size(Xmesh{iPath})),'EdgeColor','none','FaceColor','w','FaceAlpha',1.0,'FaceLighting','flat');
			else
				surf(dispUmesh{iPath}.*scale+Xmesh{iPath},dispVmesh{iPath}.*scale+Ymesh{iPath},dispWmesh{iPath}.*scale+Zmesh{iPath},zeros(size(Xmesh{iPath})),'EdgeColor','k','FaceColor','non','FaceAlpha',1.0,'FaceLighting','flat');
			end
		else
			if Style3D==1
				surf(Xmesh{iPath},Ymesh{iPath},Zmesh{iPath},zeros(size(Xmesh{iPath})),'EdgeColor','none','FaceColor','w','FaceAlpha',1.0,'FaceLighting','flat');
				surf(XMeshSkeleton{iPath},Ymesh{iPath},Zmesh{iPath},zeros(size(Xmesh{iPath})),'EdgeColor',[0.6 0.6 0.6],'LineStyle',':','FaceColor','w','FaceAlpha',1.0,'FaceLighting','flat');
			else
				surf(Xmesh{iPath},Ymesh{iPath},Zmesh{iPath},zeros(size(Xmesh{iPath})),'EdgeColor','k','FaceColor','none','FaceAlpha',1.0,'FaceLighting','flat');
			end
		end
	end
	
	
	
% 	
% 	if Style3D==1
% 		if Item3D==1 || Item3D==3
% 			for iPath=1:nPath
% 				surf(dispUmesh{iPath}.*scale+Xmesh{iPath},dispVmesh{iPath}.*scale+Ymesh{iPath},dispWmesh{iPath}.*scale+Zmesh{iPath},'EdgeColor','k','LineStyle','none','FaceColor','white','FaceAlpha',1.0,'FaceLighting','flat');
% 			end
% 		else
% 			for iPath=1:nPath
% 				surf(Xmesh{iPath},Ymesh{iPath},Zmesh{iPath},'EdgeColor','k','LineStyle','none','FaceColor','white','FaceAlpha',1.0,'FaceLighting','flat');
% 			end
% 		end
% 	else
% 		if Item3D==1 || Item3D==3
% 			for iPath=1:nPath
% 				mesh(dispUmesh{iPath}.*scale+Xmesh{iPath},dispVmesh{iPath}.*scale+Ymesh{iPath},dispWmesh{iPath}.*scale+Zmesh{iPath},zeros(size(Xmesh{iPath})),'LineStyle','-','FaceColor','none');
% 			end
% 		else
% 			for iPath=1:nPath
% 				mesh(Xmesh{iPath},Ymesh{iPath},Zmesh{iPath},'EdgeColor','g','LineStyle','-','FaceColor','none');
% 			end
% 		end
% 	end
	settings3dPloting(false);
	return;
end

%% So far color4what_3D can only be 1 2 3 4 5 
if color4what_3D==1
	colorItem=cell(nPath,1);
	for iPath=1:nPath
		colorItem{iPath}=sqrt(dispUmesh{iPath}.^2+dispVmesh{iPath}.^2+dispWmesh{iPath}.^2);
	end
elseif color4what_3D==2
	colorItem=dispUmesh;
elseif color4what_3D==3
	colorItem=dispVmesh;
elseif color4what_3D==4
	colorItem=dispWmesh;
else %Item3D==5 (cross-section normal strain)
	if strcmp(BC,'S-S')
		d_funcV=-pi/L.*m_a'.*sin(pi.*m_a'*y2L);
	elseif strcmp(BC,'C-C')
		d_funcV=2*pi/L.*cos(pi.*m_a'*y2L).*cos(pi.*y2L)-pi/L.*(m_a'+1./m_a').*sin(pi.*m_a'*y2L).*sin(pi.*y2L);
	elseif strcmp(BC,'S-C')||strcmp(BC,'C-S')
		d_funcV=-pi/L.*(m_a'+1)./m_a'.*(sin(pi.*(m_a'+1)*y2L).*(m_a'+1)+sin(pi.*m_a'*y2L).*m_a');
	elseif strcmp(BC,'F-C')||strcmp(BC,'C-F')
		d_funcV=pi/L.*(m_a'-0.5)^2./m_a'.*cos(pi.*(m_a'-0.5)*y2L);
	elseif strcmp(BC,'G-C')||strcmp(BC,'C-G')
		d_funcV=pi/L.*(m_a'-.5)./m_a'.*cos(pi.*(m_a'-.5)*y2L).*cos(pi/2.*y2L) - pi/L.*((m_a'-.5).^2+.25)./m_a'.*sin(pi.*(m_a'-.5)*y2L).*sin(pi/2.*y2L);
	else
		fprintf('\nError: Unrecognized boundary conditions.');
	end
	normalStrainYMesh=cell(nPath,1);
	for iPath=1:nPath
		normalStrainYMesh{iPath}=nan(km,transSeg*length(PathElems{iPath})+1);
		normalStrainYMesh{iPath}(:,pathVexClas{iPath})=d_funcV'*modeV(PathNodes{iPath},:)';
		
		pathSdV=SubNodeV(:,:,PathElems{iPath});
		pathSdV(:,:,~PathDirects{iPath})=flipud(pathSdV(:,:,~PathDirects{iPath}));
		pathSdV=reshape(permute(pathSdV,[1,3,2]),[],nM_a);
		normalStrainYMesh{iPath}(:,~pathVexClas{iPath})=d_funcV'*pathSdV';
	end
	colorItem=normalStrainYMesh;
end


% For 'Deformed only' or 'Deformd shape + undeformed mesh', the deformed surfs are rendered according to colorItem
if Item3D==1 || Item3D==3
	for iPath=1:nPath
		if Style3D==1
			surf(dispUmesh{iPath}.*scale+Xmesh{iPath},dispVmesh{iPath}.*scale+Ymesh{iPath},dispWmesh{iPath}.*scale+Zmesh{iPath},colorItem{iPath},'EdgeColor','none','FaceColor','interp','FaceAlpha',1.0,'FaceLighting','flat');
		else
			surf(dispUmesh{iPath}.*scale+Xmesh{iPath},dispVmesh{iPath}.*scale+Ymesh{iPath},dispWmesh{iPath}.*scale+Zmesh{iPath},colorItem{iPath},'EdgeColor','interp','FaceColor','none','FaceAlpha',1.0,'FaceLighting','flat');
		end
	end
	

else %For 'Undeformed only',  the undeformed surfs are rendered
	for iPath=1:nPath
		if Style3D==1
			surf(Xmesh{iPath},Ymesh{iPath},Zmesh{iPath},colorItem{iPath},'EdgeColor','none','FaceColor','interp','FaceAlpha',1.0,'FaceLighting','flat');
		else
			mesh(Xmesh{iPath},Ymesh{iPath},Zmesh{iPath},colorItem{iPath},'EdgeColor','interp','FaceColor','none','FaceAlpha',1.0,'FaceLighting','flat');
		end
	end
end

settings3dPloting(ifColorBar);
end

function settings3dPloting(ifColorBar)
if ifColorBar
	cb=colorbar;
	cbPosition=cb.Position;
	cbPosition(2)=cbPosition(2)+cbPosition(4)*0.15;
	cbPosition(4)=cbPosition(4)*0.7;
	cb.Position=cbPosition;
else
	colorbar('off');
end

light('position',[1,1,2],'style','infinite');
light('position',[-2,-1,0],'style','infinite');
lighting phong
material metal

view(37.5,30)
hZoom=zoom;
setAxes3DPanAndZoomStyle(hZoom,gca,'camera');
hold off
axis equal
watchoff
end