function [cindex, m] = GOA_CoastalSSHa_Index (ssha, data)
% function [CINDEX] = GOA_CoastalSSHa_Index (SSHA, DATA)
% Extract the index of GOA coastal sea level anomalies using 
% SSHA(lon, lat, time). 
% The data structure DATA contains the coordinates
% DATA.lon, DATA.lat, DATA.mask

% Extract time series of SSHa at two locations, Victoria and Kodiac
xlim = [-131.7909     -129.2828];
ylim = [52.6827      54.6168];
sla_ts_victoria = get_ts(ssha, data, xlim, ylim);

xlim = [-156.8724     -149.8283];
ylim = [57.4821      59.5595];
sla_ts_kodiac = get_ts(ssha, data, xlim, ylim);

% compute standard deviation
std_victoria = std(sla_ts_victoria);
std_kodiac = std(sla_ts_kodiac);

cindex.time = data.time;
cindex.victoria_norm = sla_ts_victoria/std_victoria;
cindex.kodiac_norm = sla_ts_kodiac/std_kodiac;

% R1 is the correlation map of Vicoria
% R2 is the correlation map of Kodiac
R1 = GOA_CorrelationMap (ssha, data, cindex.time, cindex.victoria_norm);
R2 = GOA_CorrelationMap (ssha, data, cindex.time, cindex.kodiac_norm);

R1 = R1.*data.mask;
R2 = R2.*data.mask;

% make an average of the two
R = (R1 + R2)/2;
% clf; GOA_Map2D(R, ssh); caxis([-1 1])

% use the correlation to define a mask along the coastal GOA
shelf_mask = R*nan;
in = find(R > 0.6);
shelf_mask(in) =1;
m.shelf = shelf_mask;

% inspect the mask
% clf; GOA_Map2D(shelf_mask,ssh); caxis([0 1])

% now expand the mask so that we can apply it to all time records
T = length(data.time);
shelf_mask = repmat(shelf_mask,[1 1 T]);

% extract a timeseries 
ano =  ssha.*shelf_mask;
cindex.coastal = squeeze(meanNaN(meanNaN(ano,1),2));
std_coast = std(cindex.coastal);
cindex.coastal_norm = cindex.coastal/std_coast;

outer_mask = shelf_mask;
in = find (isnan(shelf_mask));
in2 = find(~isnan(shelf_mask));
outer_mask(in) = 1;
outer_mask(in2) = nan;
outer_mask = outer_mask.*repmat(data.mask,[1 1 T]);
m.inter = outer_mask(:,:,1);


% extract a timeseries 
ano =  ssha.*outer_mask;
cindex.interior = squeeze(meanNaN(meanNaN(ano,1),2));
std_coast = std(cindex.interior);
cindex.interior_norm = cindex.interior/std_coast;

cindex.diff = cindex.coastal_norm-cindex.interior_norm;
cindex.diff = cindex.diff /std(cindex.diff);

