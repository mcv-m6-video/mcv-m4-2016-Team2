function plotResults(sequence, cfg)

evaluationSequenceNon = sequence.evaluation.nonRecursiveAlphaEvaluation;
evaluationSequenceRec = sequence.evaluation.recursiveAlphaEvaluationMethod2;

recTP          = extractfield(cell2mat(evaluationSequenceRec), 'TP');
recTN          = extractfield(cell2mat(evaluationSequenceRec), 'TN');
recFP          = extractfield(cell2mat(evaluationSequenceRec), 'FP');
recFN          = extractfield(cell2mat(evaluationSequenceRec), 'FN');
recPrecision   = extractfield(cell2mat(evaluationSequenceRec), 'precision');
recRecall      = extractfield(cell2mat(evaluationSequenceRec), 'recall');
recF           = extractfield(cell2mat(evaluationSequenceRec), 'F');

nonTP          = extractfield(cell2mat(evaluationSequenceNon), 'TP');
nonTN          = extractfield(cell2mat(evaluationSequenceNon), 'TN');
nonFP          = extractfield(cell2mat(evaluationSequenceNon), 'FP');
nonFN          = extractfield(cell2mat(evaluationSequenceNon), 'FN');
nonPrecision   = extractfield(cell2mat(evaluationSequenceNon), 'precision');
nonRecall      = extractfield(cell2mat(evaluationSequenceNon), 'recall');
nonF           = extractfield(cell2mat(evaluationSequenceNon), 'F');

f1 = figure;
hold on
plot(cfg.alpha, recTP, 'b', cfg.alpha, recTN, 'g', cfg.alpha, recFP, 'm', cfg.alpha, recFN, 'r')
plot(cfg.alpha, nonTP, 'b--', cfg.alpha, nonTN, 'g--', cfg.alpha, nonFP, 'm--', cfg.alpha, nonFN, 'r--')
hold off
xlabel('threshold')
ylabel('number of pixels')
title('TP, TN, FP, FN for ONE GAUSSIAN')
legend('recursive TP', 'recursive TN', 'recursive FP', 'recursive FN', ...
        'non-recursive TP', 'non-recursive TN', 'non-recursive FP', 'non-recursive FN')

% F measure depending on threshold 
f2 = figure;
hold on
plot(cfg.alpha, recF, '-')
plot(cfg.alpha, nonF, '--')
hold off
xlabel('threshold')
ylabel('F-measure')
axis([cfg.alpha(1) cfg.alpha(end) 0 1])
title('F-measure depending on threshold')
legend('recursive method', 'non-recursive method') 

% Precision Recall
f3 = figure;
hold on
plot(recRecall, recPrecision, '-');
plot(nonRecall, nonPrecision, '--');
xlabel('recall')
ylabel('precision')
axis([0 1 0 1])
title('Precision - Recall')
legend('recursive method', 'non-recursive method') 



if cfg.plotly.activate
    filename1 = [cfg.plotly.folder sequence.seqName '_TP_TN_FP_FN'];
    response1 = fig2plotly(f1, 'filename', filename1, 'fileopt', 'overwrite', 'open', false);
    plot_url = response1.url
    
    filename2 = [cfg.plotly.folder sequence.seqName '_precision_recall'];
    response2 = fig2plotly(f3, 'filename', filename2, 'fileopt', 'overwrite', 'open', false);
    plot_url = response2.url
    
    filename3 = [cfg.plotly.folder sequence.seqName '_F'];
    response3 = fig2plotly(f2, 'filename', filename3, 'fileopt', 'overwrite', 'open', false);
    plot_url = response3.url
end
