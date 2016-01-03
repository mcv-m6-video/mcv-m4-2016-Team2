cfg = Config;


[highway, fall, traffic] = LoadDatabases(cfg);

if cfg.grayscale
    display('Grayscale............')
    
    highway.gaussian = GaussianPerPixel( highway.train, cfg );
    fall.gaussian = GaussianPerPixel( fall.train, cfg );
    traffic.gaussian = GaussianPerPixel( traffic.train, cfg );

    
    if cfg.nonAdaptative
        display('Non adaptative............')
        display('Highway sequence............')
        [highway] = RunSequenceNonAdaptive(highway, cfg);
        %showSequence(highway)
        display('Fall sequence................')
        [fall] = RunSequenceNonAdaptive(fall, cfg);
        display('Traffic sequence..............')
        [traffic] = RunSequenceNonAdaptive(traffic, cfg);
    end
    
    if cfg.adaptative
        display('Adaptative............')
        display('Highway sequence............')
        [highway] = RunSequenceAdaptive(highway, cfg);
        display('Fall sequence................')
        [fall] = RunSequenceAdaptive(fall, cfg);
        display('Traffic sequence..............')
        [traffic] = RunSequenceAdaptive(traffic, cfg);
    end
    
    if cfg.gmm
        [highway] = RunSequenceGMM(highway, cfg);
        [fall] = RunSequenceGMM(fall, cfg);
        [traffic] = RunSequenceGMM(traffic, cfg);
        
    end
   


elseif cfg.yuv
    [~, numChannels] = size(highway);
    display('YUV............')
    for channel = 1: numChannels 
        %highway = arrayfun(@(c)GaussianPerPixel(c.train,cfg), highway, 'UniformOutput', false);
        highway{channel}.gaussian = GaussianPerPixel( highway{channel}.train, cfg );
        fall{channel}.gaussian = GaussianPerPixel( fall{channel}.train, cfg );
        traffic{channel}.gaussian = GaussianPerPixel( traffic{channel}.train, cfg );
    end
    for channel = 1: numChannels
        if cfg.nonAdaptative
            display('Non adaptative............')
            display('Highway sequence............')
            highway{channel} = RunSequenceNonAdaptive(highway{channel}, cfg);
            display('Fall sequence................')
            fall{channel} = RunSequenceNonAdaptive(fall{channel}, cfg);
            display('Traffic sequence..............')
            traffic{channel} = RunSequenceNonAdaptive(traffic{channel}, cfg);
        end
    end
    for channel = 1: numChannels
        %showSequence(highway)
        if cfg.adaptative
            display('Adaptative............')
            display('Highway sequence............')
            highway{channel} = RunSequenceAdaptive(highway{channel}, cfg);
            display('Fall sequence................')
            fall{channel} = RunSequenceAdaptive(fall{channel}, cfg);
            display('Traffic sequence..............')
            traffic{channel} = RunSequenceAdaptive(traffic{channel}, cfg);
            %showSequence(highway, 'adaptive')
        end
    end
    
    save('before.mat');
    
    highway = JoinChannels( highway, numChannels, cfg.nonAdaptative, cfg.adaptative );
    fall = JoinChannels( fall, numChannels, cfg.nonAdaptative, cfg.adaptative );
    traffic = JoinChannels( traffic, numChannels, cfg.nonAdaptative, cfg.adaptative );
    
    save('after.mat');
end

