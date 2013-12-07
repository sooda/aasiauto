function ConveyerDrive(handles)
    disp('ConveyerDrive');
    
    % ConveyerDrive simply tries to keep distance to front constant
    
    % clean old handles
    if isfield(handles, 'fig') && ishandle(handles.fig)
        stop(handles.tasd);
        delete(handles.tasd);
        delete(handles.fig);
        delete(handles.distLabel);
        delete(handles.distEdit);
    end
    
    % create contents dynamically
    ts = handles.TestSection;
    pos = get(ts,'Position');

    % create measurement figure
    handles.fig = plot(axes(...
        'Parent', ts,...
        'Units','Normalized',...
        'Position',[pos(1)-0.16, pos(2)+0.02, pos(3), pos(4)-0.02]),1);
    
    % create editbox to specify distance to front
    handles.distLabel = uicontrol(...
        'Parent', ts,...
        'Style','text',...
        'Units','Normalized',...
        'Position',[pos(1)+0.67, pos(2)+0.92, pos(3)-0.68, pos(4)-0.94],...
        'HorizontalAlign','left',...
        'String','Specify distance to front:');
    handles.distEdit = uicontrol(...
        'Parent', ts,...
        'Style','edit',...
        'Units','Normalized',...
        'Position',[pos(1)+0.67, pos(2)+0.90, pos(3)-0.70, pos(4)-0.94],...
        'BackgroundColor',[1 1 1],...
        'String','0.0');
    
    % Set function for Begin and End automatic drive callback
    set(handles.beginAutoDrive,...
        'Callback',@startConveyerDrive,...
        'Enable','on');
    set(handles.endAutoDrive,...
        'Callback',@endConveyerDrive,...
        'Enable','on');
    
    % get current distance
    c = Car.getInstance;
    dist2 = c.cardata.distToFront(end);
    set(handles.distEdit, 'String', num2str(dist2));

    % store new handles
    guidata(handles.figure1, handles);

    %% Function for Begin automatic drive callback
    function startConveyerDrive(~,~)
        disp('Starting Circle Drive!');
        
        c.cardata.autoDrive_distToFront = 0;
        c.cardata.autoDrive_time = 0;

        handles.tasd = timer(...
            'Executionmode','fixedRate','Period', 0.5,...
            'TimerFcn', @updateDistanceFromCenter);
        start(handles.tasd);
        
        c = Car.getInstance;
        dist2 = str2double(get(handles.distEdit, 'String'));
        if (isfield(c.appdata,'com'))
            c.appdata.com.write2(126, dist2);
        end
            

    end

    %% Function for End automatic drive callback
    function endConveyerDrive(~,~)
        c = Car.getInstance;
        if (isfield(c.appdata,'com'))
            c.appdata.com.write2(125, []); % stop drive
        end
        stop(handles.tasd);
    end
    %% Timer-triggered function for parameter update
    function updateDistanceFromCenter(~,~)
        if ~ishandle(handles.fig)
            stop(handles.tasd);
            return;
        end
        
        c = Car.getInstance;
        if (isfield(c.appdata,'com'))
            c.appdata.com.async_Communication_triggered(); % handle communication here
        end
        
        measurement_data = c.cardata.last_measurements;
        data = Protocol.processMeasurementData(measurement_data);
        if numel(data) > 15
            dist2 = data(16);
        else
            dist2 = rand*10;
        end
                
        c.cardata.autoDrive_distToFront = [c.cardata.autoDrive_distToFront; dist2];
        c.cardata.autoDrive_time(end+1) = c.cardata.autoDrive_time(end) + handles.tasd.Period;

        set(handles.fig,...
            'XData', c.cardata.autoDrive_time,...
            'YData', c.cardata.autoDrive_distToFront);
        
    end
end
