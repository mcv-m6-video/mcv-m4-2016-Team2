%load('resultsWeek2.mat')
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
        [highway] = RunSequenceAdaptiveMorphologicalFiltering(highway, cfg);
        display('...............Fall sequence................')
        [fall] = RunSequenceAdaptiveMorphologicalFiltering(fall, cfg);
        display('...............Traffic sequence..............')
        [traffic] = RunSequenceAdaptiveMorphologicalFiltering(traffic, cfg);
    end
    
else
    
    
end