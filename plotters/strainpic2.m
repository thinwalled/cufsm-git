function [] = strainpic2(node, elem, axesnum, scale, disp)
    % Author:   Benjamin W. Schafer
    % Date:     1998
    % Modifications:
    % 2003 - Modified to plot displacements.
    % 2004 - Modification to plot any nodal quantity out-of-plane.

    % node:     [node # | x | z | dofx | dofz | dofy | dofrot | stress]
    % elem:     [elem # | nodei | nodej | t | mat #]
    % mode:     Vector of DOF displacements in clobal coordinates [u1 | v1 | ui | vi | un | vn | w1 | theta1 | wi | thetai | wn | thetan]

    axes(axesnum)
    cla

    maxdisp = max(abs(disp));
    dispnorm = [node(:, 1) disp / maxdisp];
    maxoffset = scale * 1/10 * max(max(abs(node(:, 2:3))));

    for i = 1:length(dispnorm(:, 1))
        dispcoord(i, 1:3) = [node(i, 1), node(i, 2) + maxoffset * dispnorm(i, 2), node(i, 3) - maxoffset * dispnorm(i, 2)];
    end

    for i = 1:length(node(:, 1))

        if dispnorm(i, 2) >= 0
            plot(node(i, 2), node(i, 3), 'r.', 'markersize', 12)
            hold on
        else
            plot(node(i, 2), node(i, 3), 'b.', 'markersize', 12)
            hold on
        end

    end

    axis('equal')
    axis('off')
    % title('Strain distribution')
    hold on

    for i = 1:length(elem(:, 1))
        nodei = elem(i, 2);
        nodej = elem(i, 3);
        xi = node(find(node(:, 1) == nodei), 2);
        zi = node(find(node(:, 1) == nodei), 3);
        xj = node(find(node(:, 1) == nodej), 2);
        zj = node(find(node(:, 1) == nodej), 3);
        snodei = elem(i, 2);
        snodej = elem(i, 3);
        sxi = dispcoord(find(node(:, 1) == nodei), 2);
        szi = dispcoord(find(node(:, 1) == nodei), 3);
        sxj = dispcoord(find(node(:, 1) == nodej), 2);
        szj = dispcoord(find(node(:, 1) == nodej), 3);
        plot([xi xj], [zi zj], 'k', [sxi sxj], [szi szj], 'r', ...
            [xi sxi], [zi szi], 'r', [xj sxj], [zj szj], 'r')
    end

    hold off
end
