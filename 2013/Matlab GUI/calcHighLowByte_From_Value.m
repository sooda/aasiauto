%This function takes 
function [highbyte, lowbyte] = calcHighLowByte_From_Value(value, scaling)
   
   dec = str2double(value) * scaling;
   bin = dec2bin(dec);
   
   
   for i = 1:1:(16 - size(bin,2))
      bin = strcat('0', bin);
   end
 
   highbyte = bin2dec(bin(1:8));
   lowbyte = bin2dec(bin(9:16));