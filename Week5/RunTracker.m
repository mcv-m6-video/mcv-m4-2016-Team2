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
    sequence.alpha = 1.5;
    sequence.rho = 0.2;
    sequence.minBlob = 600;

elseif strcmp(seq, 'highway')
    % Highway
    sequence = LoadHighway(cfg);
    filteringHighway = @(x) HighwayFiltering(x);
    sequence.tracking.invisibleForTooLong = 6;
    load('ROIH.mat');
    sequence.ROI = roi;
    sequence.morphFiltering = filteringHighway;
    sequence.shadowParam = cfg.highway.shadowParam;
    sequence.alpha = 1.4;
    sequence.rho = 0.2;
    sequence.minBlob = 500;
end

trackedObjects = MultipleObjectTracking(sequence);