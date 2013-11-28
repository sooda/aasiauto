function CommunicationTest
    c = Car.getInstance();
    com = Communication();

    com.connectToCar('Simul');
    
    if (com.status ~= 5) % Simul
        Logging.log('Error connecting...');
        return;
    end
    
    Logging.log('Set car value...');
    Protocol.setCarValue(c, Car.absEnabled, 1)
    
    Logging.log('Read car value:');
    val = Protocol.getCarValue(c, Car.absEnabled);
    disp(val);

    % set experimental data coming in
    com.buf_in = [5 6 7 8];

    disp('read incoming values');
    val = com.read();
    disp(val);
    
    com.write([1 2 3]);
    
    pause(1);
    
    com.disconnectFromCar();
    stop(timerfind());
    
end