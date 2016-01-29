cfg = Config();
seq = 'target';


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
    sequence.tracking.invisibleForTooLong = 5;
    load('ROIH.mat');
    sequence.ROI = roi;
    sequence.morphFiltering = filteringHighway;
    sequence.shadowParam = cfg.highway.shadowParam;
    sequence.alpha = 1.1;
    sequence.rho = 0.5;
    sequence.minimumBlobArea = 400; 
    load('HHighway.mat');
    sequence.H = H;
    sequence.px2m = 12; 
    sequence.fps = 25;
elseif strcmp(seq, 'target')
    % Target sequence 90km/h
    sequence = LoadTarget(cfg);
    filteringHighway = @(x) TargetFiltering(x);
    sequence.tracking.invisibleForTooLong = 5;
    load('ROITarget.mat');
    sequence.ROI = imresize(roi, 0.5); %logical(ones(size(sequence.train{1}, 1), size(sequence.train{1}, 2)));
    sequence.morphFiltering = filteringHighway;
    sequence.shadowParam = cfg.target.shadowParam;
    sequence.alpha = 3;
    sequence.rho = 0.5;
    sequence.minimumBlobArea = 500; 
    load('HTarget.mat');
    sequence.H = H;
    sequence.px2m = 32.9; 
    sequence.fps = 30.093;
end

trackedObjects = MultipleObjectTracking(sequence);