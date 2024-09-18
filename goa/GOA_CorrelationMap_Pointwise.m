function [R, R_dtrend]=GOA_CorrelationMap_Pointwise( field1, field2, data1, data2)


% time allignment 
t1 = datenum(data1.year, data1.month, 15);
t2 = datenum(data2.year, data2.month, 15);

t_str = max(min(t1),min(t2));
t_end = min(max(t1),max(t2));

t1_str = find(t1 == t_str);
t1_end = find(t1 == t_end);

t2_str = find(t2 == t_str);
t2_end = find(t2 == t_end);

field1=field1(:,:,t1_str:t1_end);
field2=field2(:,:,t2_str:t2_end);

for it=1:size(field1,3)
    field2_interp(:,:,it)=interp2(data2.lon', data2.lat', field2(:,:,it)', ...
        data1.lon, data1.lat);
end

[I,J] = size(data1.mask);
R = zeros(I,J)*nan;
R_dtrend = zeros(I,J)*nan;

warning off
for i=1:I
    i
    for j=1:J
        s1 = squeeze(field1(i,j,:));
        in = find(~isnan(s1));
        s2 = squeeze(field2_interp(i,j,:));
        if length(in)>0
            R(i,j) = corrnan(s1(in),s2(in),'n');
            R_dtrend(i,j) = corrnan(s1(in),s2(in),'d');
        end
    end
end
