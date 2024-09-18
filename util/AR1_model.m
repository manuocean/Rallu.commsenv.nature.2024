function s=AR1_model(time,f,gamma)


f=f-mean(f);

f=detrend(f);

T=length(f);

sig=zeros(T,1);
sig(1)=0;

alfa = (1-gamma);

for t=1:T
  sig(t+1) = sig(t) *alfa + f(t);
end


sig=detrend(sig);
%sig=nn(sig-mean(sig));

s.sig=(sig(2:end)+sig(1:end-1))/2;
s.time=time;
s.sig=s.sig/std(s.sig);


