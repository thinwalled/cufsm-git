function [M11p,M22p,Pp,beta_P]=Plastic_Int(M11_P, M22_P, P_P,thetaMM, phiPM,Plasticsurface)
%%% Plastic Surface Interpolation Function
%%% ST March 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if Plasticsurface==1

    %GUI WAIT BAR FOR BUILDIG SURFACE
    wait_message=waitbar(0,'Gridding Plastic Surface Evenly','position',[150 300 384 68],...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
    setappdata(wait_message,'canceling',0)

    
    thetaMM=0:thetaMM:360;
    phiPM=0:phiPM:180;
    
end


%% Beta-ThetaMM-phiPM space (point for re-gridding the point cloud via interpolation)


% Chnaging the PMM coordinate to the polar coordinate to prepare data for
% interpolation

[m,n]=size(P_P);
Inter1=[reshape(M11_P,m*n,1) reshape(M22_P,m*n,1) reshape(P_P,m*n,1)];
Inter=unique(Inter1, 'rows');
[azp,elp,rp] = cart2sph(Inter(:,1),Inter(:,2),Inter(:,3));

BP(length(thetaMM)*length(thetaMM))=0;


k=1;
for i=1:length(thetaMM)
      for j=1:length(phiPM)
          
        %% Plastic Surface on the fiber discritization (interpolation)

        if phiPM(j)==180||phiPM(j)==0
            ri=1;
        else
            if thetaMM(i)>=180;
                azi=(thetaMM(i)-360)/180*pi;
            else
                azi=(thetaMM(i))/180*pi;
            end

                eli=(90-phiPM(j))/180*pi;

                F = scatteredInterpolant(azp,elp,rp,'linear','nearest');
                ri = F(azi,eli);

            if isnan(ri)
                ri = griddata(azp,elp,rp,azi,eli,'nearest');
            end

        end
                Plastic(k,1)=thetaMM(i);
                Plastic(k,2)=phiPM(j);
                Plastic(k,3)=ri;
                Plastic(k,4)=ri*cos(thetaMM(i)/180*pi)*sin(phiPM(j)/180*pi);
                Plastic(k,5)=ri*sin(thetaMM(i)/180*pi)*sin(phiPM(j)/180*pi);
                Plastic(k,6)=ri*cos(phiPM(j)/180*pi);

                if Plasticsurface==1
                            waitbar(k/(length(thetaMM)*length(phiPM)),wait_message);
                end
                
                k=k+1;

      end
end


switch Plasticsurface


case 0
    
beta_P=Plastic(:,3);
M11p=Plastic(:,4);
M22p=Plastic(1,5);
Pp=Plastic(1,6);

  
    
case 1
%% regridding data to for 3D plots

azz=thetaMM;
ell=phiPM;
[azi,eli] = meshgrid(azz,ell);

 LP=length(phiPM);

riP(length(ell),length(azz))=0;
for i=1:length(ell)
    for j=1:length(azz)

% Plastic surface (polar coordinate system)
riP(i,j)=Plastic(and(Plastic(:,1)==azi(i,j),Plastic(:,2)==eli(i,j)),3);

    end
end

% Converting to Cartesian coordinate system

% Plastic surface
[XP,YP,ZP] = sph2cart(azi/180*pi,(90-eli)/180*pi,riP);

beta_P=Plastic(:,3);
M11p=XP;
M22p=YP;
Pp=ZP;

if ishandle(wait_message)
    delete(wait_message);
end


end


end




