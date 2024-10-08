function gmap=blue_to_red(ncolors)

gmap=...
 [...
 10 50 120
 15 75 165
 30 110 200
 60 160 240
 80 180 250
130 210 255
160 240 255
200 250 255
% 200 250 255
255 255 255

255 255 255
% 255 232 120
255 232 120
255 192  60
255 160   0
255  96   0
255  50   0
225  20   0
192   0   0
165   0   0 ...
]./255;

I=length(gmap(:,1));
np=linspace(1,I,ncolors);  
rr = interp1(1:I,gmap(1:I,1),np,'linear');
gg = interp1(1:I,gmap(1:I,2),np,'linear');
bb = interp1(1:I,gmap(1:I,3),np,'linear');
gmap = [rr(:),gg(:),bb(:)];
