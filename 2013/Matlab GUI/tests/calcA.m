function A = calcA(s)
%theta = 0;  % ajoneuvon suunta suhteessa x-akseliin
%phi = 0;    % ohjauskulma suhteutettuna auton linjaan
L = 4;    % akselien välimatka
dt = 1/10; % mittauksia noin 100ms välein

if ~isfield(s,'x')
    the = 0;
    phi = 0;
else
    the = s.x(5);
    phi = s.x(6);
end

A = [
     1  0   dt*cos(the)   .5*dt^2*cos(the)  0   0
     0  1   dt*sin(the)   .5*dt^2*sin(the)  0   0
     0  0       1               0           0   0
     0  0       0               1           0   0
     0  0   dt/L*tan(phi)       0           0   0
     0  0       0               0           0   0
];

% x = [ x y v a theta phi ]';
end
