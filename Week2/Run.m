cfg = Config;


[highway, fall, traffic] = LoadDatabases(cfg);

display('Highway sequence............')
highway.gaussian = GaussianPerPixel( highway.train, cfg );
[highway] = RunSequenceNonAdaptive(highway, cfg);
%showSequence(highway)
[highway] = RunSequenceAdaptive(highway, cfg);
%showSequence(highway, 'adaptive')

display('Fall sequence................')
fall.gaussian = GaussianPerPixel( fall.train, cfg );
[fall] = RunSequenceNonAdaptive(fall, cfg);
[fall] = RunSequenceAdaptive(fall, cfg);

display('Traffic sequence..............')
traffic.gaussian = GaussianPerPixel( traffic.train, cfg );
[traffic] = RunSequenceNonAdaptive(traffic, cfg);
[traffic] = RunSequenceAdaptive(traffic, cfg);


%% Evaluation non-recursive
% OPTPlot.title   = '';
OPTPlot.legend  = {'Highway', 'Fall', 'Traffic'};
OPTPlot.filename = 'F_non_recursive';
OPTPlot.style   = {'r', 'b', 'm'};
% Plot F
plotF(cfg, OPTPlot, highway.nonAdaptive.alphaEvaluation, ...
                    fall.nonAdaptive.alphaEvaluation,...
                    traffic.nonAdaptive.alphaEvaluation);

% Pixel-based evaluation
OPTPlot2.filename = 'EvalperPixel_non_recursive_highway';
plotEvalperPixel(cfg, OPTPlot2, highway.nonAdaptive.alphaEvaluation);
OPTPlot2.filename = 'EvalperPixel_non_recursive_fall';
plotEvalperPixel(cfg, OPTPlot2, fall.nonAdaptive.alphaEvaluation);
OPTPlot2.filename = 'EvalperPixel_non_recursive_traffic';
plotEvalperPixel(cfg, OPTPlot2, traffic.nonAdaptive.alphaEvaluation);

% Plot precision - recall
OPTPlot3.legend  = {'Highway', 'Fall', 'Traffic'};
OPTPlot3.filename = 'PR_non_recursive';
plotPrecisionRecall(cfg, OPTPlot3, highway.nonAdaptive.alphaEvaluation, ...
                    fall.nonAdaptive.alphaEvaluation,...
                    traffic.nonAdaptive.alphaEvaluation);

%% Evaluation recursive
% OPTPlot.title   = '';
OPTPlot.legend  = {'Highway', 'Fall', 'Traffic'};
OPTPlot.filename = 'F_recursive';
OPTPlot.style   = {'r', 'b', 'm'};
% Plot F
plotF(cfg, OPTPlot, highway.adaptive.alphaEvaluation, ...
                    fall.adaptive.alphaEvaluation,...
                    traffic.adaptive.alphaEvaluation);

 % Pixel-based evaluation          
OPTPlot2.filename = 'EvalperPixel_recursive_highway';
plotEvalperPixel(cfg, OPTPlot2, highway.adaptive.alphaEvaluation);
OPTPlot2.filename = 'EvalperPixel_recursive_fall';
plotEvalperPixel(cfg, OPTPlot2, fall.adaptive.alphaEvaluation);
OPTPlot2.filename = 'EvalperPixel_recursive_traffic';
plotEvalperPixel(cfg, OPTPlot2, traffic.adaptive.alphaEvaluation);

% Plot precision-recall
OPTPlot3.legend  = {'Highway', 'Fall', 'Traffic'};
OPTPlot3.filename = 'PR_recursive';
plotPrecisionRecall(cfg, OPTPlot3, highway.adaptive.alphaEvaluation, ...
                    fall.adaptive.alphaEvaluation,...
                    traffic.adaptive.alphaEvaluation);

%% Comparison non-recursive VS recursive
OPTPlot.legend  = {'Highway non-recursive', 'Fall non-recursive', 'Traffic non-recursive',...
                    'Highway recursive', 'Fall recursive', 'Traffic recursive'};
OPTPlot.filename = 'F_comparison';
OPTPlot.style   = {'r', 'b', 'm', 'r--', 'b--', 'm--'};
% Plot F
plotF(cfg, OPTPlot, highway.nonAdaptive.alphaEvaluation, ...
                    fall.nonAdaptive.alphaEvaluation,...
                    traffic.nonAdaptive.alphaEvaluation, ...
                    highway.adaptive.alphaEvaluation,...
                    fall.adaptive.alphaEvaluation,...
                    traffic.adaptive.alphaEvaluation);


%%
% Show results adaptive vs non adaptive
% CompareSequences(highway.test, highway.gt, ...
%     highway.nonAdaptive.bestResult, highway.adaptive.bestResult);

