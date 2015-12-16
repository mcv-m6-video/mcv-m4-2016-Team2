function plotResults_OP6(type, evaluation2plot, cfg)
display(type)

% Format: 1col -> precision, 2col -> recall, 3col -> F1

fig1 = figure;
hold on
plot([1:size(evaluation2plot, 1)], evaluation2plot(:,1), 'b-')
plot([1:size(evaluation2plot, 1)], evaluation2plot(:,2), 'r-')
plot([1:size(evaluation2plot, 1)], evaluation2plot(:,3), 'g-')
hold off
legend('Precision', 'Recall', 'F1 measure')
xlabel('delay (frames)');

if cfg.plotly.activate
    filename = [cfg.plotly.folder type '_OP6_evolution'];
    response = fig2plotly(fig1, 'filename', filename, 'fileopt', 'overwrite', 'open', false);
    plot_url = response.url
end
