function plotResults_OP6(type, evaluation2plot, cfg)
display(type)

% Format: 1col -> precision, 2col -> recall, 3col -> F1

fig1 = figure;
hold on
plot([1:size(evaluation2plot, 1)], evaluation2plot(:,1), 'b-')
plot([1:size(evaluation2plot, 1)], evaluation2plot(:,2), 'r-')
plot([1:size(evaluation2plot, 1)], evaluation2plot(:,3), 'g-')
hold off

title([type ' ']);
xlabel('delay (frames)');
