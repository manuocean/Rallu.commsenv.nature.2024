function r = corrnan(s1, s2, flag)

in=find(~isnan(s1));
s1=s1(in);
s2=s2(in);

in=find(~isnan(s2));
s1=s1(in);
s2=s2(in);

if isempty(s1)
    r = nan;
    return
end

if isempty(s2)
    r = nan;
    return
end

if flag == 'd'
    s1=detrend(s1);
    s2=detrend(s2);
end

r = corr(s1,s2);



