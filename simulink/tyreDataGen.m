v = [0,  60,    80,  78,  72,   66,   63,   61];
x = [0,  10,    20,  30,  40,    60,    80,    100];
xq = linspace(0,100,101);
tyreData = interp1(x,v,xq, 'spline');
%plot(tyreData)
%csvwrite('tyredata.dat',tyreData)
