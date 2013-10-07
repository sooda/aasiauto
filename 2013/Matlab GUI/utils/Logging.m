classdef Logging < handle
    %LOGGING Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static = true)
        function val = console(newconsole)
            persistent current;
            if nargin >= 1
                current = newconsole;
            end
            val = current;
        end
        
        function log(message)
            disp(message);
            
            oldmsgs = get(Logging.console, 'String');
            msgssize = size(oldmsgs);
            if(msgssize(1) > 8)
                oldmsgs = oldmsgs(2:9); %delete first row
            end
            set(Logging.console, 'String', [oldmsgs;{message}]);
            % set(handles.console2,'String',[oldmsgs;{message}]);
        end
    end
    
end

