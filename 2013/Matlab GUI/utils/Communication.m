% Specifies communication class for connecting and transferring data from
% and to RC car.
classdef Communication < handle
    
    properties
        appdata;
        serial_data;
        status;
        connectionTimer;
        communicationTimer;
        buf_in;
        buf_out;

        STATUSCODE = struct('Disconnected', 0, ...
                            'Connecting', 1, ...
                            'Connected', 2, ...
                            'Initialized', 3, ...
                            'Error', 4, ...
                            'Simul', 5);
    end
    
    methods
        % Class constructor
        function this = Communication()
            this.status = this.STATUSCODE.Disconnected;
        end
        
        % Opens serial connection to car
        function this = connectToCar(this, comport)
            
            if (this.status ~= this.STATUSCODE.Disconnected)
                % error!
                Logging.log('ERROR: Already connected.');
                return;
            end
            
            if(strcmp(comport, '--'))
                Logging.log('Please select a serial port.');

            elseif (strcmp(comport, 'Simul'))
                Logging.log('Opening car simulation...');
                this.status = 5; % this.STATUSCODE.Simul;
                
                this.communicationTimer = timer('Executionmode', 'fixedRate', 'Period', 0.05, ...
                    'TimerFcn', {@this.async_Communication_triggered});
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
                    this.status = this.STATUSCODE.Connecting;

                    this.connectionTimer = timer('Executionmode', 'fixedRate', 'Period', 0.5, ...
                        'TimerFcn', {@this.connectionTimer_triggered});
                    start(this.connectionTimer); %Timer to check for Initialization

                    this.communicationTimer = timer('Executionmode', 'fixedRate', 'Period', 0.05, ...
                        'TimerFcn', {@this.async_Communication_triggered});
                    start(this.communicationTimer);
                    
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

        function val = isConnected(this)
            val = 0;
            if (this.status == this.STATUSCODE.Connected || ...
                    this.status == this.STATUSCODE.Initialized || ...
                    this.status == this.STATUSCODE.Simul)
                val = 1;
            end
        end
        
        % Disconnects serial connection
        function this = disconnectFromCar(this)
            stop(this.communicationTimer);
            
            if (this.status ~= this.STATUSCODE.Connected && ...
                    this.status ~= this.STATUSCODE.Simul)
                % error!
                Logging.log('Error: Not connected.');
                return;
            end
            
            if (this.status == this.STATUSCODE.Simul)
                this.status = this.STATUSCODE.Disconnected;
                Logging.log('Simulation disconnected.');
                return
            end
            
            if(this.appdata.manualdrive)
                endmandrivebtn_Callback(233.0072, eventdata, handles); % wtf?
            end

            if ( this.status == this.STATUSCODE.Connected || ...
                    this.status == this.STATUSCODE.Initialized)                
                fclose(this.serial_data);
                delete(this.serial_data);
                this.status = this.STATUSCODE.Disconnected;
                
                Logging.log('Disconnected.'); 
            end
        end % /disconnectFromCar
        
        %This function checks if the car is initialized and ready to start a drive session
        %In other words: if sensordata from the car is received then it is ready
        function this = connectionTimer_triggered(this, varargin)
            if (this.serial_data.BytesAvailable && ...
                    this.status ~= this.STATUSCODE.Initialized)
                this.status = this.STATUSCODE.Initialized;
                Logging.log('Initialized and ready for drive session.');
            else
                this.status = this.STATUSCODE.Disconnected;
                Logging.log('Initialization failed.');
            end
            stop(this.connectionTimer);
        end
        
        % Handle asynchronic reading and writing triggered by a timer.
        function this = async_Communication_triggered(this, varargin)
            if (this.status == this.STATUSCODE.Initialized || ...
                    this.status == this.STATUSCODE.Simul)
                val = this.getBytes();
                if (val > 0)
                    this.buf_in = [this.buf_in val];
                end
                
                if numel(this.buf_out) > 0
                    this.writeBytes(this.buf_out);
                    this.buf_out = [];
                end
            end
        end
        
        function val = read(this)
            val = this.buf_in;
            this.buf_in = [];
        end
        
        function this = write(this, val)
            this.buf_out = [this.buf_out val];
        end
        
        % Read all bytes (BytesAvailable).
        function val = getBytes(this)
            if (this.status == 5) %this.STATUSCODE.Simul)
                Logging.log('Reading data from simulation:');
                val = -1;
            elseif (this.serial_data.BytesAvailable && ...
                    this.status == this.STATUSCODE.Initialized)
                val = fread(this.serial_data, this.serial_data.BytesAvailable);
            else
                val = -1;
            end
        end
        
        % Read byte from the serial communication with car.
        function val = getByte(this)
            if (this.serial_data.BytesAvailable && ...
                    this.status == this.STATUSCODE.Initialized)
                val = fread(this.serial_data, 1);
            else
                val = -1;
            end
        end

        % Write bytes
        function this = writeBytes(this, bytes)
            if (this.status == 5) %this.STATUSCODE.Simul)
                Logging.log('Write data to simulation:');
                Logging.log(bytes);
            elseif (this.status == this.STATUSCODE.Initialized)
                fwrite(this.serial_data, bytes);
            end
        end
        
    end % /methods

end % /classdef Communication