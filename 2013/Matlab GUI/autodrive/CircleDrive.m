function CircleDrive(handles)
    disp('CircleDrive');
    
    % clean old handles
    if isfield(handles, 'asd') && ishandle(handles.asd)
        stop(handles.tasd);
        delete(handles.tasd);
        delete(handles.asd);
    end
    
    % create contents dynamically
    ts = handles.TestSection;
    handles.asd = uicontrol(...
        'Parent', ts,...
        'Style','edit',...
        'String','',...
        'Position',[rand*600 rand*600 60 24],...
        'Callback',@startCircleDrive,...
        'Enable','on');
    
    % set function for Begin automatic drive callback
    set(handles.beginAutoDrive,...
        'Callback',@startCircleDrive,...
        'Enable','on');
    
    % store new handles
    guidata(handles.figure1, handles);

    %% Function for Begin automatic drive callback
    function startCircleDrive(hObject,~)
        disp('Starting Circle Drive!');
        handles.tasd = timer(...
            'Executionmode','fixedRate','Period', 0.5,...
            'TimerFcn', @updateDistanceFromCenter);
        start(handles.tasd);
    end

    %% Timer-triggered function for parameter update
    function updateDistanceFromCenter(~,~)
        if ~ishandle(handles.asd)
            stop(handles.tasd);
            return;
        end
        set(handles.asd, 'String', num2str(rand*10));
    end
end
