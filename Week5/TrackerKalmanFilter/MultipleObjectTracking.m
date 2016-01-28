function trackedObjs = MultipleObjectTracking(sequence)

% Create System objects used for reading video, detecting moving objects,
% and displaying the results.
obj = setupSystemObjects(sequence);

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track
trackedObjs = [];

% Detect moving objects, and track them across video frames
for ii = 1:length(obj.reader.frames)
    frame = readFrame();
    [centroids, bboxes, mask] = detectObjects(frame);
    predictNewLocationsOfTracks();
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment();
    
    updateAssignedTracks();
    updateUnassignedTracks();
    deleteLostTracks();
    createNewTracks();
    
    displayTrackingResults();
end

deleteAllTracks();


    function tracks = initializeTracks()
        
        % create an empty array of tracks
        tracks = struct(...
            'id', {}, ...
            'bbox', {}, ...
            'kalmanFilter', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'consecutiveInvisibleCount', {});
    end

    function frame = readFrame()
        frame = obj.reader.frames{obj.reader.index};
        obj.reader.index = obj.reader.index + 1;
    end
    function [centroids, bboxes, mask] = detectObjects(frame)
        
        % Detect foreground.
        mask = ObjectDetector(frame, obj);
%         mask = RemoveShadow(frame, mask, obj);%obj.detector.step(frame);
        mask = mask & sequence.ROI; 
        % Apply morphological operations to remove noise and fill in holes.
%         mask2 = mask;
        mask = sequence.morphFiltering(mask);
%         figure(1); imshow(mask2)

        % Perform blob analysis to find connected components.
        [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
        
    end

    function predictNewLocationsOfTracks()
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;
            
            % Predict the current location of the track.
            predictedCentroid = predict(tracks(i).kalmanFilter);
            
            % Shift the bounding box so that its center is at
            % the predicted location.
            predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
            tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
    end

    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()
        
        nTracks = length(tracks);
        nDetections = size(centroids, 1);
        
        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end
        
        % Solve the assignment problem.
        costOfNonAssignment = 20;
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);
    end

    function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);
            
            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);
            
            % Replace predicted bounding box with detected
            % bounding box.
            tracks(trackIdx).bbox = bbox;
            
            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;
            
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
            trackIdx = tracks(trackIdx).id;
            trackedObjs{trackIdx}.centroid(end+1, :) = centroid;
        end
    end
    function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
        end
    end
    function deleteLostTracks()
        if isempty(tracks)
            return;
        end
        
        invisibleForTooLong = obj.tracking.invisibleForTooLong; %%20;
        ageThreshold = 8;
        
        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;
        
        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & visibility < 0.6) | ...
            [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
        
        
        if lostInds > 0
            for speedIdx = 1:length(lostInds)
                trackHistorial = trackedObjs{tracks(lostInds(speedIdx)).id};
                speed = speedEstimation(trackHistorial, sequence.H, ...
                                        sequence.px2m, sequence.fps);
                trackedObjs{tracks(lostInds(speedIdx)).id}.speed = speed;
                
            end
        end
        
        
        % Delete lost tracks.
        tracks = tracks(~lostInds);
    end
    function deleteAllTracks()
        if isempty(tracks)
            return;
        end
        
        numTracks = length(tracks);
        for i = 1:numTracks
            trackHistorial = trackedObjs{tracks(i).id};
            speed = speedEstimation(trackHistorial, sequence.H, ...
                sequence.px2m, sequence.fps);
            trackedObjs{tracks(lostInds(speedIdx)).id}.speed = speed;
            
        end
    end
    function createNewTracks()
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);
        
        for i = 1:size(centroids, 1)
            
            centroid = centroids(i,:);
            bbox = bboxes(i, :);
            % Initialize a track by creating a Kalman filter object when
            % the object is detected for the first time.
            % Param:
            % motionModel, initialLocation, initialEstimateError,
            % motionNoise, measurementNoise
            kalmanFilter = configureKalmanFilter(...
                obj.kalmanFilter.motionModel, centroid,...
                obj.kalmanFilter.initialEstimateError, ...
                obj.kalmanFilter.motionNoise, ...
                obj.kalmanFilter.measurementNoise);
            
            % Create a new track.
            newTrack = struct(...
                'id', nextId, ...
                'bbox', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0);
            
            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;
            
            % Increment the next id.
            nextId = nextId + 1;
            
            object.id = newTrack.id;
            object.centroid = centroid;
            if length(trackedObjs) < object.id
                trackedObjs{end+1} = object;
            else
                trackedObjs{object.id} = object;
            end
        end
    end
    function displayTrackingResults()
        % Convert the frame and the mask to uint8 RGB.
%         frame = im2uint8(frame);
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        
        minVisibleCount = 0;
        if ~isempty(tracks)
            
            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than
            % a minimum number of frames.
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);
            
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                % Create labels for objects indicating the ones for
                % which we display the predicted rather than the actual
                % location.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);
                
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end
        
        % Display the mask and the frame.
        obj.maskPlayer.step(mask);
        obj.videoPlayer.step(frame);
    end
end