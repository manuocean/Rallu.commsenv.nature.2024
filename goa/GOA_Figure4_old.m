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
save SLPa_Forc_Index.mat forc_index


% find out the value for 3 STD deviation
p= ssh.anod;
p=p(:);
p=p(~isnan(p));
mfig
hist(p,40);
fac = std(p)*3;  % it is 0.141 --> approximate to 0.15

[cindexd, m] = GOA_CoastalSSHa_Index (ssh.anod, ssh);

% Figure 4b panel B Anticyclonic index 
ano = ssh.anod;
T = size(ano,3);
mask = repmat(m.inter,[1 1 T]);

% New index 
% mask = stdNaN(ano,3);
% %clf; GOA_Map2D(mask, ssh)
% in = find(mask < 0.05);
% mask(in)=nan; mask(~isnan(mask))=1;
% clf; GOA_Map2D(mask, ssh); caxis([-3 3])
% 
% ano =  ssh.anod.*mask;
% threshold = 0.15;
% in = find(ano <= threshold); 
% ano(in)=nan;
% anticyclone_index = squeeze(sumNaN(sumNaN(ano,1),2));
% 
% mfig(1); clf
% p=[0.125      2.8819        8.25      5.2361];
% set(gcf, 'paperposition',p);
% plot(ssh.time, anticyclone_index,'linewidth',2);
% hold on
% in = find(ssh.year > 2013);
% m2 = mean(anticyclone_index(in));
% plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
% in = find(ssh.year <= 2013);
% m2 = mean(anticyclone_index(in));
% plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
% set(gca,'FontSize',14)
% datetick
% grid on
% set(gca, 'xlim',[ssh.time(1) ssh.time(end)])
% %plot(ssh.time, index_pos/std(index_pos)*std(anticyclone_index),'linewidth',2);
% 
% % Figure 4b panel B (Anticylonic and Cyclonic Eddy Indices)
% T = 367;
% fac = 0.15;
% istr=0;
% mask = repmat(m.inter,[1 1 T]);
% ano =  ssh.anod.*mask;
% ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
% in=find(ano<0); ano(in)=nan;
% in = find(abs(ano) < fac); ano(in)=nan;
% ano(~isnan(ano))=1;
% index_pos = squeeze(meanNaN(meanNaN(ano,1),2,1));
% %index_pos = squeeze(sumNaN(sumNaN(ano(istr:end,:,:),1),2));


% original index
% Figure 4b panel B (Anticylonic and Cyclonic Eddy Indices)
T = 367;
fac = 0.15;
istr=0;
mask = repmat(m.inter,[1 1 T]);
ano =  ssh.anod.*mask;
ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
in=find(ano<0); ano(in)=nan;
in = find(abs(ano) < fac); ano(in)=nan;
ano(~isnan(ano))=1;
index_pos = squeeze(meanNaN(meanNaN(ano,1),2,1));
%index_pos = squeeze(sumNaN(sumNaN(ano(istr:end,:,:),1),2));
ano =  ssh.anod.*mask;
ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
in=find(ano>0); ano(in)=nan;
in = find(abs(ano) < fac); ano(in)=nan;
ano(~isnan(ano))=1;
index_neg = squeeze(meanNaN(meanNaN(ano,1),2,1));
%index_neg = squeeze(sumNaN(sumNaN(ano(istr:end,:,:),1),2));

mfig(6); clf
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);
plot(ssh.time, index_neg,'linewidth',2)
hold on
plot(ssh.time, index_pos,'linewidth',2)
in = find(ssh.year > 2013);
m2 = mean(index_pos(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
in = find(ssh.year <= 2013);
m2 = mean(index_pos(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
set(gca,'FontSize',14)
datetick
grid on
set(gca, 'ylim',[-1 40])
set(gca, 'xlim',[ssh.time(1) ssh.time(end)])
lpr fig_4b_eddy_count_times.eps

% Fgure 4c panel C EKE index compared to anticylconic eddy index
mfig(4); clf
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
index_eke = nn(squeeze(meanNaN(meanNaN(ano,1),2,1)));
plot(ssh.time, (index_eke),'linewidth',2)
in = find(ssh.year > 2013);
m2 = mean(ind(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
in = find(ssh.year <= 2013);
m1 = mean(ind(in));
plot(ssh.time(in), repmat(m1, [length(in) 1]), 'LineWidth',2,'color','k');
set(gca,'FontSize',14)
datetick
grid on
set(gca, 'ylim',[-3.5 5])
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

for n = 277:367
    clf
    GOA_Map2D(ano(:,:,n).*m.inter, ssh)
    title(datestr(ssh.time(n)))
    pause(0.5)
end


lpr fig_4e_eddy_counts_anti_map.eps
% cyclones
mask = repmat(m.inter,[1 1 T]);
ano =  ssh.anod.*mask;
%in=find(ano<0); ano(in)=nan; % pos
in=find(ano>0); ano(in)=nan; % neg
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