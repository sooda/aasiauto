function varargout = RCCarGUI(varargin)
% RCCARGUI MATLAB code for RCCarGUI.fig
%      RCCARGUI, by itself, creates a new RCCARGUI or raises the existing
%      singleton*.
%
%      H = RCCARGUI returns the handle to a new RCCARGUI or the handle to
%      the existing singleton*.
%
%      RCCARGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RCCARGUI.M with the given input arguments.
%
%      RCCARGUI('Property','Value',...) creates a new RCCARGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RCCarGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RCCarGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RCCarGUI

% Last Modified by GUIDE v2.5 26-Nov-2012 11:15:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RCCarGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RCCarGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before RCCarGUI is made visible.
function RCCarGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RCCarGUI (see VARARGIN)

% Choose default command line output for RCCarGUI
handles.output = hObject;


% START USER CODE
% Create a timer object to fire at 0.01 sec intervals
% Specify function handles for its start and run callbacks
handles.timer = timer('Executionmode','fixedRate','Period', 0.02,...
    'TimerFcn', {@update_display,hObject,handles});

handles.timer2 = timer('Executionmode','fixedRate','Period', 0.05,...
    'TimerFcn', {@check_initialized,hObject,handles});

%set(handles.timer,'Period',1);

% Set the colors indicating a selected/unselected tab
handles.unselectedTabColor=get(handles.monitoringText,'BackgroundColor');
handles.selectedTabColor=handles.unselectedTabColor-0.1;

% Set units to normalize for easier handling
set(handles.monitoringText,'Units','normalized')
set(handles.carSetupText,'Units','normalized')
set(handles.monitoringPanel,'Units','normalized')
set(handles.carSetupPanel,'Units','normalized')

% Set logging console handle
Logging.console(handles.console);

% Tab 1
pos1=get(handles.monitoringText,'Position');
handles.a1=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.selectedTabColor,...
                'Position',[pos1(1) pos1(2) pos1(3) pos1(4)+0.01],...
                'ButtonDownFcn','RCCarGUI(''a1bd'',gcbo,[],guidata(gcbo))');
handles.t1=text('String',' Monitoring',...
                'Units','normalized',...
                'Position',[(pos1(3)-pos1(1))/2,pos1(2)/2+pos1(4)],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',8,...
                'Backgroundcolor',handles.selectedTabColor,...
                'ButtonDownFcn','RCCarGUI(''t1bd'',gcbo,[],guidata(gcbo))');
         
% Tab 2
pos2=get(handles.carSetupText,'Position');
pos2(1)=pos1(1)+pos1(3);
handles.a2=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.unselectedTabColor,...
                'Position',[pos2(1) pos2(2) pos2(3) pos2(4)+0.01],...
                'ButtonDownFcn','RCCarGUI(''a2bd'',gcbo,[],guidata(gcbo))');
handles.t2=text('String',' Car Setup',...
                'Units','normalized',...
                'Position',[pos2(3)/2,pos2(2)/2+pos2(4)],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',8,...
                'Backgroundcolor',handles.unselectedTabColor,...
                'ButtonDownFcn','RCCarGUI(''t2bd'',gcbo,[],guidata(gcbo))');
            
% Manage panels (place them in the correct position and manage visibilities)
pan1pos=get(handles.monitoringPanel,'Position');
set(handles.carSetupPanel,'Position',pan1pos)
set(handles.carSetupPanel,'Visible','off')


%applicationdata initialize
%Application data refers to the data used by the GUI
appdata.selectedcomport = '--';
appdata.save_drive_directory = strcat(pwd,'\Drive Sessions');
appdata.save_parameters_directory = pwd;
appdata.readComDirectory = 0;
appdata.readComFile = 0;

%Boolean values indicating if corresponding states are active
appdata.connected = 0;
appdata.autodrive = 0;
appdata.manualdrive = 0;

%Other values
appdata.serial = 0;
appdata.serialcurrentbytenum = 1;
appdata.storedserialdata = 999;
appdata.temp_high_byte = 0;
appdata.temp_hilo_byte_matrix = [0 0 0];
appdata.readfile = 0;
appdata.messagelength = 21; %message from car
appdata.initialized = 0;
appdata.read_value_counter = 0;
setappdata(hObject,'App_Data',appdata); %Save the data

%Cardata initialize
%Cardata refers to the data we get from the cars sensors
cardata.throttle = 0;
cardata.velocity = 0;
cardata.reverse = 0;
cardata.wheeldirection = 0;
%cardata.dynamicwheelradius = 0;
cardata.brake = 0;
cardata.position = [0 0 0]; %X Y Z
cardata.gyro = [0 0 0]; %X Y Z
cardata.wheelspeeds = [0 0 0 0]; %Left front, Right front, Left back, Right back
cardata.totalvelocity = 0;
cardata.acceleration = [0.0 0.0 0.0]; %X, Y, Z
cardata.timepassed = 0;
cardata.motorBatteryVoltage = 0;
cardata.controllerBatteryVoltage = 0;
cardata.acc_scaling = 32.0/1024.0*9.81; %the conversion factor from raw data to m/s^2
setappdata(hObject,'Car_Data',cardata); %Save the data

%Route Map plot setup
handles.carpath = plot(handles.carpathDisplay,1);
axes(handles.carpathDisplay);
title('Route Map')
%ylim([-100 100])
%xlim([-100 100])

