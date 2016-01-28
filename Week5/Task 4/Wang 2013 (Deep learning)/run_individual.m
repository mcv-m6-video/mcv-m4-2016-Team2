%     loads data and initializes variables
%
% Copyright (C) Jongwoo Lim and David Ross.
% Modified by Naiyan Wang
% All rights reserved.

% DESCRIPTION OF OPTIONS:
%
% Following is a description of the options you can adjust for
% tracking, each proceeded by its default value.  For a new sequence
% you will certainly have to change p.  To set the other options,
% first try using the values given for one of the demonstration
% sequences, and change parameters as necessary.
%
% p = [px, py, sx, sy, theta]; The location of the target in the first
% frame.
% px and py are th coordinates of the centre of the box
% sx and sy are the size of the box in the x (width) and y (height)
%   dimensions, before rotation
% theta is the rotation angle of the box
%
% 'numsample',1000,   The number of samples used in the condensation
% algorithm/particle filter.  Increasing this will likely improve the
% results, but make the tracker slower.
%
% 'condenssig',0.01,  The standard deviation of the observation likelihood.
%
% 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
% the dynamics distribution, that is how much we expect the target
% object might move from one frame to the next.  The meaning of each
% number is as follows:
%    affsig(1) = x translation (pixels, mean is 0)
%    affsig(2) = y translation (pixels, mean is 0)
%    affsig(3) = x & y scaling
%    affsig(4) = rotation angle
%    affsig(5) = aspect ratio
%    affsig(6) = skew angle
clear all
cfg = Config();

highway = LoadHighway(cfg);

title = 'highway'

p = [220 10 23 23 0.0];
opt = struct('numsample',1000,'affsig',[8,8,.01,.000,.001,.000]);

% The number of previous frames used as positive samples.
opt.maxbasis = 10;
opt.updateThres = 0.8;
% Indicate whether to use GPU in computation.
% global useGpu;
% useGpu = true;
opt.condenssig = 0.01;
opt.tmplsize = [32, 32];
opt.normalWidth = 320;
opt.normalHeight = 240;
seq.init_rect = [p(1) - p(3) / 2, p(2) - p(4) / 2, p(3), p(4), p(5)];

completePath  = arrayfun(@(c)sprintf('%s%s%06d.%s',cfg.highway.inputPath, 'in' , c, 'jpg') , cfg.highway.testFrames,...
                'UniformOutput', false);
            
seq.s_frames = completePath';

seq.opt = opt;
results = run_DLT(seq, 'results', true);
save([title '_res'], 'results');