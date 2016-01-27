cfg = Config();

% Traffic
sequence = LoadTraffic(cfg);

filteringTraffic = @(x) TrafficFiltering(x);
sequence.tracking.invisibleForTooLong = 5;
sequence.morphFiltering = filteringTraffic;

% Highway
% sequence = LoadHighway(cfg);


trackedObjects = MultipleObjectTracking(sequence);