%Velocity plot setup
handles.carspeed = plot(handles.speedDisplay,1);
axes(handles.speedDisplay);
title('Velocity')
%ylim([0 50])
%xlim([-100 100])

%Direction plot setup
handles.direction = barh(handles.directionDisplay,0);
axes(handles.directionDisplay);
xlim([-45 45])
grid(handles.directionDisplay,'off')
title('Wheel Direction')

%Reverse plot setup
handles.reverse = bar(handles.reverseTravelDisplay,0);
axes(handles.reverseTravelDisplay);
ylim([0 100])
title('Reverse')

%Break plot setup
handles.brake = bar(handles.brakeDisplay,0);
axes(handles.brakeDisplay);
ylim([0 100])
title('Brake')

%Throttle plot setup
handles.throttle = bar(handles.throttleDisplay,0);
axes(handles.throttleDisplay);
ylim([0 100])
title('Throttle')

%Load and set the default values for the car parameters data
carParametersData = load('default_car_parameters.mat');
setCarParametersData(handles,carParametersData.carParametersData); 
set(handles.savedrivedatacheckbox,'Value',1)
savedrivedatacheckbox_Callback(handles.savedrivedatacheckbox, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = RCCarGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Text object 1 callback (tab 1)
function t1bd(hObject,eventdata,handles)
set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.a1,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.monitoringPanel,'Visible','on')
set(handles.carSetupPanel,'Visible','off')

% Text object 2 callback (tab 2)
function t2bd(hObject,eventdata,handles)
set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.a2,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.carSetupPanel,'Visible','on')
set(handles.monitoringPanel,'Visible','off')

% Axes object 1 callback (tab 1)
function a1bd(hObject,eventdata,handles)
set(hObject,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.t1,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.monitoringPanel,'Visible','on')
set(handles.carSetupPanel,'Visible','off')

% Axes object 2 callback (tab 2)
function a2bd(hObject,eventdata,handles)
set(hObject,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.carSetupPanel,'Visible','on')
set(handles.monitoringPanel,'Visible','off')


% --- Executes on START MANUAL DRIVE button press.
function startmandrivebtn_Callback(hObject, eventdata, handles)
% hObject    handle to startmandrivebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Only start timer if it is not running
appdata = getappdata(handles.figure1, 'App_Data');

if appdata.connected
   
    appdata.manualdrive = 1;
    setappdata(handles.figure1, 'App_Data', appdata);
    ListenChar(2); %Start listening fror keyboard inputs
    stop(handles.timer2); %Stop the "initialize" timer
    fread(appdata.serial,appdata.serial.BytesAvailable); % Clear car message buffer
    start(handles.timer);
    %set(handles.textFieldSaveDataTo,'Enable', 'off');
    %set(handles.savedrivedatacheckbox,'Enable', 'off');
    Logging.log('Manual drive activated.')
    
else
    Logging.log('You are not connected to the car.')
end


% --- Executes on END MANUAL DRIVE button press.
function endmandrivebtn_Callback(hObject, eventdata, handles)
% hObject    handle to stopbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Only stop timer if it is running
appdata = getappdata(handles.figure1, 'App_Data');

if (appdata.manualdrive)
    
    appdata = getappdata(handles.figure1, 'App_Data');
    appdata.manualdrive = 0;
    setappdata(handles.figure1, 'App_Data', appdata);
    
    ListenChar(0); %Stop listening for keyboard inputs
    stop(handles.timer);
    Logging.log('Manual drive stopped.');

    %Save Data
    if(get(handles.savedrivedatacheckbox, 'Value'))
        carData = getappdata(handles.figure1, 'Car_Data');
        t = fix(clock);
        tim = strcat(num2str(t(6)),num2str(t(5)),num2str(t(4)),num2str(t(3)),num2str(t(2)),num2str(t(1)));
        filename = '\dSession';
        nameAndDir = strcat(appdata.save_drive_directory,filename,tim,'.mat');
        save(nameAndDir, 'carData')
        Logging.log('Data saved to selected directory.');
    end
    
    %Reset Car Data
    cardata = getappdata(handles.figure1, 'Car_Data');
    cardata.throttle = 0;
    cardata.velocity = 0;
    cardata.reverse = 0;
    cardata.wheeldirection = 0;
    cardata.brake = 0;
    cardata.position = [0 0 0]; %X Y Z
    cardata.gyro = [0 0 0]; %X Y Z
    cardata.wheelspeeds = [0 0 0 0]; %Left front, Right front, Left back, Right back
    cardata.totalvelocity = 0;
    cardata.acceleration = [0.0 0.0 0.0]; %X, Y, Z
    cardata.timepassed = 0;
    cardata.motorBatteryVoltage = 0;
    cardata.controllerBatteryVoltage = 0;
    
    setappdata(handles.figure1, 'Car_Data',cardata);
end

%This function checks if the car is initialized and ready to start a drive session
%In other words: if sensordata from the car is received then it is ready
function check_initialized(hObject,eventdata,hfigure,handles)

appdata = getappdata(handles.figure1, 'App_Data');

if appdata.serial.BytesAvailable && ~appdata.initialized 
    appdata.initialized = 1;
    Logging.log('Initialized and ready for drive session.');
    setappdata(handles.figure1, 'App_Data', appdata);
end

