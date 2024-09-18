% This code resproduces the analyses and figure for 
% Rallu De Malibran, M. C., C. Kaplan, and E. Di Lorenzo (2024), 
% Marine Heatwaves Weaken Coastal Circulation and Eddies in the 
% Gulf of Alaska, Nature Communications, 2024.

% Download the data from here
% https://www.dropbox.com/scl/fo/ybk9fln2gwx2tautijh3j/ADwhOsXehLZaoSYvCn2DfJo?rlkey=cm6akefvdo1maks7zff4li2l3&dl=0
% and place its content into a directory called data


%% Add MATLAB toolboxes for the GOA Analysis
clear
addpath data
addpath goa
addpath util/

%% Load the datasets for the analysis
[ssh, sst, chla, slp] = GOA_LoadData_Obs;
sst_hres = Load_SSTa_HighRes_OISST;

% remove the thermal expansion of SSHa define a new variable ssh.anod.
[ssh.anod, ssh.ano_norm, ssh.anod_norm] = GOA_RemoveThermal(ssh.ano);

% EKE Satellite OBS
[eke] = GOA_ComputeEKE (ssh.ano, ssh);
[eke.detrended, eke.trend] = dtrend2d(eke.ano);

%% Figure 1

% make a regression map of high resolution SSTa with the goa SSTa index
xlim =[-163 -123];
ylim =[ 45   62];
[i,j]=find_IJ(sst_hres.lon, sst_hres.lat,xlim,ylim);
sst_hres.goa_average = sq(meanNaN(meanNaN(sst_hres.ano(i,j,:),1),2));
sst_hres.goa_average = sst_hres.goa_average/std(sst_hres.goa_average);
mfig(1); clf
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);
GOA_PlotTime(sst_hres.time,sst_hres.goa_average, 'color','r');
lpr fig_1a_ssta_goa.eps


[corrmap, regress] = GOA_CorrelationMap(sst_hres.ano, sst_hres, sst_hres.time,sst_hres.goa_average);
mfig(2);
p=[0.11111      2.8889      8.2778      5.2222];
set(gcf, 'paperposition',p);
clf;
GOA_Map2D(regress.*sst_hres.mask,sst_hres)
caxis([-1 1]); red_blue_colormap
set(gca, 'LineWidth',2)
set(gca, 'ylim',[-60 65])
set(gca,'xlim',[-260 -68])
set(gca, 'FontSize', 14)
xlim2=[-178.3440 -127.3660];
ylim2=[48.0514   60.7656];
make_box(xlim2,ylim2,'k')
lpr fig_1b_ssta_pacific.eps


mfig(3)
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);

% SLPa
clf;
in1 = find(slp.year > 2013 & slp.year <= 2023); size(in1)
GOA_Map2D(meanNaN(slp.ano(:,:,in1),3), slp);
caxis([-1.5 1.5])
%contour(ssh.lon, ssh.lat, ssh.mean.*ssh.mask, 10, 'color','k', 'linewidth',1.3)
lpr fig_1c_slp_ano_2013.eps


% SSTa
clf;
in1s = find(sst_hres.time > datenum(2013,0,0));
GOA_Map2D(meanNaN(sst_hres.ano(:,:,in1s),3), sst_hres);
caxis ([0 0.9])
contour(ssh.lon, ssh.lat, ssh.mean.*ssh.mask, 10, 'color','k', 'linewidth',1.3)
lpr fig_1d_sst_ano_2013.eps

% ENSO map
clf;
nino34 = ENSO_index;
in = find (nn(nino34.index) > 1.3 & sst_hres.date.Month' < 3);
GOA_Map2D(meanNaN(sst_hres.ano(:,:,in),3), sst_hres);
caxis ([-1 1])
contour(ssh.lon, ssh.lat, ssh.mean.*ssh.mask, 10, 'color','k', 'linewidth',1.3)


% SSHa
clf;
in1 = find(ssh.year >= 2013); size(in1)
GOA_Map2D(meanNaN(ssh.anod_norm(:,:,in1),3), ssh);
caxis([-.7 .7])
contour(ssh.lon, ssh.lat, ssh.mean.*ssh.mask, 10, 'color','k', 'linewidth',1.3)
lpr fig_1e_ssh_ano_2013.eps

%% Figure 2

mfig(3)
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);
% SSTa
clf;
I = [1 11 12 ]
clf;
field = meanNaN(ssh.seas_ano(:,:,I),3)*10;
field = field - meanNaN(field(:),1);
GOA_Map2D(field, ssh);
contour(ssh.lon, ssh.lat, ssh.mean.*ssh.mask, 10, 'color','k', 'linewidth',1.1)
caxis([-.6 .6])
lpr fig_2a_ssh_seas_NDJ.eps

