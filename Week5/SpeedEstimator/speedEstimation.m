function speed = speedEstimation(trackHistorial, H, px2m, fps)

initPoint1 = trackHistorial.centroid(1, :); % x y
endPoint1 = trackHistorial.centroid(end, :); % x y

numFrames = size(trackHistorial.centroid, 1);

% dx = abs(endPoint1(1) - initPoint1(1));
% dy = abs(endPoint1(2) - initPoint1(2));
% 
% dxM = dx/21;
% dyM = dy/35;
% 
% distance = sqrt(dxM^2 + dyM^2);
initPoint1H = makehomogeneous(initPoint1');
initPoint2H = H*initPoint1H;
initPoint2(1) = initPoint2H(1) / initPoint2H(3);
initPoint2(2) = initPoint2H(2) / initPoint2H(3);

endPoint1H = makehomogeneous(endPoint1');
endPoint2H = H*endPoint1H;
endPoint2(1) = endPoint2H(1) / endPoint2H(3);
endPoint2(2) = endPoint2H(2) / endPoint2H(3);

distance = sqrt(sum((endPoint2 - initPoint2) .^ 2));

speed = ((fps/numFrames)*(distance/px2m))*0.001*3600;
