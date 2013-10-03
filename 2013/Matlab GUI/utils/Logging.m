classdef Logging
    %LOGGING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%        handles;
%        eventdata;
    end
    
    methods (Static)
        % constructor
%        function obj = Logging
%            obj;
%        end
        
        function log(message)
            %console_Callback(obj.handles.console, obj.eventdata, obj.handles, message);
            disp(message);
        end
    end
    
end

