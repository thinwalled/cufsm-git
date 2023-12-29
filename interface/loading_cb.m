function []=loading_cb(num);
%zli
%August 2010
%bws
%Fall 2015
%
%general
global fig screen prop node elem lengths curve shapes clas springs constraints GBTcon BC m_all neigs version screen
%output from pre2
global subfig ed_prop ed_node ed_elem ed_lengths axestop screen flags modeflag ed_springs ed_constraints
%output from loading
global inode A xcg zcg Ixx Izz Ixz thetap I11 I22 J Xs Ys Cw B1 B2 w Pedit Bedit M11edit M22edit Mxxedit Mzzedit fyedit Pyedit Byedit M11yedit M22yedit Mxxyedit Mzzyedit PonPyedit M11onM11yedit M22onM22yedit Betaedit Thetaedit Phiedit yPonPyedit yM11onM11yedit yM22onM22yedit yBetaedit yThetaedit yPhiedit principal geometric restrained scale_tex maxstress_tex minstress_tex axesstres axesPMM firstyieldui y_inc PMMbox PMMswitch popanel
%output from load file
global filename

switch num
       
    case 1
        %----------------------------------------------------
        %Read applied loads and update the stress plot
        P=str2num(get(Pedit,'String'));
        %moments
        %determine if restrained bending
        restrainedv=get(restrained,'Value');
        if restrainedv==1
            unsymm=0;
        else
            unsymm=1;
        end
        %assign values based on principal or geometric bending
        principalv=get(principal,'Value');
        if principalv==1
            M11=str2num(get(M11edit,'String'));
            M22=str2num(get(M22edit,'String'));
            Mxx=0;
            Mzz=0;
        else
            Mxx=str2num(get(Mxxedit,'String'));
            Mzz=str2num(get(Mzzedit,'String'));
            [M11,M22]=MxxtoM11(Mxx,Mzz,Ixx,Izz,Ixz,thetap,I11,I22,restrainedv);
            set(M11edit,'String',num2str(M11));
            set(M22edit,'String',num2str(M22));
            M11=0;
            M22=0;
        end
        %bimoment
        B=str2num(get(Bedit,'String'));
        inode=stresgen(node,P,Mxx,Mzz,M11,M22,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm);
        inode=warp_stress(inode,prop,1,0,B,0,0,Cw,0,w,0);
        scale=str2num(get(scale_tex,'String'));
        maxstress=max([inode(:,8);0]);
        set(maxstress_tex,'String',num2str(maxstress));
        minstress=min([inode(:,8);0]);
        set(minstress_tex,'String',num2str(minstress));
        %strespic(inode,elem,axesstres,scale)
        crossect(inode,elem,axesstres,springs,constraints,flags)
        %
        %
        if get(PMMswitch,'Value')
            %update the generalized PMM Demand Definition
            Py=str2num(get(Pyedit,'String'));
            M11y=str2num(get(M11yedit,'String'));
            M22y=str2num(get(M22yedit,'String'));
            set(PonPyedit,'String',num2str(P/Py));
            if principalv==1
                set(M11onM11yedit,'String',num2str(M11/M11y));
                set(M22onM22yedit,'String',num2str(M22/M22y));
            else %geometric bending
                [M11,M22]=MxxtoM11(Mxx,Mzz,Ixx,Izz,Ixz,thetap,I11,I22,restrainedv);
                set(M11onM11yedit,'String',num2str(M11/M11y));
                set(M22onM22yedit,'String',num2str(M22/M22y));
            end
            [beta,theta,phi] = PMMtoBetaThetaPhi(P/Py,M11/M11y,M22/M22y);
            set(Betaedit,'String',num2str(beta));
            set(Thetaedit,'String',num2str(theta));
            set(Phiedit,'String',num2str(phi));  
            %update the generalized PMM yield point
            fmax=max(abs([inode(:,8);0]));
            fy=str2num(get(fyedit,'String'));
            set(yPonPyedit,'String',num2str(P/Py*fy/fmax));
            set(yM11onM11yedit,'String',num2str(M11/M11y*fy/fmax));
            set(yM22onM22yedit,'String',num2str(M22/M22y*fy/fmax));   
            [ybeta,ytheta,yphi] = PMMtoBetaThetaPhi(P/Py*fy/fmax,M11/M11y*fy/fmax,M22/M22y*fy/fmax);
            set(yBetaedit,'String',num2str(ybeta));
            set(yThetaedit,'String',num2str(ytheta));
            set(yPhiedit,'String',num2str(yphi));
            %update the PMM plot
            firstyieldflag=get(firstyieldui,'Value');    
            PMMplotter(axesPMM,node,elem,P,M11,M22,Py,M11y,M22y,firstyieldflag,fy,y_inc)
        end
        %----------------------------------------------------
    
    case 2
        %----------------------------------------------------
        %principal/geometric radio button
        set(principal,'Value',1);
        set(geometric,'Value',0);
        loading_cb(1);
        %----------------------------------------------------
    case 3
        %----------------------------------------------------
        %principal/geometric radio button
        set(principal,'Value',0);
        set(geometric,'Value',1);
        loading_cb(1);
        %----------------------------------------------------
    case 4
        %----------------------------------------------------
        %update yield values
        loading_cb(11);
        %then update everything else called at the end of 11
        %----------------------------------------------------

        
    case 11
        %----------------------------------------------------
        %fy box
        fy=str2num(get(fyedit,'String'));
        %determine if restrained checked or not
        restrainedv=get(restrained,'Value');
        if restrainedv==1
            unsymm=0;
        else
            unsymm=1;
        end       
        %calculate new values for yield moments
        [Py,Mxxy,Mzzy,M11y,M22y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm);
        [By]=yieldB(fy,Cw,w);
        set(Pyedit,'String',num2str(Py));
        set(Byedit,'String',num2str(By));
        set(M11yedit,'String',num2str(M11y));
        set(M22yedit,'String',num2str(M22y));
        set(Mxxyedit,'String',num2str(Mxxy));
        set(Mzzyedit,'String',num2str(Mzzy));
        %update the generalized PMM Demand definitions
        loading_cb(1)
        %----------------------------------------------------
    case 12
        %----------------------------------------------------
        %Py button
        if str2num(get(Pedit,'String'))==str2num(get(Pyedit,'String'))
            set(Pedit,'String',0)         
        else
            set(Pedit,'String',get(Pyedit,'String'))
        end
        loading_cb(1);
        %----------------------------------------------------
    case 13
        %----------------------------------------------------
        %By button
        if str2num(get(Bedit,'String'))==str2num(get(Byedit,'String'))
            set(Bedit,'String',0)         
        else
            set(Bedit,'String',get(Byedit,'String'))
        end
        loading_cb(1);
        %----------------------------------------------------
    case 14
        %----------------------------------------------------
        %M11ybutton
        if str2num(get(M11edit,'String'))==str2num(get(M11yedit,'String'))
            set(M11edit,'String',0)         
        else
            set(M11edit,'String',get(M11yedit,'String'))
        end
        loading_cb(2); %set radio button to principal
        loading_cb(1);
        %----------------------------------------------------
    case 15
        %----------------------------------------------------
        %M22ybutton
        if str2num(get(M22edit,'String'))==str2num(get(M22yedit,'String'))
            set(M22edit,'String',0)         
        else
            set(M22edit,'String',get(M22yedit,'String'))
        end
        loading_cb(2); %set radio button to principal
        loading_cb(1);
        %----------------------------------------------------
    case 16
        %----------------------------------------------------
        %Mxxybutton
        if str2num(get(Mxxedit,'String'))==str2num(get(Mxxyedit,'String'))
            set(Mxxedit,'String',0)         
        else
            set(Mxxedit,'String',get(Mxxyedit,'String'))
        end
        loading_cb(3); %set radio button to geometric
        loading_cb(1);
        %----------------------------------------------------
    case 17
        %----------------------------------------------------
        %Mzzybutton
        if str2num(get(Mzzedit,'String'))==str2num(get(Mzzyedit,'String'))
            set(Mzzedit,'String',0)         
        else
            set(Mzzedit,'String',get(Mzzyedit,'String'))
        end
        loading_cb(3); %set radio button to geometric
        loading_cb(1);
        %----------------------------------------------------
       
    case 20
        %----------------------------------------------------
        %Drive demand based on generalized PMM demand
        Py=str2num(get(Pyedit,'String'))
        M11y=str2num(get(M11yedit,'String'));
        M22y=str2num(get(M22yedit,'String'));
        P=str2num(get(PonPyedit,'String'))*Py;
        M11=str2num(get(M11onM11yedit,'String'))*M11y;
        M22=str2num(get(M22onM22yedit,'String'))*M22y;
        set(Pedit,'String',num2str(P));
        set(M11edit,'String',num2str(M11));
        set(M22edit,'String',num2str(M22));
        loading_cb(2); %set radio button to principal 
        %and run case 1 which upates all the P and M
        %----------------------------------------------------
    case 21
        %----------------------------------------------------
        %Drive demand based on generalized Beta Theta Phi demand
        Beta=str2num(get(Betaedit,'String'))
        Theta=str2num(get(Thetaedit,'String'))
        Phi=str2num(get(Phiedit,'String'))
        [PonPy,M11onM11y,M22onM22y] = BetaThetaPhitoPMM(Beta,Theta,Phi);
        set(PonPyedit,'String',num2str(PonPy));
        set(M11onM11yedit,'String',num2str(M11onM11y));
        set(M22onM22yedit,'String',num2str(M22onM22y));
        loading_cb(20); %read and move current demands over
        %loading_cb(2); %set radio button to principal
        %loading_cb(1);
        %----------------------------------------------------

   case 25
        %----------------------------------------------------
        %Change the increment used for determining yield surface
        y_inc=y_inc/2;
        loading_cb(1);
        %----------------------------------------------------
   case 26
        %----------------------------------------------------
        %Change the increment used for determining yield surface
        y_inc=y_inc*2;
        loading_cb(1);
        %----------------------------------------------------

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

        %Submit stress to input
        %-------------------------------------------------------------------
    case 100
        %-------------------------------------------------------------------
        %generate everything based on latest numbers
        %Read applied loads and update the stress plot
        P=str2num(get(Pedit,'String'));
        %moments
        %determine if restrained bending
        restrainedv=get(restrained,'Value');
        if restrainedv==1
            unsymm=0;
        else
            unsymm=1;
        end
        %assign values based on principal or geometric bending
        principalv=get(principal,'Value');
        if principalv==1
            M11=str2num(get(M11edit,'String'));
            M22=str2num(get(M22edit,'String'));
            Mxx=0;
            Mzz=0;
        else
            Mxx=str2num(get(Mxxedit,'String'));
            Mzz=str2num(get(Mzzedit,'String'));
            [M11,M22]=MxxtoM11(Mxx,Mzz,Ixx,Izz,Ixz,thetap,I11,I22,restrainedv)
            set(M11edit,'String',num2str(M11));
            set(M22edit,'String',num2str(M22));
            M11=0;
            M22=0;
        end
        %bimoment
        B=str2num(get(Bedit,'String'));
        inode=stresgen(node,P,Mxx,Mzz,M11,M22,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,unsymm);
        inode=warp_stress(inode,prop,1,0,B,0,0,Cw,0,w,0);
        %write temp. displayed stress to actual variable
        node=inode; 
        %back to pre-processor 
        %close(subfig);
        flags=[1 0 0 0 1 0 1 1 1 1]; 
        %figure(fig);
        pre2;
        %-------------------------------------------------------------------
    
        %Close
    case 101
        %close(subfig);
        flags=[1 0 0 0 1 0 1 1 1 1]; 
        figure(fig);
        pre2;
        %-------------------------------------------------------------------

   case 200
        %----------------------------------------------------
        %Use current stress to estimate the applied actions
        [A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,J,Xs,Ys,Cw,B1,B2,w] = cutwp_prop2(node(:,2:3),elem(:,2:4));
        [P,M11,M22,B,err] = stress_to_action(node,xcg,zcg,thetap,A,I11,I22,w,Cw);
        fy=max(abs(node(:,8))); %guess at fy assuming max stress in the model = fy
        %report the error in the conversion so the user knows and can
        %decide whether or not this is going to be good enough
        text={['Member actions determined from applied stresses already in model.'];
            ['Sum squared error in stress across nodes, determined from basing stress'];
            ['on these actions instead of original stress read from pre, err=',num2str(err)]};
        choice = questdlg(text,'Accept reference applied actions','OK, Continue','Don''t Use Stress','OK, Continue');
        switch choice
            case 'OK, Continue'
                %ok...
            case 'Don''t Use Stress'
                return
        end
        %If a generated action is really small we should set it to zero
        %lets say if the action is less than 0.1% of the yield for that
        %action then we set it to zero, so we need the yield then we can
        %make the corrections as needed
        %find the yield values
        [Py,Mxxy,Mzzy,M11y,M22y]=yieldMP(node,fy,A,xcg,zcg,Ixx,Izz,Ixz,thetap,I11,I22,1);
        [By]=yieldB(fy,Cw,w);
        %correct as needed
        if abs(P/Py)<0.001, P=0;, end
        if abs(B/By)<0.001, B=0;, end
        if abs(M11/M11y)<0.001, M11=0;, end
        if abs(M22/M22y)<0.001, M22=0;, end     
        %Write the actions into the boxes
        set(Pedit,'String',num2str(P));
        set(M11edit,'String',num2str(M11));
        set(M22edit,'String',num2str(M22));
        set(Bedit,'String',num2str(B));
        set(fyedit,'String',num2str(fy));
        %set to the principal axis since this is how it is solved
        loading_cb(2);
        %update yield values based on fy guess
        loading_cb(11);
        %----------------------------------------------------
   
        %generated stress plot options
        %Set the various plotting option flags
        %flags:[node# element# mat# stress# stresspic coord constraints springs origin] 1 means show
        case 204 
            if flags(1)==1, flags(1)=0;, else flags(1)=1;, end
            loading_cb(1);
        case 205 
            if flags(2)==1, flags(2)=0;, else flags(2)=1;, end
            loading_cb(1);
        case 206 
            if flags(3)==1, flags(3)=0;, else flags(3)=1;, end
            loading_cb(1);
        case 207 
            if flags(4)==1, flags(4)=0;, else flags(4)=1;, end
            loading_cb(1);
        case 208 
            if flags(5)==1, flags(5)=0;, else flags(5)=1;, end
            loading_cb(1);
        case 209 
            if flags(6)==1, flags(6)=0;, else flags(6)=1;, end
            loading_cb(1);
        case 210 
            if flags(7)==1, flags(7)=0;, else flags(7)=1;, end
            loading_cb(1);
        case 211 
            if flags(8)==1, flags(8)=0;, else flags(8)=1;, end
            loading_cb(1);
        case 212 
            if flags(9)==1, flags(9)=0;, else flags(9)=1;, end
            loading_cb(1);
        case 213 
            if flags(10)==1, flags(10)=0;, else flags(10)=1;, end
            loading_cb(1);
        case 220
            if strcmp(popanel.Visible,'off')
                popanel.Visible = 'on'
            else
                popanel.Visible = 'off'
            end 
        

        
        
   case 300
        %----------------------------------------------------
        %Read from MASTAN
        %read forces from a mastan analysis into the applied load generator
        %
        %get path to mastan file
        [masFileName,masPathName] = uigetfile('*.mat','Select the MASTAN mat file');
        %
        %load mastan file
        load([masPathName,masFileName]);
        %
        %get element number and location along the element
        prompt={'Enter the element number:','Enter the normalized x/L location along the length [0-1]:','Enter the MASTAN analysis step:'};
        def={'1','0','1'};
        dlgTitle='MASTAN Element Number and location along length';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        maselenum=str2num(answer{1});
        maseleloc=str2num(answer{2});
        masstep=str2num(answer{3});
        %
        %read the forces from the mastan model
        ratio=maseleloc;
        startpt = node_info(elem_info(maselenum,1),1:3);
        endpt = node_info(elem_info(maselenum,2),1:3);
        L = norm(startpt - endpt);
        elfor = ele_for(maselenum,:,masstep);
        mP  = ratio*L*(( elfor(1) + elfor(7) )/L ) - elfor(1);
        mVy = elfor(2) - ratio*L*( elfor(2) + elfor(8) )/L;
        mVz = elfor(3) - ratio*L*( elfor(3) + elfor(9) )/L;
        mTx = ratio*L*(( elfor(10)+elfor(4))/L ) - elfor(4);
        mMy = elfor(5) + ratio*L*elfor(3) - ((ratio*L)^2) * ( elfor(11) + elfor(5) + L*elfor(3) )/(L^2);
        mMz = ((ratio*L)^2) * ( elfor(12) + elfor(6) - L*elfor(2) )/(L^2) + ratio*L*elfor(2) - elfor(6);
        mB  = ratio*L*(( elfor(14)-elfor(13))/L ) + elfor(13); 
        %
        %CUFSM sign convention is axial compression is positive
        mP=-mP;
        %
        %provide section properties from MASTAN and CUFSM, confirm load
        %cufsm section properties
        %name
        if isempty(filename)
            mas_name=['cufsm',datestr(floor(now))];
        else
            mas_name=[filename(1:length(filename)-4)];
        end
        %properties - use globals for now..
        %mastan
        sectionnum=elem_info(maselenum,3);
        %Confirm replacement of MASTAN section properties with CUFSM section properties
        prch={['Confirm that selected element matches current CUFSM section'];
            [strjoin([{'MASTAN name='};sect_name{sectionnum}]),' CUFSM= ',mas_name];
            ['MASTAN A=',num2str(sect_info(sectionnum,1)),' CUFSM= ',num2str(A)];
            ['MASTAN Izz=',num2str(sect_info(sectionnum,2)),' CUFSM= ',num2str(Ixx)];
            ['MASTAN Iyy=',num2str(sect_info(sectionnum,3)),' CUFSM= ',num2str(Izz)];
            ['MASTAN J=',num2str(sect_info(sectionnum,4)),' CUFSM= ',num2str(J)];
            ['MASTAN Cw=',num2str(sect_info(sectionnum,5)),' CUFSM= ',num2str(Cw)];
            ['MASTAN Zzz=',num2str(sect_info(sectionnum,6)),' CUFSM= ',num2str(Ixx)];
            ['MASTAN Zyy=',num2str(sect_info(sectionnum,7)),' CUFSM= ',num2str(Izz)];
            ['MASTAN Ayy=',num2str(sect_info(sectionnum,8)),' CUFSM= ',num2str(Inf)];
            ['MASTAN Azz=',num2str(sect_info(sectionnum,9)),' CUFSM= ',num2str(Inf)];
            ['--------------------------------------------------------------------'];
            ['Raw MASTAN output to be read into CUFSM'];
            ['Filename=',masPathName,masFileName];
            ['Element=',num2str(maselenum)];
            ['Section=',num2str(sectionnum)];
            ['Nodes=',num2str(elem_info(maselenum,1)),':',num2str(elem_info(maselenum,2))];
            ['x/L=',num2str(ratio)];
            ['P=',num2str(-mP)];
            ['Vy=',num2str(mVy)];
            ['Vz=',num2str(mVz)];
            ['Tx=',num2str(mTx)];
            ['My=',num2str(mMy)];
            ['Mz=',num2str(mMz)];
            ['B=',num2str(mB)]};
        choice = questdlg(prch,'Continue with loading MASTAN forces','Yes','No','No');
        switch choice
            case 'Yes'
                %ok...
            case 'No'
                return
        end        
        %
        %
        %load P,M,B
        set(Pedit,'String',num2str(mP));
        set(Mxxedit,'String',num2str(0));
        set(Mzzedit,'String',num2str(0));
        set(M11edit,'String',num2str(mMz));
        set(M22edit,'String',num2str(mMy));
        set(Bedit,'String',num2str(mB));
        %
        %set principal as bending axis
        loading_cb(2)
        %loading_cb(1) then full update happens    
        %-------------------------------------------------------------------
        
        
        
    case 400
        %switch on PMM representation
        if get(PMMswitch,'Value') %toggled
            delete(PMMbox);
            loading_cb(1);
        else
            PMMbox=uicontrol(subfig,...
                'Style','frame','units','normalized',...
                'Position',[0.5 0.0 0.5 1.0]);
            PMMswitch=uicontrol(subfig,...
                'Style','toggle','units','normalized',...
                'HorizontalAlignment','Right',...
                'Position',[0.96 0.96 0.03 0.03],...
                'String','PMM',...
                'Tooltip','Activate PMM representation',...
                'Value',0,...
                'Callback',[...
                'loading_cb(400);']);
        end
        %----------------------------------------------------
        
end