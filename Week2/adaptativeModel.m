function [adapt_mean, adapt_variance] = adaptativeModel(mean, variance, labeledImg, image, rho)

background = image(labeledImg == 0);

adapt_mean = rho*background + (1 - rho)*mean;
adapt_variance = rho*(background - adapt_mean).^2 + (1-rho)*variance;

end