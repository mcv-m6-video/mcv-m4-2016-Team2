
function [R, P, Q] = FWeightedMeasure(FG, GT)
% FWeightedMeasure : Computes the Weighted F-beta Measure 
% Proposed in "How to Evaluate Foreground Maps?" [Margolin et. al - CVPR'14])
%
% Input :
%   FG - Binary / Non binary foreground map (double values in the range [0 1])
%   GT - Logical binary ground truth
% Output :
%   R - The Weighted Recall
%   P - The Weighted Precision
%   Q - The Weighted F-beta score

    % Check input
    if (~isa(FG, 'double'))
        error('FG should be of type: double');
    end
    if ((max(FG(:)) > 1) || min(FG(:)) < 0)
        error('FG should be in the range of [0 1]');
    end
    if (~islogical(GT))
        error('GT should be of type: logical');
    end

    dGT = double(GT);
    E = abs(FG - dGT);
    [Dst, IDXT] = bwdist(dGT);
    
    % Pixel dependency
    K = fspecial('gaussian', 7, 5);
    Et = E;
    Et(~GT) = Et(IDXT(~GT)); % Deal correctly with the foreground region edges
    EA = imfilter(Et, K);
    MIN_E_EA = E;
    MIN_E_EA(GT & EA < E) = EA(GT & EA < E);
    % Pixel importance
    B = ones(size(GT));
    B(~GT) = 2 - 1 * exp(log(1 - 0.5) / 5 .* Dst(~GT));
    Ew = MIN_E_EA .* B;

    TPw = sum(dGT(:)) - sum(sum(Ew(GT))); 
    FPw = sum(sum(Ew(~GT)));

    % Weighed Recall
    R = 1 - mean2(Ew(GT));
    % Weighted Precision
    P = TPw ./ (eps + TPw + FPw);
    % Weighted F-beta
    Q = (2) * (R * P) ./ (eps + R + P); % Beta = 1 (effectiveness of detection)
end