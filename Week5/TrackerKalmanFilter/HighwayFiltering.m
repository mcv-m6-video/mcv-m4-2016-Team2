function filteredMask = HighwayFiltering(mask)
mask = imfill(mask, 'holes');
%         mask = imopen(mask, strel('rectangle', [7,7]));
filteredMask = imreconstruct(imerode(mask, strel('disk', 3)), mask);
%         mask = bwconvhull(mask, 'objects', 8);
%         mask = imopen(mask, strel('disk', 10));
filteredMask = imclose(filteredMask, strel('disk', 5));
filteredMask = imopen(filteredMask, strel('disk', 7));
filteredMask = bwconvhull(filteredMask, 'objects', 4);
%         mask = imclose(mask, strel('rectangle', [10 40]));
%         mask = imfill(mask, 'holes');

end