%This is the main loop that runs when the car is in manual drive
%The function handles the following:
% -Read keyboard input
% -Write corresponding drive commands to car
% -Read sensordata from car
% -Update car monitoring plots in the GUI
function update_display(hObject,eventdata,hfigure,handles)
% Timer timer1 callback, called each time timer iterates.
% Gets surface Z data, adds noise, and writes it back to surface object.

 [keyIsDown ctime keysAreDown] = KbCheck();
 handles2 = guidata(hfigure);
 
 cardata = getappdata(handles.figure1, 'Car_Data');
 appdata = getappdata(handles.figure1, 'App_Data');
 
 %appdata.read_value_counter = appdata.read_value_counter + 1;
 
 %Get last element from each dataset
 thro = cardata.throttle(size(cardata.throttle,1));
 dir = cardata.wheeldirection(size(cardata.wheeldirection,1));
 brake = cardata.brake(size(cardata.brake,1));
 rev = cardata.reverse(size(cardata.reverse,1));
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
 
 temp_read_value_counter = appdata.read_value_counter;
 appdata.read_value_counter = temp_read_value_counter + 1;
    
 if appdata.read_value_counter == 5
   appdata.read_value_counter = 1;
    %READ DATA FROM CAR
   if appdata.serial.BytesAvailable
      datastr = fread(appdata.serial,appdata.serial.BytesAvailable); 
      
     if appdata.storedserialdata ~= 999 %Add stored data to beginning
         datastr = [appdata.storedserialdata; datastr];
         appdata.storedserialdata = 999;
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
                     appdata.serialcurrentbytenum = 1;
                     i = i+2;
                     readcurrentdata = 0;
                 elseif datastr(i+1) ~= 0 %Wrong message ID
                     Logging.log('Received wrong message ID.');
                     break;                     
                 else %Read 255 followed by 0 is 255;
                     jump = 1;
                 end   
                 
             else
                 
                 if appdata.storedserialdata == 999 %Add store 255
                    appdata.storedserialdata = 255;
                 else
                    appdata.storedserialdata = [appdata.storedserialdata; 255];
                 end
                 %'break'
                 break;
             end    
          end
          %'We are not in the beginning of a message'
          if readcurrentdata %We are not in the beginning of a message
                       
             current_byte = datastr(i);
             switch appdata.serialcurrentbytenum
             
             case 1 %Wheelspeeds 
             cardata.wheelspeeds = [cardata.wheelspeeds; [0 0 0 0]]; 
             wheel_length = size(cardata.wheelspeeds,1);
             %Speed [km/h] = 3.6 * pi * wheeldiameter[m] * relevations/seconds
             wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h % 1.4137 *((current_byte/512)/0.01);          
             cardata.wheelspeeds(wheel_length, 1) = wheelSpeed;

             case 2  %Wheelspeeds
             wheel_length = size(cardata.wheelspeeds,1);
             wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h  % 1.4137 *((current_byte/512)/0.01);
             cardata.wheelspeeds(wheel_length, 2) = wheelSpeed;
                 
             case 3 %Wheelspeeds
             wheel_length = size(cardata.wheelspeeds,1);
             %current_byte
             wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h  % 1.4137 *((current_byte/512)/0.01);
             %wheelSpeed = ((current_byte/512)/0.01)
             
             cardata.wheelspeeds(wheel_length, 3) = wheelSpeed;
                
             case 4 %Wheelspeeds
             wheel_length = size(cardata.wheelspeeds,1);
             wheelSpeed = 1.4137 *((current_byte/512)/0.01); %km/h  % 1.4137 *((current_byte/512)/0.01);
             cardata.wheelspeeds(wheel_length, 4) = wheelSpeed;   
                 
             %ACCELERATION   
             case 5 %X-acceleration high byte 
                 appdata.temp_high_byte = current_byte;
             case 6 %X-acceleration low byte          
                 value = calcHighLowByteValue(appdata.temp_high_byte, current_byte);
                 cardata.acceleration = [cardata.acceleration; [0 0 0]]; % add new row
                 acc_length = size(cardata.acceleration,1);
                 cardata.acceleration(acc_length,1) = value * cardata.acc_scaling;
                 if(abs(cardata.acceleration(acc_length,1)) < 0.4)
                    cardata.acceleration(acc_length,1) = 0;
                 end
                 
                 
             case 7%Y High
                 appdata.temp_high_byte = current_byte;
             case 8%Y Low
                 value = calcHighLowByteValue(appdata.temp_high_byte, current_byte);
                 acc_length = size(cardata.acceleration,1);
                 cardata.acceleration(acc_length,2) = value * cardata.acc_scaling;
                 if(abs(cardata.acceleration(acc_length,2)) < 0.4)
                    cardata.acceleration(acc_length,2) = 0;
                 end
             case 9%Z high
                 appdata.temp_high_byte = current_byte;
             case 10%Z low
                 value = calcHighLowByteValue(appdata.temp_high_byte, current_byte);
                 acc_length = size(cardata.acceleration,1);
                 cardata.acceleration(acc_length,3) = value * cardata.acc_scaling; 
                 if(abs(cardata.acceleration(acc_length,3)) < 0.4)
                    cardata.acceleration(acc_length,3) = 0;
                 end      
                 %cardata.acceleration(acc_length,:)
             %GYRO
             case 11 %X-gyro high byte 
                 appdata.temp_high_byte = current_byte;
             case 12    
                 value = calcHighLowByteValue(appdata.temp_high_byte, current_byte);
                 cardata.gyro = [cardata.gyro; [0 0 0]]; % add new row
                 gyro_length = size(cardata.gyro,1);
                 cardata.gyro(gyro_length,1) = value / 14.38;
             case 13 %Y-gyro high byte 
                 appdata.temp_high_byte = current_byte;
             case 14    
                 value = calcHighLowByteValue(appdata.temp_high_byte, current_byte);
                 gyro_length = size(cardata.gyro,1);
                 cardata.gyro(gyro_length,2) = value / 14.38;
             case 15 %X-gyro high byte 
                 appdata.temp_high_byte = current_byte;
             case 16    
                 value = calcHighLowByteValue(appdata.temp_high_byte, current_byte);
                 gyro_length = size(cardata.gyro,1);
                 cardata.gyro(gyro_length,3) = value / 14.38;
                 
                 %cardata.gyro(gyro_length,:)  
             %Remaining values
             case 17
                 cardata.wheeldirection = [cardata.wheeldirection ; current_byte];
             case 18
                 cardata.motorBatteryVoltage = [cardata.motorBatteryVoltage; current_byte]; 
             case 19 % Last byte in message
                 cardata.controllerBatteryVoltage = [cardata.controllerBatteryVoltage; current_byte]; 
                 
                 %Update Timer
                timeLength = size(cardata.timepassed,1);
                if(timeLength>1)
                    cardata.timepassed = [cardata.timepassed; cardata.timepassed(timeLength) + handles2.timer.InstantPeriod];
                else
                    cardata.timepassed = [cardata.timepassed; 0];  
                end
                 
                %Car Total velocity
                velLen = size(cardata.wheelspeeds,1);
                totalvelocity = sum(cardata.wheelspeeds(velLen,3:4))/2;%For the seminar presentation: Only use rear wheel data
                cardata.totalvelocity = [cardata.totalvelocity; totalvelocity];
                 
                %Calculate car position
                accLength = size(cardata.acceleration,1);
                %cardata.acceleration(accLength,:);
                
                if(timeLength > 1)
                    deltaPos = calcPosFromAcc(cardata.acceleration((accLength-1):accLength,:),0.5);%cardata.timepassed(timeLength));          
                else
                    deltaPos = [0 0 0];
                end
       
                posLength = size(cardata.position,1);
                cardata.position = [cardata.position; cardata.position(posLength,:) + deltaPos];
                 
                
             otherwise             
                 Logging.log('Read exceeds normal message length.');
                % 'Read exceeds normal message length.'
                % strcat('Current byte is: ', num2str(appdata.serialcurrentbytenum))
             end
          
              i = i + 1 + jump; 
              appdata.serialcurrentbytenum = appdata.serialcurrentbytenum + 1;
              jump = 0;
          end
     end  
   end
   
   % Update Cardata only when it's read
   set(handles2.carpath,'YData',cardata.position(:,2));
   set(handles2.carpath,'XData',cardata.position(:,1));

   set(handles2.carspeed,'YData',cardata.totalvelocity);
   set(handles2.carspeed,'XData',cardata.timepassed);
 end
  
