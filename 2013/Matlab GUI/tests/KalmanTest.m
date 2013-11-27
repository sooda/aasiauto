%
% Compile the model first!
% model([],[],[],'compile')
%
% Terminate model after..
% model([],[],[],'term')
%
% http://www.swarthmore.edu/NatSci/echeeve1/Ref/Kalman/MatrixKalman.html

clear s

s.A = calcA(nan);
s.dt = 1/10;

% Define a process noise (stdev) as the car operates:
s.Q = 2^2*eye(6,6); % variance, hence stdev^2
s.Q(5,5) = 0.2^2;
s.Q(6,6) = 0.2^2;

% Define system to measure velocity, acceleration and theta
s.H = [
    0 0 1 0 0 0
    0 0 0 1 0 0
    0 0 0 0 0 1
]; %eye(5);

% Define a measurement error (stdev):
%s.R = 4^2*eye(size(s.H,1)); % variance, hence stdev^2
%s.R(3,3) = 0.1^2;
s.R = [2^2  0   0
       0   2^2  0
       0    0  0.05^2];

% Do not define any system input (control) functions:
s.B = 0;
s.u = 0;

% Do not specify an initial state:
s.x = nan;
s.P = nan;

% Generate random input and watch the filter operate.
N = 100;

figure(1)
subplot 121
axis equal
axis square
%hold on
grid on
%h1 = plot(asd2(1,:), asd2(2,:));
h1 = plot(0,0);

subplot 122;
grid on
% plot measurement data:
%h2 = plot(1:length(asd1),asd1);
h2 = plot(0,[0 0 0]);
legend('velocity', 'acceleration', 'theta angle');

for t=1:N
   outputs = model(t,[],[],'outputs');

   % create a measurement with noise
   s(end).z = [
       outputs(1) + randn/2
       outputs(2) + randn/5
       degtorad(outputs(3)*45) + (rand-0.5)/50
   ];

   s(end+1) = kalmanfilter(s(end)); % perform a Kalman filter iteration

   % p‰ivitet‰‰n dynaamiikkamatriisi A uusilla mittaus/tilatiedoilla
   s(end).A = calcA(s(end));
  
    asd1 = [s(1:end-1).z];
    asd2 = [s(2:end).x];
    
    set(h1, 'XData', asd2(1,:), 'YData', asd2(2,:));
    set(h2, 'XData', 1:length(asd1), {'YData'}, {asd1(1,:); asd1(2,:); asd1(3,:)}), 
    
    pause(0.05)
    
end


% plot a-posteriori state estimates:
%hk=plot(asd2,'b-');

%ht=plot(tru,'g-');

%legend([hz hk ht],'observations','Kalman output','true data',0)
%title('Automobile Voltimeter Example')
%hold off

