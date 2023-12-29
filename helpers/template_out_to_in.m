function [h,b1,d1,q1,b2,d2,q2,r1,r2,r3,r4,t] = template_out_to_in(H,B1,D1,q1,B2,D2,q2,ri1,ri2,ri3,ri4,t)
%BWS 2015
%reference AISI Design Manual for the lovely corner radius calcs.
%For template calc, convert outer dimensons and inside radii to centerline
%dimensiosn throughout
%convert the inner radii to centerline if nonzero
if ri1==0, 
    r1=0
else
    r1=ri1+t/2;
end
if ri2==0, 
    r2=0
else
    r2=ri2+t/2;
end
if ri3==0, 
    r3=0
else
    r3=ri3+t/2;
end
if ri4==0, 
    r4=0
else
    r4=ri4+t/2;
end
h=H-t/2-r1-r3-t/2;
if D1==0
    b1=B1-r1-t/2;
    d1=0;
else
    b1=B1-r1-t/2-(r2+t/2)*tan(q1/2);
    d1=(D1-(r2+t/2)*tan(q1/2));
end
if D2==0
    b2=B2-r3-t/2;
    d2=0;
else
    b2=B2-r3-t/2-(r4+t/2)*tan(q2/2);
    d2=(D2-(r4+t/2)*tan(q2/2));
end
end

