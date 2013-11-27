function CommunicationTest
    c = Car.getInstance();
    com = Communication();

    com.connectToCar('Simul');
    
    if (com.status ~= 5) % Simul
        Logging.log('Error connecting...');
        return;
    end
    
    Logging.log('Set car value:');
    Protocol.setCarValue(c, Car.absEnabled, 1)
    

    val = Protocol.getCarValue(c, Car.absEnabled);
    disp(val);


    val = com.getBytes();
    disp(val);
    
    com.writeBytes([1 2 3]);

end