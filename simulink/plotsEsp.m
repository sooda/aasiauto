figure

subplot(2,1,1);

plot(simData.Time,simData.Data(:,1)*10,simData.Time,simData.Data(:,2));
legend('Auton py�r�hdysnopeus [rad/s]', 'Ratin k��nt�kulma [rad*10]');
title(['ESP-simulaatio K:' num2str(pidData(1)) ' Ti:' num2str(pidData(2)) ' Td:' num2str(pidData(3))])


% 
% subplot(3,1,2); 
% plot(carData.Time,carData.Data(:,1), carData.Time, carData.Data(:,2));
% legend('vehicle speed', 'wheel speed');

subplot(2,1,2);
plot(simData.Time, simData.Data(:,2), simData.Time, simData.Data(:,4));
legend('Auton py�r�hdysnopeus [rad/s]','Auton haluttu py�r�hdysnopeus [rad/s]');