function cutwp_draw(coord,ends,exy,xc,yc,theta,xs,ys,dcoord,origin,centroid,axisxy,axis12,shear,axial,deform,node,mode);
%  Draw the cross section 
%----------------------------------------------------------------------------
%
nele = size(ends,1); 
hold on

for j = 1:nele 
    sn = ends(j,1); fn = ends(j,2);
    u = coord(fn,1)-coord(sn,1);
    v = coord(fn,2)-coord(sn,2);
    phi = angle(u+v*1i);
    xsn1 = coord(sn,1)+ends(j,3)*sin(phi)/2;
    xfn1 = coord(fn,1)+ends(j,3)*sin(phi)/2;
    ysn1 = coord(sn,2)-ends(j,3)*cos(phi)/2;
    yfn1 = coord(fn,2)-ends(j,3)*cos(phi)/2;
    xsn2 = coord(sn,1)-ends(j,3)*sin(phi)/2;
    xfn2 = coord(fn,1)-ends(j,3)*sin(phi)/2;
    ysn2 = coord(sn,2)+ends(j,3)*cos(phi)/2;
    yfn2 = coord(fn,2)+ends(j,3)*cos(phi)/2;
    
    vert = [xsn1 ysn1; xsn2 ysn2; xfn2 yfn2; xfn1 yfn1];
    patch('Faces',[1 2 3 4],'Vertices',vert,'FaceVertexCdata',[0 0 0.5],'FaceColor','flat','EdgeColor',[0 0 1])
    
end

k = ends(:,1:2); k = k(:);
minx = min(coord(k,1)); maxx = max(coord(k,1));
miny = min(coord(k,2)); maxy = max(coord(k,2));
maxxy = max(maxx-minx,maxy-miny)/2;
x1 = xc-1.1*maxxy; x2 = xc+1.1*maxxy;
y1 = yc-1.1*maxxy; y2 = yc+1.1*maxxy;

if deform
    for j = 1:nele 
        sn = ends(j,1); fn = ends(j,2);
        u = dcoord(fn,1,mode)-dcoord(sn,1,mode);
        v = dcoord(fn,2,mode)-dcoord(sn,2,mode);
        phi = angle(u+v*1i);
        xsn1 = dcoord(sn,1,mode)+ends(j,3)*sin(phi)/2;
        xfn1 = dcoord(fn,1,mode)+ends(j,3)*sin(phi)/2;
        ysn1 = dcoord(sn,2,mode)-ends(j,3)*cos(phi)/2;
        yfn1 = dcoord(fn,2,mode)-ends(j,3)*cos(phi)/2;
        xsn2 = dcoord(sn,1,mode)-ends(j,3)*sin(phi)/2;
        xfn2 = dcoord(fn,1,mode)-ends(j,3)*sin(phi)/2;
        ysn2 = dcoord(sn,2,mode)+ends(j,3)*cos(phi)/2;
        yfn2 = dcoord(fn,2,mode)+ends(j,3)*cos(phi)/2;
        
        vert = [xsn1 ysn1; xsn2 ysn2; xfn2 yfn2; xfn1 yfn1];
        patch('Faces',[1 2 3 4],'Vertices',vert,'FaceVertexCdata',[0.5 0.5 0],'FaceColor','flat','EdgeColor',[1 1 0])
        
    end
    minx = min([dcoord(k,1,mode); minx]); maxx = max([dcoord(k,1,mode); maxx]);
    miny = min([dcoord(k,2,mode); miny]); maxy = max([dcoord(k,2,mode); maxy]);
end

if axisxy
    plot([x1; x2],[yc; yc],'color','g','linestyle','-.')
    text(x2,yc,'  X','color','g')
    plot([xc; xc],[y1; y2],'color','g','linestyle','-.')
    text(xc,y2,'  Y','color','g')
    minx = min([minx x1 x2]); maxx = max([maxx x1 x2]);
    miny = min([miny y1 y2]); maxy = max([maxy y1 y2]);
end

if axis12
    
    pxy = [x1-xc x2-xc 0 0; 0 0 y1-yc y2-yc];
    pxy = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)]*pxy; 
    pxy(1,:) = pxy(1,:)+xc; pxy(2,:) = pxy(2,:)+yc;
    px1 = pxy(1,1); py1 = pxy(2,1);
    px2 = pxy(1,2); py2 = pxy(2,2);
    px3 = pxy(1,3); py3 = pxy(2,3);
    px4 = pxy(1,4); py4 = pxy(2,4);
    
    plot([px1; px2] ,[py1; py2],'color','r','linestyle','-.')
    text(px2,py2,'  1','color','r')
    plot([px3; px4],[py3; py4],'color','r','linestyle','-.')
    text(px4,py4,'  2','color','r')
    minx = min([minx px1 px2 px3 px4]); maxx = max([maxx px1 px2 px3 px4]);
    miny = min([miny py1 py2 py3 py4]); maxy = max([maxy py1 py2 py3 py4]);
end

if origin
    plot(0,0,'.w')
    text(0,0,'  O','color','w')
    minx = min(minx,0); maxx = max(maxx,0);
    miny = min(miny,0); maxy = max(maxy,0);
end

if centroid
    plot(xc,yc,'.w')
    text(xc,yc,'  C','color','w')
    minx = min(minx,xc); maxx = max(maxx,xc);
    miny = min(miny,yc); maxy = max(maxy,yc);
end

if shear
    plot(xs,ys,'.w')
    text(xs,ys,'  S','color','w')
    minx = min(minx,xs); maxx = max(maxx,xs);
    miny = min(miny,ys); maxy = max(maxy,ys);
end

if axial
    plot(exy(1)+xc,exy(2)+yc,'.w')
    text(exy(1)+xc,exy(2)+yc,'  Pe','color','w')
    minx = min(minx,exy(1)); maxx = max(maxx,exy(1));
    miny = min(miny,exy(2)); maxy = max(maxy,exy(2));
end

if node
    for i = 1:nele
        sn = ends(i,1); fn = ends(i,2);
        xm = mean(coord([sn fn],1));
        ym = mean(coord([sn fn],2));
        text(coord(sn,1),coord(sn,2),['  ',num2str(sn)],'color','w')
        plot(coord(sn,1),coord(sn,2),'.w')
        text(coord(fn,1),coord(fn,2),['  ',num2str(fn)],'color','w')
        plot(coord(fn,1),coord(fn,2),'.w')
        text(xm,ym,num2str(i),'color','m')
    end
end  

hold off

meanx = mean([maxx minx]); meany = mean([maxy miny]);
maxxy = max(maxx-minx,maxy-miny)/2;

% set color and the axis of the figure
set(gca,'color','k','TickLength',[0 0],'xtick',[],'ytick',[],...
    'XLim',[meanx-1.4*maxxy meanx+1.4*maxxy],...
    'YLim',[meany-1.4*maxxy meany+1.4*maxxy],...
    'DataAspectRatio',[1 1 1],'PlotBoxAspectratio',[1 1 1]);
