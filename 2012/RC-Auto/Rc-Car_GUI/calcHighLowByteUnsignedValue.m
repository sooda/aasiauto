%This function takes 
function value = calcHighLowByteUnsignedValue(highbyte, lowbyte, scale)

   high = dec2bin(highbyte);
   low = dec2bin(lowbyte);
   
   for i = 1:1:(8 - size(high,2))
      high = strcat('0', high);
   end
   
   for i = 1:1:(8 - size(low,2))
      low = strcat('0', low);
   end
   %high
   %low
   
value = bin2dec(strcat(high,low))/scale;
value = num2str(value);