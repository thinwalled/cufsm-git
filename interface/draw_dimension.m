function draw_dimension(ax, p1, p2, offset, label)
%DRAW_DIMENSION Draws a clean outward-facing engineering dimension.
% offset is a "requested" offset (often 2*tLocal). This function will clamp
% it to a reasonable range based on the current axis/model scale.

p1 = p1(:)';  p2 = p2(:)';

v = p2 - p1;
L = norm(v);
if L < 1e-12
    return;
end
vhat = v / L;

% --- Determine outward normal using plot centroid (axis center) ---
n1 = [-vhat(2),  vhat(1)];
n2 = [ vhat(2), -vhat(1)];

xl = xlim(ax);  yl = ylim(ax);
cx = mean(xl);
cz = mean(yl);

pmid = 0.5*(p1 + p2);
if dot(n1, pmid - [cx cz]) > dot(n2, pmid - [cx cz])
    n = n1;
else
    n = n2;
end
n = n / norm(n);

% ============================================================
% Scale-aware sizing (fixes mm/in and thin/thick extremes)
% ============================================================
dx = xl(2) - xl(1);
dy = yl(2) - yl(1);
diagAx = hypot(dx, dy);             % overall plotted model scale

% Arrowhead size: constant relative to model size (same for all dimensions)
% Tune these fractions to taste.
ah = 0.015 * diagAx;                % ~1.5% of model diagonal
ah = max(ah, 0.004 * diagAx);       % floor (redundant but explicit)
ah = min(ah, 0.030 * diagAx);       % cap

% Offset clamp: requested offset comes in (often 2*t).
% Impose min/max based on model size so thin plates don't hug the section
% and thick plates don't push dimensions way out.
minOff = 0.020 * diagAx;            % minimum dimension standoff
maxOff = 0.080 * diagAx;            % maximum dimension standoff
offset1 = clamp(offset, minOff, maxOff);
offset2 = 1.50 * offset1;

% --- Offset points ---
p1o = p1 + offset1 * n;
p2o = p2 + offset1 * n;

% --- Dimension line ---
plot(ax, [p1o(1) p2o(1)], [p1o(2) p2o(2)], 'k-', 'LineWidth', 1);

% --- Arrowheads (uniform size) ---
draw_arrowhead(ax, p1o, -vhat, n, ah);
draw_arrowhead(ax, p2o, +vhat, n, ah);

% --- Text label (further outward & rotated with strip direction) ---
pm_text = 0.5*(p1 + p2) + offset2 * n;

theta_deg = atan2(vhat(2), vhat(1)) * 180/pi;

% Optional: keep text from being upside-down
if theta_deg > 90
    theta_deg = theta_deg - 180;
elseif theta_deg < -90
    theta_deg = theta_deg + 180;
end

text(ax, pm_text(1), pm_text(2), label, ...
     'HorizontalAlignment','center', ...
     'VerticalAlignment','middle', ...
     'FontSize',10, ...
     'BackgroundColor','none', ...
     'Rotation', theta_deg);

end

function draw_arrowhead(ax, p, vhat, n, ah)
%DRAW_ARROWHEAD Draws CAD-style arrowhead at point p.
% vhat : direction the arrowhead should point TOWARD.
% n    : normal vector for the flare direction.
% ah   : arrowhead size.

ang = 20 * pi/180;

% two arrow legs (flare about -vhat)
d1 = cos(ang)*(-vhat) + sin(ang)*n;
d2 = cos(ang)*(-vhat) - sin(ang)*n;

d1 = d1 / norm(d1);
d2 = d2 / norm(d2);

pA = p + ah * d1;
pB = p + ah * d2;

plot(ax,[p(1) pA(1)], [p(2) pA(2)], 'k-', 'LineWidth', 1);
plot(ax,[p(1) pB(1)], [p(2) pB(2)], 'k-', 'LineWidth', 1);
end

function y = clamp(x, lo, hi)
y = min(max(x, lo), hi);
end

% function draw_dimension(ax, p1, p2, offset, label)
% %DRAW_DIMENSION Draws a clean outward-facing engineering dimension.
% 
% p1 = p1(:)';
% p2 = p2(:)';
% 
% v = p2 - p1;
% L = norm(v);
% if L < 1e-9
%     return;
% end
% vhat = v / L;
% 
% % --- Determine outward normal using centroid ---
% n1 = [-vhat(2),  vhat(1)];
% n2 = [ vhat(2), -vhat(1)];
% 
% cx = mean(xlim(ax));
% cz = mean(ylim(ax));
% pmid = 0.5*(p1 + p2);
% 
% if dot(n1, pmid - [cx cz]) > dot(n2, pmid - [cx cz])
%     n = n1;
% else
%     n = n2;
% end
% n = n / norm(n);
% 
% % --- Offsets ---
% offset1 = offset*1;
% offset2 = offset*2.5;
% 
% p1o = p1 + offset1 * n;
% p2o = p2 + offset1 * n;
% 
% % --- Dimension line ---
% plot(ax, [p1o(1) p2o(1)], [p1o(2) p2o(2)], 'k-', 'LineWidth', 1);
% 
% % --- Arrowheads ---
% ah = 0.15;  % fixed size
% draw_arrowhead(ax, p1o, -vhat, n, ah);   % left → right
% draw_arrowhead(ax, p2o, +vhat, n, ah);   % right → left
% 
% % --- Text label (further outward & rotated with the strip) ---
% pm_text = 0.5*(p1 + p2) + offset2 * n;
% 
% % angle of the strip (dimension line direction)
% theta = atan2( vhat(2), vhat(1) );        % radians
% theta_deg = theta * 180/pi;               % convert for MATLAB text
% 
% text(ax, pm_text(1), pm_text(2), label, ...
%      'HorizontalAlignment','center',...
%      'VerticalAlignment','middle',...
%      'FontSize',10, ...
%      'BackgroundColor','none', ...
%      'Rotation', theta_deg);
% 
% end
% 
% function draw_arrowhead(ax, p, vhat, n, ah)
% %DRAW_ARROWHEAD Draws CAD-style arrowhead at point p.
% %   vhat : direction the arrowhead should point TOWARD.
% %   n    : normal vector for the flare direction.
% %   ah   : arrowhead size.
% 
% % flare angle = 20 degrees
% ang = 20 * pi/180;
% 
% % two arrow legs
% d1 = cos(ang)*(-vhat) + sin(ang)*n;
% d2 = cos(ang)*(-vhat) - sin(ang)*n;
% 
% d1 = d1 / norm(d1);
% d2 = d2 / norm(d2);
% 
% p1 = p + ah * d1;
% p2 = p + ah * d2;
% 
% plot(ax,[p(1) p1(1)], [p(2) p1(2)], 'k-', 'LineWidth', 1);
% plot(ax,[p(1) p2(1)], [p(2) p2(2)], 'k-', 'LineWidth', 1);
% end