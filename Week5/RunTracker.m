cfg = Config();
seq = 'traffic';


if strcmp(seq, 'traffic')
    % Traffic
    sequence = LoadTraffic(cfg);
    filteringTraffic = @(x) TrafficFiltering(x);
    sequence.tracking.invisibleForTooLong = 5;
    load('ROIT2.mat');
    sequence.ROI = roi;
    sequence.morphFiltering = filteringTraffic;
    sequence.shadowParam = cfg.traffic.shadowParam;
    sequence.alpha = 1.5;
    sequence.rho = 0.2;
    sequence.minimumBlobArea = 600;
    load('HTraffic.mat');
    sequence.H = H;
    sequence.px2m = 12; 
    sequence.fps = 25; %30
    
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
    sequence.minimumBlobArea = 500; 
    load('HHighway.mat');
    sequence.H = H;
    sequence.px2m = 12; 
    sequence.fps = 12;
end

trackedObjects = MultipleObjectTracking(sequence);