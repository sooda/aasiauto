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

