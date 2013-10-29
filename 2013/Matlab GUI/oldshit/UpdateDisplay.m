function UpdateDisplay(hObject, eventdata, hfigure, handles)
    % Timer timer1 callback, called each time timer iterates.
    % Gets surface Z data, adds noise, and writes it back to surface object.

     [~, ~, keysAreDown] = KbCheck();
     handles2 = guidata(hfigure);

     c = Car.getInstance;
%     cardata = getappdata(handles.figure1, 'Car_Data');
%     appdata = getappdata(handles.figure1, 'App_Data');

     %appdata.read_value_counter = appdata.read_value_counter + 1;

     %Get last element from each dataset
     thro = c.cardata.throttle(size(c.cardata.throttle,1));
     dir = c.cardata.wheeldirection(size(c.cardata.wheeldirection,1));
     brake = c.cardata.brake(size(c.cardata.brake,1));
     rev = c.cardata.reverse(size(c.cardata.reverse,1));
     sound_horn = 0;


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
                %if carspeed < 2? --> enable TODOOOOOO
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
     if(~keysAreDown(37)&& ~keysAreDown(39))
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
     if(keysAreDown(67))
         drv_clutch = uint8(1);
     end

     if(keysAreDown(84))
         sound_horn = 1;
     end

     temp_read_value_counter = c.appdata.read_value_counter;
     c.appdata.read_value_counter = temp_read_value_counter + 1;

     if c.appdata.read_value_counter == 5
       c.appdata.read_value_counter = 1;
        %READ DATA FROM CAR
       if c.appdata.serial.BytesAvailable
          datastr = fread(c.appdata.serial, c.appdata.serial.BytesAvailable); 

         if c.appdata.storedserialdata ~= 999 %Add stored data to beginning
             datastr = [c.appdata.storedserialdata; datastr];
             c.appdata.storedserialdata = 999;
         end

         length = size(datastr,1);

         i = 1;
         jump = 0; %used if 255 + 0, meaning a data byte 255
         while i <= length


             readcurrentdata = 1;
             %'Check if its maybe a new message'
              if(datastr(i) == 255) %Check if it's maybe a new message

                 if i+1 <= length %Can read next byte

                     if datastr(i+1) == 48 %If its a new message for computer
                         c.appdata.serialcurrentbytenum = 1;
                         i = i+2;
                         readcurrentdata = 0;
                     elseif datastr(i+1) ~= 0 %Wrong message ID
                         Logging.log('Received wrong message ID.');
                         break;                     
                     else %Read 255 followed by 0 is 255;
                         jump = 1;
                     end   

                 else

                     if c.appdata.storedserialdata == 999 %Add store 255
                        c.appdata.storedserialdata = 255;
                     else
                        c.appdata.storedserialdata = [c.appdata.storedserialdata; 255];
                     end
                     %'break'
                     break;
                 end    
              end
              %'We are not in the beginning of a message'
              if readcurrentdata %We are not in the beginning of a message

                 current_byte = datastr(i);
                 switch c.appdata.serialcurrentbytenum

                 case 1 %Wheelspeeds 
                 c.cardata.wheelspeeds = [c.cardata.wheelspeeds; [0 0 0 0]]; 
                 wheel_length = size(c.cardata.wheelspeeds,1);
                 %Speed [km/h] = 3.6 * pi * wheeldiameter[m] * relevations/seconds
                 wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h % 1.4137 *((current_byte/512)/0.01);          
                 c.cardata.wheelspeeds(wheel_length, 1) = wheelSpeed;

                 case 2  %Wheelspeeds
                 wheel_length = size(c.cardata.wheelspeeds,1);
                 wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h  % 1.4137 *((current_byte/512)/0.01);
                 c.cardata.wheelspeeds(wheel_length, 2) = wheelSpeed;

                 case 3 %Wheelspeeds
                 wheel_length = size(c.cardata.wheelspeeds,1);
                 %current_byte
                 wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h  % 1.4137 *((current_byte/512)/0.01);
                 %wheelSpeed = ((current_byte/512)/0.01)

                 c.cardata.wheelspeeds(wheel_length, 3) = wheelSpeed;

                 case 4 %Wheelspeeds
                 wheel_length = size(c.cardata.wheelspeeds,1);
                 wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h  % 1.4137 *((current_byte/512)/0.01);
                 c.cardata.wheelspeeds(wheel_length, 4) = wheelSpeed;   

                 %ACCELERATION   
                 case 5 %X-acceleration high byte 
                     c.appdata.temp_high_byte = current_byte;
                 case 6 %X-acceleration low byte          
                     value = calcHighLowByteValue(c.appdata.temp_high_byte, current_byte);
                     c.cardata.acceleration = [c.cardata.acceleration; [0 0 0]]; % add new row
                     acc_length = size(c.cardata.acceleration,1);
                     c.cardata.acceleration(acc_length,1) = value * c.cardata.acc_scaling;
                     if(abs(c.cardata.acceleration(acc_length,1)) < 0.4)
                        c.cardata.acceleration(acc_length,1) = 0;
                     end


                 case 7%Y High
                     c.appdata.temp_high_byte = current_byte;
                 case 8%Y Low
                     value = calcHighLowByteValue(c.appdata.temp_high_byte, current_byte);
                     acc_length = size(c.cardata.acceleration,1);
                     c.cardata.acceleration(acc_length,2) = value * c.cardata.acc_scaling;
                     if(abs(c.cardata.acceleration(acc_length,2)) < 0.4)
                        c.cardata.acceleration(acc_length,2) = 0;
                     end
                 case 9%Z high
                     c.appdata.temp_high_byte = current_byte;
                 case 10%Z low
                     value = calcHighLowByteValue(c.appdata.temp_high_byte, current_byte);
                     acc_length = size(c.cardata.acceleration,1);
                     c.cardata.acceleration(acc_length,3) = value * c.cardata.acc_scaling; 
                     if(abs(c.cardata.acceleration(acc_length,3)) < 0.4)
                        c.cardata.acceleration(acc_length,3) = 0;
                     end      
                     %c.cardata.acceleration(acc_length,:)
                 %GYRO
                 case 11 %X-gyro high byte 
                     c.appdata.temp_high_byte = current_byte;
                 case 12    
                     value = calcHighLowByteValue(c.appdata.temp_high_byte, current_byte);
                     c.cardata.gyro = [c.cardata.gyro; [0 0 0]]; % add new row
                     gyro_length = size(c.cardata.gyro,1);
                     c.cardata.gyro(gyro_length,1) = value / 14.38;
                 case 13 %Y-gyro high byte 
                     c.appdata.temp_high_byte = current_byte;
                 case 14    
                     value = calcHighLowByteValue(c.appdata.temp_high_byte, current_byte);
                     gyro_length = size(c.cardata.gyro,1);
                     c.cardata.gyro(gyro_length,2) = value / 14.38;
                 case 15 %X-gyro high byte 
                     c.appdata.temp_high_byte = current_byte;
                 case 16    
                     value = calcHighLowByteValue(c.appdata.temp_high_byte, current_byte);
                     gyro_length = size(c.cardata.gyro,1);
                     c.cardata.gyro(gyro_length,3) = value / 14.38;

                     %c.cardata.gyro(gyro_length,:)  
                 %Remaining values
                 case 17
                     c.cardata.wheeldirection = [c.cardata.wheeldirection ; current_byte];
                 case 18
                     c.cardata.motorBatteryVoltage = [c.cardata.motorBatteryVoltage; current_byte]; 
                 case 19 % Last byte in message
                     c.cardata.controllerBatteryVoltage = [c.cardata.controllerBatteryVoltage; current_byte]; 

                     %Update Timer
                    timeLength = size(c.cardata.timepassed,1);
                    if(timeLength>1)
                        c.cardata.timepassed = [c.cardata.timepassed; c.cardata.timepassed(timeLength) + handles2.timer.InstantPeriod];
                    else
                        c.cardata.timepassed = [c.cardata.timepassed; 0];  
                    end

                    %Car Total velocity
                    velLen = size(c.cardata.wheelspeeds,1);
                    totalvelocity = sum(c.cardata.wheelspeeds(velLen,3:4))/2;%For the seminar presentation: Only use rear wheel data
                    c.cardata.totalvelocity = [c.cardata.totalvelocity; totalvelocity];

                    %Calculate car position
                    accLength = size(c.cardata.acceleration,1);
                    %c.cardata.acceleration(accLength,:);

                    if(timeLength > 1)
                        deltaPos = calcPosFromAcc(c.cardata.acceleration((accLength-1):accLength,:),0.5);%c.cardata.timepassed(timeLength));          
                    else
                        deltaPos = [0 0 0];
                    end

                    posLength = size(c.cardata.position,1);
                    c.cardata.position = [c.cardata.position; c.cardata.position(posLength,:) + deltaPos];


                 otherwise             
                     Logging.log('Read exceeds normal message length.');
                    % 'Read exceeds normal message length.'
                    % strcat('Current byte is: ', num2str(c.appdata.serialcurrentbytenum))
                 end

                  i = i + 1 + jump; 
                  c.appdata.serialcurrentbytenum = c.appdata.serialcurrentbytenum + 1;
                  jump = 0;
              end
         end  
       end

       % Update c.cardata only when it's read
       set(handles2.carpath,'YData',c.cardata.position(:,2));
       set(handles2.carpath,'XData',c.cardata.position(:,1));

       set(handles2.carspeed,'YData',c.cardata.totalvelocity);
       set(handles2.carspeed,'XData',c.cardata.timepassed);
     end

    %Save steering data
    c.cardata.throttle = [c.cardata.throttle; thro];
    c.cardata.brake = [c.cardata.brake; brake];
    c.cardata.wheeldirection = [c.cardata.wheeldirection; dir];
    c.cardata.reverse = [c.cardata.reverse; rev];

    thro = thro * 0.2;
    rev = rev * 0.2;

    %SEND DATA TO CAR
    drv_throttle = uint8(thro * 2.55);
    drv_dir = uint8(128 + (dir * 127) / 45); % direction
    drv_brake = uint8(brake * 2.55); % jarru
    drv_drvdir = uint8(0);

    if(thro > 0)
        drv_drvdir = uint8(0); % ajosuunta
    elseif (rev > 0)
        drv_drvdir = uint8(1); % ajosuunta
        drv_throttle = uint8(rev * 2.55);
    end

    stopasync(c.appdata.serial); % why?

    if(sound_horn)   
        fwrite(c.appdata.serial, [255 65 drv_throttle drv_dir drv_brake drv_clutch drv_drvdir 255 68], 'async');  
    else
        fwrite(c.appdata.serial, [255 65 drv_throttle drv_dir drv_brake drv_clutch drv_drvdir], 'async');
    end
    readasync(c.appdata.serial);  % what?
    %Save car data
%    setappdata(handles.figure1, 'Car_Data',c.cardata);
%    setappdata(handles.figure1, 'App_Data',c.appdata);

    %Update command plots

    set(handles2.reverse,'YData',rev);
    set(handles2.throttle,'YData',thro);
    set(handles2.brake,'YData',brake);
    set(handles2.direction,'YData',dir);

end