I = [2:4 ]
clf;
field = meanNaN(ssh.seas_ano(:,:,I),3)*10;
field = field - meanNaN(field(:),1);
GOA_Map2D(field, ssh);
caxis([-.6 .6])
lpr fig_2b_ssh_seas_FMA.eps

I = [5:7 ]
clf;
field = meanNaN(ssh.seas_ano(:,:,I),3)*10;
field = field - meanNaN(field(:),1);
GOA_Map2D(field, ssh);
caxis([-.6 .6])
lpr fig_2c_ssh_seas_MJJ.eps

I = [8:10 ]
clf;
field = meanNaN(ssh.seas_ano(:,:,I),3)*10;
field = field - meanNaN(field(:),1);
GOA_Map2D(field, ssh);
caxis([-.6 .6])
lpr fig_2d_ssh_seas_ASO.eps

clf;
GOA_Map2D(stdNaN(ssh.ano,3), ssh);
caxis([0 .1])
lpr fig_2e_ssh_std.eps

% SSHa OBS vs. CHLa  **
[Rssh, Rssh_dtrend]=GOA_CorrelationMap_Pointwise(ssh.ano, chla.ano, ssh, chla);
clf;
GOA_Map2D(Rssh, ssh);
caxis([-.5 .5])
lpr fig_2f_chla_ssh_corr.eps



%% Figure 3

cindexd = GOA_CoastalSSHa_Index (ssh.anod, ssh);


% Figure 3c SSHa correlation map
mfig(3)
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);
corrmap=GOA_CorrelationMap(ssh.anod, ssh, cindexd.time, cindexd.coastal_norm);
clf;
GOA_Map2D(corrmap, ssh);
caxis ([-1 1])
contour(ssh.lon, ssh.lat, ssh.mean.*ssh.mask, 10, 'color','k', 'linewidth',1.1)
lpr fig_3c_ssha_corr_map.eps


% Figure 3b SLPa Forcing Pattern, and compute SLPa Dowelling Index
mfig(2)
p=[0.52083      4.1806      7.4583      4.6389];
set(gcf, 'paperposition',p);
ilag =0
[corrmap, regress] =GOA_CorrelationMap(slp.ano, slp, cindexd.time+ilag*30, cindexd.coastal_norm);
clf; 
GOA_Map2D(corrmap, slp);
set(gca, 'xlim',[-178.344 -121])
set(gca, 'ylim',[37 70])
set(gca,'FontSize',14)
red_blue_colormap
caxis([-0.6 0.1])
% make an index for the atmospheric forcing pattern
xlim = [-167.4565     -122.0886];
ylim = [37.5794      58.7659];
[i,j]=find_IJ(slp.lon, slp.lat, xlim, ylim);
make_box(xlim,ylim,'k')
slpa_ts = get_timeseries(corrmap(i,j), slp.ano(i,j,:), slp.mask(i,j));
lpr fig_3b_slpa_corr_map.eps

% run an AR1 model
gamma = 1/2;
f=slpa_ts;
f=f-mean(f); 
T=length(f);
sig=zeros(T,1);
sig(1)=0;%cindexd.coastal_norm(1);
for t=1:T
  sig(t+1) = sig(t) *(1-gamma) + f(t);
end
sig=(sig(2:end)+sig(1:end-1))/2;
sig=sig/std(sig);

clf
red_signi(cindexd.time, sig, cindexd.time, cindexd.coastal_norm, 30, 1500)

% Figure 3a blue line
mfig(1); clf
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);
clf
GOA_PlotTime(cindexd.time, cindexd.coastal_norm, 'color','b');
grid off
set(gca, 'xlim', [ssh.time(1)-60 ssh.time(end)+60])
plot(cindexd.time, sig, 'linewidth',0.8,'color','k');
lpr fig_3a2_ssha_coastal_index.eps

