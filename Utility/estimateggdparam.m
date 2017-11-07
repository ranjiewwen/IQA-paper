function [gamparam sigma] = estimateggdparam(vec)  % vec=I(i,j)



gam                              = 0.2:0.001:10;
r_gam                            = (gamma(1./gam).*gamma(3./gam))./((gamma(2./gam)).^2);  %gamma º¯Êý

sigma_sq                         = mean((vec).^2);
sigma                            = sqrt(sigma_sq);
E                                = mean(abs(vec));
rho                              = sigma_sq/E^2;
[min_difference, array_position] = min(abs(rho - r_gam));
gamparam                         = gam(array_position);  






