function [rss,rbs] = calc_rssrbs(SMC,LAI,rbs)
global SaturatedMC ResidualMC fieldMC
% aa=3.8;
% rss = exp((aa+4.1)-aa*(SMC-ResidualMC(1))/(fieldMC(1)-ResidualMC(1)));
rss = exp(7.6-1.5*(SMC-0.0875)/(0.25-0.0875));
rbs            = rbs*LAI/4.3;