function output = MorphologicalFillingHoles(result, cfg)

output = cellfun(@(x) imfill(x, cfg.connectivity, 'holes'), result, 'UniformOutput', false);
