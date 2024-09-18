function ts = get_ts(field, data,xlim, ylim)

[i,j]=find_IJ(data.lon, data.lat, xlim, ylim);
ts = squeeze(meanNaN( meanNaN( field(i,j,:),1) ,2));

