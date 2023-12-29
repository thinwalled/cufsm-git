function cutwp_print(file,coord,ends,KL1,KL2,KL3,exy,E,v,c);

fname = [file '.twp'];
fid = fopen(fname,'w');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'CU-TWP VERSION 2003                          DATE ');
fprintf(fid,datestr(now,1));
fprintf(fid,'   TIME ');
fprintf(fid,datestr(now,16));
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'                              I N P U T   D A T A\n');

p = [1:size(coord,1)]';
p = [p coord];
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'- NODE DATA\n');
fprintf(fid,'\n');
fprintf(fid,'      NODE         X-COORD        Y-COORD\n');
%RULER      :-----12345------1234567890123--1234567890123--1234567890123
fprintf(fid,'\n');
fprintf(fid,'     %5i      % -13.6G  % -13.6G\n',p');
fprintf(fid,'\n');
fprintf(fid,'\n');

p = [1:size(ends,1)]';
p = [p ends];
fprintf(fid,'- ELEMENT DATA\n');
fprintf(fid,'\n');
fprintf(fid,'    ELEMENT   NODES FORMING ELEMENT     THICKNESS\n');
fprintf(fid,'                NODE-I     NODE-J\n');
%RULER      :-----12345------12345------12345------1234567890123
fprintf(fid,'\n');
fprintf(fid,'     %5i      %5i      %5i      % -13.6G\n',p');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'- MATERIAL PROPERTIES\n');
fprintf(fid,'\n');
fprintf(fid,'     Elastic Modulus, E:  %-13.6G\n',E);
fprintf(fid,'     Poisson''s ratio, v:  %-13.6G\n',v);
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'- EFFECTIVE UNBRACED LENGTH\n');
fprintf(fid,'\n');
fprintf(fid,'     Bending about the 1-axis, KL1:   %-13.6G\n',KL1);   
fprintf(fid,'     Bending about the 2-axis, KL2:   %-13.6G\n',KL2);   
fprintf(fid,'     Twisting about the 3-axis, KL3:  %-13.6G\n',KL3);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'- LOAD CONDITIONS\n');
fprintf(fid,'\n');
fprintf(fid,'     CASE 1:  Axial Force, Pe\n');
fprintf(fid,'              Eccentricity about the x-axis:    % -13.6G\n',exy(1));
fprintf(fid,'              Eccentricity about the y-axis:    % -13.6G\n',exy(2));
fprintf(fid,'\n');
fprintf(fid,'     CASE 2:  Bending moment about the 1-axis, Me1\n');
fprintf(fid,'\n');
fprintf(fid,'     CASE 3:  Bending moment about the 2-axis, Me2\n');
fprintf(fid,'\n');
fprintf(fid,'     CASE 4:  Biaxial Bending moment, Me1/Me2:  % -13.6G\n',c);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'                              O U T P U T   D A T A\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

force = 'Pe'; dist = 1;
[A,xc,yc,Ix,Iy,Ixy,theta,I1,I2,J,xs,ys,Cw,B1,B2,Pe,dcoord] = cutwp_prop(coord,ends,KL1,KL2,KL3,force,exy,E,v,dist);

fprintf(fid,'- SECTION PROPERTIES\n');
fprintf(fid,'\n');
fprintf(fid,'     Area:                                  % -13.6G\n',A);
fprintf(fid,'     Moment of Inertia, Ix:                 % -13.6G\n',Ix);
fprintf(fid,'     Moment of Inertia, Iy:                 % -13.6G\n',Iy);
fprintf(fid,'     Product of Inertia, Ixy:               % -13.6G\n',Ixy);
fprintf(fid,'     Moment of Inertia, I1:                 % -13.6G\n',I1);
fprintf(fid,'     Moment of Inertia, I2:                 % -13.6G\n',I2);
fprintf(fid,'     Angle for Principal Direction, theta:  % -13.6G\n',theta);

if isnan(Cw)
    
    fprintf(fid,'     Torsion Constant-Closed Section, J:    % -13.6G\n',J);
    fprintf(fid,'     Centroid Coordinates, (x,y):           ( %13.6G, %13.6G )\n',xc,yc);
    
else
    
    fprintf(fid,'     Torsion Constant-Open Section, J:      % -13.6G\n',J);
    fprintf(fid,'     Centroid Coordinates, (x,y):           ( %13.6G, %13.6G )\n',xc,yc);
    fprintf(fid,'     Shear Center Coordinates, (x,y):       ( %13.6G, %13.6G )\n',xs,ys);
    fprintf(fid,'     Warping Constant, Cw:                  % -13.6G\n',Cw);
    fprintf(fid,'     B1:                                    % -13.6G\n',B1);
    fprintf(fid,'     B2:                                    % -13.6G\n',B2);
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'- ELASTIC CRITICAL BUCKLING LOAD\n');
    fprintf(fid,'\n');
    fprintf(fid,'     CASE 1:\n');
    fprintf(fid,'\n');
    fprintf(fid,'           MODE           Pe\n');
    %RULER      :----------12345------1234567890123
    fprintf(fid,'\n');
    fprintf(fid,'          %5i      % -13.6G\n',1,Pe(1));
    fprintf(fid,'          %5i      % -13.6G\n',2,Pe(2));
    fprintf(fid,'          %5i      % -13.6G\n',3,Pe(3));
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    
    force = 'Me1'; 
    [A,xc,yc,Ix,Iy,Ixy,theta,I1,I2,J,xs,ys,Cw,B1,B2,Pe,dcoord] = cutwp_prop(coord,ends,KL1,KL2,KL3,force,exy,E,v,dist);
    
    fprintf(fid,'     CASE 2:\n');
    fprintf(fid,'\n');
    fprintf(fid,'           MODE           Me1\n');
    %RULER      :----------12345------1234567890123
    fprintf(fid,'\n');
    fprintf(fid,'          %5i      % -13.6G\n',1,Pe(1));
    fprintf(fid,'          %5i      % -13.6G\n',2,Pe(2));
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    
    force = 'Me2'; 
    [A,xc,yc,Ix,Iy,Ixy,theta,I1,I2,J,xs,ys,Cw,B1,B2,Pe,dcoord] = cutwp_prop(coord,ends,KL1,KL2,KL3,force,exy,E,v,dist);
    
    fprintf(fid,'     CASE 3:\n');
    fprintf(fid,'\n');
    fprintf(fid,'           MODE           Me2\n');
    %RULER      :----------12345------1234567890123
    fprintf(fid,'\n');
    fprintf(fid,'          %5i      % -13.6G\n',1,Pe(1));
    fprintf(fid,'          %5i      % -13.6G\n',2,Pe(2));
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    
    force = 'Me12'; exy = c;
    [A,xc,yc,Ix,Iy,Ixy,theta,I1,I2,J,xs,ys,Cw,B1,B2,Pe,dcoord] = cutwp_prop(coord,ends,KL1,KL2,KL3,force,exy,E,v,dist);
    
    fprintf(fid,'     CASE 4:\n');
    fprintf(fid,'\n');
    fprintf(fid,'           MODE           Me1            Me2\n');
    %RULER      :----------12345------1234567890123--1234567890123
    fprintf(fid,'\n');
    fprintf(fid,'          %5i      % -13.6G  % -13.6G\n',1,c*Pe(1),Pe(1));
    fprintf(fid,'          %5i      % -13.6G  % -13.6G\n',2,c*Pe(2),Pe(2));
    
end

fclose(fid); 
