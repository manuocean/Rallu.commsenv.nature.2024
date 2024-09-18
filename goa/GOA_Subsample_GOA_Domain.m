
function data1 = GOA_Subsample_GOA_Domain (data,c_flag);

xlim = [-178.3440 -127.3660];
ylim = [48.0514   60.7656];

[i,j]=find_IJ(data.lon, data.lat, xlim, ylim);

if c_flag == 'c'
    data1.time = data.time;
    data1.year = data.year;
    data1.month = data.month;
    data1.lon = data.lon(i,j);
    data1.lat = data.lat(i,j);
    data1.mask = data.mask(i,j);
    data1.field = data.chlorl(i,j,:);
end

if c_flag == 's'
    data1.time = data.time';
    data1.year = data.year;
    data1.month = data.month';
    data1.lon = data.lon(i,j);
    data1.lat = data.lat(i,j);
    data1.mask = data.mask(i,j);
    data1.field = data.ssh(i,j,:);
end

if c_flag == 't'
    data1.time = data.time;
    data1.year = data.year;
    data1.month = data.month;
    data1.lon = data.lon(i,j);
    data1.lat = data.lat(i,j);
    data1.mask = data.mask(i,j);
    data1.field = data.sst(i,j,:);
end


if c_flag == 'a'
    xlim = [-200.3440 -117.3660];
    ylim = [35.0514   75.7656];
    [i,j]=find_IJ(data.lon, data.lat, xlim, ylim);
    data1.time = data.time;
    data1.year = data.year;
    data1.month = data.month;
    data1.lon = data.lon(i,j);
    data1.lat = data.lat(i,j);
    data1.mask = data.mask(i,j);
    data1.field = data.field(i,j,:);
end

if c_flag == 'z'
    xlim = [-200.3440 -117.3660];
    ylim = [35.0514   75.7656];
    [i,j]=find_IJ(data.lon, data.lat, xlim, ylim);
    data1.time = data.time;
    data1.year = data.year;
    data1.month = data.month;
    data1.lon = data.lon(i,j);
    data1.lat = data.lat(i,j);
    data1.mask = data.mask(i,j);
    data1.field = data.field(i,j,:);
end

% 9/1997
% 7/2023

istr = find(data1.year == 1993 & data1.month == 1);
iend = find(data1.year == 2023 & data1.month == 7);

if c_flag == 'c'
    istr =1;
end


if c_flag ~= 'z'
    data1.time = data1.time(istr:iend);
    data1.year = data1.year(istr:iend);
    data1.month = data1.month(istr:iend);
    data1.field = data1.field(:,:,istr:iend);
end
