function [xlim, ylim] = get_bounds

xlim = get(gca, 'xlim');
ylim = get(gca, 'ylim');

disp(['xlim = [',num2str(xlim),'];']);
disp(['ylim = [',num2str(ylim),'];']);