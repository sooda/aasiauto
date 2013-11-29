function UpdateDisplay(~, ~, hfigure, ~)
    % Timer timer1 callback, called each time timer iterates.
    % Gets surface Z data, adds noise, and writes it back to surface object.
    
    [~, ~, keysAreDown] = KbCheck();
    handles2 = guidata(hfigure);

    c = Car.getInstance;

    %Get last element from each dataset
    thro = c.cardata.throttle(size(c.cardata.throttle, end));
    dir = c.cardata.wheeldirection(size(c.cardata.wheeldirection, end));
    rev = c.cardata.reverse(size(c.cardata.reverse, end));
    brake = 0;
    sound_horn = 0;

    measurement_data = c.cardata.last_measurements;
    data = Protocol.processMeasurementData(measurement_data);
     
    %Reading user keyboard commands

    %Reading Brake commands
    if(keysAreDown(32))%'Space bar' = full brake
         brake = 100;
         thro = 0;
         rev = 0;
    elseif keysAreDown(78)%'n' = strong brake
         brake = 75;
         thro = 0;
         rev = 0;
    elseif keysAreDown(66)%'b' = medium brake
         brake = 50;
         thro = 0;
         rev = 0;
    elseif keysAreDown(86)%'v' = minimal brake
         brake = 25;
         thro = thro / 2;
         rev = rev / 2;
    else
         brake = 0;

         %If no brake, reading throttle commands
         if(keysAreDown(38)) %'uparrow'
            thro = thro+5-thro/20;
            rev = 0;
         else
           thro = thro-25;
           if(thro < 0)
               thro = 0;
           end

           %If no brake or throttle then read reverse
           if(keysAreDown(40))%'downarrow'
                thro = 0;
                % if carspeed < 2? --> enable TODOOOOOO ---> check this in
                % microcontrols!
                rev = rev+5-rev/20;
           else
                rev = rev-25;
                if (rev < 0)
                    rev = 0;
                end
           end  

         end
    end  

    %Reading steering commands
    if(keysAreDown(37)) %rightarrow
        dir = -45;%dir - 20;
         if(dir < -45)
            dir=-45;
        end
    end
    %Reading steering commands
    if(keysAreDown(39)) %leftarrow

        dir = 45;%dir + 20;

        if(dir > 45)
             dir = 45;
         end
    end

    %If no steering command given
    if(~keysAreDown(37)&& ~keysAreDown(39)) % ~right && ~left arrow
         if(dir>0)
              dir = dir - 10;
              if(dir<0)
                   dir= 0;
              end
         else
              dir = dir + 10;
              if(dir>0)
                  dir = 0;
              end     
         end
    end

    drv_clutch = uint8(0); % kytkimen asento
    if(keysAreDown(67)) % TODO: mik� n�pp�in? c?
        drv_clutch = uint8(1);
    end

    if(keysAreDown(84)) % TODO: mik� n�pp�in? t?
        sound_horn = 1;
    end

    % Process received measurement data
    
    % Store measured values
    c.cardata.wheelspeeds = [c.cardata.wheelspeeds; data(1:4)];
    c.cardata.acceleration = [c.cardata.acceleration; data(5:7)];
    c.cardata.gyro = [c.cardata.gyro; data(8:10)];
    c.cardata.wheeldirection = [c.cardata.wheeldirection; data(11)];
    c.cardata.motorBatteryVoltage = [c.cardata.motorBatteryVoltage; data(12)];
    c.cardata.controllerBatteryVoltage = [c.cardata.controllerBatteryVoltage; data(13)];
    
    % Update Timer
    c.cardata.timepassed = [c.cardata.timepassed; c.cardata.timepassed(end) + handles2.timer.InstantPeriod];
    
    % Car Total velocity
    totalvelocity = sum(c.cardata.wheelspeeds(end,1:4))/2;
    c.cardata.totalvelocity = [c.cardata.totalvelocity; totalvelocity];

    % Calculate car position
    timeSinceLast = 0.0;
    if(numel(c.cardata.timepassed) > 1)
        timeSinceLast = cardata.timepassed(end) - cardata.timepassed(end-1);
    end

    posLength = size(c.cardata.position,1);
    c.cardata.position = [c.cardata.position; c.cardata.position(posLength,:) + deltaPos];


    % Use Kalman filter to predict position using velocity,
    % acceleration and theta angle

    % initialize on the first time
    if (~isfield(c.appdata,'kalmanfilter'))
        s.dt = timeSinceLast;
        s.A = calcA(nan); % initialize with theta 0

        % Define a process noise (stdev) as the car operates:
        s.Q = 2^2*eye(6,6); % variance, hence stdev^2
        s.Q(5,5) = 0.2^2;
        s.Q(6,6) = 0.2^2;

        % Define system to measure velocity, acceleration and theta
        s.H = [
            0 0 1 0 0 0
            0 0 0 1 0 0
            0 0 0 0 0 1
        ];

        % Define a measurement error (stdev):
        s.R = [2^2  0   0 % variance, hence stdev^2
               0   2^2  0
               0    0  0.05^2];

        % Do not define any system input (control) functions:
        s.B = 0;
        s.u = 0;

        % Do not specify an initial state:
        s.x = nan;
        s.P = nan;
        c.appdata.kalmanfilter = s;

    end

    if (timeSinceLast > 0)
        s = c.appdata.kalmanfilter;
        s.dt = timeSinceLast;

        % set measured data
        s(end).z = [
           c.cardata.totalvelocity(end)
           c.cardata.acceleration(end)
           degtorad(dir) % direction angle between [-45, 45] deg
        ];

        s(end+1) = kalmanfilter(s(end)); % perform a Kalman filter iteration

        % update dynamics matrix A with new measures and state
        s(end).A = calcA(s(end));

        % update car position
        asd = [s(2:end).x];
        pos(1) = asd(1,end);
        pos(2) = asd(2,end);
        c.cardata.position = [c.cardata.position; pos];
        c.appdata.kalmanfilter = s;
    end
                

    % Update c.cardata
    set(handles2.carpath,'XData',c.cardata.position(:,1));
    set(handles2.carpath,'YData',c.cardata.position(:,2));

    set(handles2.carspeed,'XData',c.cardata.timepassed);
    set(handles2.carspeed,'YData',c.cardata.totalvelocity);
 

    %Save steering data
    c.cardata.throttle = [c.cardata.throttle; thro];
    c.cardata.brake = [c.cardata.brake; brake];
    c.cardata.wheeldirection = [c.cardata.wheeldirection; dir];
    c.cardata.reverse = [c.cardata.reverse; rev];

    thro = thro * 0.2; % TODO: scaling throttle and reverse shoudn't be needed here!
    rev = rev * 0.2;

    %SEND DATA TO CAR
    drv_throttle = uint8(thro * 2.55);
    drv_dir = uint8(128 + (dir * 127) / 45); % steering wheel direction
    drv_brake = uint8(brake * 2.55);
    drv_drvdir = uint8(0); % driving direction

    if(thro > 0)
        drv_drvdir = uint8(0);
    elseif (rev > 0)
        drv_drvdir = uint8(1);
        drv_throttle = uint8(rev * 2.55);
    end

    % Write driving data to car
    data = [drv_throttle drv_dir drv_brake drv_clutch drv_drvdir sound_horn];
    datasz = 2*numel(data);
    c.appdata.com.write([datasz 120 data]);
    
    %Update command plots
    set(handles2.reverse,'YData',rev);
    set(handles2.throttle,'YData',thro);
    set(handles2.brake,'YData',brake);
    set(handles2.direction,'YData',dir);

end