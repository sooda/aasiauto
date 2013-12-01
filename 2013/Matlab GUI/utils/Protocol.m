classdef Protocol %< value
    properties (Constant)

    end
    methods (Static = true)
       
        function setCarValue(car, id, value)
            % TODO: value processing here?
            if id < 20
%               value = value; % join from two bytes
            elseif id == 20
%               value = value; % no conversion
            elseif id > 20 && id < 30
               value = num2str(value);
            elseif id == 40
%               value = value;
            elseif id > 40 && id <= 51
               value = num2str(value);
            elseif id > 51
%               value = value; % join from two bytes
            end

            disp('message:');
            car.setParam(id, value);
            
        end
       
        function value = getCarValue(car, id)
            value = car.getParam(id);
            
            if id < 20
%               value = value; % split to two bytes
            elseif id == 20
%               value = value; % no conversion
            elseif id > 20 && id < 30
               value = str2int(value);
            elseif id == 40
%               value = value;
            elseif id > 40 && id <= 51
               value = str2int(value);
            elseif id > 51
%               value = value; % split to two bytes
            end
            
        end
        
        function parseMessage(c, id, data)
            if id == 0 % ping
                Protocol.pong(c);
                
            elseif id == 1 % pong
                Logging.log('Got pong!');
                
            elseif id == 2 % GUI requests car params
                % ...
                
            elseif id == 3 % Car requests car params
                Protocol.sendCarParams(c);
                
            elseif id == 99 % All params have been sent by car/GUI
                % ...
                
            elseif id == 110 % Car data vector (measurements)
                c.cardata.last_measurements = data; % just override..
                
            elseif id == 120 % Driving data from GUI to Car..
                % ...
                
            else % suppose that we got car parameter
                Protocol.setCarValue(c, id, data);
            end
        end
        
        function pong(c)
            c.appdata.com.write([0 1]); % 0-length pong
        end
        
        function sendCarParams(c)
            fields = fieldnames(c);
            for i=1:numel(fields)
                id = c.(fields{i});
                if isscalar(id)
                    value = Protocol.getCarValue(c, id);
                    c.appdata.com.write([2 id value]); % write two bytes
                end
            end
            c.appdata.com.write([0 99]); % write two bytes
        end
        
        function rest = parse_buffer(buf)
            % msg: [0xFF][lenOfData][id][data]
            headersize = 3; % length of msg header size
            n = numel(buf);
            i = 1;
            c = Car.getInstance;

            while i+2 <= n % minimum length of message is 3
                % header not included in size data
                if (buf(i) ~= 255) % message start byte (0xFF)
                    Logging.log('corrupted msg...');
                end
                datasz = buf(i+1); % data size in bytes
                chunksz = headersize + datasz; % message size
                dataend = i + chunksz - 1; % last index of data
                id = buf(i+2);

                if dataend > n % full message chunk not available?
                    break;
                end

                data = ByteTools.buf2num(buf(i+3:dataend));
                Protocol.parseMessage(c, id, data);

                i = i + chunksz; % move pointer to start of the next message
            end
            rest = buf(i:end); % return rest of the buffer
        end
            
        function value = processMeasurementData(m)
            value = zeros(size(m));
            c = Car.getInstance;
            
            % scale correct values
            
            % Wheel speeds
            % Speed [km/h] = 3.6 * pi * wheeldiameter[m] * relevations/seconds
            for i=1:4
                value(i) = 1.4137 *(( m(i) /512)/0.01); %TODO: em?
            end
            
            % Acceleration-x,y,z
            for i=5:7
                value(i) = m(i) * c.cardata.acc_scaling;
                if (abs(value(i)) < 0.4)
                    value(i) = 0;  % remove noise
                end
            end
            
            % Gyro-x,y,z
            for i=8:10
                value(i) = m(i) / 14.38; % TODO: what is this value?
            end
            
            % Wheel direction
            value(11) = m(11);
            
            % Motor battery voltage
            value(12) = m(12);
            
            % Controller battery voltage
            value(13) = m(13);
        end

   end
end