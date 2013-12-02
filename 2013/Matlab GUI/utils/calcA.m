function A = calcA(s)
%theta = 0;  % ajoneuvon suunta suhteessa x-akseliin
%phi = 0;    % ohjauskulma suhteutettuna auton linjaan
L = 5.2;    % akselien välimatka (m)2

if ~isfield(s,'x')
    the = 0;
    phi = 0;
    dt = 1/10; % mittauksia noin 100ms välein
else
    the = s.x(5);       % theta angle from state vector
    phi = -1 * s.z(3);  % phi angle from measurements
%    phi = s.x(6);
    dt = 0.1; %s.dt;
end

A = [
     1  0   dt*cos(the)   .5*dt^2*cos(the)  0   0
     0  1   dt*sin(the)   .5*dt^2*sin(the)  0   0
     0  0       1               0           0   0
     0  0       0               1           0   0
     0  0   dt/L*tan(phi)       0           1   0
     0  0       0               0           0   1
];

% x = [ x y v a theta phi ]';
end
