function [B_p, Z_w] = plasticB(F_y, node, elem, tol, max_num_iter)
%
%   [B_p, Z_w] = plasticB(F_y, node, elem)
%   [B_p, Z_w] = plasticB(F_y, node, elem, tol, max_num_iter)
%
%   Inputs:
%       F_y          - yield stress
%       node         - CUFSM node matrix, [node# x z ...]
%       elem         - CUFSM elem matrix, [elem# nodei nodej t ...]
%       tol          - relative error tolerance on Z_w (optional, default 1E-6)
%       max_num_iter - maximum number of iterations (optional, default 1000)
%
%   Outputs:
%       B_p  - plastic bimoment, B_p = F_y * Z_w
%       Z_w  - plastic warping modulus
%
%   Theory:
%       At full plastification the stress is F_y * sign(w), where w is the
%       sectorial coordinate about a pole (x_0, z_0), shifted by w_0. Over
%       p = (x_0, z_0, w_0), w is affine, so
%
%           F(p) = int(|w(s; p)|) dA
%
%       is convex. Its gradient is made of the stress resultants of the
%       trial stress state, so its minimum is the stress state with no axial force
%       and no bending moment (P = M_xx = M_zz = 0). The minimizer is the
%       plastic shear center, and Z_w = min F, B_p = F_y * Z_w. Every trial
%       gives F(p) >= Z_w.
%
%   Method:
%       Ellipsoid method (Bland, Goldfarb and Todd 1981). It starts at
%       the elastic shear center with w_0 at the mean of w, from an
%       ellipsoid that is guaranteed to contain the minimizer, and stops
%       when the error bound is below tol * Z_w. F and its
%       gradient are integrated exactly along each element, splitting it
%       where w changes sign.
%
%   Reference for the plastic bimoment: Glauz (2023), CFSRC R-2023-05.
% 
%   Author:
%      Damir Akchurin, Oct. 21, 2026
% 

if nargin < 4 || isempty(tol)
    tol = 1E-6;
end
if nargin < 5 || isempty(max_num_iter)
    max_num_iter = 1000;
end

%% Geometry:
x  = node(:, 2);
z  = node(:, 3);
ni = elem(:, 2);
nj = elem(:, 3);
t  = elem(:, 4);
num_nodes = size(node, 1);
num_elems = size(elem, 1);

%% Walk the elements outward from a free end of the section:
deg  = accumarray([ni; nj], 1, [num_nodes 1]);
root = find(deg == 1, 1);
if isempty(root)
    error("Open sections only, no free end found.");
end

reached = false(num_nodes, 1);
used    = false(num_elems, 1);
reached(root) = true;
queue = root;
steps = zeros(num_elems, 3); % [element, node a, node b]
num_steps = 0;
while ~isempty(queue)
    a = queue(1);
    queue(1) = [];
    for k = find(~used & (ni == a | nj == a))'
        b = ni(k) + nj(k) - a;
        if reached(b)
            error("Open sections only, closed cell found.");
        end
        used(k)    = true;
        reached(b) = true;
        queue(end + 1) = b;
        num_steps = num_steps + 1;
        steps(num_steps, :) = [k, a, b];
    end
end
if num_steps < num_elems
    error("The section must be one connected part.");
end

% Element geometry, in the direction of the walk (a to b):
k  = steps(:, 1);
a  = steps(:, 2);
b  = steps(:, 3);
dx = x(b) - x(a);
dz = z(b) - z(a);
L  = sqrt(dx .^ 2 + dz .^ 2);       % element length
s  = zeros(size(L));                % direction sine
c  = zeros(size(L));                % direction cosine
s(L > 0) = dz(L > 0) ./ L(L > 0);
c(L > 0) = dx(L > 0) ./ L(L > 0);
A_i = L .* t(k);                    % element area

%% Section properties:
x_m  = x(a) + dx / 2;
z_m  = z(a) + dz / 2;
A    = sum(A_i);
x_c  = sum(A_i .* x_m) / A;
z_c  = sum(A_i .* z_m) / A;
I_xx = sum(A_i .* z_m .^ 2   + A_i .* L .^ 2 .* s .^ 2 / 12) - A * z_c ^ 2;
I_zz = sum(A_i .* x_m .^ 2   + A_i .* L .^ 2 .* c .^ 2 / 12) - A * x_c ^ 2;
I_xz = sum(A_i .* x_m .* z_m + A_i .* L .^ 2 .* s .* c / 12) - A * x_c * z_c;

% All elements on one line (e.g., flat plate):
if abs(I_xx * I_zz - I_xz ^ 2) <= 1E-12 * (I_xx + I_zz) ^ 2
    B_p = 0;
    Z_w = 0;
    return
end

%% Elastic shear center (starting pole):
w_c = sectorial(x_c, z_c, 0, x, z, a, b, s, c, L, root);
x_a = x(a) - x_c;
z_a = z(a) - z_c;
d_c = x_a .* s - z_a .* c;
I_wz = sum(A_i .* w_c(a) .* z_a ...
    + A_i .* (w_c(a) .* s + d_c .* z_a) .* L / 2 ...
    + A_i .* d_c .* s .* L .^ 2 / 3);
I_wx = sum(A_i .* w_c(a) .* x_a ...
    + A_i .* (w_c(a) .* c + d_c .* x_a) .* L / 2 ...
    + A_i .* d_c .* c .* L .^ 2 / 3);
det_I = I_xx * I_zz - I_xz ^ 2;
x_s = x_c + (I_zz * I_wz - I_xz * I_wx) / det_I;
z_s = z_c - (I_xx * I_wx - I_xz * I_wz) / det_I;

%% Objective in terms of q = p - (x_s, z_s, 0):
w_s = sectorial(x_s, z_s, 0, x, z, a, b, s, c, L, root);
v   = [-(z - z(root)), x - x(root), -ones(num_nodes, 1)];
v_a = v(a, :);
v_b = v(b, :);

%% Starting ellipsoid, guaranteed to contain the minimizer:
% Start at the shear center with w_0 at the mean of w. With
% G = int(v * v') dA and kappa = max over nodes of v' * inv(G) * v, the
% ellipsoid (q - q_0)' * G * (q - q_0) <= 4 * kappa * F(q_0) ^ 2 contains
% every minimizer.
q   = [0; 0; sum(A_i .* (w_s(a) + w_s(b)) / 2) / A];
F_0 = trial(w_s, v, q, a, b, v_a, v_b, A_i);
onsection = unique([a; b]);
if F_0 <= 1E-12 * A * max((x(onsection) - x_c) .^ 2 + (z(onsection) - z_c) .^ 2)
    B_p = 0;
    Z_w = 0;
    return
end

G = (A_i .* v_a)' * v_a / 3 + (A_i .* v_b)' * v_b / 3 ...
    + ((A_i .* v_a)' * v_b + (A_i .* v_b)' * v_a) / 6;
G = (G + G') / 2;
kappa = max(sum((v(onsection, :) / G) .* v(onsection, :), 2));

% Ellipsoid {q_0 + B * u : |u| <= 1} with B * B' = 4 * kappa * F_0^2 * inv(G):
% from G = L_G * L_G', take B = 2 * sqrt(kappa) * F_0 * inv(L_G')
L_G = chol(G, "lower");
B   = 2 * sqrt(kappa) * F_0 * (L_G' \ eye(3));

%% Ellipsoid iterations:
n   = 3;
c_1 = n / sqrt(n ^ 2 - 1);
c_2 = n / (n + 1);
Z_w   = inf;
bound = inf;
for iter = 1:max_num_iter
    [F, g] = trial(w_s, v, q, a, b, v_a, v_b, A_i);
    Z_w = min(Z_w, F);

    % Bound: F(q) - (true minimum) <= |B' * g|, and the best value
    % found is never above F(q), so the smallest |B' * g| so far bounds it:
    h = B' * g;
    bound = min(bound, norm(h));
    if bound <= tol * Z_w
        break
    end

    % Cut through the center perpendicular to g, keep the downhill half,
    % and wrap it in the smallest ellipsoid:
    h_u = h / norm(h);
    q   = q - B * h_u / (n + 1);
    B   = B * (c_1 * (eye(3) - h_u * h_u') + c_2 * (h_u * h_u'));
end

%% Results:
B_p = F_y * Z_w;
end

function w = sectorial(x_0, z_0, w_root, x, z, a, b, s, c, L, root)
w = zeros(size(x));
w(root) = w_root;
for i = 1:numel(a)
    d = (x(a(i)) - x_0) * s(i) - (z(a(i)) - z_0) * c(i);
    w(b(i)) = w(a(i)) + d * L(i);
end
end


function [F, g] = trial(w_s, v, q, a, b, v_a, v_b, A_i)
w   = w_s + v * q;
w_a = w(a);
w_b = w(b);

same  = w_a .* w_b >= 0;
cross = ~same;

F = sum(A_i(same) .* abs(w_a(same) + w_b(same)) / 2) ...
    + sum(A_i(cross) .* (w_a(cross) .^ 2 + w_b(cross) .^ 2) ...
    ./ (2 * abs(w_a(cross) - w_b(cross))));

if nargout < 2
    return
end

sgn = sign(w_a(same) + w_b(same));
g = ((sgn .* A_i(same))' * (v_a(same, :) + v_b(same, :)) / 2)';
if any(cross)
    xi  = w_a(cross) ./ (w_a(cross) - w_b(cross));
    v_0 = v_a(cross, :) + xi .* (v_b(cross, :) - v_a(cross, :));
    g = g + ((sign(w_a(cross)) .* A_i(cross) .* xi)' ...
        * (v_a(cross, :) + v_0) / 2)' ...
        + ((sign(w_b(cross)) .* A_i(cross) .* (1 - xi))' ...
        * (v_0 + v_b(cross, :)) / 2)';
end
end
