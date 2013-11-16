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

% Last Modified by GUIDE v2.5 08-Oct-2013 16:26:30

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
RCCarGUI_Init(hObject, eventdata, handles, varargin);
savedrivedatacheckbox_Callback(handles.savedrivedatacheckbox, eventdata, handles)

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
%appdata = getappdata(handles.figure1, 'App_Data');
c = Car.getInstance;

if c.appdata.connected
   
    c.appdata.manualdrive = 1;
%    setappdata(handles.figure1, 'App_Data', appdata);
    ListenChar(2); %Start listening fror keyboard inputs
    stop(handles.timer2); %Stop the "initialize" timer
% TODO! Serial is not here anymore
    fread(c.appdata.serial, appdata.serial.BytesAvailable); % Clear car message buffer
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
%appdata = getappdata(handles.figure1, 'App_Data');
c = Car.getInstance;

if (c.appdata.manualdrive)
    
%    appdata = getappdata(handles.figure1, 'App_Data');
    c.appdata.manualdrive = 0;
%    setappdata(handles.figure1, 'App_Data', appdata);
    
    ListenChar(0); %Stop listening for keyboard inputs
    stop(handles.timer);
    Logging.log('Manual drive stopped.');

    %Save Data
    if(get(handles.savedrivedatacheckbox, 'Value'))
%        carData = getappdata(handles.figure1, 'Car_Data');
        carData = c.cardata;
        
        t = fix(clock);
        tim = strcat(num2str(t(6)),num2str(t(5)),num2str(t(4)),num2str(t(3)),num2str(t(2)),num2str(t(1)));
        filename = '\dSession';
        nameAndDir = strcat(c.appdata.save_drive_directory, filename, tim, '.mat');
        save(nameAndDir, 'carData')
        Logging.log('Data saved to selected directory.');
    end
    
    %Reset Car Data
%    cardata = getappdata(handles.figure1, 'Car_Data');
    c.cardata.throttle = 0;
    c.cardata.velocity = 0;
    c.cardata.reverse = 0;
    c.cardata.wheeldirection = 0;
    c.cardata.brake = 0;
    c.cardata.position = [0 0 0]; %X Y Z
    c.cardata.gyro = [0 0 0]; %X Y Z
    c.cardata.wheelspeeds = [0 0 0 0]; %Left front, Right front, Left back, Right back
    c.cardata.totalvelocity = 0;
    c.cardata.acceleration = [0.0 0.0 0.0]; %X, Y, Z
    c.cardata.timepassed = 0;
    c.cardata.motorBatteryVoltage = 0;
    c.cardata.controllerBatteryVoltage = 0;
    c.cardata.kulma = 0;
    
%    setappdata(handles.figure1, 'Car_Data',cardata);
end

%This is the main loop that runs when the car is in manual drive
%The function handles the following:
% -Read keyboard input
% -Write corresponding drive commands to car
% -Read sensordata from car
% -Update car monitoring plots in the GUI
function update_display(hObject,eventdata,hfigure,handles)
    UpdateDispay(hObject, eventdata, hfigure, handles);

    
% --- Executes on button press in Connect To Car.
function connecttocarbtn_Callback(hObject, eventdata, handles)
% hObject    handle to connecttocarbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%TODO error handling
%appdata = getappdata(handles.figure1, 'App_Data');
c = Car.getInstance;

if(strcmp(c.appdata.selectedcomport, '--'))
    Logging.log('Please select a serial port.')

else
    try 
        c.appdata.serial = serial(c.appdata.selectedcomport);
        c.appdata.serial.BaudRate = 38400;
        c.appdata.serial.Terminator = 'LF';
        fopen (c.appdata.serial);
        c.appdata.connected = 1;
        setappdata(handles.figure1,'App_Data',c.appdata);
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

%appdata = getappdata(handles.figure1, 'App_Data');
c = Car.getInstance;

if(c.appdata.manualdrive)
    endmandrivebtn_Callback(233.0072, eventdata, handles);
end

if(c.appdata.connected)
    fclose(c.appdata.serial);
    delete(c.appdata.serial);
    c.appdata.connected = 0;
    c.appdata.initialized = 0;
    setappdata(handles.figure1, 'App_Data', c.appdata);
    Logging.log('Disconnected.'); 
end

% --- Executes on selection change in portConnectpop.
function portConnectpop_Callback(hObject, eventdata, handles)
% hObject    handle to portConnectpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns portConnectpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from portConnectpop

