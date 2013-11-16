%
% Compile the model first!
% model([],[],[],'compile')
%
% Terminate model after..
% model([],[],[],'term')
%
% http://www.swarthmore.edu/NatSci/echeeve1/Ref/Kalman/MatrixKalman.html

clear s

s.A = calcA(0);

% Define a process noise (stdev) as the car operates:
s.Q = 2^2*eye(6,6); % variance, hence stdev^2

% Define system to measure velocity, acceleration and theta
s.H = [
    0 0 1 0 0 0
    0 0 0 1 0 0
    0 0 0 0 0 1
]; %eye(5);

% Define a measurement error (stdev):
s.R = 4^2*eye(size(s.H,1)); % variance, hence stdev^2
%s.R(3,3) = 0.1^2;

% Do not define any system input (control) functions:
s.B = 0;
s.u = 0;

% Do not specify an initial state:
s.x = nan;
s.P = nan;

% Generate random input and watch the filter operate.
tru=[]; % true input
for t=1:25
   outputs = model(t,[],[],'outputs');
   tru(end+1) = outputs(3);

   % create a measurement with noise
   s(end).z = [
       outputs(1) + randn
       outputs(2) + randn
       outputs(3) + randn/5
   ];

   s(end+1) = kalmanfilter(s(end)); % perform a Kalman filter iteration

   % p‰ivitet‰‰n dynaamiikkamatriisi A uusilla mittaus/tilatiedoilla
   s(end).A = calcA(s(end));
  
end

figure
axis equal
hold on
grid on
asd1 = [s(1:end-1).z];
asd2 = [s(2:end).x];
plot(asd2(1,:), asd2(2,:));

figure
hold on
grid on

% plot measurement data:
hk=plot(1:length(asd1),asd1,'b-');

% plot a-posteriori state estimates:
%hk=plot(asd2,'b-');

%ht=plot(tru,'g-');

%legend([hz hk ht],'observations','Kalman output','true data',0)
%title('Automobile Voltimeter Example')
%hold off

