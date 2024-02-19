function [C_L,J_D,J_GD]=SecAnal_fcFSM(node,elem,cornerStrips)
%For fcFSM constraint matrices construction
%Feb. 11, 2024, Sheng Jin

%Most of the constructing process for fcFSM constraint matrices is based only on cross-section geometry
%This function is this part of the process.
%So for fcFSM modal analysis, the main buckling analysis function will call this function before the loop on different lengths

%node: information of nodes, [node# x z dofx dofz dofy dofrot stress], number of nodes x 8;
%elem: information of strips, [elem# nodei nodej t matnum], number of strips x 5;
%cornerStrips: strip elements belong to curved corners.
%C_L: constraint matrix of Local mode class
%J_GD:transform matrix from [q] to [P]
%	[q] is the cross-section mid-line direction forces uniformly distributed in the cross-section of each plate, except those belong to curved corners.
%	[P] is the equivalent nodal load vector of [q]
%	*fcFSM considers the deformation of a member subjected to [q] as the GD class deformation.
%J_D:A basis of [q] that are in equilibrium
%	if [q] is in equilibrium, fcFSM considers the corresponding deformation as D class deformation.

%Limitations of current version of fcFSM
%1. Considers only one longitudinal term, although this term can be a value other than 1. 
%		multiple longitudinal terms will be supported in the future versions.
%2. User defined equation constraints are not supported, and DOF constraints on nodes are not supported.
%		there will be a general fcFSM algorithm for arbitrary supporting conditions.

nNd=size(node,1);%number of nodes
xNd=node(:,2); %X- coordinates of nodes
zNd=node(:,3); %Z- coordinates of nodes
nStrip=size(elem,1); %number of strips
ndStrip=elem(:,2:3); %the two nodes of each strip
tStrip=elem(:,4); %thickness of strips

%widths of strips
bStrip=sqrt((xNd(ndStrip(:,2))-xNd(ndStrip(:,1))).^2+(zNd(ndStrip(:,2))-zNd(ndStrip(:,1))).^2);
%mid-line directions of strips (the direction of a strip is from its 1st node to its 2nd node) 
%we will take the anti-clockwise angle in the positive Y-plane from the X-direction to the mid-line direction of the cross-section of strips
%but we will not calculate the angles directly,because the anti-trigonometric functions may cause uncontrollable errors.
%we will calculate the sine and cosine values of the angles, and use these values instead of angle values.
CosStrip=(xNd(ndStrip(:,2))-xNd(ndStrip(:,1)))./bStrip;
SinStrip=(zNd(ndStrip(:,2))-zNd(ndStrip(:,1)))./bStrip;

%flat plates
%A thin-walled member consists of several flat plates.
%A plate can be devided into several strips.
%So this is the definition of the plate mentioned in fcFSM:
%	(1)a plate is flat;
%	(2)two plates connected to each other are different in mid-line direction.
%	(3)strips consisting in corners belong to no plate

%The concept of plate is important for fcFSM because GD class (thus all classes) is defined based on plates:
%GD mode class is the deformation of members subjected to cross-section mid-line direction forces uniformly distributed in the cross-section of each plate (wall).
%BTW, corners (i.e. strips consisting in corners) don't belong to any plate, this is the only thing we need to do for modal analyses of curved-cornered cross-sections

%now we are going to construct a matrix identifying plates of the member
%the row number of the matrix will be the same to number of plates, i.e. each row describe a plate
%the column number of the matrix is the same to strip number,
%a true value of the i-th row j-th column element of the matrix means j-th strip belongs to i-th plate.
%but first, let's construct this matrix as "pairs of strips that are adjecent and parallel"
%each pair of strips forms a row of this matrix, the two entries in this row corresponding to this pair of strips are true, others are false
ndStrip(cornerStrips,:)=0;%those strips belong to curved corners will not take part in
plateInfo=false(0,nStrip);
for iNd=1:nNd
	[adjecentEle,~]=find(ndStrip==iNd);
	for iCntE=1:length(adjecentEle)-1
		idxEle1=adjecentEle(iCntE);
		for jCntE=iCntE+1:length(adjecentEle)
			idxEle2=adjecentEle(jCntE);
			if (abs(CosStrip(idxEle1)-CosStrip(idxEle2))<1e-4 && abs(SinStrip(idxEle1)-SinStrip(idxEle2))<1e-4)||(abs(CosStrip(idxEle1)+CosStrip(idxEle2))<1e-4 && abs(SinStrip(idxEle1)+SinStrip(idxEle2))<1e-4) 
				toBeAdded=false(1,nStrip);
				toBeAdded(1,adjecentEle(iCntE))=true;
				toBeAdded(1,adjecentEle(jCntE))=true;
				plateInfo=[plateInfo;toBeAdded];
			end
		end
	end
end
%then, a further adjusting to this martix:
%	if a strip belonging to no pair, it forms a separate row (this strip forms a plate)
%	otherwise all the conterparts pairing to a strip belongs to a same plate of this strip 
%then we get what we want
for iStrip=1:nStrip
	if ismember(iStrip,cornerStrips)%those strips belong to curved corners will not take part in
		continue
	end
	[rowInfo,~]=find(plateInfo(:,iStrip));
	if isempty(rowInfo)
		toBeAdded=false(1,nStrip);
		toBeAdded(1,iStrip)=true;
		plateInfo=[plateInfo;toBeAdded];
	else
		for iInfo=length(rowInfo):-1:2
			plateInfo(rowInfo(1),:)=plateInfo(rowInfo(1),:)|plateInfo(rowInfo(iInfo),:);
			plateInfo(rowInfo(iInfo),:)=[];
		end
	end
end

nPlate=size(plateInfo,1);%number of plates
%mid-line directions of plates
CosP=zeros(nPlate,1);
SinP=zeros(nPlate,1);
AreaP=zeros(nPlate,1);%cross-section areas of plates
nodeP=zeros(nPlate,1);%a signature node for each plate 
stripsP=cell(nPlate,1);%a list of strips belong to each plate 
for iPlate=1:nPlate
	[~,stripsP{iPlate}]=find(plateInfo(iPlate,:)); 
	SinP(iPlate)=SinStrip(stripsP{iPlate}(1)); %direction of a plate is set same to it's first strip.
	CosP(iPlate)=CosStrip(stripsP{iPlate}(1));
	nodeP(iPlate)=ndStrip(stripsP{iPlate}(1),1);%just pick a node (whichever one) that belongs to this plate
	AreaP(iPlate)=bStrip(stripsP{iPlate})'*tStrip(stripsP{iPlate});
end

%% going to construct the constraint matrices
%1. for GD mode class
%	GD mode class is the deformation of members subjected to cross-section mid-line direction forces uniformly distributed in the cross-section of each plate.
%	let's denote these mid-line direction  uniformly distributed forces as [q]=[q1,q2, ..., q_nPlate]'
%	concentrating them to nodes, leading to equivalent load vector of [q]: [P]=[J_GD]*[q]
%	[P] is, apparently, the load vector that cause GD mode deformation

J_GD=zeros(4*nNd,nPlate);
%The DOFs are arranged as such in CUFSM: [u1 v1...un vn w1 01...wn 0n].
%So the order numbers of the X- and Z- direction forces of node i in the [P] vector are, respectively, 2i-1 and 2*nNd+2i-1
%concentrating of [q] leads to no Y- direction nodal force or nodal moment
for iPlate=1:nPlate
	for iStrip=1:length(stripsP{iPlate})
		thisStrip=stripsP{iPlate}(iStrip);
		thisNd1=ndStrip(thisStrip,1);
		thisNd2=ndStrip(thisStrip,2);
		J_GD(		thisNd1*2-1,iPlate)=J_GD(		thisNd1*2-1,iPlate)+bStrip(thisStrip)*tStrip(thisStrip)*CosP(iPlate)/2;
		J_GD(		thisNd2*2-1,iPlate)=J_GD(		thisNd2*2-1,iPlate)+bStrip(thisStrip)*tStrip(thisStrip)*CosP(iPlate)/2;
		J_GD(nNd*2+	thisNd1*2-1,iPlate)=J_GD(nNd*2+	thisNd1*2-1,iPlate)+bStrip(thisStrip)*tStrip(thisStrip)*SinP(iPlate)/2;
		J_GD(nNd*2+	thisNd2*2-1,iPlate)=J_GD(nNd*2+	thisNd2*2-1,iPlate)+bStrip(thisStrip)*tStrip(thisStrip)*SinP(iPlate)/2;
	end
end
%the constraint equation of GD class can then be written as: [Delta_GD]=[C_GD]*[q], where the constraint matrix [C_GD]=[K]\[J_GD],
%so [C_GD] can be determined after the determination of [K], the stiffness matrix.

%2. for L mode class
% L class is orthogonal to GD class with respect to stiffness, so the previous [P] of GD satisfies: [P]'*[Delta_L]=0,
% which means [J_GD]'*[Delta_L]=[0], leading to the constraint equation of L class: [Delta_L]=[C_L]*[phi_L],
% where the constraint matrix of L mode class is: 
C_L=null(J_GD');

%3. for D mode class
% D class is further defined from GD class: the previous [q] for GD should be in equilibrium here
% [q] is in the plane of cross-section, so the necessary and sufficient conditions for the equilibrium are:
% the X-direction resulant force Fx=0, the Z-direction Fz=0, and the resulant torque T=0, that writes:
% [CosP,SinP,xNd(nodeP).*SinP-zNd(nodeP).*CosP]'*diag(AreaP)*[q]=[0 0 0]'
% thus, the [q] for D class is then determined as [q_D]=[J_D]*[phi_D], where:
J_D=null([CosP,SinP,xNd(nodeP).*SinP-zNd(nodeP).*CosP]'*diag(AreaP));
% Finally, we write the constraint equation of D class: [Delta_D]=[K]\[J_GD]*[J_D]*[phi_D]
% So, the constraint matrix of D class is [C_D]=[K]\[J_GD]*[J_D]. This will be done after the determination of [K].

%4. for G mode class
% because G class belongs to GD class, the load vector of G can be written as [P_G]=[J_GD]*[q_G],
% now the question is: what condition should the [q] of G class, i.e. [q_G], satisfy?
% G should be orthogonal to D w.r.t. stiffness, which means [Delta_D]'*[P_G]=0
% that writes [C_D]'*[J_GD]*[q_G]=[0] (because [Delta_D]=[C_D]*[phi_D])
% so we have [q_G]=[J_G]*[phi_G], where [J_G]=null([C_D]'*[J_GD])
% Finally, we get the constraint equation of G: [Delta_G]=[C_G]*[phi_G], where the constraint matrix [C_G]=[K]\[J_GD]*[J_G].
% This will be done after the determination of [K].

