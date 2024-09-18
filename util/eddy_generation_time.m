% Assuming SSHa is a 3D array (lon x lat x time)
% The arrays lon, lat, and time should already be defined.

lon=ssh.lon(:,1);
lat = sq(ssh.lat(1,:));

% Define the spatial resolution (degrees)
dx = mean(diff(lon)); % Resolution in longitude
dy = mean(diff(lat)); % Resolution in latitude

mask = repmat(ssh.mask,[1 1 T]);
SSHa = ssh.anod.*mask;

% Preallocate arrays for gradients and vorticity
dSSHdx = nan(size(SSHa)); % SSH gradient in the x-direction (longitude)
dSSHdy = nan(size(SSHa)); % SSH gradient in the y-direction (latitude)
vorticity = nan(size(SSHa)); % Vorticity array

% Loop through time steps to calculate spatial gradients and vorticity
for t = 1:size(SSHa, 3)
    % Calculate spatial gradients, ignoring NaN values
    [dSSHdx(:,:,t), dSSHdy(:,:,t)] = gradient(SSHa(:,:,t), dx, dy);
    
    % Geostrophic velocities (ignoring constant Coriolis and other factors for simplicity)
    u_g = -dSSHdy(:,:,t); % Geostrophic velocity in x (u_g)
    v_g = dSSHdx(:,:,t); % Geostrophic velocity in y (v_g)
    
    % Compute relative vorticity
    [dug_dy, ~] = gradient(u_g, dy, dx);
    [~, dvg_dx] = gradient(v_g, dy, dx);
    
    vorticity(:,:,t) = dvg_dx - dug_dy;
end

% Time derivative of vorticity
dVorticitydt = diff(vorticity, 1, 3); % Time derivative along the 3rd dimension

% Initialize the time-dependent Eddy Generation Index (EGI) array
EGI_time = nan(1, size(dVorticitydt, 3)); % Preallocate for the time series

% Calculate EGI at each time step
for t = 1:size(dVorticitydt, 3)
    % Consider only positive vorticity changes
    positive_vorticity_change = max(dVorticitydt(:,:,t), 0);
    
    % Sum over all grid points to get a basin-wide EGI value for each time step
    EGI_time(t) = nansum(positive_vorticity_change(:));
end

% Plot the time-dependent EGI
mfig(1); clf
time = (ssh.time(1:end-1)+ssh.time(2:end))/2
GOA_PlotTime(time,EGI_time);
%plot(time(2:end), EGI_time, 'LineWidth', 2);
xlabel('Time');
ylabel('Eddy Generation Index (EGI)');
title('Time-Dependent Eddy Generation Index (EGI) Over the Basin');
grid on;


% Assuming SSHa is a 3D array (lon x lat x time)
% The arrays lon, lat, and time should already be defined.

% Define the spatial resolution (degrees)
dx = mean(diff(lon)); % Resolution in longitude
dy = mean(diff(lat)); % Resolution in latitude

% Preallocate arrays for gradients and vorticity
dSSHdx = nan(size(SSHa)); % SSH gradient in the x-direction (longitude)
dSSHdy = nan(size(SSHa)); % SSH gradient in the y-direction (latitude)
vorticity = nan(size(SSHa)); % Vorticity array

% Loop through time steps to calculate spatial gradients and vorticity
for t = 1:size(SSHa, 3)
    % Calculate spatial gradients, ignoring NaN values
    [dSSHdx(:,:,t), dSSHdy(:,:,t)] = gradient(SSHa(:,:,t), dx, dy);
    
    % Geostrophic velocities (ignoring constant Coriolis and other factors for simplicity)
    u_g = -dSSHdy(:,:,t); % Geostrophic velocity in x (u_g)
    v_g = dSSHdx(:,:,t); % Geostrophic velocity in y (v_g)
    
    % Compute relative vorticity
    [dug_dy, ~] = gradient(u_g, dy, dx);
    [~, dvg_dx] = gradient(v_g, dy, dx);
    
    vorticity(:,:,t) = dvg_dx - dug_dy;
end

% Time derivative of vorticity
dVorticitydt = diff(vorticity, 1, 3); % Time derivative along the 3rd dimension

% Compute the standard deviation of the vorticity over the entire domain and time
vorticity_std = nanstd(vorticity(:));

% Set the vorticity threshold based on the standard deviation
vorticity_threshold = 3 * vorticity_std; % Example: 2 standard deviations above the mean

% Initialize the time-dependent Eddy Generation Index (EGI) array
EGI_time_large_vortices = nan(1, size(dVorticitydt, 3)); % Preallocate for the time series

% Calculate EGI at each time step for large positive vortices
for t = 1:size(dVorticitydt, 3)
    % Consider only positive vorticity changes that exceed the threshold
    large_positive_vorticity_change = max(dVorticitydt(:,:,t) - vorticity_threshold, 0);
    
    % Sum over all grid points to get a basin-wide EGI value for each time step
    EGI_time_large_vortices(t) = nansum(large_positive_vorticity_change(:));
end



% Plot the time-dependent EGI
mfig(2); clf
time = (ssh.time(1:end-1)+ssh.time(2:end))/2
GOA_PlotTime(time,EGI_time_large_vortices);
%plot(time(2:end), EGI_time, 'LineWidth', 2);
xlabel('Time');
ylabel('Eddy Generation Index (EGI)');
title('Time-Dependent Eddy Generation Index (EGI) Over the Basin');
grid on;


