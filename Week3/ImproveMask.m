function outMask = ImproveMask(mask, cfg)

outMask = mask;

if strcmp(cfg.morphologicalFiltering, 'imfill')
    outMask = MorphologicalFillingHoles(mask, cfg);
    
elseif strcmp(cfg.morphologicalFiltering, 'areaFilt')
    outMask = MorphologicalAreaFiltering(mask, cfg);
    
elseif strcmp(cfg.morphologicalFiltering, 'other')
    outMask = MorphologicalOther(mask, cfg);
end
