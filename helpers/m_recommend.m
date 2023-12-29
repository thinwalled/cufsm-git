function [m_a_recommend]=m_recommend(prop,node,elem,a);

% Z. Li, Oct. 2010
%Suggested longitudinal terms are calculated based on the characteristic
%half-wave lengths of local, distortional, and global buckling from the
%signature curve.

%the inputs for signature curve
iGBTcon.ospace=1;iGBTcon.couple=1;iGBTcon.orth=1;
iGBTcon.local=0;
iGBTcon.dist=0;
iGBTcon.glob=0;
iGBTcon.other=0;
[icurve,ishapes]=signature_ss(prop,node,elem,iGBTcon);

for j=1:max(size(icurve));
    curve_sign(j,1)=icurve{j}(1,1);
    curve_sign(j,2)=icurve{j}(1,2);
end
xmin=min(curve_sign(:,1));
ymin=0;
xmax=max(curve_sign(:,1));
ymax=min([max(curve_sign(:,2)),3*median(curve_sign(:,2))]);
cr=0;
for xx=1:length(curve_sign(:,1))-2
    load1=curve_sign(xx,2);
    load2=curve_sign(xx+1,2);
    load3=curve_sign(xx+2,2);
    if (load2<load1)&(load2<=load3)
        cr=cr+1;
        lam_cr(cr)=load2;
        wl(cr)=curve_sign(xx+1,1);ncr(cr)=xx+1;
    end
end

if length(wl)==2
    Lcrl=wl(1);  Lcrd=wl(2);
else
    iGBTcon.ospace=1;iGBTcon.couple=1;iGBTcon.orth=1;
    [elprop,m_node,m_elem,node_prop,nmno,ncno,nsno,ndm,nlm,DOFperm]=base_properties(node,elem);
    ngm=4;
    nom=2*(length(node(:,1))-1);
    iGBTcon.local=ones(1,nlm);
    iGBTcon.dist=zeros(1,ndm);
    iGBTcon.glob=zeros(1,ngm);
    iGBTcon.other=zeros(1,nom);
    [icurve_local,ishapes_local]=signature_ss(prop,node,elem,iGBTcon);
    %
    iGBTcon.local=zeros(1,nlm);
    iGBTcon.dist=ones(1,ndm);
    iGBTcon.glob=zeros(1,ngm);
    iGBTcon.other=zeros(1,nom);
    [icurve_dist,ishapes_dist]=signature_ss(prop,node,elem,iGBTcon);
    cr=0;
    
    for j=1:max(size(icurve_local));
        curve_sign_l(j,1)=icurve_local{j}(1,1);
        curve_sign_l(j,2)=icurve_local{j}(1,2);
        curve_sign_d(j,1)=icurve_dist{j}(1,1);
        curve_sign_d(j,2)=icurve_dist{j}(1,2);
    end
    %cFSM local half-wavelength
    for xx=1:length(curve_sign_l(:,1))-2
        load1=curve_sign_l(xx,2);
        load2=curve_sign_l(xx+1,2);
        load3=curve_sign_l(xx+2,2);
        if (load2<load1)&(load2<=load3)
            cr=cr+1;
            lam_cr(cr)=load2;
            wl_local(cr)=curve_sign_l(xx+1,1);ncr(cr)=xx+1;
        end
    end
    %cFSM dist half-wavelength
    for xx=1:length(curve_sign_d(:,1))-2
        load1=curve_sign_d(xx,2);
        load2=curve_sign_d(xx+1,2);
        load3=curve_sign_d(xx+2,2);
        if (load2<load1)&(load2<=load3)
            cr=cr+1;
            lam_cr(cr)=load2;
            wl_dist(cr)=curve_sign_d(xx+1,1);ncr(cr)=xx+1;
        end
    end
    %half-wavelength of local and distortional buckling
    Lcrl=wl_local(1);  Lcrd=wl_dist(1);
end

%recommend longitudinal terms m
imPlengths=a;
for i=1:length(imPlengths)
    imPm_all{i}=[];
    if ceil(imPlengths(i)/Lcrl)>4
        imPm_all{i}=[ceil(imPlengths(i)/Lcrl)-3 ceil(imPlengths(i)/Lcrl)-2 ceil(imPlengths(i)/Lcrl)-1 ceil(imPlengths(i)/Lcrl) ...
            ceil(imPlengths(i)/Lcrl)+1 ceil(imPlengths(i)/Lcrl)+2 ceil(imPlengths(i)/Lcrl)+3];
    else
        imPm_all{i}=[1 2 3 4 5 6 7];
    end
    
    if ceil(imPlengths(i)/Lcrd)>4
        imPm_all{i}=[imPm_all{i} ceil(imPlengths(i)/Lcrd)-3 ceil(imPlengths(i)/Lcrd)-2 ceil(imPlengths(i)/Lcrd)-1 ceil(imPlengths(i)/Lcrd) ...
            ceil(imPlengths(i)/Lcrd)+1 ceil(imPlengths(i)/Lcrd)+2 ceil(imPlengths(i)/Lcrl)+3];
    else
        imPm_all{i}=[imPm_all{i} 1 2 3 4 5 6 7];
    end
    imPm_all{i}=[imPm_all{i} 1 2 3];
end
[m_a_recommend]=msort(imPm_all);