%Save steering data
cardata.throttle = [cardata.throttle; thro];
cardata.brake = [cardata.brake; brake];
cardata.wheeldirection = [cardata.wheeldirection; dir];
cardata.reverse = [cardata.reverse; rev];
   
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

stopasync(appdata.serial);

if(sound_horn)   
    fwrite(appdata.serial, [255 65 drv_throttle drv_dir drv_brake drv_clutch drv_drvdir 255 68], 'async');  
else
    fwrite(appdata.serial, [255 65 drv_throttle drv_dir drv_brake drv_clutch drv_drvdir], 'async');
end
readasync(appdata.serial);
%Save car data
setappdata(handles.figure1, 'Car_Data',cardata);
setappdata(handles.figure1, 'App_Data',appdata);

%Update command plots

set(handles2.reverse,'YData',rev);
set(handles2.throttle,'YData',thro);
set(handles2.brake,'YData',brake);
set(handles2.direction,'YData',dir);

% --- Executes on button press in Connect To Car.
function connecttocarbtn_Callback(hObject, eventdata, handles)
% hObject    handle to connecttocarbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%TODO error handling
appdata = getappdata(handles.figure1, 'App_Data');

if(strcmp(appdata.selectedcomport, '--'))
    Logging.log('Please select a serial port.')

else
    try 
        appdata.serial = serial(appdata.selectedcomport);
        appdata.serial.BaudRate = 38400;
        appdata.serial.Terminator = 'LF';
        fopen (appdata.serial);
        appdata.connected = 1;
        setappdata(handles.figure1,'App_Data',appdata);
        Logging.log('Connected, please wait for car initialization...')
        
        start(handles.timer2); %Timer to check for Iniatilzation
    catch err
    
        if(strcmp(err.identifier,'MATLAB:serial:fopen:opfailed'))
            Logging.log('Failed to connect to selected port.')
        else
            Logging.log('Undefined error occured, check matlab command window.')
            rethrow(err);
        end
    end
end

% --- Executes on button press in Disconnect From Car.
function disconnectfromcarbtn_Callback(hObject, eventdata, handles)
% hObject    handle to disconnectfromcarbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

appdata = getappdata(handles.figure1, 'App_Data');

if(appdata.manualdrive)
    endmandrivebtn_Callback(233.0072, eventdata, handles);
end

if(appdata.connected)
    fclose(appdata.serial);
    delete(appdata.serial);
    appdata.connected = 0;
    appdata.initialized = 0;
    setappdata(handles.figure1, 'App_Data', appdata);
    Logging.log('Disconnected.'); 
end

