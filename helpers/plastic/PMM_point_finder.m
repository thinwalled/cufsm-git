function [BP]=PMM_point_finder(az,el,r,azi,eli)

%%% March 2013
%%% Shahabeddin Torabian

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
azi=azi/180*pi;
eli=eli/180*pi;


% [m,n]=size(Pn);
% 
% Inter1=[reshape(Mxn,m*n,1) reshape(Mzn,m*n,1) reshape(Pn,m*n,1)];
% Inter=unique(Inter1, 'rows');
% 
% [az,el,r] = cart2sph(Inter(:,1),Inter(:,2),Inter(:,3));

% ri = griddata(az,el,r,azi,eli,'cubic');
F = TriScatteredInterp(az,el,r);
ri = F(azi,eli);

if isnan(ri)
ri = griddata(az,el,r,azi,eli,'nearest');
end

% if azi==pi
% ri = griddata(az,el,r,azi,eli,'nearest');
% end

BP=ri;

end




