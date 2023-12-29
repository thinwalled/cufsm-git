function []=plasticbuild_cb(num);
%bws
%March 2016
%
%general
global fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen
%output from pre2
global subfig ed_prop ed_node ed_elem ed_lengths axestop screen flags modeflag ed_springs ed_constraints
%output from load file
global filename
%output from plasticbuild
global fib nfibedit fyedit gradesedit degreesedit axesfibersect popanel axesPMM rawpointsui gridui gridedgeui gridptsui Dthetaedit Dphiedit M11ponM11yedit M22ponM22yedit M11pedit M22pedit Ppanchoredit Thetaedit Phiedit Betapedit M11pr M22pr Ppr M11p M22p Pp

switch num

    case 1
    %---------------------
    %plot the cross-section properly
    crossect(node,elem,axesfibersect,springs,constraints,flags)
    nfib=str2num(get(nfibedit,'String'));
    nfiber=ones(length(elem(:,1)),1)*nfib;
    fib = fiber4elem(node,elem,nfiber);   
    fibplotoverlay(node,elem,nfiber,fib)
    %---------------------
    
    case 5
    %-----------------------------
    %Coarse button for raw surface discretization
    grades=str2num(get(gradesedit,'String'));
    degrees=str2num(get(degreesedit,'String'));
    grades=ceil(grades*0.8);
    degrees=degrees(1:2:length(degrees));
    set(gradesedit,'String',num2str(grades));
    set(degreesedit,'String',num2str(degrees));    
    %-----------------------------

    case 6
    %-----------------------------
    %Fine button for raw surface discretization
    grades=str2num(get(gradesedit,'String'));
    degrees=str2num(get(degreesedit,'String'));
    grades=ceil(grades*1.25);
    nd=length(degrees);
    if nd>=559 %default initial value
        helpdlg('Consider doubling the finite strip elements for a finer result instead of changing the PNA grades and degrees. The degrees are already likely fine enough based on the current values being used.', 'Help on discretizaton of plastic surface');
    end   
    for i=1:nd
        if i<nd
            degreesn(2*i-1)=degrees(i);
            degreesn(2*i)=(degrees(i)+degrees(i+1))/2;
        else
            degreesn(2*i-1)=degrees(i);            
        end
    end
    degrees=degreesn;
    set(gradesedit,'String',num2str(grades));
    set(degreesedit,'String',num2str(degrees));    
    %-----------------------------

    case 7
    %-----------------------------
    %Coarse button for gridded surface discretization
    Dtheta=str2num(get(Dthetaedit,'String'));
    Dphi=str2num(get(Dphiedit,'String'));
    Dtheta=ceil(Dtheta*2);
    Dphi=ceil(Dphi*2);
    set(Dthetaedit,'String',num2str(Dtheta));
    set(Dphiedit,'String',num2str(Dphi));    
    %-----------------------------

    case 8
    %-----------------------------
    %Fine button for gridded surface discretization
    Dtheta=str2num(get(Dthetaedit,'String'));
    Dphi=str2num(get(Dphiedit,'String'));
    Dtheta=ceil(Dtheta/2);
    Dphi=ceil(Dphi/2);
    set(Dthetaedit,'String',num2str(Dtheta));
    set(Dphiedit,'String',num2str(Dphi));    
    %-----------------------------

    
    case 10
    %-----------------------------------------------
    %Generate the initial plastic surface
    [A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
    unsymm=1;
    fy=str2num(get(fyedit,'String'));
    nfib=str2num(get(nfibedit,'String'));
    Ne=str2num(get(gradesedit,'String'));
    Deg=str2num(get(degreesedit,'String'));
    nfiber=ones(length(elem(:,1)),1)*nfib;
    fib = fiber4elem(node,elem,nfiber);   
    [M11pr,M22pr,Ppr]=PMM_Plastic(fib,node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap*180/pi,I11,I22,unsymm,Ne,Deg); %July 2021 thetap angle changed to degress in input to PMM_plastic
    %plot the results
    rawpts=1;, gridit=0; gridedge=0; gridpts=0;
    set(rawpointsui,'Value',rawpts);
    set(gridui,'Value',gridit);
    set(gridedgeui,'Value',gridedge);
    set(gridptsui,'Value',gridpts);    
    %Grid the raw plastic surface
    betaray=1;
    thetabetap=str2num(get(Thetaedit,'String'));
    phibetap=str2num(get(Phiedit,'String'));
    PMMplasticplotter(axesPMM,M11pr,M22pr,Ppr,rawpts,M11p,M22p,Pp,gridit,gridedge,gridpts,betaray,thetabetap,phibetap);
    %Calc the anchor points and report out
    plasticbuild_cb(12)
    %Calculate the betap values
    plasticbuild_cb(13)
    %-----------------------------------------------
    
    case 11
    %-----------------------------------------------
    %Grid the raw plastic surface
    if M11pr==0
        %let user know they must do the raw construction first
        errordlg('You must select and build raw surface before interpolation', 'Error - Need raw surface first');
    else
        Dtheta=str2num(get(Dthetaedit,'String'));
        Dphi=str2num(get(Dphiedit,'String'));
        Plasticsurface=1;
        [M11p,M22p,Pp,beta_P]=Plastic_Int(M11pr, M22pr, Ppr,Dtheta,Dphi,Plasticsurface);
        %plot the results
        rawpts=0;, gridit=1; gridedge=0; gridpts=1;
        set(rawpointsui,'Value',rawpts);
        set(gridui,'Value',gridit);
        set(gridedgeui,'Value',gridedge);
        set(gridptsui,'Value',gridpts);    
        %Grid the raw plastic surface
        betaray=1;
        thetabetap=str2num(get(Thetaedit,'String'));
        phibetap=str2num(get(Phiedit,'String'));
        PMMplasticplotter(axesPMM,M11pr,M22pr,Ppr,rawpts,M11p,M22p,Pp,gridit,gridedge,gridpts,betaray,thetabetap,phibetap)
    end
    %-----------------------------------------------

    case 12
    %-----------------------------------------------
    %Calculate the Plastic Anchors
    thetaMM=0  ;,PhiPM=90;,[M11ponM11y,~,~,~]=Plastic_Int(M11pr, M22pr, Ppr,thetaMM,PhiPM,0);
    thetaMM=90 ;,PhiPM=90;,[~,M22ponM22y,~,~]=Plastic_Int(M11pr, M22pr, Ppr,thetaMM,PhiPM,0);
    %Get Mpp values
    fy=str2num(get(fyedit,'String'));
    unsymm=1;
    %calculate new values for yield moments
    [A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
    [Py,Mxxy,Mzzy,M11y,M22y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap*180/pi,I11,I22,unsymm);
    M11panchor=M11ponM11y*M11y;
    M22panchor=M22ponM22y*M22y;
    Ppanchor=Py;
    %feed the results back to the interface
    set(M11ponM11yedit,'String',num2str(M11ponM11y));
    set(M22ponM22yedit,'String',num2str(M22ponM22y));
    set(M11pedit,'String',num2str(M11panchor));
    set(M22pedit,'String',num2str(M22panchor));
    set(Ppanchoredit,'String',num2str(Ppanchor));    
    %-----------------------------------------------
    
    
    case 13
    %------------------------------------------------
    %Calculate betap
    thetaMM=str2num(get(Thetaedit,'String'));
    phiPM=str2num(get(Phiedit,'String'));
    [~,~,~,betap]=Plastic_Int(M11pr, M22pr, Ppr,thetaMM,phiPM,0);
    set(Betapedit,'String',num2str(betap));
    %and plot the updated beta ray vector
    plasticbuild_cb(50)
    
    case 50
    %-----------------------------------------------
    rawpts=get(rawpointsui,'Value');
    gridit=get(gridui,'Value');
    gridedge=get(gridedgeui,'Value');
    gridpts=get(gridptsui,'Value');    
    %Grid the raw plastic surface
    betaray=1;
    thetabetap=str2num(get(Thetaedit,'String'));
    phibetap=str2num(get(Phiedit,'String'));
    PMMplasticplotter(axesPMM,M11pr,M22pr,Ppr,rawpts,M11p,M22p,Pp,gridit,gridedge,gridpts,betaray,thetabetap,phibetap)
    
    %-----------------------------------------------
    %----------------------------------------------------
    %viewpoint and rotate button for 3D PMM visualization
    %----------------------------------------------------
   case 51
        axes(axesPMM(1));
        view(0,90)
   case 52
        axes(axesPMM(1));
        view(0,0)
   case 53
        axes(axesPMM(1));
        view(90,0)
   case 54
        axes(axesPMM(1));
        view(37.5,30)
   case 55
        axes(axesPMM(1));
        rotate3d
        %----------------------------------------------------
  
        %generated stress plot options
        %Set the various plotting option flags
        %flags:[node# element# mat# stress# stresspic coord constraints springs origin] 1 means show
        case 204 
            if flags(1)==1, flags(1)=0;, else flags(1)=1;, end
            plasticbuild_cb(1);
        case 205 
            if flags(2)==1, flags(2)=0;, else flags(2)=1;, end
            plasticbuild_cb(1);
        case 206 
            if flags(3)==1, flags(3)=0;, else flags(3)=1;, end
            plasticbuild_cb(1);
        case 207 
            if flags(4)==1, flags(4)=0;, else flags(4)=1;, end
            plasticbuild_cb(1);
        case 208 
            if flags(5)==1, flags(5)=0;, else flags(5)=1;, end
            plasticbuild_cb(1);
        case 209 
            if flags(6)==1, flags(6)=0;, else flags(6)=1;, end
            plasticbuild_cb(1);
        case 210 
            if flags(7)==1, flags(7)=0;, else flags(7)=1;, end
            plasticbuild_cb(1);
        case 211 
            if flags(8)==1, flags(8)=0;, else flags(8)=1;, end
            plasticbuild_cb(1);
        case 212 
            if flags(9)==1, flags(9)=0;, else flags(9)=1;, end
            plasticbuild_cb(1);
        case 213 
            if flags(10)==1, flags(10)=0;, else flags(10)=1;, end
            plasticbuild_cb(1);
        case 220
            if strcmp(popanel.Visible,'off')
                popanel.Visible = 'on'
            else
                popanel.Visible = 'off'
            end 
 
    case 900
        helpdlg('The plastic surface is constructing by evaluating a large number of different plastic neutral axis (PNA) locations and determining the P,M11,M22 that results at the selected PNA. All the angles in the angles box are investigated as PNAs and the given angle is investigated at separate locations in the section - grades determines the number of different PNAs that are investigated at a given angle.', 'Help on raw plastic surface construction');
    case 901
        helpdlg('The raw plastic surface is interpolated to an evenly spaced grid of points for viewing and exporting. Select the increments in theta and phi to construct the gridded surface', 'Help on gridding/interpolating plastic surface');

end