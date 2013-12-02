function UpdateDisplay(~, ~, hfigure, ~)
    % Timer timer1 callback, called each time timer iterates.
    % Gets surface Z data, adds noise, and writes it back to surface object.
    
    handles2 = guidata(hfigure);

    c = Car.getInstance;

    c.appdata.com.async_Communication_triggered(); % handle communication here
    
    joy = [-0.2891    0.2620   -0.5703    0.5397]; % [ left_max right_max forward_max backward_max ]

    measurement_data = c.cardata.last_measurements;
    data = Protocol.processMeasurementData(measurement_data);
    keys = getappdata(0, 'keys');
    
    %Get last element from each dataset
    thro = c.cardata.throttle(end);
    dir = c.cardata.wheeldirection(end);
    rev = c.cardata.reverse(end);
    brake = 0;
    sound_horn = 0;

    if numel(c.appdata.joystick)
        try 
            a = read(c.appdata.joystick);
        catch
            c.appdata.joystick = [];
            return;
        end
        
        thro = a(6) / joy(4) * 100;
        dir = a(1) / joy(2) * 45;
        rev = a(6) / joy(4) * 100;
        brake = a(6) / joy(4) * 100;
        sound_horn = 0;

        if (dir > 45)
            dir = 45;
        end
        if (dir < -45)
            dir = -45;
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
        %Reading user keyboard commands

        %Reading Brake commands
        if (find(ismember(keys,'space')))
             brake = 100;
             thro = 0;
             rev = 0;
        elseif (find(ismember(keys,'n'))) %'n' = strong brake
             brake = 75;
             thro = 0;
             rev = 0;
        elseif (find(ismember(keys,'b')))%'b' = medium brake
             brake = 50;
             thro = 0;
             rev = 0;
        elseif (find(ismember(keys,'v')))%'v' = minimal brake
             brake = 25;
             thro = thro / 2;
             rev = rev / 2;
        else
             brake = 0;

             %If no brake, reading throttle commands
             if (find(ismember(keys,'uparrow'))) %'uparrow'
                thro = thro+5-thro/20;
                rev = 0;
             else
               thro = thro-25;
               if(thro < 0)
                   thro = 0;
               end

               %If no brake or throttle then read reverse
               if (find(ismember(keys,'downarrow'))) %'downarrow'
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
        if (find(ismember(keys,'rightarrow'))) %rightarrow
            dir = -45;%dir - 20;
             if(dir < -45)
                dir=-45;
            end
        end
        %Reading steering commands
        if (find(ismember(keys,'leftarrow'))) %leftarrow
            dir = 45;%dir + 20;
            if(dir > 45)
                 dir = 45;
             end
        end

        %If no steering command given
        if (~any(ismember(keys,'leftarrow') + ismember(keys,'rightarrow'))) % ~right && ~left arrow
             if(dir>0)
                  dir = dir - 10;
                  if(dir < 0)
                       dir = 0;
                  end
             else
                  dir = dir + 10;
                  if(dir > 0)
                      dir = 0;
                  end     
             end
        end
    end
    

    if find(ismember(keys,'t'))
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
%    if isnan(c.cardata.timepassed(end))
%        c.cardata.timepassed(end+1) = 0.1;
%    else
    c.cardata.timepassed(end+1) = c.cardata.timepassed(end) +0.1; %+ handles2.timer.InstantPeriod;
%    end
    
    % Car Total velocity
    totalvelocity = sum(c.cardata.wheelspeeds(end,1:4))/2;
    c.cardata.totalvelocity = [c.cardata.totalvelocity; totalvelocity];

    % plot some measurements
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
%    posLength = size(c.cardata.position,1);
%    c.cardata.position = [c.cardata.position; c.cardata.position(posLength,:) + deltaPos];


    % Use Kalman filter to predict position using velocity,
    % acceleration and theta angle
    % initialize on the first time
    if (~isfield(c.appdata,'kalmanfilter'))
        dt = 0.1; %timeSinceLast;
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
        dt = timeSinceLast;

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

%    thro = thro * 0.2; % TODO: scaling throttle and reverse shoudn't be needed here!
%    rev = rev * 0.2;
    %SEND DATA TO CAR
    if (rev > 0)
        thro = rev*-1;
    end
    drv_throttle = thro * 10; % throttle or reverse [-1000, 1000]
    drv_dir = dir/45*1000; % steering wheel angle [-255, 255]
    drv_brake = brake * 10;

    % throttle
    data = [drv_throttle drv_throttle];
%    c.appdata.com.write2(120, data);

    % steering
    if drv_dir > 0
        [121 drv_dir]
    end
%    c.appdata.com.write2(121, drv_dir);

    % brake
    data = [drv_brake drv_brake drv_brake drv_brake];
%    c.appdata.com.write2(122, data);
    
    % sound horn
%    c.appdata.com.write2(123, sound_horn);
    
    %Update command plots
    set(handles2.reverse,'YData',rev);
    set(handles2.throttle,'YData',thro);
    set(handles2.brake,'YData',brake);
    set(handles2.direction,'YData',dir);

%    drawnow;
    
end