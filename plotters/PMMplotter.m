function [] = PMMplotter(axesnum, node, elem, P, M11, M22, Py, M11y, M22y, firstyieldflag, fy, inc)

    % Axes for the subplots of P-M11, P-M22, M11-M22 space:
    for i = 1:4
        axes(axesnum(i));
        cla
    end

    % Generate first yield surface:
    if firstyieldflag
        % Let's create a first yield surface for M11-M22 space:
        thetaMM = [0:inc:360]';
        phiPM = 0 * thetaMM + 90;
        [betay, PMMymm] = firstyield(node, elem, fy, thetaMM, phiPM);

        % Let's create a first yield surface for P-M11 space:
        phiPM = [0:inc:360]';
        thetaMM = 0 * phiPM;
        [betay, PMMypm1] = firstyield(node, elem, fy, thetaMM, phiPM);

        % Let's create a first yield surface for P-M22 space:
        phiPM = [0:inc:360]';
        thetaMM = 0 * phiPM + 90;
        [betay, PMMypm2] = firstyield(node, elem, fy, thetaMM, phiPM);

        % Let's create the 3D first yield surface:
        phiPM = [0:inc:360]';
        thetaMM = [0:inc:360]';
        k = 1;

        for i = 1:length(phiPM)

            for j = 1:length(thetaMM)
                phiPM3D(k, 1) = phiPM(i);
                thetaMM3D(k, 1) = thetaMM(j);
                k = k + 1;
            end

        end

        [betay3D, PMMy3D] = firstyield(node, elem, fy, thetaMM3D, phiPM3D);
    end

    % First yield point under reference load:
    [beta, theta, phi] = PMMtoBetaThetaPhi(P / Py, M11 / M11y, M22 / M22y);
    [betay, PMMy] = firstyield(node, elem, fy, theta, phi);

    % M11-M22:
    axes(axesnum(2));
    plot([0 M11 / M11y], [0 M22 / M22y], 'b-', 'LineWidth', 2)
    hold on
    plot([M11 / M11y], [M22 / M22y], 'bo', 'MarkerSize', 10)
    text([M11 / M11y] * 0.9, [M22 / M22y] * 1.1, '\beta', 'FontSize', 12)
    text([M11 / M11y] / 2, [M22 / M22y] / 4, '\theta_{MM}')
    plot([PMMy(2)], [PMMy(3)], 'r.', 'MarkerSize', 12)
    text([PMMy(2)] * 0.9, [PMMy(3)] * 1.1, '\beta_y')

    if firstyieldflag
        hold on
        plot(PMMymm(:, 2), PMMymm(:, 3), 'r-')
    end

    axis equal
    hold off
    xlabel('M_{11}/M_{11y}')
    ylabel('M_{22}/M_{22y}')
    xrange = xlim;
    xrange = [min([-1 xrange(1)]'), max([1 xrange(2)]')];
    yrange = ylim;
    yrange = [min([-1 yrange(1)]'), max([1 yrange(2)]')];
    axis([xrange yrange]);
    hold on, plot(xrange, [0 0], 'k-', [0 0], yrange, 'k-', 'LineWidth', 0.1), hold off

    % P-M11
    axes(axesnum(3));
    plot([0 M11 / M11y], [0 P / Py], 'b-', 'LineWidth', 2)
    hold on
    plot([M11 / M11y], [P / Py], 'bo', 'MarkerSize', 10)
    text([M11 / M11y] * 0.9, [P / Py] * 1.1, '\beta')
    text([M11 / M11y] / 8, [P / Py] / 2, '\phi_{PM}')
    plot([PMMy(2)], [PMMy(1)], 'r.', 'MarkerSize', 12)
    text([PMMy(2)] * 0.9, [PMMy(1)] * 1.1, '\beta_y')

    if firstyieldflag
        hold on
        plot(PMMypm1(:, 2), PMMypm1(:, 1), 'r-')
    end

    axis equal
    hold off
    xlabel('M_{11}/M_{11y}')
    ylabel('P/P_y')
    xrange = xlim;
    xrange = [min([-1 xrange(1)]'), max([1 xrange(2)]')];
    yrange = ylim;
    yrange = [min([-1 yrange(1)]'), max([1 yrange(2)]')];
    axis([xrange yrange]);
    hold on, plot(xrange, [0 0], 'k-', [0 0], yrange, 'k-', 'LineWidth', 0.1), hold off

    % P-M22:
    axes(axesnum(4));
    plot([0 M22 / M22y], [0 P / Py], 'b-', 'LineWidth', 2)
    hold on
    plot([M22 / M22y], [P / Py], 'bo', 'MarkerSize', 10)
    text([M22 / M22y] * 0.9, [P / Py] * 1.1, '\beta')
    text([M22 / M22y] / 8, [P / Py] / 4, '\phi_{PM}')
    plot([PMMy(3)], [PMMy(1)], 'r.', 'MarkerSize', 12)
    text([PMMy(3)] * 0.9, [PMMy(1)] * 1.1, '\beta_y')

    if firstyieldflag
        hold on
        plot(PMMypm2(:, 3), PMMypm2(:, 1), 'r-')
    end

    axis equal
    hold off
    xlabel('M_{22}/M_{22y}')
    ylabel('P/P_y')
    xrange = xlim;
    xrange = [min([-1 xrange(1)]'), max([1 xrange(2)]')];
    yrange = ylim;
    yrange = [min([-1 yrange(1)]'), max([1 yrange(2)]')];
    axis([xrange yrange]);
    hold on, plot(xrange, [0 0], 'k-', [0 0], yrange, 'k-', 'LineWidth', 0.1), hold off

    % P-M11-M22 visualization in the first axes, plotted last:
    axes(axesnum(1))
    plot3([0 M11 / M11y], [0 M22 / M22y], [0 P / Py], 'b-', 'LineWidth', 2)
    hold on
    plot3([M11 / M11y], [M22 / M22y], [P / Py], 'bo', 'MarkerSize', 10)
    plot3([PMMy(2)], [PMMy(3)], [PMMy(1)], 'r.', 'MarkerSize', 12)
    %box on
    if firstyieldflag
        hold on
        plot3(PMMymm(:, 2), PMMymm(:, 3), PMMymm(:, 1), 'r-')
        plot3(PMMypm1(:, 2), PMMypm1(:, 3), PMMypm1(:, 1), 'r-')
        plot3(PMMypm2(:, 2), PMMypm2(:, 3), PMMypm2(:, 1), 'r-')
        %plot3(PMMy3D(:,2),PMMy3D(:,3),PMMy3D(:,1),'r.')
        n = length(phiPM);
        o = length(thetaMM);
        X = reshape(PMMy3D(:, 2), n, o);
        Y = reshape(PMMy3D(:, 3), n, o);
        Z = reshape(PMMy3D(:, 1), n, o);
        C = reshape(betay3D, n, o);
        %surf(X,Y,Z);
        %surf(X,Y,Z,'FaceColor',[.1 .1 .1],'EdgeColor','none')
        surf(X, Y, Z, C, 'EdgeColor', 'none')
        view(37.5, 30)
        colormap hsv
        %camlight left;

        % Lighting phong:
        alpha(0.4)
    end

    axis equal
    hold off
    xlabel('M_{11}/M_{11y}')
    ylabel('M_{22}/M_{22y}')
    zlabel('P/P_y')
    xrange = xlim;
    xrange = [min([-1 xrange(1)]'), max([1 xrange(2)]')];
    yrange = ylim;
    yrange = [min([-1 yrange(1)]'), max([1 yrange(2)]')];
    zrange = zlim;
    zrange = [min([-1 zrange(1)]'), max([1 zrange(2)]')];
    axis([xrange yrange zrange]);
    hold on,
    plot3(xrange, [0 0], [0 0], 'k-', 'LineWidth', 0.1)
    plot3([0 0], yrange, [0 0], 'k-', 'LineWidth', 0.1)
    plot3([0 0], [0 0], zrange, 'k-', 'LineWidth', 0.1)
    hold off
end
