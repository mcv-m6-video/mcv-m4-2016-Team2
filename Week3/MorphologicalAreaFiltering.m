function output = MorphologicalAreaFiltering(result, cfg)

output = cellfun(@(x) bwareaopen(x, cfg.areaFilteringSize, cfg.connectivity), result, 'UniformOutput', false);