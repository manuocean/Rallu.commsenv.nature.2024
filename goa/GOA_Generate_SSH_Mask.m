
function data = Generate_SSH_Mask(data)

% step 2, define a closed polygod to enclose the bearing sea, 
x = [-180.0946 -177.2667 -174.8974 -172.2606 -169.8913 -167.9424 -165.8406 ...
    -164.1974 -161.9045 -156.8984 -156.9748 -156.9748 -180.3239 -180.1328 -180.0946];
y = [51.8268   51.8268   52.0105   52.3255   52.8768   53.4280   54.0842   54.8717   55.5805 ...
 57.2867   64.0000   64.0000   64.0000   52.2468   51.8268];

% find the points inside the polygon and set than to nan, we do not want to
% retain the bearing sea in this analysis
newMask = data.mask;
latGrid=data.lat;
lonGrid=data.lon;

% Iterate over each point in the mask
for i = 1:size(newMask, 1)
    for j = 1:size(newMask, 2)
        % Check if the point is inside the polygon
        if inpolygon(lonGrid(i, j), latGrid(i, j), x, y)
            % Modify the value of the mask at this point
            newMask(i, j) = nan; % Set 'newValue' to whatever you want
        end
    end
end

data.mask = newMask;
