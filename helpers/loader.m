function [pathname,filename,prop,node,elem,lengths,curve,shapes,springs,constraints,GBTcon,clas,BC,m_all]=loader();
%BWS
%August 2000 (last modified)
%December 2015 modified for conversion of old to new springs
%
%
[filename,pathname]=uigetfile('*.mat','Select File for use in CUFSM');
if filename==0
	return
else
	prop=[];
	node=[];
	elem=[];
	lengths=[];
	curve=[];
	shapes=[];
	springs=[];
	constraints=[];
    GBTcon.glob=[];
    GBTcon.dist=[];
    GBTcon.local=[];
    GBTcon.other=[];
    GBTcon.ospace=[];
    GBTcon.orth=[];
    GBTcon.couple=[];
    GBTcon.norm=[];
    clas=[];
    
    %to be compatible with older version
    GBTcon.basis=[];

	load([pathname,filename]);
    
    if ~isempty(springs)
        if length(springs(1,:))<10&&springs(1,1)~=0 %then this is the old springs and needs to be written to the new structure
            uiwait(msgbox('Springs from version 4.2 or earlier detected, will be converted.'));
            oldsprings=springs;
            springs=[];
            for i=1:length(oldsprings(:,1))
                springnum=i;
                nodei=oldsprings(i,1);
                nodej=0;
                dof=oldsprings(i,2);
                kspring=oldsprings(i,3);
                kflag=oldsprings(i,4);
                if kflag==0
                    uiwait(msgbox('Spring detected with k_{flag}=0, i.e. total stiffness spring, all foundation springs are now per unit length, manual conversion of spring stiffness may be needed to achieve intended results.'));
                end
                ku=(dof==1)*kspring;
                kv=(dof==2)*kspring;
                kw=(dof==3)*kspring;
                kq=(dof==4)*kspring;
                local=0;
                discrete=0;
                yonL=0;
                springs(i,:)=[springnum nodei nodej ku kv kw kq local discrete yonL];
            end
        end
    end
        
    
    if exist('m_all')<1
        for i=1:length(lengths)
            m_all{i}=[1];
        end
    end
    if exist('BC')<1
        BC='S-S';
    end
    if exist('curve')==1
        if ~iscell(curve)&~isempty(curve)
            tempcurve=curve;
            curve=[];
            for i=1:length(tempcurve(:,1))
                curve{i}(:,1)=tempcurve(i,1,:);
                curve{i}(:,2)=tempcurve(i,2,:);
            end
        end
    end
    if exist('shapes')==1
        if ~iscell(shapes)&~isempty(shapes)
            tempshapes=shapes;
            shapes=[];
            for i=1:length(tempshapes(1,:,1))
                shapes{i}(:,:)=tempshapes(:,i,:);
            end
        end
    end
    
    if exist('clas')==1
        if ~iscell(clas)&~isempty(clas)
            tempclas=clas;
            clas=[];
            for i=1:length(tempclas(1,:,1))
                clas{i}(:,1)=tempclas(i,1,:);
                clas{i}(:,2)=tempclas(i,2,:);
                clas{i}(:,3)=tempclas(i,3,:);
                clas{i}(:,4)=tempclas(i,4,:);
            end
        end
    end
    
    if exist('GBTcon.basis')==1
        if GBTcon.basis==1
            GBTcon.ospace=1;
            GBTcon.orth=1;
            GBTcon.couple=1;
        elseif GBTcon.basis==2
            GBTcon.ospace=1;
            GBTcon.orth=2;
            GBTcon.couple=1;
        else
            GBTcon.ospace=2;
            GBTcon.orth=2;
            GBTcon.couple=1;
        end
    end
    
    if exist('GBTcon.glob')<1
        GBTcon.glob=0;
    end
    if exist('GBTcon.dist')<1
        GBTcon.dist=0;
    end
    if exist('GBTcon.local')<1
        GBTcon.local=0;
    end
    if exist('GBTcon.other')<1
        GBTcon.other=0;
    end
    
    if exist('GBTcon.ospace')<1
        GBTcon.ospace=1;
    end
    if exist('GBTcon.orth')<1
        GBTcon.orth=2;
    end
    if exist('GBTcon.couple')<1
        GBTcon.couple=1;
    end
    
    if exist('GBTcon.norm')<1
        GBTcon.norm=1;
    end
end

