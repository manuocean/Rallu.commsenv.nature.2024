function [eke] = GOA_ComputeEKE (ano, data)
% function [EKE] = GOA_ComputeEKE (ANO, DATA)
% Compute the eddy kinetic energy from sea level anomalies given by ANO 
% The data structure DATA contains the coordinates
% DATA.lon, DATA.lat, DATA.mask
% The output KE is a structured array continaing the mean kinetic energy
% and the eddy kinetic energe.

eke.time = data.time;
eke.year = data.year;
eke.month = data.month;

% measure the eddy kinetic energy of the eddies (new added on Jan 3, 2024)
x_grad = ano(2:end,:,:)-ano(1:end-1,:,:);
x_grad = (x_grad(:,2:end,:)+x_grad(:,1:end-1,:))/2;

y_grad = ano(:,2:end,:)-ano(:,1:end-1,:);
y_grad = (y_grad(2:end,:,:)+y_grad(1:end-1,:,:))/2;


tmp = (data.lon(2:end,:)+data.lon(1:end-1,:))/2;
tmp = (tmp(:,2:end,:)+tmp(:,1:end-1,:))/2;
eke.lon = tmp;

tmp = (data.lat(2:end,:)+data.lat(1:end-1,:))/2;
tmp = (tmp(:,2:end,:)+tmp(:,1:end-1,:))/2;
eke.lat = tmp;

tmp = (data.mask(2:end,:)+data.mask(1:end-1,:))/2;
tmp = (tmp(:,2:end,:)+tmp(:,1:end-1,:))/2;
eke.mask = tmp;

eke.ke = abs(x_grad) + abs(y_grad);

[seas, seas_ano, ano] = Remove_Seasonal_Cycle(eke.ke, data.month);
eke.ke_seas = seas;
eke.ano=ano;