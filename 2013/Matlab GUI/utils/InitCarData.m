function cardata = InitCarData()
    cardata.throttle = 0;
    cardata.velocity = 0;
    cardata.reverse = 0;
    cardata.wheeldirection = 0;
    cardata.steeringwheel = 0;
    cardata.brake = 0;
    cardata.position = [0 0]; %X Y
    cardata.gyro = [0 0 0]; %X Y Z
    cardata.wheelspeeds = [0 0 0 0]; %Left front, Right front, Left back, Right back
    cardata.totalvelocity = 0;
    cardata.acceleration = [0.0 0.0 0.0]; %X, Y, Z
    cardata.timepassed = 0;
    cardata.motorBatteryVoltage = 0;
    cardata.controllerBatteryVoltage = 0;
    cardata.acc_scaling = 32.0/1024.0*9.81; %the conversion factor from raw data to m/s^2
    cardata.last_measurements = [];
end

