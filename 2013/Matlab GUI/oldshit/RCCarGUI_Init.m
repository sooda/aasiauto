function RCCarGUI_Init(hObject, ~, handles, varargin)
    handles.output = hObject;
    
    % START USER CODE
    % Create a timer object to fire at 0.01 sec intervals
    % Specify function handles for its start and run callbacks
    handles.timer = timer('Executionmode','fixedRate','Period', 0.02,...
        'TimerFcn', {@UpdateDisplay,hObject,handles});

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

    % Get instance of Car to set appdata and cardata
    c = Car.getInstance();

    % enable or disable joystick
    try
        appdata.joystick = vrjoystick(1);
    catch
        appdata.joystick = [];
    end
    
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
%    setappdata(hObject,'App_Data',appdata); %Save the data
    c.appdata = appdata;
    
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
    cardata.kulma = 0;
    cardata.motorBatteryVoltage = 0;
    cardata.controllerBatteryVoltage = 0;
    cardata.acc_scaling = 32.0/1024.0*9.81; %the conversion factor from raw data to m/s^2
%    setappdata(hObject,'Car_Data',cardata); %Save the data
    cardata.last_measurements = [];
    c.cardata = cardata;

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
    if exist('default_params.mat', 'file')
        c.loadFromFile('default');
        setCarParametersData(handles);
        set(handles.savedrivedatacheckbox,'Value',1)
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
end