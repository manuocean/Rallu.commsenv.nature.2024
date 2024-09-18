
function ts = get_ts_poly(ano, chla, x, y)


% find the points inside the polygon and set than to nan, we do not want to
% retain the bearing sea in this analysis
newMask = chla.mask*nan;
latGrid=chla.lat;
lonGrid=chla.lon;
x=[-165.3296 -161.7652 -156.2701 -152.1611 -148.3986 -145.9234 -145.8739 -149.8838 -152.8542 -154.2403 -155.5770 -158.8939 ...
     -161.8642 -166.9138 -172.8050 -175.5278 -174.4882 -167.7554 -165.3296];
y =[53.5604   53.9741   55.3745   56.8703   58.6207   58.2706   56.8066   54.6425   54.1969   53.0512   52.2555   52.1919 ...
    51.5554   51.1416   50.5688   50.5051   51.8736   53.1467   53.5604];

% Iterate over each point in the mask
for i = 1:size(chla.mask, 1)
    for j = 1:size(chla.mask, 2)
        % Check if the point is inside the polygon
        if inpolygon(lonGrid(i, j), latGrid(i, j), x, y)
            % Modify the value of the mask at this point
            newMask(i, j) = 1; % Set 'newValue' to whatever you want
        end
    end
end

[I,J,T]=size(ano);
ano = ano.*repmat(newMask, [1 1 T]);
ts = squeeze(meanNaN(meanNaN(ano,1),2));
ts = squeeze(meanNaN(meanNaN(abs(ano),1),2));
tssl = squeeze(meanNaN(meanNaN((ano),1),2));


x=[ -170.195553414097
         -160.045865455213
         -154.999059287812
         -147.989606277533
         -140.755850770925
         -137.335237701909
         -139.353960168869
          -142.38204386931
         -154.101849302496
         -163.802932268722
         -169.52264592511
          -173.27971273862
         -175.242359581498
         -174.064771475771
         -171.597444016153
         -170.195553414097];


y = [  48.5076294697904
          50.5068074393753
          52.3185624743115
          54.1615546650226
          55.9733096999589
          57.3789817098233
           59.003313810111
          59.3469225236334
          55.8795982326346
           53.318151459104
           52.131139539663
          50.7879418413481
          50.2569101931771
          48.7575267159885
          48.3202065351418
          48.5076294697904];

windowSize = 5 * 12;
y=ts;

% Compute the moving average
movingAvg = movmean(y, windowSize);