% --- Executes on selection change in portConnectpop.
function portConnectpop_Callback(hObject, eventdata, handles)
% hObject    handle to portConnectpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns portConnectpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from portConnectpop
appdata = getappdata(handles.figure1, 'App_Data');
instrumentinfo = instrhwinfo('serial');
appdata.availablecomports = instrumentinfo.AvailableSerialPorts;
setappdata(handles.figure1, 'App_Data',appdata); %save availablecomports

values = get(hObject,'String');
selectedValue = get(hObject,'Value');

%Validation of serial port not currently possible since matlab instrhwinfo
%only refreshes on program startup. May be changed in future versions of
%matlab.

appdata.selectedcomport = values{selectedValue};
setappdata(handles.figure1, 'App_Data', appdata);

function console_callBack(hObject, eventdata, handles, message)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of console as text
%        str2double(get(hObject,'String')) returns contents of console as a double

oldmsgs = get(handles.console,'String');
msgssize = size(oldmsgs);
if(msgssize(1)>8)
    oldmsgs = oldmsgs(2:9); %delete first row
end
set(handles.console,'String',[oldmsgs;{message}]);
set(handles.console2,'String',[oldmsgs;{message}]);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textFieldSaveDataTo.
function textFieldSaveDataTo_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to textFieldSaveDataTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(get(handles.savedrivedatacheckbox,'value'))
    appdata = getappdata(handles.figure1, 'App_Data');
    currentvalue = get(hObject,'String');

    %Choose save directory
    if(appdata.save_drive_directory==0)
     appdata.save_drive_directory = uigetdir(strcat(pwd,'\Drive Sessions'),'Select save directory');
    else
     appdata.save_drive_directory = uigetdir(appdata.save_drive_directory,'Select save directory');
    end

    %Display save directory
    if (appdata.save_drive_directory == 0)
      set(hObject,'String',currentvalue);
    else
     set(hObject,'String',appdata.save_drive_directory);
    end
    %Save save directory
    setappdata(handles.figure1, 'App_Data', appdata);
end

% --- Executes during object creation, after setting all properties.
function textFieldSaveDataTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textFieldSaveDataTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',pwd);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in savedrivedatacheckbox.
function savedrivedatacheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to savedrivedatacheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of savedrivedatacheckbox
appdata = getappdata(handles.figure1, 'App_Data');

if get(hObject,'Value')
    set(handles.textFieldSaveDataTo,'Enable', 'inactive');
    
    if strcmp(appdata.save_drive_directory, '')
        textFieldSaveDataTo_ButtonDownFcn(handles.textFieldSaveDataTo, eventdata, handles);
    end
else
    set(handles.textFieldSaveDataTo,'Enable', 'off');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textFieldReadDataFrom.
function textFieldReadDataFrom_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to textFieldReadDataFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
appdata = getappdata(handles.figure1, 'App_Data');
currentvalue = get(hObject,'String');

%Choose save directory
[appdata.readComFile, appdata.readComDirectory] = uigetfile('*.mat','MAT-files (*.mat)','Select a file');

%Display save directory
if (appdata.readComFile == 0)
 set(hObject,'String',currentvalue);
else
 set(hObject,'String',strcat(appdata.readComDirectory,appdata.readComFile));
end
%Save save directory
setappdata(handles.figure1, 'App_Data', appdata);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    appdata = getappdata(handles.figure1, 'App_Data');

    if (appdata.connected)
     disconnectfromcarbtn_Callback(233.0051, eventdata, handles)
        appdata.connected = 0;
    end

    % Destroy timer
    delete(handles.timer)
    delete(handles.timer2)

    %Clear the serial object
    appdata = getappdata(handles.figure1, 'App_Data');
    clear appdata.serial
    
% Hint: delete(hObject) closes the figure
delete(hObject);

% --------------------------------------------------------------------
function saveConfiguration_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

appdata = getappdata(handles.figure1, 'App_Data');

[filename, pathname, ~] = uiputfile('*.mat', 'Save car setup parameters as');

 %Save data
 if ~isequal(pathname,0) && ~isequal(filename,0)
   appdata.save_parameters_directory = pathname;
   
   nameAndDir = strcat(pathname,filename);

   carParametersData = getCarParametersData(handles);
   save(nameAndDir, 'carParametersData');
 
   %Save appdata
   setappdata(handles.figure1, 'App_Data', appdata);
    
   Logging.log('Car parameters data saved.');
 end   

% --------------------------------------------------------------------
function openConfiguration_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname, ~] = uigetfile('*.mat', 'Load car setup parameters from file');

 %Load data
 if ~isequal(pathname,0) && ~isequal(filename,0)
   
   nameAndDir = strcat(pathname,filename);

   carParametersData = load(nameAndDir);
   carParametersData = carParametersData.carParametersData; %Simplify the struct structure
   setCarParametersData(handles,carParametersData);
    
   Logging.log('Car parameters data loaded.');
 end

%Read and return the data from the car paramterers edit boxes
function data = getCarParametersData(handles)

%Get Vehicle parameters
data.dynamicWheelRollRadius = get(handles.dynamicWheelRollRadiusEdit, 'String');
data.wheelbase = get(handles.wheelbaseEdit, 'String');
data.vehicleMass = get(handles.vehicleMassEdit, 'String');
data.distanceFrontAxleCoG = get(handles.distanceFrontAxleCoGEdit, 'String');
data.distanceRearAxleCoG = get(handles.distanceRearAxleCoGEdit, 'String');
data.frontAxleTurnStiffness = get(handles.frontAxleTurnStiffnessEdit, 'String');
data.rearAxleTurnStiffness = get(handles.rearAxleTurnStiffnessEdit, 'String');

