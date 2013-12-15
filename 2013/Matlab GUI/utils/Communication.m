% Specifies communication class for connecting and transferring data from
% and to RC car.
classdef Communication < handle
    
    properties
        serial_data;
        status;
        connectionTimer;
        communicationTimer;
        buf_in;
        buf_out;
        discardFirstMessage;

        STATUSCODE = struct('Disconnected', 0, ...
                            'Connecting', 1, ...
                            'Connected', 2, ...
                            'Initialized', 3, ...
                            'Error', 4, ...
                            'Simul', 5);
    end
    
    methods
        %% Class constructor
        function this = Communication()
            this.status = this.STATUSCODE.Disconnected;
        end
        
        %% Open serial connection to car
        function this = connectToCar(this, comport)
            
            if (this.status ~= this.STATUSCODE.Disconnected)
                % error!
                Logging.log('ERROR: Already connected.');
                return;
            end
            
            this.connectionTimer = timer('Executionmode', 'fixedRate', 'Period', 0.5, ...
                'TimerFcn', {@this.connectionTimer_triggered});
%            this.communicationTimer = timer('Executionmode', 'fixedRate', 'Period', 0.01, ...
%                'TimerFcn', {@this.async_Communication_triggered});
            this.communicationTimer = timer('Executionmode', 'fixedRate', 'Period', 0.1, ...
                'TimerFcn', {@this.keepAlive});

            if(strcmp(comport, '--'))
                Logging.log('Please select a serial port.');

            elseif (strcmp(comport, 'Simul'))
                Logging.log('Opening car simulation...');
                this.status = this.STATUSCODE.Simul;

                start(this.communicationTimer);
            else
                try 
                    this.serial_data = serial(comport);
                    this.serial_data.BaudRate = 38400;
                    this.serial_data.Terminator = 'LF';
                    this.buf_in = [];
                    this.buf_out = [];
                    fopen (this.serial_data);

                    Logging.log('Connected, please wait for car initialization...');
                    disp(['Please, notice that microcontrollers must have been turned ' ...
                        'on before attempting to connect the car.']);
                    this.status = this.STATUSCODE.Connecting;

                    start(this.connectionTimer); %Timer to check for Initialization
                    start(this.communicationTimer);
                    
                    fwrite(this.serial_data, uint8([0 0]));
                    
                catch err

                    if(strcmp(err.identifier, 'MATLAB:serial:fopen:opfailed'))
                        this.status = this.STATUSCODE.Disconnected;
                        Logging.log('Failed to connect to selected port.');
                    else
                        this.status = this.STATUSCODE.Error;
                        Logging.log([ 'Undefined error occured, check Matlab command window: ' err.identifier ]);
                        rethrow(err);
                    end
                end
            end
        end % /connectToCar

        %% Check if GUI is connected to car.
        function val = isConnected(this)
            val = 0;
            if (this.status == this.STATUSCODE.Connected || ...
                    this.status == this.STATUSCODE.Initialized || ...
                    this.status == this.STATUSCODE.Simul)
                val = 1;
            end
        end
        
        %% Disconnect serial connection
        function this = disconnectFromCar(this)
            if (isvalid(this.communicationTimer))
                stop(this.communicationTimer);
                delete(this.communicationTimer);
            end
            if (isvalid(this.connectionTimer))
                stop(this.connectionTimer);
                delete(this.connectionTimer);
            end
            
            % delete also all the rest timers
%            delete(timerfindall());
            
            if (~this.isConnected() && this.status ~= this.STATUSCODE.Connecting)
                % error!
                Logging.log('Error: Not connected.');
                return;
            end
            
            if (this.status == this.STATUSCODE.Simul)
                this.status = this.STATUSCODE.Disconnected;
                Logging.log('Simulation disconnected.');
                return
            end
            
            c = Car.getInstance();
            
            c.appdata.connected = 0;
            
            if(c.appdata.manualdrive)
%                endmandrivebtn_Callback(0,0,0);
            end

            fclose(this.serial_data);
            delete(this.serial_data);
            this.status = this.STATUSCODE.Disconnected;
                
            Logging.log('Disconnected.');

        end % /disconnectFromCar
        
        %% This function checks if the car is initialized and ready to start a drive session
        % In other words: if sensordata from the car is received then it is ready
        function this = connectionTimer_triggered(this, varargin)
