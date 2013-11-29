% container
classdef ByteTools

    methods (Static)
        function num = buf2num(buf)
            num = double(typecast(buf, 'int16'));
        end
    
        function buf = num2buf(num)
            buf = typecast(uint16(num), 'uint8');
        end
        
    end
end