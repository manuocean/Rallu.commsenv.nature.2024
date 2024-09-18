
T = 367;
fac = 0.15;
istr=0;
mask = repmat(ssh.mask,[1 1 T]);
ano =  ssh.anod.*mask;

ano = ano(:,:,2:end) - ano(:,:,1:end-1);
p= ano;
p=p(:);
p=p(~isnan(p));
mfig
hist(p,40);
fac = std(p)*3;  % it is 0.141 --> approximate to 0.15




in=find(ano<0); ano(in)=nan;
in = find(abs(ano) < fac); ano(in)=nan;
ano(~isnan(ano))=1;

p1=sumNaN(ano,1,1);
mfig(1);
pcolor(sq(p1)); 
colorbar

p2=sumNaN(ano,2,1);
mfig(2);
pcolor(sq(p2)); 
colorbar

p3 = sq(sumNaN(p2,1));
p4 = sq(sumNaN(p1,2));

mfig(3);
clf
%plot(p3, 'linewidth', 2,'color','b'); hold on
plot(p4, 'linewidth', 2,'color','r'); hold on

colorbar

index_pos = squeeze(meanNaN(p1,2,1));






%% made a different mask
mfig(1)
ano = ssh.anod;
T = size(ano,3);
mask = repmat(m.inter,[1 1 T]);

mask = stdNaN(ano,3);
clf; GOA_Map2D(mask, ssh)
in = find(mask < 0.05);
mask(in)=nan; mask(~isnan(mask))=1;
%in = find (ssh.lon(:,1) > -145); mask(in,:) = nan;
clf; GOA_Map2D(mask, ssh); caxis([-3 3])

mask2 = mask;
pad = 2;
[I,J]=size(mask);
for i=1:I
    for j=1:J
        if(mask(i,j) == 1)
            if i > pad+1 & j>pad+1
                mask2(i-pad:i+pad, j-pad:j+pad)=1;
            end
        end
    end
end

%mask = mask2(1:I,1:J);

%clf; GOA_Map2D(mask, ssh); caxis([-3 3])

%mask(:)=1;
mask = repmat(mask,[1 1 T]);


mask = repmat(m.inter,[1 1 T]);
mask = repmat(ssh.mask,[1 1 T]);


fac = 0.1;
ano =  ssh.anod.*mask;
in=find(ano<0); ano(in)=nan;
in = find(abs(ano) < fac); ano(in)=nan;

% 
% for i=1:360
% i
% clf
% GOA_Map2D(ano(:,:,i), ssh); caxis([-0.5 0.5]);
% title(datestr(ssh.time(i)))
% pause(0.2)
% end


%% original index
% Figure 4b panel B (Anticylonic and Cyclonic Eddy Indices)
T = 367;
fac = 0.15;
istr=0;

yr_str = 2015
mydate = datenum(2016,6,1);


% anticyclone
ano =  ssh.anod.*mask;
%ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
% all values below zero are set to NaN
in=find(ano<0); ano(in)=nan;
% all values below abs(fac) are set to nan
in = find(abs(ano) < fac); ano(in)=nan;
% replace values with 1
ano(~isnan(ano))=1;

% original
index_pos = squeeze(meanNaN(meanNaN(ano,1),2,1));

% test
index_pos = squeeze(sumNaN(sumNaN(ano,1),2));
%index_pos=EGI_time_large_positive_vortices'; index_pos(end+1)=0;
% in = find(index_pos > 100 & ssh.year > 2013);
% index_pos(in) = 100;
%index_pos = squeeze(meanNaN(meanNaN(ano,1),2));

%index_pos = squeeze(sumNaN(sumNaN(ano(istr:end,:,:),1),2));


% cyclone
ano =  ssh.anod.*mask;
%ano = (ano(1:end-1,1:end-1,:)+ano(2:end,2:end,:))/2;
in=find(ano>0); ano(in)=nan;
in = find(abs(ano) < fac); ano(in)=nan;
ano(~isnan(ano))=1;
% original
%index_neg = squeeze(meanNaN(meanNaN(ano,1),2,1));

% test
index_neg = abs(squeeze(sumNaN(sumNaN(ano,1),2)));
%index_neg = abs(squeeze(meanNaN(meanNaN(ano,1),2)));
%index_neg(isnan(index_neg)) = 0;
%index_neg = squeeze(sumNaN(sumNaN(ano(istr:end,:,:),1),2));

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

%m2e-m1e






