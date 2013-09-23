function fcustomwrite(serial,high,low,Id)

%stopasync(serial);
towrite = [255 66 Id];

if strcmp(low,'')%One byte
   towrite = [towrite high];
    if high == 255
     towrite = [towrite 0];
    end
    
   towrite = [towrite 0];
    
else %Two bytes

    towrite = [towrite high];
    if high == 255
     towrite = [towrite 0];
    end
    towrite = [towrite low];
    if low == 255
        towrite = [towrite 0];
    end
end

%fwrite(serial, towrite, 'async');
fwrite(serial, towrite);
%readasync(serial);
%pause(0.05);