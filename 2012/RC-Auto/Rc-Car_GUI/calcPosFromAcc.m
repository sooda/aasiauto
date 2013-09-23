function position = calcPosFromAcc(acceleration, time)

position = [0 0 0];
%velocity = [0 0 0];

xAcc = (acceleration(1,1)+ acceleration(2,1))/2.0;
yAcc = (acceleration(1,2)+ acceleration(2,2))/2.0;
zAcc = (acceleration(1,3)+ acceleration(2,3))/2.0;

%  xAcc
%  yAcc
%  zAcc

position(1) = 0.5 * xAcc * time^2;
position(2) = 0.5 * yAcc * time^2;
position(3) = 0.5 * zAcc * time^2;

%velocity(1) = xAcc * time;
%velocity(2) = yAcc * time;
%velocity(3) = zAcc * time;
end