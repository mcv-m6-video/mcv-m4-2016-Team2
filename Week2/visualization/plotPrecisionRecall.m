function plotPrecisionRecall(cfg, OPTPlot, varargin)

if nargin < 3
    error('No data to plot')
end

for ii = 1:length(varargin)
    toPlot(ii, :) = extractfield(cell2mat(varargin{ii}), 'precision');
    OPTPlot.x(ii, :) = extractfield(cell2mat(varargin{ii}), 'recall');
end

OPTPlot.style   = {'r', 'b', 'm'};
OPTPlot.xlabel  = 'Recall';
OPTPlot.ylabel  = 'Precision'

plotCurves(cfg, OPTPlot, toPlot)