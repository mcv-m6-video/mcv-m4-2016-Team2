function plotResults(type, evaluationSequence, evaluationPerFrame, cfg)
display(type)
%% Task 1
results = {evaluationSequence.TP; evaluationSequence.TN;...
           evaluationSequence.FP; evaluationSequence.FN; ...
           evaluationSequence.precision; evaluationSequence.recall; ...
           evaluationSequence.F};
toDisplay = [{'True Positive'; 'True Negative'; ...
              'False Positive'; 'False Negative'; ...
              'Precision'; 'Recall'; 'F1-score'}, results];
display(toDisplay)

%% Task 3
% Graph 1: F1 Score vs # frame
FperFrame = evaluationPerFrame.F;

fig1 = figure;
plot([1:length(FperFrame)], FperFrame)
title([type ' F1 Score vs # frame']);
xlabel('# frame');
ylabel('F1 score');


if cfg.plotly.activate
    filename = [cfg.plotly.folder type '_' num2str(cfg.delay) '_G1_FperFrame'];
    response = fig2plotly(fig1, 'filename', filename, 'fileopt', 'overwrite', 'open', false);
    plot_url = response.url
end

% Graph 2: True Positive & Total Foreground pixels vs #frame
TPperFrame = evaluationPerFrame.TP;
FperFrame = evaluationPerFrame.ForegroundPx;

fig2 = figure;
plot([1:length(TPperFrame)],TPperFrame, 'b-', [1:length(FperFrame)],FperFrame, 'm-');
title([type ' True Positive & Total Foreground pixels vs #frame']);
xlabel('# frame');
ylabel('# pixels');
legend('True positive', 'Total foreground pixels')

if cfg.plotly.activate
    filename = [cfg.plotly.folder type '_' num2str(cfg.delay) '_G2_FperFrame'];
    response = fig2plotly(fig2, 'filename', filename, 'fileopt', 'overwrite', 'open', false);
    plot_url = response.url

end
