cfg = Config;

% [highway, fall, traffic] = LoadDatabases(cfg);

highway.gaussian = GaussianPerPixel( highway.train );
fall.gaussian = GaussianPerPixel( fall.train );
traffic.gaussian = GaussianPerPixel( traffic.train );

alpha = 0:0.25:3;
highway.evaluation = EvaluateAlpha(highway, alpha);
fall.evaluation = EvaluateAlpha(fall, alpha);
traffic.evaluation = EvaluateAlpha(traffic, alpha);

% plot(alpha, extractfield(cell2mat(evaluationSequence), 'recall'))
% ...