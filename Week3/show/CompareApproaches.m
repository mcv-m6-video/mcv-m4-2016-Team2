function CompareApproaches(varargin)

if nargin < 2
    error('')
end

for ii=1:nargin
    sequences{ii} = varargin{ii}
end

results = extractfield(cell2mat(sequences), 'bestResult');

figure;
numFrames = length(results{1});
for ii=1:numFrames
    for jj = 1:length(results)
        subplot(1, nargin, jj); imshow(results{jj}{ii})
    end
    pause()
end

