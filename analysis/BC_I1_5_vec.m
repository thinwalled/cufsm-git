function [I1,I2,I3,I4,I5] = BC_I1_5_vec(BC,m_a,a)
%
% Calculate the 5 undetermined parameters I1,I2,I3,I4,I5 for local elastic
% and geometric stiffness matrices.
% BC: a string specifying boundary conditions to be analyzed:
    %'S-S' simply-pimply supported boundary condition at loaded edges
    %'C-C' clamped-clamped boundary condition at loaded edges
    %'S-C' simply-clamped supported boundary condition at loaded edges
    %'C-F' clamped-free supported boundary condition at loaded edges
    %'C-G' clamped-guided supported boundary condition at loaded edges
%Outputs:
%I1,I2,I3,I4,I5
    %calculation of I1 is the integration of Ym*Yn from 0 to a
    %calculation of I2 is the integration of Ym''*Yn from 0 to a
    %calculation of I3 is the integration of Ym*Yn'' from 0 to a
    %calculation of I3 is the integration of Ym*Yn'' from 0 to a
    %calculation of I4 is the integration of Ym''*Yn'' from 0 to a
    %calculation of I5 is the integration of Ym'*Yn' from 0 to a

% Originated from BC_I1_5.m 
% Sheng Jin Jan. 2024
	
totalm = length(m_a); %Total number of longitudinal terms m
mVec=reshape(m_a,[totalm,1]);%vector used in constructing the sparse matrix

