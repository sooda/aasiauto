% container
classdef ByteTools

    methods (Static)
        function num = buf2num(buf)
            try
                num = double(typecast(buf, 'int16'));
            catch
                num = [];
                disp('ERROR2!!!')
                buf
            end
        end
    
        function buf = num2buf(num)
            try
                buf = typecast(int16(num), 'uint8');
            catch
                buf = [];
                disp('ERROR!!!');
                num
            end
        end
        
        function buf = duplicateFFs(val)
            n = numel(val);
            buf = zeros(1,n);
            i = 1;
            j = 1;
            while i <= n
                buf(j) = val(i);
                if (val(i) == 255)
                    buf(j+1) = 255;
                    j = j + 1;
                end
                i = i + 1;
                j = j + 1;
            end
        end
        
    end
end