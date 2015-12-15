function [ LoadedImages, filenames ] = LoadFlowResults( inputPath, varargin )

    resultsFilenames = dir([ inputPath, '*.png']);
    filenames = extractfield(resultsFilenames, 'name');


    if nargin == 2
        %Means that we are loading the results, so we need the gtNames to
        %keep the order between images.
        gtNames = varargin{1};
        
        %We remove the part of the name that is not equal in the gt.
        toSortNames = cellfun(@(c) c(8:end), ...
                     {resultsFilenames.name},'UniformOutput',false);
    else
        %we are loading the gt    
        gtNames = filenames;
        toSortNames = filenames;
    end
    
    %We make sure that the images are computed in the same order.
    order = find(ismember(gtNames, toSortNames));
    
    for index = 1:length(resultsFilenames)
        
        filename = filenames{order(index)};
        
        LoadedImages{index} = imread( [inputPath filename] );
    end

end