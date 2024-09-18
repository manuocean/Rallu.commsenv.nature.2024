function [seas, seas_ano, ano] = Remove_Seasonal_Cycle(field, months)
% [seas_mean, ano] = Remove_Seasonal_Cycle(field, months)
% This function computes the seasonal cycle from a 3D array 
% FIELD(lon, lat, time) and returns the seasonal cycle in SEAS, and also it
% removes the seasonal cycle from the data to produce an anomaly 
% ANO(lon, lat, time). This function expects data that is at monthly
% resolutions and it requires an array of the MONTHS(time)

% compute seasonal cycle
for imon = 1:12
    ind = find (months == imon);
    seas(:,:,imon) = meanNaN(field(:,:,ind) ,3);
end

% compute the seasonal anomalies from the long-term mean
longterm_mean = meanNaN(field,3);
for imon = 1 : 12
    seas_ano(:,:,imon) = seas(:,:,imon) - longterm_mean;
end

% compute the anomalies from the seasonal cycle

[I,J,N] = size(field);

for i = 1:N 
    imon = months(i);
    ano(:,:,i) = field(:,:,i) - seas(:,:,imon);
end 
