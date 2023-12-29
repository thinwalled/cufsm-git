function []=classifycurvemode(curvecell,filenamecell,clascell,axesnum,logopt,xmin,xmax,ymin,ymax,fileindex,lengthindex)
%zli
%August 2010
%
axes(axesnum)
cla
%
%Classification breakdown plot

clas=clascell{fileindex};

if ~isempty(clas)
    curve=curvecell{fileindex};
    curve_length=[1:length(curve{lengthindex}(:,1))];
    clasplot=clas{lengthindex};
    if logopt
        set(gca,'XScale','log')
    else
        set(gca,'XScale','linear')
    end
    hold on
    hc=plot(curve_length,clasplot(:,1),'-',curve_length,clasplot(:,2),'--',curve_length,clasplot(:,3),'-.',curve_length,clasplot(:,4),':');
    set(hc,'LineWidth',2);
    legend(hc,'global','distortional','local','other')
    axis tight
    axis([xmin xmax 0 100])
    xlabel('mode number');
    ylabel('modal participation');
    colormap lines(4)%jet
end