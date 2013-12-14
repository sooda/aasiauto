function [dir, thro, rev, brake] = parseInputFromKeyboard(keys, maxAngle, c)
    %Reading user keyboard commands

    thro = c.cardata.throttle(end);
    rev  = c.cardata.reverse(end);
    dir  = c.cardata.steeringwheel(end);
    brake = 0;
    
    %Reading Brake commands
    if (find(ismember(keys,'space')))
         brake = 100;
         thro = 0;
         rev = 0;
    elseif (find(ismember(keys,'n'))) %'n' = strong brake
         brake = 75;
         thro = 0;
         rev = 0;
    elseif (find(ismember(keys,'b')))%'b' = medium brake
         brake = 50;
         thro = 0;
         rev = 0;
    elseif (find(ismember(keys,'v')))%'v' = minimal brake
         brake = 25;
         thro = thro / 2;
         rev = rev / 2;
    else
         brake = 0;

         %If no brake, reading throttle commands
         if (find(ismember(keys,'uparrow'))) %'uparrow'
            thro = thro+5-thro/20;
            rev = 0;
         else
           thro = thro-25;
           if(thro < 0)
               thro = 0;
           end

           %If no brake or throttle then read reverse
           if (find(ismember(keys,'downarrow'))) %'downarrow'
                thro = 0;
                % if carspeed < 2? --> enable TODOOOOOO ---> check this in
                % microcontrols!
                rev = rev+5-rev/20;
           else
                rev = rev-25;
                if (rev < 0)
                    rev = 0;
                end
           end  

         end
    end  

    %Reading steering commands
    if (find(ismember(keys,'rightarrow'))) %rightarrow
        dir = -maxAngle;%dir - 20;
         if(dir < -maxAngle)
            dir=-maxAngle;
        end
    end
    %Reading steering commands
    if (find(ismember(keys,'leftarrow'))) %leftarrow
        dir = maxAngle;%dir + 20;
        if(dir > maxAngle)
             dir = maxAngle;
         end
    end

    %If no steering command given
    if (~any(ismember(keys,'leftarrow') + ismember(keys,'rightarrow'))) % ~right && ~left arrow
         if(dir>0)
              dir = dir - 10;
              if(dir < 0)
                   dir = 0;
              end
         else
              dir = dir + 10;
              if(dir > 0)
                  dir = 0;
              end     
         end
    end

end