
clear
%% Load the datasets for the analysis
[ssh, sst, chla, slp] = GOA_LoadData_Obs;

vstress = Load_vstress;
ustress = Load_ustress;

xlim = [-178.3440 -127.3660];
ylim = [48.0514   60.7656];

[i,j]=find_IJ(vstress.lon, vstress.lat, xlim, ylim);
% Resample the fields
vstress_resampled.time = vstress.time;
vstress_resampled.year = vstress.year;
vstress_resampled.month = vstress.month;
vstress_resampled.lon = vstress.lon(i, j);
vstress_resampled.lat = vstress.lat(i, j);
vstress_resampled.field = vstress.field(i, j, :);
vstress_resampled.mask = vstress.mask(i, j);
vstress_resampled.clima = vstress.clima(i, j, :);
vstress_resampled.ano = vstress.ano(i, j, :);

ustress_resampled.time = ustress.time;
ustress_resampled.year = ustress.year;
ustress_resampled.month = ustress.month;
ustress_resampled.lon = ustress.lon(i, j);
ustress_resampled.lat = ustress.lat(i, j);
ustress_resampled.field = ustress.field(i, j, :);
ustress_resampled.mask = ustress.mask(i, j);
ustress_resampled.clima = ustress.clima(i, j, :);
ustress_resampled.ano = ustress.ano(i, j, :);

ustress=ustress_resampled;
vstress=vstress_resampled;

mfig(3)
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);


% SLPa
clf;
in1 = find(slp.year >= 2013 & slp.year <= 2023); size(in1)
GOA_Map2D(meanNaN(slp.ano(:,:,in1),3), slp);
caxis([-1.5 1.5])
%contour(ssh.lon, ssh.lat, ssh.mean.*ssh.mask, 10, 'color','k', 'linewidth',1.3)


in = find(vstress.year > 2013 & vstress.year <= 2023); size(in)
u = -meanNaN(ustress.ano(:,:,in),3);
v = -meanNaN(vstress.ano(:,:,in),3);


% Create the quiver plot
% hold on
% quiver(ustress.lon, ustress.lat, u, v,'k', 'LineWidth', 2, 'AutoScaleFactor', 0.8, 'MaxHeadSize', 10);


% Define constants
rho = 1025; % density of seawater in kg/m^3
Omega = 7.2921e-5; % Earth's rotation rate in rad/s

% Latitude of the Gulf of Alaska
phi = vstress.lat; % adjust this to the appropriate latitude in degrees

% Convert latitude to radians
phi_rad = deg2rad(phi);

% Coriolis parameter
f = 2 * Omega * sin(phi_rad);

% Load or define wind stress components (tau_x, tau_y)
% tau_x and tau_y should be arrays of the same size representing wind stress
% in the x (eastward) and y (northward) directions, respectively.

% Compute Ekman transport components
M_x = v ./ (rho * f); % Ekman transport in the x-direction (m^2/s)
M_y = -u ./ (rho * f); % Ekman transport in the y-direction (m^2/s)

% Compute the net Ekman transport magnitude
M_magnitude = sqrt(M_x.^2 + M_y.^2);

hold on
quiver(ustress.lon, ustress.lat, M_x, M_y,'b', 'LineWidth', 2, 'AutoScaleFactor', 0.8, 'MaxHeadSize', 10);
lpr fig_1c_slp_ano_elman_2013.eps


%% Figure 2

xlim = [-167.4565     -122.0886];
ylim = [37.5794      58.7659];

vstress = Load_vstress;
ustress = Load_ustress;

[i,j]=find_IJ(vstress.lon, vstress.lat, xlim, ylim);
% Resample the fields
vstress_resampled.time = vstress.time;
vstress_resampled.year = vstress.year;
vstress_resampled.month = vstress.month;
vstress_resampled.lon = vstress.lon(i, j);
vstress_resampled.lat = vstress.lat(i, j);
vstress_resampled.field = vstress.field(i, j, :);
vstress_resampled.mask = vstress.mask(i, j);
vstress_resampled.clima = vstress.clima(i, j, :);
vstress_resampled.ano = vstress.ano(i, j, :);

ustress_resampled.time = ustress.time;
ustress_resampled.year = ustress.year;
ustress_resampled.month = ustress.month;
ustress_resampled.lon = ustress.lon(i, j);
ustress_resampled.lat = ustress.lat(i, j);
ustress_resampled.field = ustress.field(i, j, :);
ustress_resampled.mask = ustress.mask(i, j);
ustress_resampled.clima = ustress.clima(i, j, :);
ustress_resampled.ano = ustress.ano(i, j, :);

ustress=ustress_resampled;
vstress=vstress_resampled;

cindexd = GOA_CoastalSSHa_Index (ssh.anod, ssh);


% Figure 3b SLPa Forcing Pattern, and compute SLPa Dowelling Index
mfig(2)
p=[0.52083      4.1806      7.4583      4.6389];
set(gcf, 'paperposition',p);
ilag =0
[corrmap, regress] =GOA_CorrelationMap(slp.ano, slp, cindexd.time+ilag*30, cindexd.coastal_norm);
[corrmapu, u] =GOA_CorrelationMap(ustress.ano, ustress, cindexd.time+ilag*30, cindexd.coastal_norm);
[corrmapv, v] =GOA_CorrelationMap(vstress.ano, vstress, cindexd.time+ilag*30, cindexd.coastal_norm);
u=-u;
v=-v;

% Define constants
rho = 1025; % density of seawater in kg/m^3
Omega = 7.2921e-5; % Earth's rotation rate in rad/s

% Latitude of the Gulf of Alaska
phi = vstress.lat; % adjust this to the appropriate latitude in degrees

% Convert latitude to radians
phi_rad = deg2rad(phi);

% Coriolis parameter
f = 2 * Omega * sin(phi_rad);

% Load or define wind stress components (tau_x, tau_y)
% tau_x and tau_y should be arrays of the same size representing wind stress
% in the x (eastward) and y (northward) directions, respectively.

% Compute Ekman transport components
M_x = v ./ (rho * f); % Ekman transport in the x-direction (m^2/s)
M_y = -u ./ (rho * f); % Ekman transport in the y-direction (m^2/s)

% Compute the net Ekman transport magnitude
M_magnitude = sqrt(M_x.^2 + M_y.^2);

clf; 
GOA_Map2D(corrmap, slp);
set(gca, 'xlim',[-178.344 -121])
set(gca, 'ylim',[37 70])
set(gca,'FontSize',14)
red_blue_colormap
caxis([-0.6 0.1])
% make an index for the atmospheric forcing pattern
[i,j]=find_IJ(slp.lon, slp.lat, xlim, ylim);
make_box(xlim,ylim,'k')
hold on
c=[181 23 0]/255;
quiver(ustress.lon, ustress.lat, M_x, M_y,'color',c, 'LineWidth', 2, 'AutoScaleFactor', 0.8, 'MaxHeadSize', 10);


lpr fig_3b_slpa_corr_map_elman.eps