%Get servo calibration
data.frontAxleLeftBrakeServosNeutralPositions = get(handles.frontAxleLeftBrakeServosNeutralPositionsEdit, 'String');
data.frontAxleRightBrakeServosNeutralPositions = get(handles.frontAxleRightBrakeServosNeutralPositionsEdit, 'String');
data.rearAxleLeftBrakeServosNeutralPositions = get(handles.rearAxleLeftBrakeServosNeutralPositionsEdit, 'String');
data.rearAxleRightBrakeServosNeutralPositions = get(handles.rearAxleRightBrakeServosNeutralPositionsEdit, 'String');
data.frontAxleLeftBrakeServosMaximumPositions = get(handles.frontAxleLeftBrakeServosMaximumPositionsEdit, 'String');
data.frontAxleRightBrakeServosMaximumPositions = get(handles.frontAxleRightBrakeServosMaximumPositionsEdit, 'String');
data.rearAxleLeftBrakeServosMaximumPositions = get(handles.rearAxleLeftBrakeServosMaximumPositionsEdit, 'String');
data.rearAxleRightBrakeServosMaximumPositions = get(handles.rearAxleRightBrakeServosMaximumPositionsEdit, 'String');

%Get ABS Parameters
data.absEnabled = get(handles.absEnabledCheckBox,'Value');
data.absLowThres = get(handles.absLowThresEdit, 'String');
data.absMiddleThres = get(handles.absMiddleThresEdit, 'String');
data.absHighThres = get(handles.absHighThresEdit, 'String');
data.finalPhaseLengthLift = get(handles.finalPhaseLengthLiftEdit, 'String');
data.finalPhaseLengthHolding = get(handles.finalPhaseLengthHoldingEdit, 'String');
data.slopeFirstPhaseCalcBrake = get(handles.slopeFirstPhaseCalcBrakeEdit, 'String');
data.thirdPhaseReleaseBrake = get(handles.thirdPhaseReleaseBrakeEdit, 'String');
data.lastPhaseReleaseBrake = get(handles.lastPhaseReleaseBrakeEdit, 'String');

%Get ESP Parameters
data.espEnabled = get(handles.espEnabledCheckBox,'Value');
data.espSensitivityControlAngVel = get(handles.espSensitivityControlAngVelEdit, 'String');
data.espSensitivityAdjSlipAngle = get(handles.espSensitivityAdjSlipAngleEdit, 'String');
data.espBrakeForceFactor = get(handles.espBrakeForceFactorEdit, 'String');
data.espBrakeForceDist = get(handles.espBrakeForceDistEdit, 'String');
data.espAngularVelContPCoeff = get(handles.espAngularVelContPCoeffEdit, 'String');
data.espAngularVelContDCoeff = get(handles.espAngularVelContDCoeffEdit, 'String');
data.espDriftAngleContrPCoeff = get(handles.espDriftAngleContrPCoeffEdit, 'String');
data.espDriftAngleContrDCoeff = get(handles.espDriftAngleContrDCoeffEdit, 'String');
data.espThresValAngularVelToSlipAngleContrl = get(handles.espThresValAngularVelToSlipAngleContrlEdit, 'String');
 
%Set the parameter data to the car parameters editboxes
function setCarParametersData(handles,data)

%Set Vehicle parameters
set(handles.dynamicWheelRollRadiusEdit, 'String', data.dynamicWheelRollRadius);
set(handles.wheelbaseEdit, 'String',data.wheelbase);
set(handles.vehicleMassEdit, 'String', data.vehicleMass);
set(handles.distanceFrontAxleCoGEdit, 'String',data.distanceFrontAxleCoG);
set(handles.distanceRearAxleCoGEdit, 'String', data.distanceRearAxleCoG);
set(handles.frontAxleTurnStiffnessEdit, 'String', data.frontAxleTurnStiffness);
set(handles.rearAxleTurnStiffnessEdit, 'String', data.rearAxleTurnStiffness);

%Set servo calibration
set(handles.frontAxleLeftBrakeServosNeutralPositionsEdit, 'String', data.frontAxleLeftBrakeServosNeutralPositions);
set(handles.frontAxleRightBrakeServosNeutralPositionsEdit, 'String', data.frontAxleRightBrakeServosNeutralPositions);
set(handles.rearAxleLeftBrakeServosNeutralPositionsEdit, 'String', data.rearAxleLeftBrakeServosNeutralPositions);
set(handles.rearAxleRightBrakeServosNeutralPositionsEdit, 'String', data.rearAxleRightBrakeServosNeutralPositions);
set(handles.frontAxleLeftBrakeServosMaximumPositionsEdit, 'String', data.frontAxleLeftBrakeServosMaximumPositions);
set(handles.frontAxleRightBrakeServosMaximumPositionsEdit, 'String', data.frontAxleRightBrakeServosMaximumPositions);
set(handles.rearAxleLeftBrakeServosMaximumPositionsEdit, 'String', data.rearAxleLeftBrakeServosMaximumPositions);
set(handles.rearAxleRightBrakeServosMaximumPositionsEdit, 'String', data.rearAxleRightBrakeServosMaximumPositions);

