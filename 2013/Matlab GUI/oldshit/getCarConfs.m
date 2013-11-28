function getCarConfs(hObject, eventdata, handles)
    %c.appdata = getc.appdata(handles.figure1, 'App_Data');
    c = Car.getInstance;
    
    if (~c.appdata.connected)
        Logging.log('Not connected');
        return;
    end
 
    com = c.appdata.com;
    
    % Clear data buffer
    com.read()
    
    com.buf_in = [];
    com.buf_in = uint8([com.buf_in 2 0 20 0 round(rand) 0]);
    com.buf_in = uint8([com.buf_in 2 0 40 0 round(rand) 0]);
    
%    if c.appdata.serial.BytesAvailable %Clear car buffer
%        fread(c.appdata.serial,c.appdata.serial.BytesAvailable);
%    end

    %Request car parameters
    %stopasync(c.appdata.serial);
%    readasync(c.appdata.serial);
    %pause(0.1);

%    fwrite(c.appdata.serial, [255 67 255 0], 'async');
    com.write([255 67 255 0]);
    %readasync(c.appdata.serial);
    %  fwrite(c.appdata.serial, 255);
    %  fwrite(c.appdata.serial, 67);
    %  fwrite(c.appdata.serial, 255);
    %  fwrite(c.appdata.serial, 0);

    reading_byte_num = 0;
    counter = 0;
    data = [];
    %READ PARAMETER DATA FROM CAR
    while (counter < 34)
        counter = counter + 1;
        reading_byte_num = reading_byte_num + 1;

        data = [data com.read()];
        
        if numel(data) > 0
            
            Logging.log(['got data: ' num2str(data)]);
            data = parse_buffer(data);
            
            break;
            
        end
    end

%    disp('Current car configuration:')
%    disp(c);
    
    disp('ABS:')
    c.getParam(20)
    disp('ESP:')
    c.getParam(40)

    if counter < 34
        Logging.log('Warning: All parameters were Not loaded successfully! Current car data parameters printed to MATLAB Command Window..');
    else
%        response = questdlg('The current car parameters have been printed to MATLAB Command Window, would you like to import these parameters to the GUI? Warning: Current parameters in GUI will be lost.', ...
%                             'Confirm import of parameters', ...
%                             'Import parameters', 'Cancel', 'Cancel');

%        if strcmp(response, 'Import parameters')
%            setCarParametersData(handles,D);
            Logging.log('Current car data parameters loaded.');
%        end
    end

end