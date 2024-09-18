function h = plot_timeseries(t, y, varargin)
% plot_timeseries: Plot a time series with optional additional plot properties
%
% This function plots a time series given time and data vectors. Additional
% plot properties can be specified using optional input arguments.
%
% Inputs:
%   t        - A vector of time values.
%   y        - A vector of data values corresponding to the time values.
%   varargin - Optional additional plot properties specified as name-value pairs.
%
% Outputs:
%   h - Handle to the plot object.

% Check if additional plot properties are provided
if nargin > 2
    h = plot(t, y, 'linewidth', 2, varargin{:}); % Plot with additional properties
else
    h = plot(t, y, 'linewidth', 2); % Plot with default properties
end

% Turn on the grid
grid on

% Set font size for the current axes
set(gca, 'FontSize', 14)

% Format the x-axis as date
datetick

% Hold the current plot to allow for additional plotting
hold on

end
