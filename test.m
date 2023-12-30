%test
clear all
close all force
% Create a figure
fig = figure;

numControls=10;

% Disable rendering temporarily
hold off;

% Create uicontrols without rendering
for i = 1:numControls
    hControls(i) = uicontrol('Style', 'pushbutton', 'String', ['Button ' num2str(i)], 'Position', [10 10+30*(i-1) 80 25]);
end

% Enable rendering
hold on;

% Force a manual update
drawnow;