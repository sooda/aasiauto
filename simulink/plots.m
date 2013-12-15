figure

subplot(2,1,1);

plot(ctrlData.Time,ctrlData.Data(:,1)./500,carData.Time,carData.Data(:,6)./500, ctrlData.Time, ctrlData.Data(:,4)./100);
legend('output', 'input', 'slipK');
title(['ABS-simulaatio slipK:' num2str(slipPid(1)) ' slipTi:' num2str(slipPid(2)) ' slipTd:' num2str(slipPid(3)) ...
     ' accK:' num2str(accPid(1)) ' accTi:' num2str(accPid(2)) ' accTd:' num2str(accPid(3))])
ylim([0 1.1]);

% 
% subplot(3,1,2); 
% plot(carData.Time,carData.Data(:,1), carData.Time, carData.Data(:,2));
% legend('vehicle speed', 'wheel speed');

subplot(2,1,2);
plot(carData.Time, carData.Data(:,3).*100, carData.Time, carData.Data(:,4));
legend('slip', 'wheel acceleration');