[big2,small2]=find(mVec' == (mVec-2) );%big2 and small2 are lists of the sequences of the elements differ from each other by 2

[big1,small1]=find(mVec' == (mVec-1) );%those differ from each other by 1

if strcmp(BC,'S-S')
    %For simply-pimply supported boundary condition at loaded edges
	I1=.5*a.*speye(totalm);
	I2=spdiags(mVec.^2.*(-pi^2/a/2),0,totalm,totalm);
	I3=spdiags(mVec.^2.*(-pi^2/a/2),0,totalm,totalm);
	I4=spdiags(mVec.^4.*(pi^4/a^3/2),0,totalm,totalm);
	I5=spdiags(mVec.^2.*(pi^2/a/2),0,totalm,totalm);

elseif strcmp(BC,'C-C')
    %For Clamped-clamped boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
	I1=spalloc(totalm,totalm,totalm*3-2);
	I2=spalloc(totalm,totalm,totalm*3-2);
	I3=spalloc(totalm,totalm,totalm*3-2);
	I4=spalloc(totalm,totalm,totalm*3-2);
	I5=spalloc(totalm,totalm,totalm*3-2);
	
	I1(logical(eye(totalm)))=[3*a/8;a/4.*ones(totalm-1,1)];
	I2(logical(eye(totalm)))=-pi^2/4/a.*(mVec.^2+1);
	I3(logical(eye(totalm)))=-pi^2/4/a.*(mVec.^2+1);
	I4(logical(eye(totalm)))=pi^4/4/a^3.*((mVec.^2+1).^2+4.*mVec.^2);
	I5(logical(eye(totalm)))=pi^2/4/a.*(mVec.^2+1);
	
	I1(sub2ind(size(I1),big2,small2))=-a/8;
	I2(sub2ind(size(I2),big2,small2))=pi^2/8/a.*(mVec(big2).^2+1)-pi^2/4/a.*mVec(big2);
	I3(sub2ind(size(I3),big2,small2))=pi^2/8/a.*(mVec(small2).^2+1)+pi^2/4/a.*mVec(small2);
	I4(sub2ind(size(I4),big2,small2))=-pi^4/8/a^3.*(mVec(big2)-1).^2.*(mVec(small2)+1).^2;
	I5(sub2ind(size(I5),big2,small2))=-pi^2/8/a.*(mVec(big2).*mVec(small2)+1);
	
	I1(sub2ind(size(I1),small2,big2))=-a/8;
	I2(sub2ind(size(I2),small2,big2))=pi^2/8/a.*(mVec(small2).^2+1)+pi^2/4/a.*mVec(small2);
	I3(sub2ind(size(I3),small2,big2))=pi^2/8/a.*(mVec(big2).^2+1)-pi^2/4/a.*mVec(big2);
	I4(sub2ind(size(I4),small2,big2))=-pi^4/8/a^3.*(mVec(small2)+1).^2.*(mVec(big2)-1).^2;
	I5(sub2ind(size(I5),small2,big2))=-pi^2/8/a.*(mVec(small2).*mVec(big2)+1);

	
elseif strcmp(BC,'S-C')||strcmp(BC,'C-S')
    %For simply-clamped supported boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
	I1=spalloc(totalm,totalm,totalm*3-2);
	I2=spalloc(totalm,totalm,totalm*3-2);
	I3=spalloc(totalm,totalm,totalm*3-2);
	I4=spalloc(totalm,totalm,totalm*3-2);
	I5=spalloc(totalm,totalm,totalm*3-2);
	
	I1(logical(eye(totalm)))=a/2.*((mVec+1).^2./mVec.^2+1);
	I2(logical(eye(totalm)))=-pi^2/a.*(mVec+1).^2;
	I3(logical(eye(totalm)))=-pi^2/a.*(mVec+1).^2;
	I4(logical(eye(totalm)))=pi^4/2/a^3.*(mVec+1).^2.*((mVec+1).^2+mVec.^2);
	I5(logical(eye(totalm)))=pi^2/a.*(mVec+1).^2;
	
	I1(sub2ind(size(I1),big1,small1))=a/2.*(mVec(big1)+1)./mVec(big1);
	I2(sub2ind(size(I2),big1,small1))=-pi^2/a/2.*(mVec(big1)+1).*mVec(big1);
	I3(sub2ind(size(I3),big1,small1))=-pi^2/a/2.*(mVec(small1)+1).^2.*(mVec(big1)+1)./mVec(big1);
	I4(sub2ind(size(I4),big1,small1))=pi^4/a^3/2.*(mVec(big1)+1).*mVec(big1).*(mVec(small1)+1).^2;
	I5(sub2ind(size(I5),big1,small1))=pi^2/a/2.*(mVec(big1)+1).*(mVec(small1)+1);

	I1(sub2ind(size(I1),small1,big1))=a/2.*(mVec(big1)+1)./mVec(big1);
	I2(sub2ind(size(I2),small1,big1))=-pi^2/a/2.*(mVec(small1)+1).*(mVec(big1)+1)./mVec(big1);
	I3(sub2ind(size(I3),small1,big1))=-pi^2/a/2.*(mVec(big1)+1).*mVec(big1);
	I4(sub2ind(size(I4),small1,big1))=pi^4/a^3/2.*(mVec(small1)+1).^2.*mVec(big1).*(mVec(big1)+1);
	I5(sub2ind(size(I5),small1,big1))=pi^2/a/2.*(mVec(small1)+1).*(mVec(big1)+1);

	
	%
elseif strcmp(BC,'C-F')||strcmp(BC,'F-C')
    %For clamped-free supported boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
	I1=a-a/pi.*(-1).^(mVec-1)./(mVec-.5)-a/pi.*(-1).^(mVec'-1)./(mVec'-.5);
	I1(logical(eye(totalm)))=1.5*a-2*a/pi.*(-1).^(mVec-1)./(mVec-.5);
	I2=repmat((mVec-.5).^2.*(-1).^(mVec-1)./(mVec-.5).*(pi/a),1,totalm);
	I2(logical(eye(totalm)))=pi^2/a.*(mVec-.5).^2.*((-1).^(mVec-1)./(mVec-.5)./pi-.5);
	I3=I2';
	I4=spdiags(pi^4/2/a^3.*(mVec-.5).^4,0,totalm,totalm);
	I5=spdiags(pi^2/2/a.*(mVec-.5).^2,0,totalm,totalm);




elseif strcmp(BC,'C-G')||strcmp(BC,'G-C')
    %For clamped-guided supported boundary condition at loaded edges
    %calculation of I1 is the integration of Ym*Yn from 0 to a
	I1=spalloc(totalm,totalm,totalm*3-2);
	I2=spalloc(totalm,totalm,totalm*3-2);
	I3=spalloc(totalm,totalm,totalm*3-2);
	I4=spalloc(totalm,totalm,totalm*3-2);
	I5=spalloc(totalm,totalm,totalm*3-2);
	
	I1(logical(eye(totalm)))=[3*a/8;a/4*ones(totalm-1,1)];
	I2(logical(eye(totalm)))=-pi^2/a/4.*(0.25+(mVec-.5).^2);
	I3(logical(eye(totalm)))=-pi^2/a/4.*(0.25+(mVec-.5).^2);
	I4(logical(eye(totalm)))=pi^4/4/a^3.*(((mVec-.5).^2+.25).^2+(mVec-.5).^2);
	I5(logical(eye(totalm)))=pi^2/a/4.*(mVec-.5).^2+pi^2/16/a;
	
	I1(sub2ind(size(I1),big1,small1))=-a/8;
	I2(sub2ind(size(I2),big1,small1))=pi^2/a/8.*((mVec(big1)-.5).^2-mVec(big1)+.75);
	I3(sub2ind(size(I3),big1,small1))=pi^2/a/8.*((mVec(small1)-.5).^2+mVec(small1)-.25);
	I4(sub2ind(size(I4),big1,small1))=-pi^4/a^3/8.*mVec(small1).^4;
	I5(sub2ind(size(I5),big1,small1))=-pi^2/a/8.*mVec(small1).^2;
	
	I1(sub2ind(size(I1),small1,big1))=-a/8;
	I2(sub2ind(size(I2),small1,big1))=pi^2/a/8.*((mVec(small1)-.5).^2+mVec(small1)-.25);
	I3(sub2ind(size(I3),small1,big1))=pi^2/a/8.*((mVec(big1)-.5).^2-mVec(big1)+.75);
	I4(sub2ind(size(I4),small1,big1))=-pi^4/a^3/8.*mVec(small1).^4;
	I5(sub2ind(size(I5),small1,big1))=-pi^2/a/8.*mVec(small1).^2;
	
end


