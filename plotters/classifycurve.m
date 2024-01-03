function [] = classifycurve(curvecell, filenamecell, clascell, filedisplay, axesnum, logopt, xmin, xmax, ymin, ymax, fileindex, modeindex)
    % Author:   Benjamin W. Schafer
    % Date:     October 2006

    axes(axesnum)
    cla

    % Classification breakdown plot:
    clas = clascell{fileindex};

    if ~isempty(clas)
        curve = curvecell{fileindex};

        for i = 1:max(size(curve));
            curve_length(i, 1) = curve{i}(modeindex, 1);
            clasplot(i, :) = clas{i}(modeindex, :);
        end

        if logopt
            set(gca, 'XScale', 'Log')
        else
            set(gca, 'XScale', 'Linear')
        end

        hold on
        hc = plot(curve_length, clasplot(:, 1), '-', curve_length, clasplot(:, 2), '--', curve_length, clasplot(:, 3), '-.', curve_length, clasplot(:, 4), ':');
        set(hc, 'LineWidth', 2);
        legend(hc, 'Global', 'Distortional', 'Local', 'Other')
        axis tight
        axis([xmin xmax 0 100])
        xlabel('Length');
        ylabel('Modal participation');
        colormap lines(4) % jet
    end

end