% Figure 3a black line, SLPa Downlwelling Index
clf
GOA_PlotTime(slp.time, slpa_ts, 'color','k');
set(gca, 'xlim', [ssh.time(1)-60 ssh.time(end)+60])
grid off
lpr fig_3a2_slpa_coastal_index.eps




%% Figure 4

% Figure 3a black line, SLPa Downlwelling Index
mfig(3); clf
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);
in=find(slpa_ts < 1);
tmp = slpa_ts; tmp(in) =0;
GOA_PlotTime(slp.time, tmp, 'color',gpcol(2));
tmp1=tmp;
hold on
in=find(slpa_ts > -1);
tmp = slpa_ts; tmp(in) =0;
GOA_PlotTime(slp.time, abs(tmp), 'color',gpcol(1));
tmp2=tmp;
tmp (:)=0;
GOA_PlotTime(slp.time, abs(tmp), 'color','w');
set(gca, 'xlim', [ssh.time(1)-60 ssh.time(end)+60])
%grid off
set(gca, 'ylim',[-1 5])
set(gca, 'xlim',[ssh.time(1) ssh.time(end)])
lpr fig_4a_slpa_donwelling_index.eps

clear forc_index
forc_index.time = slp.time;
forc_index.data = tmp1+tmp2;
save data/SLPa_Forc_Index.mat forc_index

% cmopute coastal index and mask
[cindexd, m] = GOA_CoastalSSHa_Index (ssh.anod, ssh);

% find the 3 STD for SSHa
ano = ano(:,:,2:end) - ano(:,:,1:end-1);
p= ano;
p=p(:);
p=p(~isnan(p));
mfig
hist(p,40);
fac = std(p)*3;  % it is 0.141 --> approximate to 0.15


% Figure 4b panel B (Anticylonic and Cyclonic Eddy Indices)
T = 367;
fac = 0.15;
istr=0;

yr_str = 2015
mydate = datenum(2016,6,1);


% anticyclone
mask = repmat(ssh.mask,[1 1 T]);
ano =  ssh.anod.*mask;
%ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
% all values below zero are set to NaN
in=find(ano<0); ano(in)=nan;
% all values below abs(fac) are set to nan
in = find(abs(ano) < fac); ano(in)=nan;
% replace values with 1
ano(~isnan(ano))=1;
index_pos = squeeze(sumNaN(sumNaN(ano,1),2));

% cyclone
mask = repmat(ssh.mask,[1 1 T]);
ano =  ssh.anod.*mask;
%ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
in=find(ano>0); ano(in)=nan;
in = find(abs(ano) < fac); ano(in)=nan;
ano(~isnan(ano))=1;
index_neg = abs(squeeze(sumNaN(sumNaN(ano,1),2)));

