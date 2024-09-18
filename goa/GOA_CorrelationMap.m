function [corrmap, regmap] = GOA_CorrelationMap (ano, data, time, index)
% function [CINDEX] = GOA_CoastalSSHa_Index (ANO, DATA, TIME, INDEX)
% Extract the index of GOA coastal sea level anomalies using 
% SSHA(lon, lat, time). 
% TIME is the time of the index, INDEX are the values of the index
% The data structure DATA contains the coordinates
% DATA.lon, DATA.lat, DATA.mask

t2=data.time;
mask = data.mask;
s2 = ano;
t1 = time;
s1 = index;

STDunits=1;

[I,J,T]=size(s2);
o.corr=zeros(I,J)*nan;
o.regress=o.corr*nan;
t_start= max(t1(1), t2(1));
t_end  =min(t1(end), t2(end));
s1=interp1(t1,s1,t2,'linear');
tidx = t2 >= t_start & t2 <= t_end;
s2c=s2(:,:,tidx);
s1c=s1(tidx);
s1c=s1c(:);
[f2d]=ConvertXYT_into_ZT_mod(s2c,mask); 
cov2=(1./numel(s1c))*(f2d*s1c);
[cov2FLD]=ConvertZT_into_XYT(cov2,mask);

if STDunits
    regress=cov2/std(s1c); %use this to get [s2 unit / std of s1]
else
    regress=cov2/var(s1c); %tmp
end

[o.regress]=ConvertZT_into_XYT(regress,mask);
a=cov2/var(s1c);
[o.a]=ConvertZT_into_XYT(regress,mask);
corr2=cov2./(std(f2d,0,2)*std(s1c));
[corr2FLD]=ConvertZT_into_XYT(corr2,mask);
o.corr=corr2FLD;
o.cov=cov2FLD;

corrmap = o.corr;
regmap = o.regress;

function fout=ConvertXYT_into_ZT_mod(f,mask);

[I,J,T]=size(f);
 f=f.*repmat(mask,[ 1 1 T]);
 f=reshape(f,[I*J,T]);
 in=find(isnan( mask(:) ) == 0);
 fout=f(in,:);