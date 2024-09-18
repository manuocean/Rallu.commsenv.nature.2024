
function chla = Generate_Chla_Mask(chla)

% make a count of pixels that are not nan in each location of the grid
[I,J] = size(chla.lon);
for i=1:I
    for j=1:J
        tmp = squeeze(chla.chlorl(i,j,:));
        in = find(~isnan(tmp));
        count(i,j) = length(in);
    end
end

% step 1, set to NaN values that have counts lower than 150, this will take
% care of most values over land
mask = count*0 + 1; mask (count < 150) = nan; 


% step 2, define a closed polygod to enclose the bearing sea, 
x = [-180.0946 -177.2667 -174.8974 -172.2606 -169.8913 -167.9424 -165.8406 ...
    -164.1974 -161.9045 -156.8984 -156.9748 -156.9748 -180.3239 -180.1328 -180.0946];
y = [51.8268   51.8268   52.0105   52.3255   52.8768   53.4280   54.0842   54.8717   55.5805 ...
 57.2867   64.0000   64.0000   64.0000   52.2468   51.8268];

% find the points inside the polygon and set than to nan, we do not want to
% retain the bearing sea in this analysis
newMask = mask;
latGrid=chla.lat;
lonGrid=chla.lon;

% Iterate over each point in the mask
for i = 1:size(mask, 1)
    for j = 1:size(mask, 2)
        % Check if the point is inside the polygon
        if inpolygon(lonGrid(i, j), latGrid(i, j), x, y)
            % Modify the value of the mask at this point
            newMask(i, j) = nan; % Set 'newValue' to whatever you want
        end
    end
end

% step3, fix a few land areas on the aletian peninsula that need to be set
% to nan

xlim1 = [-156.8977     -154.3104];
ylim1 = [59.3218      60.0936];
[i,j]=find_IJ(chla.lon, chla.lat, xlim1, ylim1);
newMask(i,j)=nan;

xlim2 = [-156.9938     -156.0797];
ylim2 = [57.7414      58.1461];
[i,j]=find_IJ(chla.lon, chla.lat, xlim2, ylim2);
newMask(i,j)=nan;

% step 4, assign the new mask
chla.mask = newMask;
