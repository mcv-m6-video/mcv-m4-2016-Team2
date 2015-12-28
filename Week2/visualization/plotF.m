function plotF(cfg, OPTPlot, varargin)

if nargin < 3
    error('No data to plot')
end

for ii = 1:length(varargin)
    evF(ii, :) = extractfield(cell2mat(varargin{ii}), 'F');
    OPTPlot.x(ii, :) = OPTPlot.xaxis;
end



OPTPlot.ylabel  = 'F-measure';
OPTPlot.axis = 1;
plotCurves(cfg, OPTPlot, evF)