%Set ABS Parameters
set(handles.absEnabledCheckBox,'Value',data.absEnabled);
set(handles.absLowThresEdit, 'String', data.absLowThres);
set(handles.absMiddleThresEdit, 'String', data.absMiddleThres);
set(handles.absHighThresEdit, 'String', data.absHighThres);
set(handles.finalPhaseLengthLiftEdit, 'String', data.finalPhaseLengthLift);
set(handles.finalPhaseLengthHoldingEdit, 'String', data.finalPhaseLengthHolding);
set(handles.slopeFirstPhaseCalcBrakeEdit, 'String', data.slopeFirstPhaseCalcBrake);
set(handles.thirdPhaseReleaseBrakeEdit, 'String', data.thirdPhaseReleaseBrake);
set(handles.lastPhaseReleaseBrakeEdit, 'String', data.lastPhaseReleaseBrake);

%Set ESP Parameters
set(handles.espEnabledCheckBox,'Value',data.espEnabled);
set(handles.espSensitivityControlAngVelEdit, 'String', data.espSensitivityControlAngVel);
set(handles.espSensitivityAdjSlipAngleEdit, 'String', data.espSensitivityAdjSlipAngle);
set(handles.espBrakeForceFactorEdit, 'String', data.espBrakeForceFactor);
set(handles.espBrakeForceDistEdit, 'String', data.espBrakeForceDist);
set(handles.espAngularVelContPCoeffEdit, 'String', data.espAngularVelContPCoeff);
set(handles.espAngularVelContDCoeffEdit, 'String', data.espAngularVelContDCoeff);
set(handles.espDriftAngleContrPCoeffEdit, 'String', data.espDriftAngleContrPCoeff);
set(handles.espDriftAngleContrDCoeffEdit, 'String', data.espDriftAngleContrDCoeff);
set(handles.espThresValAngularVelToSlipAngleContrlEdit, 'String', data.espThresValAngularVelToSlipAngleContrl);

% Resets the parameters
function resetToDefault_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to resetToDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 response = questdlg('This action will reset the car configuration parameters to the default parameters. All unsaved data will be lost. Are you sure?', ...
                         'Confirm parameters reset', ...
                         'Reset parameters', 'Cancel', 'Cancel');

if strcmp(response, 'Reset parameters')
    
   carParametersData = load('default_car_parameters.mat');
   setCarParametersData(handles,carParametersData.carParametersData); %Simplify the struct structure and set data
   
   Logging.log('Default car data parameters loaded.');
end

%Request and save the current car parameters
function getCarConfParamBtn_Callback(hObject, eventdata, handles)

appdata = getappdata(handles.figure1, 'App_Data');

if appdata.serial.BytesAvailable %Clear car buffer
    fread(appdata.serial,appdata.serial.BytesAvailable);
end

%Request car parameters
%stopasync(appdata.serial);
readasync(appdata.serial);
%pause(0.1);

fwrite(appdata.serial, [255 67 255 0], 'async');
%readasync(appdata.serial);
%  fwrite(appdata.serial, 255);
%  fwrite(appdata.serial, 67);
%  fwrite(appdata.serial, 255);
%  fwrite(appdata.serial, 0);

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
    
    if appdata.serial.BytesAvailable
      datavalue = fread(appdata.serial,1); 
      %datavalue
         if datavalue == 255 %Check if it's maybe a new message
              datavalue = fread(appdata.serial,1); %Pick the next byte to see what is following
              %datavalue
              
              if datavalue ~= 0 %If it's a new message
                 current_Message_Id = datavalue;        
                 curremt_Parameter_Id = fread(appdata.serial,1);
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

%Save car parameters to car
function setCarConfParamBtn_Callback(hObject, eventdata, handles)
% hObject    handle to setCarConfParamBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = getCarParametersData(handles);
appdata = getappdata(handles.figure1, 'App_Data');

%Write brake controller parameters to car
[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleLeftBrakeServosNeutralPositions);
fcustomwrite(appdata.serial,hi,lo,10);

[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleRightBrakeServosNeutralPositions);
fcustomwrite(appdata.serial,hi,lo,11);

[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleLeftBrakeServosNeutralPositions);
fcustomwrite(appdata.serial,hi,lo,12);

[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleRightBrakeServosNeutralPositions);
fcustomwrite(appdata.serial,hi,lo,13);

[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleLeftBrakeServosMaximumPositions);
fcustomwrite(appdata.serial,hi,lo,14);

[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleRightBrakeServosMaximumPositions);
fcustomwrite(appdata.serial,hi,lo,15);

[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleLeftBrakeServosMaximumPositions);
fcustomwrite(appdata.serial,hi,lo,16);

[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleRightBrakeServosMaximumPositions);
fcustomwrite(appdata.serial,hi,lo,17);

%Write ABS Parameters to car
fcustomwrite(appdata.serial,data.absEnabled,'',20);
fcustomwrite(appdata.serial,str2double(data.absLowThres),'',21);
fcustomwrite(appdata.serial,str2double(data.absMiddleThres),'',22);
fcustomwrite(appdata.serial,str2double(data.absHighThres),'',23);
fcustomwrite(appdata.serial,str2double(data.finalPhaseLengthLift),'',24);
fcustomwrite(appdata.serial,str2double(data.finalPhaseLengthHolding),'',25);
fcustomwrite(appdata.serial,str2double(data.slopeFirstPhaseCalcBrake),'',26);
fcustomwrite(appdata.serial,str2double(data.thirdPhaseReleaseBrake),'',27);
fcustomwrite(appdata.serial,str2double(data.lastPhaseReleaseBrake),'',28);

