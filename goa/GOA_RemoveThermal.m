function [anod, ano_norm, anod_norm] = GOA_RemoveThermal(ano)


% Additional treatment of SSHa data 
% remove the thermal expansion of SSHa define a new variable ssh.anod.

for t=1:size(ano,3)
    fac=ano(:,:,t); fac = meanNaN(fac(:),1);
    anod(:,:,t) = ano(:,:,t)-fac;
end

% normalize the SSHa
[I,J,T] = size(ano);   % get the size of teh array
anod_norm = zeros(I,J,T)*nan; % initialize the array that will hold the normalized data
ano_norm = zeros(I,J,T)*nan;
for i=1:I
    for j=1:J
        ts = squeeze(ano(i,j,:)); % extrac the timeseries at a given i,j point
        ts = ts/std(ts); % normalize by the std 
        ano_norm(i,j,:) = ts; % assign it to the new variable

        ts = squeeze(anod(i,j,:)); % extrac the timeseries at a given i,j point
        ts = ts/std(ts); % normalize by the std 
        anod_norm(i,j,:) = ts; % assign it to the new variable
    end
end
