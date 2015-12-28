function plotEvalperPixel(cfg, OPTPlot, seq)

if nargin < 3
    error('No data to plot')
end


    toPlot(1,:) = extractfield(cell2mat(seq), 'TP');
    toPlot(2,:) = extractfield(cell2mat(seq), 'TN');
    toPlot(3, :) = extractfield(cell2mat(seq), 'FP');
    toPlot(4, :) = extractfield(cell2mat(seq), 'FN');

    OPTPlot.x = repmat(OPTPlot.xaxis, [4, 1]);

OPTPlot.style   = {'r', 'b', 'm', 'g'};
OPTPlot.xlabel  = 'threshold';
OPTPlot.ylabel  = 'number of pixels'
OPTPlot.legend  = {'TP', 'TN', 'FP', 'FN'};

plotCurves(cfg, OPTPlot, toPlot)