%Write ESP Parameters to car
fcustomwrite(appdata.serial,data.espEnabled,'',40);
fcustomwrite(appdata.serial,str2double(data.espSensitivityControlAngVel),'',41);
fcustomwrite(appdata.serial,str2double(data.espSensitivityAdjSlipAngle),'',42);
fcustomwrite(appdata.serial,str2double(data.espBrakeForceFactor),'',43);
fcustomwrite(appdata.serial,str2double(data.espBrakeForceDist),'',44);
fcustomwrite(appdata.serial,str2double(data.espAngularVelContPCoeff),'',45);
fcustomwrite(appdata.serial,str2double(data.espAngularVelContDCoeff),'',46);
fcustomwrite(appdata.serial,str2double(data.espDriftAngleContrPCoeff),'',47);
fcustomwrite(appdata.serial,str2double(data.espDriftAngleContrDCoeff),'',48);
fcustomwrite(appdata.serial,str2double(data.espThresValAngularVelToSlipAngleContrl),'',49);

%Write Vehicle Parameters to car
fcustomwrite(appdata.serial,str2double(data.dynamicWheelRollRadius),'',50);
[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.wheelbase); %scaled mm to range [0 65535]
fcustomwrite(appdata.serial,hi,lo,51);
[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.vehicleMass, 1000); %scaled kg to range [0 65535]
fcustomwrite(appdata.serial,hi,lo,52);
[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.distanceFrontAxleCoG);
fcustomwrite(appdata.serial,hi,lo,53);
[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.distanceRearAxleCoG);
fcustomwrite(appdata.serial,hi,lo,54);
[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.frontAxleTurnStiffness);
fcustomwrite(appdata.serial,hi,lo,55);
[hi, lo] = ByteTools.calcHighLowByte_From_Value(data.rearAxleTurnStiffness);
fcustomwrite(appdata.serial,hi,lo,56);
Logging.log('GUI Car data parameters uploaded to car.');

% --------------------------------------------------------------------
function aboutGUI_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to aboutGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox('Author: Valter Sandström                                                 E-mail: valter.sandstrom@aalto.fi                                26.11.2012',...
    'About this GUI...');







% --------------------------------------------------------------------
% --------------------------------------------------------------------
% NÄMÄ MUUALLE!!!!
% --------------------------------------------------------------------
% --------------------------------------------------------------------







% --- Executes on mouse press over axes background.
function ButtonPressDisplay_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ButtonPressDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function textFieldReadDataFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textFieldReadDataFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function portConnectpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to portConnectpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); %Autogenerated code
end

% --- Executes during object creation, after setting all properties.
function console_CreateFcn(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function frontAxleLeftBrakeServosNeutralPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frontAxleLeftBrakeServosNeutralPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function rearAxleLeftBrakeServosNeutralPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rearAxleLeftBrakeServosNeutralPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function frontAxleLeftBrakeServosMaximumPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frontAxleLeftBrakeServosMaximumPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function rearAxleLeftBrakeServosMaximumPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rearAxleLeftBrakeServosMaximumPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dynamicWheelRollRadiusEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dynamicWheelRollRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function wheelbaseEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wheelbaseEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function vehicleMassEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vehicleMassEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function distanceFrontAxleCoGEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceFrontAxleCoGEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function distanceRearAxleCoGEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceRearAxleCoGEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function frontAxleTurnStiffnessEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frontAxleTurnStiffnessEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function rearAxleTurnStiffnessEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rearAxleTurnStiffnessEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function espBrakeForceFactorEdit_Callback(hObject, eventdata, handles)
% hObject    handle to espBrakeForceFactorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of espBrakeForceFactorEdit as text
%        str2double(get(hObject,'String')) returns contents of espBrakeForceFactorEdit as a double
return

% --- Executes during object creation, after setting all properties.
function espBrakeForceFactorEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espBrakeForceFactorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function espBrakeForceDistEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espBrakeForceDistEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function espAngularVelContDCoeffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espAngularVelContDCoeffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function espDriftAngleContrPCoeffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espDriftAngleContrPCoeffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function espDriftAngleContrDCoeffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espDriftAngleContrDCoeffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function espThresValAngularVelToSlipAngleContrlEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espThresValAngularVelToSlipAngleContrlEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function espSensitivityControlAngVelEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espSensitivityControlAngVelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function espSensitivityAdjSlipAngleEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espSensitivityAdjSlipAngleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function espAngularVelContPCoeffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to espAngularVelContPCoeffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function absHighThresEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to absHighThresEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function finalPhaseLengthLiftEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finalPhaseLengthLiftEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function finalPhaseLengthHoldingEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finalPhaseLengthHoldingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slopeFirstPhaseCalcBrakeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slopeFirstPhaseCalcBrakeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function thirdPhaseReleaseBrakeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thirdPhaseReleaseBrakeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function lastPhaseReleaseBrakeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lastPhaseReleaseBrakeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function absLowThresEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to absLowThresEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function absMiddleThresEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to absMiddleThresEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function frontAxleRightBrakeServosNeutralPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frontAxleRightBrakeServosNeutralPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function rearAxleRightBrakeServosNeutralPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rearAxleRightBrakeServosNeutralPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function frontAxleRightBrakeServosMaximumPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frontAxleRightBrakeServosMaximumPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function rearAxleRightBrakeServosMaximumPositionsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rearAxleRightBrakeServosMaximumPositionsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function console2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to console2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



