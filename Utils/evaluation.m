function [evaluationFrame, evaluationSequence] = evaluation(setImages, setGT)

TPtotal = []; FNtotal = []; FPtotal = []; TNtotal = [];
ForegoundPxtotal = [];
for idx_img = 1:length(setImages)
%     idx_img
    image   = setImages{idx_img};
    gt      = setGT{idx_img};
    
%     subplot(1, 2, 1); imshow(image==1)
%     subplot(1, 2, 2); imshow(gt==255)
%     pause()
    
    [TPperFrame, FNperFrame, FPperFrame, TNperFrame, ForegroundPxperFrame] = evaluationPerFrame(image, gt);
    
    TPtotal = [TPtotal; TPperFrame];
    FNtotal = [FNtotal; FNperFrame];
    FPtotal = [FPtotal; FPperFrame];
    TNtotal = [TNtotal; TNperFrame]; 
    ForegoundPxtotal = [ForegoundPxtotal; ForegroundPxperFrame];
end

% Evaluation per frame
precision = TPtotal ./(TPtotal + FPtotal);
recall = TPtotal ./(TPtotal + FNtotal);
F = (2.*precision.*recall)./(precision + recall);

evaluationFrame.TP = TPtotal;
evaluationFrame.FN = FNtotal;
evaluationFrame.FP = FPtotal;
evaluationFrame.TN = TNtotal;
evaluationFrame.precision = precision;
evaluationFrame.recall = recall;
evaluationFrame.F = F;
evaluationFrame.ForegroundPx = ForegoundPxtotal;

% Evaluation per sequence
TPtotal_val = sum(TPtotal);
FNtotal_val = sum(FNtotal);
FPtotal_val = sum(FPtotal);
TNtotal_val = sum(TNtotal);

precisionTotal = TPtotal_val /(TPtotal_val + FPtotal_val);
recalllTotal = TPtotal_val /(TPtotal_val + FNtotal_val);

Ftotal =( 2*precisionTotal*recalllTotal )/(precisionTotal+recalllTotal);

evaluationSequence.TP = TPtotal_val;
evaluationSequence.FN = FNtotal_val;
evaluationSequence.FP = FPtotal_val;
evaluationSequence.TN = TNtotal_val;
evaluationSequence.precision = precisionTotal;
evaluationSequence.recall = recalllTotal;
evaluationSequence.F = Ftotal;




