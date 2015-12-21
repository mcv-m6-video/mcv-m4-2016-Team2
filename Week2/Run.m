cfg = Config;

% [highway, fall, traffic] = LoadDatabases(cfg);

highway.gaussian = GaussianPerPixel( highway.train );
% fall.gaussian = GaussianPerPixel( fall.train );
% traffic.gaussian = GaussianPerPixel( traffic.train );

% compute best inital alpha with non adaptative
alphaEvaluation = EvaluateAlpha(highway, cfg.alpha, false, 0);
[F,I] = sort(extractfield(cell2mat(alphaEvaluation), 'F'), 'descend');
bestAlpha = I(1);
bestF = F(1)
iterations = 0;
fDiff = Inf;
while (iterations < cfg.maxIterations && fDiff > cfg.minfDiff)
    oldBestF = bestF;
    % compute best rho with the best alpha
    rhoEvaluation = EvaluateRho(highway, bestAlpha, true, cfg.rho);
    [~,I] = sort(extractfield(cell2mat(rhoEvaluation), 'F'), 'descend');
    bestRho = I(1);
    % compute alpha with best rho
    alphaEvaluation = EvaluateAlpha(highway, cfg.alpha, true, bestRho);
    [F,I] = sort(extractfield(cell2mat(alphaEvaluation), 'F'), 'descend');
    bestAlpha = I(1);
    bestF = F(1)
    
    iterations = iterations+1
    fDiff = abs(oldBestF - bestF)
end
% fall.evaluation = EvaluateAlpha(fall, cfg.alpha, cfg.adaptative, cfg.rho);
% traffic.evaluation = EvaluateAlpha(traffic, cfg.alpha, cfg.adaptative, cfg.rho);

% plot(cfg.alpha, extractfield(cell2mat(evaluationSequence), 'recall'))
% ...