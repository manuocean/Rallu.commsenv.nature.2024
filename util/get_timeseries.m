
function ts = get_timeseries(patt, field, mask);
% patt = sstano2014;
% field = SST.ano;
% mask = SST.mask;

patt = ConvertXYT_into_ZT(patt, mask);
field = ConvertXYT_into_ZT(field, mask);
ts = nn(field'*patt);