function [adapt_mean, adapt_variance] = AdaptativeModel(mean, variance, labeledImg, image, rho)

% 
background = labeledImg == 0;

adapt_mean = mean;
adapt_variance = variance;

adapt_mean(background) = rho*image(background)+ (1 - rho)*mean(background);
adapt_variance(background) = rho*(image(background) - adapt_mean(background)).^2 + (1-rho)*variance(background);

end