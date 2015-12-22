cfg = Config;

[highway, fall, traffic] = LoadDatabases(cfg);

highway.gaussian = GaussianPerPixel( highway.train, cfg );
%  fall.gaussian = GaussianPerPixel( fall.train );
% traffic.gaussian = GaussianPerPixel( traffic.train );

[highway] = RunSequence(highway, cfg)
plotResults(highway, cfg)

% fall.evaluation = EvaluateAlpha(fall, cfg.alpha, cfg.adaptative, cfg.rho);
% traffic.evaluation = EvaluateAlpha(traffic, cfg.alpha, cfg.adaptative, cfg.rho);

% plot(cfg.alpha, extractfield(cell2mat(evaluationSequence), 'recall'))
% ...