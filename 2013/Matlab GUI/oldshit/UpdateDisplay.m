function UpdateDisplay(~, ~, hfigure, ~)

    % Timer timer1 callback, called each time timer iterates.
    
    handles2 = guidata(hfigure);

    c = Car.getInstance;

    c.appdata.com.async_Communication_triggered(); % handle communication here
    

    measurement_data = c.cardata.last_measurements;
    data = Protocol.processMeasurementData(measurement_data);
    keys = getappdata(0, 'keys');
    
    %Get last element from each dataset
    sound_horn = 0;  %#ok<*NASGU>
    maxAngle = 30; % maximum steering wheel angle
    
    %% Read joystick input
    joy = [-0.2891    0.2620   -0.5703    0.5397]; % [ left_max right_max forward_max backward_max ]
    if numel(c.appdata.joystick)
        try 
            a = read(c.appdata.joystick);
        catch
            c.appdata.joystick = [];
            return;
        end
        
        thro = a(6) / joy(4) * 100;
        dir = a(1) / joy(2) * maxAngle;
        rev = a(6) / joy(4) * 100;
        brake = a(6) / joy(4) * 100;
        sound_horn = 0;

        if abs(thro) > 2
            brake = 0;
        end
        
        if (dir > maxAngle)
            dir = maxAngle;
        end
        if (dir < -maxAngle)
            dir = -maxAngle;
        end;
        
        % dead zone near 0
        if (abs(thro) < 2)
            thro = 0;
        end
        if (abs(dir) < 2)
            dir = 0;
        end
        
        % sanity check
        if (thro < 0)
            thro = 0;
            rev = 0;
            brake = 75;
        end
        if (thro > 0)
            rev = 0;
        end
        
    else
        % Read user keyboard commands
        [dir, thro, rev, brake] = parseInputFromKeyboard(keys, maxAngle, c);
    end
    
    % check sound horn
    if find(ismember(keys,'t'))
        sound_horn = 1;
    end

    % Store measured values
    c.cardata.wheelspeeds = [c.cardata.wheelspeeds; data(1:4)];
    c.cardata.acceleration = [c.cardata.acceleration; data(5:7)];
    c.cardata.gyro = [c.cardata.gyro; data(8:10)];
    c.cardata.wheeldirection = [c.cardata.wheeldirection; data(11)];
    c.cardata.motorBatteryVoltage = [c.cardata.motorBatteryVoltage; data(12)];
    c.cardata.controllerBatteryVoltage = [c.cardata.controllerBatteryVoltage; data(13)];
    
    % Update Timer
    c.cardata.timepassed(end+1) = c.cardata.timepassed(end) + 0.05; %+ handles2.timer.InstantPeriod;
    
    % Car Total velocity
    totalvelocity = sum(c.cardata.wheelspeeds(end,1:4))/4;
%    totalvelocity = max(c.cardata.wheelspeeds(end,1:4));
    c.cardata.totalvelocity = [c.cardata.totalvelocity; totalvelocity];

    % plot some measurements (if figure is open)
    if ishandle(2)
        h = getappdata(2, 'handles');
        if isfield(h,'h1')
            mdata = { c.cardata.motorBatteryVoltage ;
                c.cardata.controllerBatteryVoltage };
            set(h.h1, {'YData'}, mdata, 'XData', c.cardata.timepassed');
        end
    end

    
    % Calculate car position
    timeSinceLast = 0.0;
    if(numel(c.cardata.timepassed) > 1)
        timeSinceLast = c.cardata.timepassed(end) - c.cardata.timepassed(end-1);
    end


    %% Use Kalman filter to predict position using velocity,
    % acceleration and theta angle
    % initialize on the first time
    if (~isfield(c.appdata,'kalmanfilter'))
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
%        s.z = [0; 0; 0];
        c.appdata.kalmanfilter = s;

    end
    
    %c.appdata = rmfield(c.appdata,'kalmanfilter');
    %return;
    
    % Apply Kalman-filter
    if (timeSinceLast > 0)
        s = c.appdata.kalmanfilter;

        % set measured data
        s(end).z = [
           c.cardata.totalvelocity(end)
           max(c.cardata.acceleration(end))
           degtorad(dir*-1) % direction angle between [-maxAngle, maxAngle] deg
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
    
    
    %% Update c.cardata
    set(handles2.carpath,'XData',c.cardata.position(:,1));
    set(handles2.carpath,'YData',c.cardata.position(:,2));

    set(handles2.carspeed,'XData',c.cardata.timepassed);
    set(handles2.carspeed,'YData',c.cardata.totalvelocity);
 
    %Save steering data
    c.cardata.throttle = [c.cardata.throttle; thro];
    c.cardata.brake = [c.cardata.brake; brake];
    c.cardata.steeringwheel = [c.cardata.steeringwheel; dir];
    c.cardata.reverse = [c.cardata.reverse; rev];

    %SEND DATA TO CAR
    if (rev > 0)
        thro = -rev;
    end
    drv_throttle = thro * 10;    % throttle or reverse [-1000, 1000]
    drv_dir = dir/maxAngle*1000; % steering wheel angle [-1000, 1000]
    drv_brake = brake * 10;      % brake [0, 1000]

    % throttle
    data = [drv_throttle drv_throttle];
    c.appdata.com.write2(120, data);

    % steering
    c.appdata.com.write2(121, drv_dir);

    % brake
    data = [drv_brake drv_brake drv_brake drv_brake];
    c.appdata.com.write2(122, data);
    
    % sound horn
%    c.appdata.com.write2(123, sound_horn);
    
    if rev > 0
        thro = 0;
    end
    
    %Update command plots
    set(handles2.reverse,'YData',rev);
    set(handles2.throttle,'YData',thro);
    set(handles2.brake,'YData',brake);
    set(handles2.direction,'YData',dir);

%    drawnow;
    
end
