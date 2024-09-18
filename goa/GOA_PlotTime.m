function h= GOA_PlotTime(t, y, varargin)

if nargin > 2
   h= plot(t, y, 'linewidth',2, varargin{:});
else
   h= plot(t, y, 'linewidth',2);
end

grid on
set(gca, 'FontSize', 14)
datetick
hold on
