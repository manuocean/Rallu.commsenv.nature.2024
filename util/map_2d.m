function map_2d(field, data)
% Map2d: Create a 2D map plot of a given field with coastlines
%
% This function plots the long-term mean of a given field over a specified
% geographical region with coastlines overlaid. The field data is masked to 
% highlight the region of interest.
%
% Inputs:
%   field - (unused in this function, but typically represents the field name or description)
%   data  - A structure containing the following fields:
%           .lon  - Longitude values (2D array)
%           .lat  - Latitude values (2D array)
%           .mean - Mean values of the field to be plotted (2D array)
%           .mask - Mask array to highlight the region of interest (2D array)

% Plot the long-term mean field data using pcolor
% Apply the mask to highlight the region of interest
pcolor(data.lon, data.lat, field.* data.mask);

% Use interpolated shading for smooth color transitions
shading interp

% Hold the current plot to overlay additional graphical elements
hold on

% Add coastlines to the plot
% Adjust the linewidth and color for better visibility
world_coast('linewidth', 2, 'color', 'k');

% Add labels to the X-axis and Y-axis
xlabel('Longitude W');
ylabel('Latitude');

% Release the hold on the current plot
hold off

% Increase the default font of the figure to 14
set(gca, 'FontSize', 14);

% Add colorbar
colorbar

end
