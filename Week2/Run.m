cfg = Config;


[highway, fall, traffic] = LoadDatabases(cfg);

if cfg.grayscale
    display('Highway sequence............')
    highway.gaussian = GaussianPerPixel( highway.train, cfg );
    [highway] = RunSequenceNonAdaptive(highway, cfg);
    %showSequence(highway)
    [highway] = RunSequenceAdaptive(highway, cfg);
    %showSequence(highway, 'adaptive')
    [highway] = RunSequenceGMM(highway, cfg);

    display('Fall sequence................')
    fall.gaussian = GaussianPerPixel( fall.train, cfg );
    [fall] = RunSequenceNonAdaptive(fall, cfg);
    [fall] = RunSequenceAdaptive(fall, cfg);
    [fall] = RunSequenceGMM(fall, cfg);

    display('Traffic sequence..............')
    traffic.gaussian = GaussianPerPixel( traffic.train, cfg );
    [traffic] = RunSequenceNonAdaptive(traffic, cfg);
    [traffic] = RunSequenceAdaptive(traffic, cfg);
    [traffic] = RunSequenceGMM(traffic, cfg);

elseif cfg.yuv
    [~, numChannels] = size(highway);
    
    for channel = 1: numChannels
        
        display('Highway sequence............')
        %highway = arrayfun(@(c)GaussianPerPixel(c.train,cfg), highway, 'UniformOutput', false);
        highway{channel}.gaussian = GaussianPerPixel( highway{channel}.train, cfg );
        highway{channel} = RunSequenceNonAdaptive(highway{channel}, cfg);
        %showSequence(highway)
        %highway{channel} = RunSequenceAdaptive(highway{channel}, cfg);
        %showSequence(highway, 'adaptive')
        
        display('Fall sequence................')
        fall{channel}.gaussian = GaussianPerPixel( fall{channel}.train, cfg );
        fall{channel} = RunSequenceNonAdaptive(fall{channel}, cfg);
        %fall{channel} = RunSequenceAdaptive(fall{channel}, cfg);
        
        display('Traffic sequence..............')
        traffic{channel}.gaussian = GaussianPerPixel( traffic{channel}.train, cfg );
        traffic{channel} = RunSequenceNonAdaptive(traffic{channel}, cfg);
        %traffic{channel} = RunSequenceAdaptive(traffic{channel}, cfg);
    end
    
end

%% Evaluation non-recursive
% OPTPlot.title   = '';
OPTPlot.legend  = {'Highway', 'Fall', 'Traffic'};
OPTPlot.filename = 'F_non_recursive';
OPTPlot.style   = {'r', 'b', 'm'};
OPTPlot.xaxis = cfg.alpha;
OPTPlot.xlabel  = 'threshold';
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
OPTPlot.xaxis = cfg.alpha;
OPTPlot.xlabel  = 'threshold';
% Plot F
plotF(cfg, OPTPlot, highway.adaptive.alphaEvaluation, ...
                    fall.adaptive.alphaEvaluation,...
                    traffic.adaptive.alphaEvaluation);

 % Pixel-based evaluation
OPTPlot2.xaxis =  cfg.alpha;
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
OPTPlot.xaxis = cfg.alpha;
OPTPlot.xlabel  = 'threshold';
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

%% Evaluation GMM
% OPTPlot.title   = '';
OPTPlot.legend  = {'Highway', 'Fall', 'Traffic'};
OPTPlot.filename = 'F_GMM';
OPTPlot.style   = {'r', 'b', 'm'};
OPTPlot.xaxis = cfg.numGaussians;
OPTPlot.xlabel  = 'number of Gaussians';
% Plot F
plotF(cfg, OPTPlot, highway.GMM.evaluation, ...
                     fall.GMM.evaluation,...
                     traffic.GMM.evaluation);

 % Pixel-based evaluation    
OPTPlot2.xaxis =  cfg.numGaussians;
OPTPlot2.filename = 'EvalperPixel_GMM_highway';
plotEvalperPixel(cfg, OPTPlot2, highway.GMM.evaluation);
OPTPlot2.filename = 'EvalperPixel_GMM_fall';
plotEvalperPixel(cfg, OPTPlot2, fall.GMM.evaluation);
OPTPlot2.filename = 'EvalperPixel_GMM_traffic';
plotEvalperPixel(cfg, OPTPlot2, traffic.GMM.evaluation);

% Plot precision-recall
OPTPlot3.legend  = {'Highway', 'Fall', 'Traffic'};
OPTPlot3.filename = 'PR_GMM';
plotPrecisionRecall(cfg, OPTPlot3, highway.GMM.evaluation, ...
                    fall.GMM.evaluation,...
                    traffic.GMM.evaluation);
%% Comparison recursive VS GMM

                    
%