mfig(13); clf
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);
plot(ssh.time, index_neg,'linewidth',2)
hold on
plot(ssh.time, index_pos,'linewidth',2)
%plot(ssh.time, lowpassa(index_pos,12),'linewidth',2, 'color','k')
in = find(ssh.time > mydate);
m2 = mean(index_pos(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
in = find(ssh.time <= mydate);
m2 = mean(index_pos(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
set(gca,'FontSize',14)
datetick
grid on
set(gca, 'ylim',[-2 300])
set(gca, 'xlim',[ssh.time(1) ssh.time(end)])
lpr fig_4b_eddy_count_times.eps



% Fgure 4c panel C EKE index compared to anticylconic eddy index
mfig(14); clf
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);
plot(ssh.time, index_neg*nan,'linewidth',2)
hold on
plot(ssh.time, nn(index_pos-mean(index_pos)),'linewidth',2)
ind=nn(index_pos-mean(index_pos));
mask = repmat(m.inter,[1 1 T]);
ano =  ssh.anod.*mask;
ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
ano(~isnan(ano))=1; ano=eke.ano.*ano;
%index_eke = nn(squeeze(meanNaN(meanNaN(ano,1,1),2,1)));
index_eke = nn(squeeze(sumNaN(sumNaN(ano,1),2)));
%index_eke = nn(squeeze(meanNaN(meanNaN(ano,1),2)));
inde=nn(index_eke-mean(index_eke));
corr(inde, ind)

plot(ssh.time, (index_eke),'linewidth',2)
in = find(ssh.time > mydate);
m2 = mean(ind(in));
m2e = mean(inde(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
in = find(ssh.time <= mydate);
m1 = mean(ind(in));
m1e = mean(inde(in));
plot(ssh.time(in), repmat(m1, [length(in) 1]), 'LineWidth',2,'color','k');
set(gca,'FontSize',14)
datetick
grid on
set(gca, 'ylim',[-3.5 4.5])
set(gca, 'xlim',[ssh.time(1) ssh.time(end)])
lpr fig_4c_eddy_eke_times.eps

m2-m1


% Figures 4e and 4f: Eddy Transit Count Maps
mfig(4)
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);
% anticyclones
T = 367;
fac = 0.15;
mask = repmat(m.inter,[1 1 T]);
mask = repmat(ssh.mask,[1 1 T]);
ano =  ssh.anod.*mask;
in=find(ano<0); ano(in)=nan; % pos
%in=find(ano>0); ano(in)=nan; % neg
in = find(abs(ano) < fac); ano(in)=nan;
ano(~isnan(ano))=1;
anoc=meanNaN(ano,3,1);
anoc(anoc<5)=nan;
clf
%pcolor(ssh.lon, ssh.lat, anoc.*m.inter); shading flat; hold on; world_coast
GOA_Map2D(anoc.*m.inter, ssh)
colorbar
red_blue_colormap
caxis([-35 35])

lpr fig_4e_eddy_counts_anti_map.eps

% cyclones
mask = repmat(m.inter,[1 1 T]);
ano =  ssh.anod.*mask;
%in=find(ano<0); ano(in)=nan; % pos
in=find(ano>0); ano(in)=0; % neg
in = find(abs(ano) < fac); ano(in)=nan;
ano(~isnan(ano))=1;
anoc=meanNaN(ano,3,1);
anoc(anoc<5)=nan;
clf
%pcolor(ssh.lon, ssh.lat, anoc.*m.inter); shading flat; hold on; world_coast
GOA_Map2D(anoc.*m.inter, ssh)
colorbar
red_blue_colormap
caxis([-10 10])
lpr fig_4f_eddy_counts_cycl_map.eps

% Figure 4g EKE map
mfig(3)
p=[0.52083      4.1806      7.4583      2.6389];
set(gcf, 'paperposition',p);
% EKE
clf;
p=stdNaN(eke.ano,3); p=p/max(p(:))*100;
GOA_Map2D(p, eke);
caxis ([0 80])
lpr fig_4g_eke_std.eps

% Significance test of changes in mean of Anticylonic eddy
ind = nn(index_pos-mean(index_pos));
%alfa=aryule(ind, 1);
alfa = 0.816;
coefs=aryule(EGI.index', 1); alfa = abs(coefs(2))
alfa = 0.685;
in1 = find(ssh.time <= datenum(2016,5,1));
in2 = find(ssh.time > datenum(2016,5,1));
m1 = mean(ind(in1));
m2 = mean(ind(in2));
disp(['Change in mean (STD units) = ',num2str(m2-m1)]);

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

% Compute Eddy Activity Index (EAI) and related figures
GOA_EGI_index


%% Figure 5

% figure 5a
mfig; 
clf
ax=[-0.3 0.3]
in = find (ssh.year == 1998 & ssh.month == 2);
for ilag = 0:2
    eddy_maps(:,:,ilag+1) = mean(ssh.anod(:,:,in+ilag),3);
    tmp =  eddy_maps(:,:,ilag+1);
    subplot(3,1,ilag+1)
    GOA_Map2D(tmp, ssh);  caxis(ax); colorbar off
end
lpr fig_5a_eddy_sequence_feb1998.eps

% figure 5b
mfig
clf
ax=[-0.3 0.3]
in = find (ssh.year == 2018 & ssh.month == 2);
for ilag = 0:2
    eddy_maps(:,:,ilag+1) = mean(ssh.anod(:,:,in+ilag),3);
    tmp =  eddy_maps(:,:,ilag+1);
    subplot(3,1,ilag+1)
    GOA_Map2D(tmp, ssh);  caxis(ax); colorbar off
end
lpr fig_5b_eddy_sequence_feb2018.eps

mfig
% make movie
for i=1:T
    GOA_Map2D(ssh.anod(:,:,i), ssh);  caxis(ax); colorbar off
    title (datestr(ssh.time(i)));
    pause(0.1);
end


%% Figure 6

GOA_CMIP_models_analysis