%appdata = getappdata(handles.figure1, 'App_Data');
c = Car.getInstance;

instrumentinfo = instrhwinfo('serial');
c.appdata.availablecomports = instrumentinfo.AvailableSerialPorts;
setappdata(handles.figure1, 'App_Data',c.appdata); %save availablecomports

values = get(hObject,'String');
selectedValue = get(hObject,'Value');

%Validation of serial port not currently possible since matlab instrhwinfo
%only refreshes on program startup. May be changed in future versions of
%matlab.

c.appdata.selectedcomport = values{selectedValue};
setappdata(handles.figure1, 'App_Data', c.appdata);


% TODO: TO BE DELETED!
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
%    appdata = getappdata(handles.figure1, 'App_Data');
    c = Car.getInstance;
    currentvalue = get(hObject,'String');

    %Choose save directory
    if(c.appdata.save_drive_directory==0)
     c.appdata.save_drive_directory = uigetdir(strcat(pwd,'\Drive Sessions'),'Select save directory');
    else
     c.appdata.save_drive_directory = uigetdir(c.appdata.save_drive_directory,'Select save directory');
    end

    %Display save directory
    if (c.appdata.save_drive_directory == 0)
      set(hObject,'String',currentvalue);
    else
     set(hObject,'String',c.appdata.save_drive_directory);
    end
    %Save save directory
%    setappdata(handles.figure1, 'App_Data', appdata);
end

% --- Executes during object creation, after setting all properties.
function textFieldSaveDataTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textFieldSaveDataTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'String',pwd);
Generic_callback(hObject, eventdata, handles);


% --- Executes on button press in savedrivedatacheckbox.
function savedrivedatacheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to savedrivedatacheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of savedrivedatacheckbox
    %appdata = getappdata(handles.figure1, 'App_Data');
    c = Car.getInstance;

    if get(hObject,'Value')
        set(handles.textFieldSaveDataTo,'Enable', 'inactive');

        if strcmp(c.appdata.save_drive_directory, '')
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
    %appdata = getappdata(handles.figure1, 'App_Data');
    currentvalue = get(hObject,'String');
    c = Car.getInstance;
    
    %Choose save directory
    [c.appdata.readComFile, c.appdata.readComDirectory] = uigetfile('*.mat','MAT-files (*.mat)','Select a file');

    %Display save directory
    if (c.appdata.readComFile == 0)
     set(hObject,'String',currentvalue);
    else
     set(hObject,'String',strcat(c.appdata.readComDirectory,c.appdata.readComFile));
    end
    %Save save directory
%    setappdata(handles.figure1, 'App_Data', appdata);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %appdata = getappdata(handles.figure1, 'App_Data');
    c = Car.getInstance;

    if (c.appdata.connected)
     disconnectfromcarbtn_Callback(233.0051, eventdata, handles)
        c.appdata.connected = 0;
    end

    % Destroy timer
    %delete(handles.timer)
    %delete(handles.timer2)

    %Clear the serial object
%    appdata = getappdata(handles.figure1, 'App_Data');
    clear c.appdata.serial
    
    % Hint: delete(hObject) closes the figure
    delete(hObject);

% --------------------------------------------------------------------
function saveConfiguration_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%appdata = getappdata(handles.figure1, 'App_Data');
c = Car.getInstance;

[filename, pathname, ~] = uiputfile('*.mat', 'Save car setup parameters as');

 %Save data
 if ~isequal(pathname,0) && ~isequal(filename,0)
   c.appdata.save_parameters_directory = pathname;
   
   nameAndDir = strcat(pathname,filename);

   carParametersData = getCarParametersData(handles);
   save(nameAndDir, 'carParametersData');
 
   %Save appdata
%   setappdata(handles.figure1, 'App_Data', c.appdata);
    
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
getCarConfs(hObject, eventdata, handles);


%Save car parameters to car
function setCarConfParamBtn_Callback(hObject, eventdata, handles)
% hObject    handle to setCarConfParamBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setCarConfs(hObject, eventdata, handles);


% --------------------------------------------------------------------
function aboutGUI_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to aboutGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox('Author: Valter Sandström                                                 E-mail: valter.sandstrom@aalto.fi                                26.11.2012',...
    'About this GUI...');


% --------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function Generic_callback(hObject, eventdata, handles)
% hObject    handle to ButtonPressDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); %Autogenerated code
end

% --- Executes during object creation, after setting all properties.
function Empty_callback(hObject, eventdata, handles)
% hObject    handle to ButtonPressDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
