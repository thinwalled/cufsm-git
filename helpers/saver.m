function [pathname,filename]=saver(prop,node,elem,lengths,curve,shapes,springs,constraints,GBTcon,clas,BC,m_all)
%BWS
%August 2000 (last modified)
%
[filename,pathname]=uiputfile('*.mat','Save as');
if filename==0
	return
else
    %if isempty(curve)|curve(1,1)==0|isempty(shapes)|shapes(1,1)==0
    if exist('curve')<1 & exist('shapes')<1
        save([pathname,filename],'prop','node','elem','lengths','springs','constraints','GBTcon','BC','m_all');
    else
        if exist('clas')<1
            save([pathname,filename],'prop','node','elem','lengths','springs','constraints','GBTcon','curve','shapes','BC','m_all');
        elseif exist('clas')==1
            save([pathname,filename],'prop','node','elem','lengths','springs','constraints','GBTcon','curve','shapes','clas','BC','m_all');
            
        end
    end
end

