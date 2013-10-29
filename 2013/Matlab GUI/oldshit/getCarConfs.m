function getCarConfs(hObject, eventdata, handles)
    %c.appdata = getc.appdata(handles.figure1, 'App_Data');
    c = Car.getInstance;
    
    if c.appdata.serial.BytesAvailable %Clear car buffer
        fread(c.appdata.serial,c.appdata.serial.BytesAvailable);
    end

    %Request car parameters
    %stopasync(c.appdata.serial);
    readasync(c.appdata.serial);
    %pause(0.1);

    fwrite(c.appdata.serial, [255 67 255 0], 'async');
    %readasync(c.appdata.serial);
    %  fwrite(c.appdata.serial, 255);
    %  fwrite(c.appdata.serial, 67);
    %  fwrite(c.appdata.serial, 255);
    %  fwrite(c.appdata.serial, 0);

    D = 0; %The struct where the loaded data is stored.
    ver_matrix = zeros(34,1); %Verification matrix used to check that all parameters were updated

    current_Message_Id = 0;
    curremt_Parameter_Id = 0;
    reading_byte_num = 0;
    high_byte = 0;
    counter = 0;

    %READ PARAMETER DATA FROM CAR
    while (~min(ver_matrix) && counter < 3000) %Continue untill verification matrix is "full" or counter == 1000
        counter = counter + 1;
        reading_byte_num = reading_byte_num + 1;

        if c.appdata.serial.BytesAvailable
          datavalue = fread(c.appdata.serial,1); 
          %datavalue
             if datavalue == 255 %Check if it's maybe a new message
                  datavalue = fread(c.appdata.serial,1); %Pick the next byte to see what is following
                  %datavalue

                  if datavalue ~= 0 %If it's a new message
                     current_Message_Id = datavalue;        
                     curremt_Parameter_Id = fread(c.appdata.serial,1);
                     %curremt_Parameter_Id
                     reading_byte_num = 0; %Reset the counter

                  else %If it was 255 + 0, meaning a data byte 255
                     datavalue = 255;
                  end   
             end    

             if(reading_byte_num ~= 0)

                if current_Message_Id == 52 %Current parameter message from car  
                 switch curremt_Parameter_Id    

                     case 10
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.frontAxleLeftBrakeServosNeutralPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(1)=1;
                         end
                     case 11
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.frontAxleRightBrakeServosNeutralPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(2)=1;
                         end
                     case 12
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.rearAxleLeftBrakeServosNeutralPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(3)=1;
                         end
                     case 13
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.rearAxleRightBrakeServosNeutralPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(4)=1;
                         end
                         case 14
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.frontAxleLeftBrakeServosMaximumPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(5)=1;
                         end
                     case 15
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.frontAxleRightBrakeServosMaximumPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(6)=1;
                         end
                     case 16
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.rearAxleLeftBrakeServosMaximumPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(7)=1;
                         end
                     case 17
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.rearAxleRightBrakeServosMaximumPositions = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(8)=1;
                         end
                     case 20
                         if reading_byte_num == 1 %First Byte
                             D.absEnabled = datavalue;
                             ver_matrix(9)=1;
                         end
                     case 21
                          if reading_byte_num == 1 %First Byte
                             D.absLowThres = num2str(datavalue);
                             ver_matrix(10)=1;
                         end
                     case 22
                         if reading_byte_num == 1 %First Byte
                             D.absMiddleThres = num2str(datavalue);
                             ver_matrix(11)=1;
                         end
                     case 23
                         if reading_byte_num == 1 %First Byte
                             D.absHighThres = num2str(datavalue);
                             ver_matrix(12)=1;
                         end
                     case 24
                         if reading_byte_num == 1 %First Byte
                             D.finalPhaseLengthLift = num2str(datavalue);
                             ver_matrix(13)=1;
                         end
                     case 25
                         if reading_byte_num == 1 %First Byte
                             D.finalPhaseLengthHolding = num2str(datavalue);
                             ver_matrix(14)=1;
                         end                                
                     case 26
                         if reading_byte_num == 1 %First Byte
                             D.slopeFirstPhaseCalcBrake = num2str(datavalue);
                             ver_matrix(15)=1;
                         end
                     case 27
                         if reading_byte_num == 1 %First Byte
                             D.thirdPhaseReleaseBrake = num2str(datavalue);
                             ver_matrix(16)=1;
                         end
                     case 28
                         if reading_byte_num == 1 %First Byte
                             D.lastPhaseReleaseBrake = num2str(datavalue);
                             ver_matrix(17)=1;
                         end          
                     case 40
                         if reading_byte_num == 1 %First Byte
                             D.espEnabled = datavalue;
                             ver_matrix(18)=1;
                         end
                     case 41
                          if reading_byte_num == 1 %First Byte
                             D.espSensitivityControlAngVel = num2str(datavalue);
                             ver_matrix(19)=1;
                         end
                     case 42
                          if reading_byte_num == 1 %First Byte
                             D.espSensitivityAdjSlipAngle = num2str(datavalue);
                             ver_matrix(20)=1;
                         end
                     case 43
                          if reading_byte_num == 1 %First Byte
                             D.espBrakeForceFactor = num2str(datavalue);
                             ver_matrix(21)=1;
                         end
                     case 44
                          if reading_byte_num == 1 %First Byte
                             D.espBrakeForceDist = num2str(datavalue);
                             ver_matrix(22)=1;
                         end
                     case 45
                          if reading_byte_num == 1 %First Byte
                             D.espAngularVelContPCoeff = num2str(datavalue);
                             ver_matrix(23)=1;
                         end
                     case 46
                          if reading_byte_num == 1 %First Byte
                             D.espAngularVelContDCoeff = num2str(datavalue);
                             ver_matrix(24)=1;
                         end
                     case 47
                          if reading_byte_num == 1 %First Byte
                             D.espDriftAngleContrPCoeff = num2str(datavalue);
                             ver_matrix(25)=1;
                         end
                     case 48
                          if reading_byte_num == 1 %First Byte
                             D.espDriftAngleContrDCoeff = num2str(datavalue);
                             ver_matrix(26)=1;
                         end
                     case 49
                          if reading_byte_num == 1 %First Byte
                             D.espThresValAngularVelToSlipAngleContrl = num2str(datavalue);
                             ver_matrix(27)=1;
                          end

                     case 50   
                          if reading_byte_num == 1 %First Byte
                             D.dynamicWheelRollRadius = num2str(datavalue);
                             ver_matrix(28)=1;
                          end                
                     case 51
                           if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                           elseif reading_byte_num == 2%Second Byte  
                             D.wheelbase = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue); %scaled to mm   
                             ver_matrix(29)=1;
                           end
                     case 52
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.vehicleMass = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue, 1000); %scaled to kg   
                             ver_matrix(30)=1;
                         end
                     case 53
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.distanceFrontAxleCoG = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(31)=1;
                         end
                     case 54
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.distanceRearAxleCoG = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);  
                             ver_matrix(32)=1;
                         end
                     case 55
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.frontAxleTurnStiffness = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(33)=1;
                         end
                     case 56
                         if reading_byte_num == 1 %First Byte
                             high_byte = datavalue; 
                         elseif reading_byte_num == 2%Second Byte  
                             D.rearAxleTurnStiffness = ByteTools.calcHighLowByteUnsignedValue(high_byte, datavalue);
                             ver_matrix(34)=1;
                         end

                     otherwise
                        Logging.log('Invalid message ID');
                 end   
                end
             end
        end
    end

    disp('Current car configuration:')
    disp(D);

    if ~min(ver_matrix)
        Logging.log('Warning: All parameters were Not loaded successfully! Current car data parameters printed to MATLAB Command Window..');
    else
        response = questdlg('The current car parameters have been printed to MATLAB Command Window, would you like to import these parameters to the GUI? Warning: Current parameters in GUI will be lost.', ...
                             'Confirm import of parameters', ...
                             'Import parameters', 'Cancel', 'Cancel');

        if strcmp(response, 'Import parameters')
            setCarParametersData(handles,D);
            Logging.log('Current car data parameters loaded.');
        end
    end

end