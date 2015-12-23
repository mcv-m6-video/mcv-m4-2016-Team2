cfg = Config;

[highway, fall, traffic] = LoadDatabases(cfg);

highway.gaussian = GaussianPerPixel( highway.train, cfg );
%  fall.gaussian = GaussianPerPixel( fall.train );
% traffic.gaussian = GaussianPerPixel( traffic.train );

[highway] = RunSequenceNonAdaptive(highway, cfg);
%showSequence(highway)

[highway] = RunSequenceAdaptive(highway, cfg)
%showSequence(highway, 'adaptive')

plotResults_NonAdaptiveVSAdaptive(highway, cfg)
%%
% Show results adaptive vs non adaptive
% CompareSequences(highway.test, highway.gt, ...
%     highway.nonAdaptive.bestResult, highway.adaptive.bestResult);

