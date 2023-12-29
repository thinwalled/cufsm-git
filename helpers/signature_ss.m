function [icurve,ishapes]=signature_ss(prop,node,elem,iGBTcon)
%
%Z. Li, July 2010 (last modified)
%generate the signature curve solution
%
Mm=1000000;%Minimum element length
Mw=0;%Maximum element length
for i=1:length(elem(:,1))
    hh1=abs(sqrt((node(elem(i,2),2)-node(elem(i,3),2))^2+(node(elem(i,2),3)-node(elem(i,3),3))^2));
    if hh1<Mm
        Mm=hh1;
    end
    if hh1>Mw
        Mw=hh1;
    end
end
hlengths=logspace(log10(Mm),log10(1000*Mw),100);
%
isprings=0;
iconstraints=0;
iBC='S-S';
for i=1:length(hlengths)
    im_all{i}=[1];
end
[icurve,ishapes]=strip(prop,node,elem,hlengths,isprings,iconstraints,iGBTcon,iBC,im_all,10);

