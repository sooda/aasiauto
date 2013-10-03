% Specifies communication class for connecting and transferring data from
% and to RC car.

classdef Communication < handle
    
    properties
        appdata;
        serial_data;
        status;
        connectionTimer;

        STATUSCODE = struct('Disconnected', 0, ...
                            'Connecting', 1, ...
                            'Connected', 2, ...
                            'Initialized', 3, ...
                            'Error', 4);
    end
    
    methods
        % Class constructor
        function this = Communication()
            this.status = this.STATUSCODE.Disconnected;
            %timer('Executionmode','fixedRate','Period', 1, ...
            %    'TimerFcn', {@this.connectionTimer_triggered}, inf);
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

            else
                try 
                    this.status = this.STATUSCODE.Connecting;

                    this.serial_data = serial(comport);
                    this.serial_data.BaudRate = 38400;
                    this.serial_data.Terminator = 'LF';
                    fopen (this.serial_data);

                    Logging.log('Connected, please wait for car initialization...');
                    this.status = this.STATUSCODE.Connecting;

                    this.connectionTimer = timer('Executionmode','fixedRate','Period', 0.05, ...
                        'TimerFcn', {@this.connectionTimer_triggered});
                    start(this.connectionTimer); %Timer to check for Initialization

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

        % Disconnects serial connection
        function this = disconnectFromCar(this)
            if (this.status ~= this.STATUSCODE.Connected)
                % error!
                Logging.log('Error: Not connected.');
                return;
            end
            
            if(this.appdata.manualdrive)
                endmandrivebtn_Callback(233.0072, eventdata, handles); % wtf?
            end

            if ( this.status == this.STATUSCODE.Connected || ...
                    this.status == this.STATUSCODE.Initialized )
                
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
        end % / check_initialized

    end % /methods

end % /classdef Communication