%                this.status = this.STATUSCODE.Initialized;
%                Logging.log('Initialized and ready for drive session.');
%                stop(this.connectionTimer);
%                c = Car.getInstance;
%                c.appdata.connected = 1;

			if (this.status == this.STATUSCODE.Simul)
				c.appdata.connected = 1;
				
            % wait for input from car
            elseif (this.serial_data.BytesAvailable && ...
                    this.status ~= this.STATUSCODE.Initialized)
                this.status = this.STATUSCODE.Initialized;
                Logging.log('Initialized and ready for drive session.');
                stop(this.connectionTimer);
                c = Car.getInstance();
                c.appdata.connected = 1;
%                this.discardFirstMessage = 1;
            else
                % ping
                fwrite(this.serial_data, uint8([0 0]));
                disp('.');
            end
            
        end
        
        %% Keep connection between GUI and Car alive
        function this = keepAlive(this, varargin)
            c = Car.getInstance();
            
            if ~isfield(c.appdata,'manualdrive') || (this.status == this.STATUSCODE.Initialized && c.appdata.manualdrive ~= 1)
                this.write2(0, []); % ping
                this.writeBytes(this.buf_out);
                this.buf_out = [];

                val = this.getBytes();
                if (numel(val) > 0 && val(1) > -1)
                    this.buf_in = [this.buf_in val];
                    this.buf_in = Protocol.parse_buffer(this.buf_in); % just clean buffer here
                end    
            end
            % TODO: integrate simulation here
            % if this.status == this.STATUSCODE.Simul etc.
        end
        
        %% Handle asynchronic reading and writing triggered by a timer.
        function this = async_Communication_triggered(this) %, varargin)
            if (this.status == this.STATUSCODE.Simul)
                if (exist('controller','file')) % file or builtin or class..
                    buf = controller(this.buf_out);
                    this.buf_out = [];
                    this.buf_in = [this.buf_in buf];
                end
            elseif (this.status == this.STATUSCODE.Initialized)
                val = this.getBytes();
                if (numel(val) > 0 && val(1) > -1)
                    this.buf_in = [this.buf_in val];
                    this.buf_in = Protocol.parse_buffer(this.buf_in);
                end
                
                this.write2(0, []); % ping
                
                if numel(this.buf_out) > 0
                    this.writeBytes(this.buf_out);
                    this.buf_out = [];
                end
            end
        end
        
        %% Return content of the read buffer
        function val = read(this)
            val = this.buf_in;
            this.buf_in = [];
        end
        
%        function this = write(this, val)
%            val = ByteTools.num2buf(int16(val));
%            val = ByteTools.duplicateFFs(val);
%            this.buf_out = [this.buf_out int8(255) val];
%        end
        
        %% Write data with given ID to buffer
        function this = write2(this, id, data)
            data = ByteTools.num2buf(int16(data));
            sz = numel(data);
            data = ByteTools.duplicateFFs(data);
            this.buf_out = uint8([this.buf_out 255 sz id data]);
        end
        
        %% Read all bytes (BytesAvailable).
        function val = getBytes(this)
            if (this.status == this.STATUSCODE.Simul)
                Logging.log('Reading data from simulation (async)...');
                val = -1;
            elseif (this.status == this.STATUSCODE.Initialized)
                val = [];
%                while (this.serial_data.BytesAvailable)
                if (this.serial_data.BytesAvailable)
                    buf = fread(this.serial_data, this.serial_data.BytesAvailable);

%                    if (this.discardFirstMessage == 1 && numel(buf) > 0)
%                        disp('Discard first bytes..');
%                        buf
%                        val = [];
%                        return;
%                    end
                    val = [val buf'];
%                    continue;
                    return;
                    
                    % drop double-0xFF
%                    n = numel(buf);
%                    buf2 = buf;
%                    j = 1;
%                    i = 1;
%                    while i < n
%                        if buf(i) == 255 && buf(i+1) == 255
%                            i = i + 2;
%                            buf2(j+1) = '';
%                            continue;
%                        end
%                        j = j + 1;
%                        i = i + 1;
%                    end

%                    val = [val buf2];
                end
                
%                this.discardFirstMessage = 0;
            else
                val = -1;
            end
        end
        
        %% Write bytes to serial connection
        function this = writeBytes(this, bytes)
            if (this.status == this.STATUSCODE.Simul)
                Logging.log('Write data to simulation:');
                Logging.log(bytes);
            elseif (this.status == this.STATUSCODE.Initialized)
                fwrite(this.serial_data, bytes);
            end
        end
        
    end % /methods

end % /classdef Communication
