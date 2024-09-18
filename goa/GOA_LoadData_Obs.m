function [ssh, sst, chla, slp] = GOA_LoadData_Obs()


% Satellite CHL-a data
load chla.mat;
chla.year = str2num(datestr(chla.time, 'yyyy'));
chla.month = str2num(datestr(chla.time(:), 'mm'));
chla.chlorl = log(chla.chlor);
chla = GOA_Generate_Chla_Mask(chla);
chla = GOA_Subsample_GOA_Domain (chla,'c');
[seas, seas_ano, ano] = Remove_Seasonal_Cycle(chla.field, chla.month);
chla.seas = seas;
chla.seas_ano = seas_ano;
chla.ano = ano;

% Satellite SSH
load Satellite_SSH.mat
mask = mean(ssh.ssh,3); mask (~isnan(mask)) =1; ssh.mask =mask;
ssh = GOA_Generate_SSH_Mask(ssh);
ssh = GOA_Subsample_GOA_Domain (ssh,'s');
[seas, seas_ano, ano] = Remove_Seasonal_Cycle(ssh.field, ssh.month);
ssh.seas = seas;
ssh.seas_ano = seas_ano;
ssh.ano = ano;
[seas, seas_ano, ano] = Remove_Seasonal_Cycle(abs(ssh.ano), ssh.month);
ssh.seasv = seas;
ssh.seas_anov = seas_ano;
ssh.anov = ano;
file = 'http://apdrc.soest.hawaii.edu:80/dods/public_data/satellite_product/MDOT/mdot30';
lon = ncread(file, 'lon')-360;   lat = ncread(file, 'lat');
[lat,lon] = meshgrid(lat, lon);
mdot = ncread(file, 'mdot'); mdot(mdot> 100000) = nan;
ssh.mean = interp2(lon', lat', mdot', ssh.lon, ssh.lat);

% Load SST
load GOA_sst.mat
sstg=sst;
sstg.month = sstg.months;
mask=mean(sstg.sst,3); mask(~isnan(mask))=1;
sstg.mask=mask;
sst = GOA_Subsample_GOA_Domain (sstg,'t');
sst = GOA_Generate_SSH_Mask(sst);
[seas, seas_ano, ano] = Remove_Seasonal_Cycle(sst.field, sst.month);
sst.seas = seas;
sst.seas_ano = seas_ano;
sst.ano = ano;
sst.ano = GOA_apply_mask(sst.ano, sst.mask);

% Sea Level Pressure SLP
slp = Load_SLP;
slp = GOA_Subsample_GOA_Domain(slp,'a');
[seas, seas_ano, ano] = Remove_Seasonal_Cycle(slp.field, slp.month);
slp.seas = seas;
slp.seas_ano = seas_ano;
slp.ano = ano;

% Sea Level Pressure SLP full
slp2 = Load_SLP;
slp2 = GOA_Subsample_GOA_Domain (slp,'z');
[seas, seas_ano, ano] = Remove_Seasonal_Cycle(slp2.field, slp2.month);
slp2.seas = seas;
slp2.seas_ano = seas_ano;
slp2.ano = ano;


