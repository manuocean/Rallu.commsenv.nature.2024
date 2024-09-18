function GOA_Map2D(field, data)
% function GOA_Map2D(FIELD, DATA)
% Make a 2D map of a LON/LAT FIELD(lon, lat)
% The data structure DATA contains the coordinates
% DATA.lon, DATA.lat, DATA.mask
% The function plots only the Gulf of Alaska domain

% apply the land/mask
field = field.*data.mask;

in=find(~isnan(field(:)));
if length(in) <=0
    return
end

% make a 2D map using the function pcolor.m
pcolor(data.lon, data.lat, field);
hold on
world_coast('linewidth', 2, 'color', 'k')
shading interp
set(gca,'FontSize',14)
grid on

% display only the region of the GOA
xlim = [-178.3440 -127.3660];
ylim = [48.0514   60.7656];
%ylim = [51.0514   60.7656]
set(gca,'xlim', xlim, 'ylim', ylim)

% select the range of the min/max values to display based on the mean and
% standard deviation
field_std = stdNaN(field(:),1);
field_mean = meanNaN(field(:),1);
range_min = field_mean - field_std*3;
range_max = field_mean + field_std*3;
if range_min ~= range_max
    caxis([range_min range_max])
end

% add a colorbar and set the colormap for the shading of the figure
colorbar;
red_blue_colormap

