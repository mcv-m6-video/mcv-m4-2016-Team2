function plotCurves(cfg, OPTPlot, toPlot)

if nargin < 3
    error('No data to plot')
end

f = figure;
hold on
for ii = 1:size(toPlot, 1)
    plot(OPTPlot.x(ii, :), toPlot(ii, :), OPTPlot.style{ii})
end
hold off

if isfield(OPTPlot, 'axis')
    if OPTPlot.axis
        axis([OPTPlot.x(1) OPTPlot.x(end) 0 1]) 
    end
        
end
if isfield(OPTPlot, 'xlabel'), xlabel(OPTPlot.xlabel), end
if isfield(OPTPlot, 'ylabel'), ylabel(OPTPlot.ylabel), end
if isfield(OPTPlot, 'title'), title(OPTPlot.title), end
if isfield(OPTPlot, 'legend'), legend(OPTPlot.legend), end

if cfg.plotly.activate
    filename1 = [cfg.plotly.folder OPTPlot.filename];
    response1 = fig2plotly(f, 'filename', filename1, 'fileopt', 'overwrite', 'open', false);
    plot_url = response1.url
end

