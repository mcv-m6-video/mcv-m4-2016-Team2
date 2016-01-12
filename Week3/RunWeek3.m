%load('resultsWeek3.mat')
cfg = Config();

[highway, fall, traffic] = LoadDatabases(cfg);

if cfg.grayscale
    display('Grayscale............')
    highway.gaussian = GaussianPerPixel( highway.train, cfg );
    fall.gaussian = GaussianPerPixel( fall.train, cfg );
    traffic.gaussian = GaussianPerPixel( traffic.train, cfg );
    
    if cfg.nonAdaptive
        display('........Non adaptative............')
        display('...............Highway sequence............')
        [highway] = RunSequenceNonAdaptiveMorphologicalFiltering(highway, cfg);
        %showSequence(highway)
        display('...............Fall sequence................')
        [fall] = RunSequenceNonAdaptiveMorphologicalFiltering(fall, cfg);
        display('...............Traffic sequence..............')
        [traffic] = RunSequenceNonAdaptiveMorphologicalFiltering(traffic, cfg);
        
    end
    
    if cfg.adaptive
        display('........Adaptative............')
        display('...............Highway sequence............')
        [highway] = RunSequenceAdaptiveMorphologicalFiltering(highway, cfg, cfg.highway.bestRho);
        display('...............Fall sequence................')
        [fall] = RunSequenceAdaptiveMorphologicalFiltering(fall, cfg, cfg.fall.bestRho);
        display('...............Traffic sequence..............')
        [traffic] = RunSequenceAdaptiveMorphologicalFiltering(traffic, cfg, cfg.traffic.bestRho);
    end
    
else
    
% Task 6: Improved Evaluation of Foreground Maps
% FG - Binary / Non binary foreground map (double values in the range [0 1])
% FG = ;
% GT - Logical binary ground truth
% GT = ;
% [R, P, Q] = FWeightedMeasure(FG, GT);  
end