
%% Compute time derivtive of the vorticity as a measure of the eddies growth 
% EGI Index = Eddy Growith Index

% Assuming SSHa is a 3D array (lon x lat x time)
% The arrays lon, lat, and time should already be defined.
lon = ssh.lon(:,1);
lat = sq(ssh.lat(1,:));

% Constants
Omega = 7.2921e-5; % Earth's angular velocity in rad/s
deg2rad = pi / 180; % Conversion factor from degrees to radians

% Calculate the Coriolis parameter (f) as a function of latitude
f = 2 * Omega * sin(lat * deg2rad); % f will be a 1D array of size [lat, 1]


% Define the spatial resolution (degrees)
dx = mean(diff(lon)); % Resolution in longitude
dy = mean(diff(lat)); % Resolution in latitude

T = size(ssh.anod,3);
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

% Compute the standard deviation of the vorticity over the entire domain and time
vorticity_std = nanstd(vorticity(:));

% Set the vorticity thresholds based on 3 times the standard deviation
positive_vorticity_threshold = 3 * vorticity_std;
negative_vorticity_threshold = -3 * vorticity_std;

% Initialize the time-dependent Eddy Generation Index (EGI) arrays
EGI_time_large_positive_vortices = nan(1, size(dVorticitydt, 3)); % Preallocate for positive vortices
EGI_time_large_negative_vortices = nan(1, size(dVorticitydt, 3)); % Preallocate for negative vortices

%dVorticitydt = abs(dVorticitydt);

% Calculate EGI at each time step for large positive and negative vortices
for t = 1:size(dVorticitydt, 3)
    % Consider only positive vorticity changes that exceed the positive threshold
%     vort = dVorticitydt(:,:,t) - positive_vorticity_threshold;
%     vort = max(vort,0);
%     mfig(3); clf
%     GOA_Map2D(vort, ssh);
%     caxis([-0.1 0.1])

    large_positive_vorticity_change = max(dVorticitydt(:,:,t) - positive_vorticity_threshold, 0);
    
%     % Consider only negative vorticity changes that exceed the negative threshold
%     vort = dVorticitydt(:,:,t) - negative_vorticity_threshold;
%     vort = min(vort,0);
%     mfig(3); clf
%     GOA_Map2D(vort, ssh);
%     caxis([-0.1 0.1])
    
    large_negative_vorticity_change = min(dVorticitydt(:,:,t) - negative_vorticity_threshold, 0);
    
    % Sum over all grid points to get a basin-wide EGI value for each time step
    EGI_time_large_positive_vortices(t) = nansum(large_positive_vorticity_change(:));
    EGI_time_large_negative_vortices(t) = abs(nansum(large_negative_vorticity_change(:)));
end

EGI = EGI_time_large_positive_vortices + EGI_time_large_negative_vortices;
%EGI_time_large_positive_vortices = nn(EGI_time_large_positive_vortices-mean(EGI_time_large_positive_vortices));
%EGI_time_large_negative_vortices = nn(EGI_time_large_negative_vortices-mean(EGI_time_large_negative_vortices));
EGI = nn(EGI - mean(EGI));
EGI_time_large_positive_vortices = EGI;
time = (ssh.time(1:end-1)+ssh.time(2:end))/2;

clear EGI
EGI.time = time;
EGI.index = EGI_time_large_positive_vortices;
save data/EGI_Index.mat EGI

mfig(1); 
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);

% Plot the time-dependent EGI for large positive and negative vortices
clf;
GOA_PlotTime(time,EGI_time_large_positive_vortices,'color',gpcol(5));
%GOA_PlotTime(time,EGI_time_large_negative_vortices,'color',gpcol(2));
in2 = find(time > datenum(2016, 6, 1));
in1 = find(time <= datenum(2016, 6, 1));
m1 = mean(EGI_time_large_positive_vortices(in1));
m2 = mean(EGI_time_large_positive_vortices(in2));
plot(time(in1), repmat(m1, [length(in1) 1]), 'LineWidth',2,'color','k');
plot(time(in2), repmat(m2, [length(in2) 1]), 'LineWidth',2,'color','k');
m2-m1
set(gca, 'ylim',[-2 3.5])
set(gca, 'xlim',[ssh.time(1) ssh.time(end)])
%xlabel('Time');
%ylabel('Eddy Growth Index (EGI)');
lpr fig_4_EGI_index.eps


EGI_map_mean = nanmean(abs(dVorticitydt), 3); % Sum over time, ignore negative changes

time = (ssh.time(1:end-1)+ssh.time(2:end))/2;
in2 = find(time > datenum(2016, 6, 1));
in1 = find(time <= datenum(2016, 6, 1));
dVorticitydt1 = dVorticitydt(:,:,in1);
dVorticitydt2 = dVorticitydt(:,:,in2);
EGI1 = nanmean(abs(dVorticitydt1), 3); % Sum over time, ignore negative changes
EGI2 = nanmean(abs(dVorticitydt2), 3); % Sum over time, ignore negative changes
EGI_map_diff = EGI2 - EGI1;
EGI_map_diff = shapiro2(EGI_map_diff,2,1,1);

% Plotting the Eddy Generation Index (EGI)
mfig(2);
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);
fac = stdNaN(EGI_map_mean(:),1)
clf;
GOA_Map2D( EGI_map_diff./fac, ssh);
caxis([-.7 .7]);
shading interp;
colorbar;
%title('Eddy Growth Index (EGI) Difference');
%xlabel('Longitude');
%ylabel('Latitude');
lpr fig_4_EGI_index_diff_map.eps


mfig(3);
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);
clf;
GOA_Map2D( EGI_map_mean, ssh);
caxis([0.0 0.35]);
shading interp;
colorbar;
lpr fig_4_EGI_index_map.eps
%title('Eddy Growth Index (EGI)');
%xlabel('Longitude');
%ylabel('Latitude');

%% Significance text
mfig(4)
% Significance test of changes in mean of Anticylonic eddy
ind = EGI.index';
coefs=aryule(ind, 1); 
alfa = abs(coefs(2))
in1 = find(EGI.time <= datenum(2016,5,1));
in2 = find(EGI.time > datenum(2016,5,1));
m1 = mean(ind(in1));
m2 = mean(ind(in2));
disp(['Change in mean (STD units) = ',num2str(m2-m1)]);

T=length(EGI.time);

clf
plot(ind)
for k=1:10000
    s=AR1_model_alfa(1:T, randn(T,1), alfa);
    m1 = mean(s.sig(in1));
    m2 = mean(s.sig(in2));
    mdiff(k)= m2-m1;
end
hist(mdiff, 30)
prctile(mdiff, 97)
prctile(mdiff, 95)



