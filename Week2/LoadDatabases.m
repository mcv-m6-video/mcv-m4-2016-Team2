function [ highway, fall, traffic ] = LoadDatabases( cfg )
%LOADDATABASES Summary of this function goes here
%   Detailed explanation goes here

highway.train = LoadImages(cfg.highway.inputPath, );
highwat.test = LoadImages(cfg.highway.inputPath);
highway.gt = LoadImages(cfg.highway.gtPath);

fall.images = LoadImages(cfg.highway.fall
fall.gt = LoadImages(

traffic.images

end

