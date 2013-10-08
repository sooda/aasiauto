% container
classdef ByteTools

    methods (Static)
        %This function takes 
        function [highbyte, lowbyte] = calcHighLowByte_From_Value(value, scale)
            if nargin < 2
                scale = 1;
            end
            
            value = str2double(value) * scale;
            
            highbyte = bitshift(value, -8);
            lowbyte = bitand(value, 255);

        end

        %This function takes 
        function value = calcHighLowByteUnsignedValue(highbyte, lowbyte, scale)
            if nargin < 3
                scale = 1;
            end
            value = num2str((bitshift(highbyte, 8) + lowbyte) / scale);

        end

        %This function takes 
        function value = calcHighLowByteValue(highbyte, lowbyte)
            % TODO: how this differs from CalcHighLowByteUnsignedValue?

            high = dec2bin(highbyte);
            low = dec2bin(lowbyte);

            for i = 1:1:(8 - size(high,2))
              high = strcat('0', high);
            end

            for i = 1:1:(8 - size(low,2))
              low = strcat('0', low);
            end

            value = double(typecast(uint16(bin2dec(strcat(high, low))), 'int16'));

        end
    
    end
end