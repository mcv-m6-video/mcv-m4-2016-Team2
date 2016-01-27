cfg = Config();
seq = 'highway';


if strcmp(seq, 'traffic')
    % Traffic
    sequence = LoadTraffic(cfg);
    filteringTraffic = @(x) TrafficFiltering(x);
    sequence.tracking.invisibleForTooLong = 5;
    sequence.ROI = load('ROI.mat');
    sequence.morphFiltering = filteringTraffic;
    sequence.shadowParam = cfg.traffic.shadowParam;

elseif strcmp(seq, 'highway')
    % Highway
    sequence = LoadHighway(cfg);
    filteringHighway = @(x) HighwayFiltering(x);
    sequence.tracking.invisibleForTooLong = 5;
    sequence.tracking.invisibleForTooLong = 5;
    load('ROIH.mat');
    sequence.ROI = roi;
    sequence.morphFiltering = filteringHighway;
    sequence.shadowParam = cfg.highway.shadowParam;
end

trackedObjects = MultipleObjectTracking(sequence);