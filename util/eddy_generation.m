% Assuming SSHa is a 3D array (lon x lat x time)
% The arrays lon, lat, and time should already be defined.

lon=ssh.lon(:,1);
lat = sq(ssh.lat(1,:));

% Define the spatial resolution (degrees)
dx = mean(diff(lon)); % Resolution in longitude
dy = mean(diff(lat)); % Resolution in latitude

mask = ssh.mask;
%in =find (ssh.lat < 50); mask(in) = nan;
mask = repmat(mask,[1 1 T]);
SSHa = ssh.anod.*mask;

 
% Time derivative of SSH anomalies
dSSHdt = diff(SSHa, 1, 3); % Time derivative along the 3rd dimension

% Preallocate arrays for gradients and vorticity
dSSHdx = nan(size(SSHa)); % SSH gradient in the x-direction (longitude)
dSSHdy = nan(size(SSHa)); % SSH gradient in the y-direction (latitude)
vorticity = nan(size(SSHa)); % Vorticity array

% Loop through time steps to calculate spatial derivatives and vorticity
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


% Eddy Generation Index (EGI)
% Sum the positive vorticity changes to focus on regions of eddy formation


time = (ssh.time(1:end-1)+ssh.time(2:end))/2
in2 = find(time > datenum(2016, 6, 1));
in1 = find(time <= datenum(2016, 6, 1));

dVorticitydt1 = dVorticitydt(:,:,in1);
dVorticitydt2 = dVorticitydt(:,:,in2);

EGI1 = nanmean(max(dVorticitydt1, 0), 3); % Sum over time, ignore negative changes
EGI2 = nanmean(max(dVorticitydt2, 0), 3); % Sum over time, ignore negative changes
EGI = EGI2 - EGI1;

EGI = shapiro2(EGI,2,1,2);

% Plotting the Eddy Generation Index (EGI)
mfig(4);
clf;
GOA_Map2D( EGI, ssh);
caxis([-0.02 0.02]);
shading interp;
colorbar;
title('Eddy Generation Index (EGI)');
xlabel('Longitude');
ylabel('Latitude');
