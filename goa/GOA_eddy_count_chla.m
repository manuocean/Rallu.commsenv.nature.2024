
istr = find(ssh.year == 1997 & ssh.month == 9)
clear chl
for it=1:311
    chl (:,:,it) = interp2(chla.lon', chla.lat', chla.ano(:,:,it)', ssh.lon, ssh.lat);
end
%chl=dtrend2d(chl);


% Figure 4b panel B Anticyclonic index 
ano = ssh.anod(:,:,istr:end);
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
clf; GOA_Map2D(mask2(1:I,1:J), ssh); caxis([-3 3])

%mask(:)=1;
mask = repmat(mask2(1:I,1:J),[1 1 T]);
%mask = repmat(mask,[1 1 T]);




ano =  ssh.anod(:,:,istr:end).*mask;
threshold = 0.08;
in = find(ano <= threshold); 
ano(in)=nan;
ano(~isnan(ano))=1;
ano2 = ano.*chl;
anticyclone_index = squeeze(sumNaN(sumNaN(ano2,1),2));
%anticyclone_index = nn(anticyclone_index-mean(anticyclone_index));

ano =  ssh.anod.*mask;
in = find(ano >= -threshold); 
ano(in)=nan;
%ano(~isnan(ano))=1;
cyclone_index = -squeeze(sumNaN(sumNaN(ano,1),2));

time = ssh.time(istr:end);
year = ssh.year(istr:end);
mfig(1); clf
p=[0.125      2.8819        8.25      5.2361];
set(gcf, 'paperposition',p);
plot(time, anticyclone_index,'linewidth',2);
hold on
%plot(ssh.time, cyclone_index,'linewidth',2);
%plot(ssh.time, pp/std(pp)*std(anticyclone_index),'linewidth',2);
in = find(year > 2013);
m2 = mean(anticyclone_index(in));
plot(time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','k');
in = find(year <= 2013);
m1 = mean(anticyclone_index(in));
plot(time(in), repmat(m1, [length(in) 1]), 'LineWidth',2,'color','k');
m2-m1

in = find(ssh.year > 2002);
m2 = mean(anticyclone_index(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','r');
in = find(ssh.year <= 2002);
m2 = mean(anticyclone_index(in));
plot(ssh.time(in), repmat(m2, [length(in) 1]), 'LineWidth',2,'color','r');


set(gca,'FontSize',14)
datetick
grid on
set(gca, 'xlim',[ssh.time(1) ssh.time(end)])
%plot(ssh.time, index_pos/std(index_pos)*std(anticyclone_index),'linewidth',1,'color',[.5 .5 .5]);
return




chl=chla.ano;


n = 348;

mfig(2);
clf;
GOA_Map2D(ano(:,:,n), ssh);

in = find(anticyclone_index > 40 );

for i=in'
    figure(1);
    plot(ssh.time(i), anticyclone_index(i), '*g');
    mfig(2);clf;
    GOA_Map2D(ano(:,:,i), ssh);
    title(datestr(ssh.time(i)))
    pause
end

    