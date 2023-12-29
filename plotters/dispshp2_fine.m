function []=dispshp2(undef,L,node,elem,mode,axesnum,scalem,m_a,BC,ifpatch)
%BWS
%1998 originated
%2010 BWS and Z.Li improvements for speed and generality
%
%L=length
%node: [node# x z dofx dofz dofy dofrot stress] nnodes x 8;
%elem: [elem# nodei nodej t] nelems x 4;
%mode: vector of displacements global dof [u1 v1...un vn w1 01...wn 0n]'
%
wait_message=waitbar(0,'slower for long length or many longitudinal terms','Name','Plotting the 3D shape.' );

% set(wait_message,'WindowStyle','modal')
%watchon;
%
%
%
axes(axesnum);
cla;
set(axesnum,'visible','off')
%
%set initial axis limits
xmin=min(node(:,2));
xmax=max(node(:,2));
ymin=0;
ymax=L;
zmin=min(node(:,3));
zmax=max(node(:,3));
if nargin<10|isempty(ifpatch)
    ifpatch=0;
end
%
%
%Determine a scaling factor for the displaced shape
scale=scalem*1/3*max(max(node(:,2:3)));
%
%for k=1:10
%   plot3(node(:,2),ones(length(node(:,1)),1)*(k-1)/9*L,-node(:,3),'r.')
%   axis('off')
%   title('MODE SHAPE')
%   hold on
%end
%axis equal
%
%

%Generate and plot
maxm=max(m_a);
Mw=0;%Maximum element length
for i=1:length(elem(:,1))
    hh1=abs(sqrt((node(elem(i,2),2)-node(elem(i,3),2))^2+(node(elem(i,2),3)-node(elem(i,3),3))^2));
    if hh1>Mw
        Mw=hh1;
    end
end
km=max(ceil(L/Mw),3*maxm);
for k=1:km
%    figure(wait_message)
   nnodes=length(node(:,1));
   for i=1:length(elem(:,1))
      %Get element geometry
      nodei = elem(i,2);	nodej = elem(i,3);
      xi = node(nodei,2);	   xj = node(nodej,2);
      zi = node(nodei,3);	   zj = node(nodej,3);
      %Determine the global element displacements
      %dbar is the nodal displacements for the element in global
      %coordinates. dbar=(u1 v1 u2 v2 w1 o1 w2 o2)';
      links=5;
      disp1m=zeros(2,links+1);
      disp2m=zeros(2,links+1);
      totalm=length(m_a);%Total number of longitudinal terms
      for mn=1:totalm
          dbar(1:2,1)=mode(4*nnodes*(mn-1)+2*nodei-1:4*nnodes*(mn-1)+2*nodei);%+dbar(1:2,1);
          dbar(3:4,1)=mode(4*nnodes*(mn-1)+2*nodej-1:4*nnodes*(mn-1)+2*nodej);%+dbar(3:4,1);
          dbar(5:6,1)=mode(4*nnodes*(mn-1)+2*nnodes+2*nodei-1:4*nnodes*(mn-1)+2*nnodes+2*nodei);%+dbar(5:6,1);
          dbar(7:8,1)=mode(4*nnodes*(mn-1)+2*nnodes+2*nodej-1:4*nnodes*(mn-1)+2*nnodes+2*nodej);%+dbar(7:8,1);
%           dbar(1:2,1)=mode(4*nnodes*(mn-1)+2*nodei-1:4*nnodes*(mn-1)+2*nodei);%+dbar(1:2,1);
%           dbar(3:4,1)=mode(4*nnodes*(mn-1)+2*nodej-1:4*nnodes*(mn-1)+2*nodej);%+dbar(3:4,1);
%           dbar(5:6,1)=mode(4*nnodes*(mn-1)+2*nnodes+2*nodei-1:4*nnodes*(mn-1)+2*nnodes+2*nodei);%+dbar(5:6,1);
%           dbar(7:8,1)=mode(4*nnodes*(mn-1)+2*nnodes+2*nodej-1:4*nnodes*(mn-1)+2*nnodes+2*nodej);%+dbar(7:8,1);
          %transform the dbar to local coordinates d
          phi=atan2(-(zj-zi),(xj-xi));
          d=gammait(phi,dbar);
          %Determine the additional displacements in each element
          links=5; %number of additional line segments to define the disp shape
          b=sqrt((xj-xi)^2+(zj-zi)^2);
          dl=shapef(links,d,b);
          %transform the additional displacements into global coordinates
          dlbar=gammait2(phi,dl);
          %Create a vector of undisplaced coordinates "undisp"
          undisp=zeros(2,links+1);
          undisp(:,1)=[xi zi]';
          undisp(:,links+1)=[xj zj]';
          for j=2:links
              undisp(:,j)=[xi+(xj-xi)*(j-1)/links zi+(zj-zi)*(j-1)/links]';
          end
          %Create a vector of displaced coordinates "disp"
          if strcmp(BC,'S-S')
              %stand for z "it" the scale change for 3 dimensional plot
              z_it1=sin(m_a(mn)*pi*(k-1)/(km-1)); 
              %stand for z "it" the scale change for 3 dimensional plot
              z_it2=sin(m_a(mn)*pi*(k)/(km-1)); 
          elseif strcmp(BC,'C-C')
              %stand for z "it" the scale change for 3 dimensional plot
              z_it1=sin(m_a(mn)*pi*(k-1)/(km-1))*sin(pi*(k-1)/(km-1)); 
              %stand for z "it" the scale change for 3 dimensional plot
              z_it2=sin(m_a(mn)*pi*(k)/(km-1))*sin(pi*(k)/(km-1)); 
          elseif strcmp(BC,'S-C')|strcmp(BC,'C-S')
              %stand for z "it" the scale change for 3 dimensional plot
              z_it1=sin((m_a(mn)+1)*pi*(k-1)/(km-1))+(m_a(mn)+1)*sin(pi*(k-1)/(km-1))/m_a(mn);
              z_it2=(sin((m_a(mn)+1)*pi*(k)/(km-1))+(m_a(mn)+1)*sin(pi*(k)/(km-1))/m_a(mn));
          elseif strcmp(BC,'F-C')|strcmp(BC,'C-F')
              z_it1=1-cos((m_a(mn)-1/2)*pi*(k-1)/(km-1));
              z_it2=1-cos((m_a(mn)-1/2)*pi*(k)/(km-1));
          elseif strcmp(BC,'G-C')|strcmp(BC,'C-G')
              z_it1=sin((m_a(mn)-1/2)*pi*(k-1)/(km-1))*sin(pi*(k-1)/(km-1)/2);
              z_it2=sin((m_a(mn)-1/2)*pi*(k)/(km-1))*sin(pi*(k)/(km-1)/2);
          end
          %
          disp1=zeros(2,links+1);
          if mn<totalm
              disp1(:,1)=[scale*dbar(1)*z_it1 scale*dbar(5)*z_it1]';
              disp1(:,links+1)=[scale*dbar(3)*z_it1 scale*dbar(7)*z_it1]';
              disp1(1,2:links)=scale*dlbar(1,:)*z_it1;
              disp1(2,2:links)=scale*dlbar(3,:)*z_it1;
          elseif mn==totalm
              disp1(:,1)=[xi+scale*dbar(1)*z_it1 zi+scale*dbar(5)*z_it1]';
              disp1(:,links+1)=[xj+scale*dbar(3)*z_it1 zj+scale*dbar(7)*z_it1]';
              disp1(1,2:links)=undisp(1,2:links)+scale*dlbar(1,:)*z_it1;
              disp1(2,2:links)=undisp(2,2:links)+scale*dlbar(3,:)*z_it1;
          end
          disp1m=disp1m+disp1;
          %
          disp2=zeros(2,links+1);
          if mn<totalm
              disp2(:,1)=[scale*dbar(1)*z_it2 scale*dbar(5)*z_it2]';
              disp2(:,links+1)=[scale*dbar(3)*z_it2 scale*dbar(7)*z_it2]';
              disp2(1,2:links)=scale*dlbar(1,:)*z_it2;
              disp2(2,2:links)=scale*dlbar(3,:)*z_it2;
          elseif mn==totalm
              disp2(:,1)=[xi+scale*dbar(1)*z_it2 zi+scale*dbar(5)*z_it2]';
              disp2(:,links+1)=[xj+scale*dbar(3)*z_it2 zj+scale*dbar(7)*z_it2]';
              disp2(1,2:links)=undisp(1,2:links)+scale*dlbar(1,:)*z_it2;
              disp2(2,2:links)=undisp(2,2:links)+scale*dlbar(3,:)*z_it2;
          end
          disp2m=disp2m+disp2;
      end%mn
      %
      %Wireframe Plot
      %--------------------------------------------------------------
      if ifpatch==0
          %Plot the undeformed geometry
          if undef==1
             plot3([xi xj],[(k-1)/(km-1)*L (k-1)/(km-1)*L],[zi zj],'k--','LineWidth',1,'erasemode','none')
             if k==1 & i==1
                 axis off, axis equal, axis([xmin xmax ymin ymax zmin zmax]), view(37.5,30)
             end
             hold on
             if k<km
                plot3([xi xi],[(k-1)/(km-1)*L (k)/(km-1)*L],[zi zi],'b','LineWidth',1,'erasemode','none')
                plot3([xj xj],[(k-1)/(km-1)*L (k)/(km-1)*L],[zj zj],'b','LineWidth',1,'erasemode','none')
             end
          end
          %Now the deformed geometry
          plot3(disp1m(1,:),ones(1,links+1)*(k-1)/(km-1)*L,disp1m(2,:),'k','LineWidth',1,'erasemode','none')
             if k==1 & i==1
                 axis off, axis equal, axis([xmin xmax ymin ymax zmin zmax]), view(37.5,30)
             end
          hold on
          if k<km
             for mm=[1,length(disp1m(1,:))]
                plot3([disp1m(1,mm),disp2m(1,mm)],[(k-1)/(km-1)*L (k)/(km-1)*L],[disp1m(2,mm),disp2m(2,mm)],'k','LineWidth',1,'erasemode','none')
             end
          end    
      end  
      
      %
      %Solid Plot (by patch)
      %-------------------------------------------------------------------
      if ifpatch==1
      % undeformed geometry
          if undef==1
              if k<km
                  for mm=1:1:length(disp1m(1,:))-1
                      patch('vertices',[xi (k-1)/(km-1)*L zi;xj (k-1)/(km-1)*L zj; xj (k)/(km-1)*L zj; xi (k)/(km-1)*L zi],'faces',[1 4 3 2],'FaceColor','w','EdgeColor','none');%,'erasemode','none');
                      if k==1 & i==1
                        axis off, axis equal, axis([xmin xmax ymin ymax zmin zmax]), view(37.5,30)
                      end
                      hold on
                  end
              end
          end
          %Now the deformed geometry
          plot3(disp1m(1,:),ones(1,links+1)*(k-1)/(km-1)*L,disp1m(2,:),'k','LineWidth',1);%,'erasemode','none')
          if k==1 & i==1
              axis off, axis equal, axis([xmin xmax ymin ymax zmin zmax]), view(37.5,30)
          end
          hold on
          if k<km
              for mm=[1,length(disp1m(1,:))]
                  plot3([disp1m(1,mm),disp2m(1,mm)],[(k-1)/(km-1)*L (k)/(km-1)*L],[disp1m(2,mm),disp2m(2,mm)],'k','LineWidth',1);%,'erasemode','none')
              end
          end
      % deformed geometry
          if k<km
              for mm=1:1:length(disp1m(1,:))-1
                  patch('vertices',[disp1m(1,mm) (k-1)/(km-1)*L disp1m(2,mm);disp1m(1,mm+1) (k-1)/(km-1)*L disp1m(2,mm+1); disp2m(1,mm+1) (k)/(km-1)*L disp2m(2,mm+1); disp2m(1,mm) (k)/(km-1)*L disp2m(2,mm)],'faces',[1 4 3 2],'FaceColor','w','EdgeColor','none');%,'erasemode','none');
                  if k==1 & i==1
                    axis off, axis equal, axis([xmin xmax ymin ymax zmin zmax]), view(37.5,30)
                  end
                  hold on
              end
          end
      %
      end
      
      axis off
         
   end
   
%    info=['Length ',num2str(k),' done.'];
   
   waitbar(k/km,wait_message);
end
if ishandle(wait_message)
    delete(wait_message);
end
axis equal
view(37.5,30)
hold off
%watchoff