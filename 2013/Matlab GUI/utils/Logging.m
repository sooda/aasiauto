classdef Logging < handle
    %LOGGING utility class
    
    methods (Static = true)
        %% Setter and getter for GUI console to be used
        function val = console(newconsole)
            persistent current;
            if nargin >= 1
                current = newconsole;
            end
            val = current;
        end
        
        %% Logging function
        function log(message)
            disp(message);
            
            if ~ishandle(Logging.console)
                return;
            end
            
            buffsize = 7;
            
            oldmsgs = get(Logging.console, 'String');
            if(numel(oldmsgs) > buffsize)
                oldmsgs(1) = ''; % delete oldest message
            end
            set(Logging.console, 'String', [oldmsgs;{message}]);
        end
    end
    
end