% %% Evaluation non-recursive
% % OPTPlot.title   = '';
% OPTPlot.legend  = {'Highway', 'Fall', 'Traffic'};
% OPTPlot.filename = 'F_non_recursive';
% OPTPlot.style   = {'r', 'b', 'm'};
% OPTPlot.xaxis = cfg.alpha;
% OPTPlot.xlabel  = 'threshold';
% % Plot F
% plotF(cfg, OPTPlot, highway.nonAdaptive.alphaEvaluation, ...
%                     fall.nonAdaptive.alphaEvaluation,...
%                     traffic.nonAdaptive.alphaEvaluation);
% 
% % Pixel-based evaluation
% OPTPlot2.filename = 'EvalperPixel_non_recursive_highway';
% plotEvalperPixel(cfg, OPTPlot2, highway.nonAdaptive.alphaEvaluation);
% OPTPlot2.filename = 'EvalperPixel_non_recursive_fall';
% plotEvalperPixel(cfg, OPTPlot2, fall.nonAdaptive.alphaEvaluation);
% OPTPlot2.filename = 'EvalperPixel_non_recursive_traffic';
% plotEvalperPixel(cfg, OPTPlot2, traffic.nonAdaptive.alphaEvaluation);
% 
% % Plot precision - recall
% OPTPlot3.legend  = {'Highway', 'Fall', 'Traffic'};
% OPTPlot3.filename = 'PR_non_recursive';
% plotPrecisionRecall(cfg, OPTPlot3, highway.nonAdaptive.alphaEvaluation, ...
%                     fall.nonAdaptive.alphaEvaluation,...
%                     traffic.nonAdaptive.alphaEvaluation);
% 
% %% Evaluation recursive
% % OPTPlot.title   = '';
% OPTPlot.legend  = {'Highway', 'Fall', 'Traffic'};
% OPTPlot.filename = 'F_recursive';
% OPTPlot.style   = {'r', 'b', 'm'};
% OPTPlot.xaxis = cfg.alpha;
% OPTPlot.xlabel  = 'threshold';
% % Plot F
% plotF(cfg, OPTPlot, highway.adaptive.alphaEvaluation, ...
%                     fall.adaptive.alphaEvaluation,...
%                     traffic.adaptive.alphaEvaluation);
% 
%  % Pixel-based evaluation
% OPTPlot2.xaxis =  cfg.alpha;
% OPTPlot2.filename = 'EvalperPixel_recursive_highway';
% plotEvalperPixel(cfg, OPTPlot2, highway.adaptive.alphaEvaluation);
% OPTPlot2.filename = 'EvalperPixel_recursive_fall';
% plotEvalperPixel(cfg, OPTPlot2, fall.adaptive.alphaEvaluation);
% OPTPlot2.filename = 'EvalperPixel_recursive_traffic';
% plotEvalperPixel(cfg, OPTPlot2, traffic.adaptive.alphaEvaluation);
% 
% % Plot precision-recall
% OPTPlot3.legend  = {'Highway', 'Fall', 'Traffic'};
% OPTPlot3.filename = 'PR_recursive';
% plotPrecisionRecall(cfg, OPTPlot3, highway.adaptive.alphaEvaluation, ...
%                     fall.adaptive.alphaEvaluation,...
%                     traffic.adaptive.alphaEvaluation);
% 
% 
% %% Comparison non-recursive VS recursive
% OPTPlot.legend  = {'Highway non-recursive', 'Fall non-recursive', 'Traffic non-recursive',...
%                     'Highway recursive', 'Fall recursive', 'Traffic recursive'};
% OPTPlot.filename = 'F_comparison';
% OPTPlot.style   = {'r', 'b', 'm', 'r--', 'b--', 'm--'};
% OPTPlot.xaxis = cfg.alpha;
% OPTPlot.xlabel  = 'threshold';
% % Plot F
% plotF(cfg, OPTPlot, highway.nonAdaptive.alphaEvaluation, ...
%                     fall.nonAdaptive.alphaEvaluation,...
%                     traffic.nonAdaptive.alphaEvaluation, ...
%                     highway.adaptive.alphaEvaluation,...
%                     fall.adaptive.alphaEvaluation,...
%                     traffic.adaptive.alphaEvaluation);
% 
% 
% %%
% % Show results adaptive vs non adaptive
% % CompareSequences(highway.test, highway.gt, ...
% %     highway.nonAdaptive.bestResult, highway.adaptive.bestResult);
% 
% %% Evaluation GMM
% % OPTPlot.title   = '';
% OPTPlot.legend  = {'Highway', 'Fall', 'Traffic'};
% OPTPlot.filename = 'F_GMM';
% OPTPlot.style   = {'r', 'b', 'm'};
% OPTPlot.xaxis = cfg.numGaussians;
% OPTPlot.xlabel  = 'number of Gaussians';
% % Plot F
% plotF(cfg, OPTPlot, highway.GMM.evaluation, ...
%                      fall.GMM.evaluation,...
%                      traffic.GMM.evaluation);
% 
%  % Pixel-based evaluation    
% OPTPlot2.xaxis =  cfg.numGaussians;
% OPTPlot2.filename = 'EvalperPixel_GMM_highway';
% plotEvalperPixel(cfg, OPTPlot2, highway.GMM.evaluation);
% OPTPlot2.filename = 'EvalperPixel_GMM_fall';
% plotEvalperPixel(cfg, OPTPlot2, fall.GMM.evaluation);
% OPTPlot2.filename = 'EvalperPixel_GMM_traffic';
% plotEvalperPixel(cfg, OPTPlot2, traffic.GMM.evaluation);
% 
% % Plot precision-recall
% OPTPlot3.legend  = {'Highway', 'Fall', 'Traffic'};
% OPTPlot3.filename = 'PR_GMM';
% plotPrecisionRecall(cfg, OPTPlot3, highway.GMM.evaluation, ...
%                     fall.GMM.evaluation,...
%                     traffic.GMM.evaluation);
%% Comparison recursive VS GMM

                    
%
