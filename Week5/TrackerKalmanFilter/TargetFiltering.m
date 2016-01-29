function filteredMask = TargetFiltering(mask)
% filteredMask = mask;
filteredMask = imreconstruct(imerode(mask, strel('disk', 5)), mask);;