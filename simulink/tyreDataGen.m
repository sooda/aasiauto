v = [0,  0.60,    0.80,  0.78,  0.72,   0.66,  0.63,   0.61];
x = linspace(0,1,8);
%x = [0,  10, 20,  30,  40,    60,    80,    100];
xq = linspace(0,1,101);
tyreData = interp1(x,v,xq, 'spline');
%plot(tyreData)
%csvwrite('tyredata.dat',tyreData)
