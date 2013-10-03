
%This function takes 
function value = calcHighLowByteValue(highbyte, lowbyte)

   high = dec2bin(highbyte);
   low = dec2bin(lowbyte);
   
   for i = 1:1:(8 - size(high,2))
      high = strcat('0', high);
   end
   
   for i = 1:1:(8 - size(low,2))
      low = strcat('0', low);
   end
   
value = double(typecast(uint16(bin2dec(strcat(high, low))), 'int16'));
          
        
   