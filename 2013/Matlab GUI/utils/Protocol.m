classdef Protocol %< value
    properties (Constant)

    end
    methods (Static = true)
       
        function setCarValue(car, id, value)
            % TODO: value processing here? ... should get rid of this shit
            if id < 20
               value = value; % join from two bytes
            elseif id == 20
               value = value; % no conversion
            elseif id > 20 && id < 30
               value = num2str(value);
            elseif id == 40
               value = value;
            elseif id > 40 && id <= 51
               value = num2str(value);
            elseif id > 51
               value = value; % join from two bytes
            end

            car.setParam(id, value);
            
        end
       
        function value = getCarValue(car, id)
            value = car.getParam(id);
            
            if id < 20
               value = value; % split to two bytes
            elseif id == 20
               value = value; % no conversion
            elseif id > 20 && id < 30
               value = str2int(value);
            elseif id == 40
               value = value;
            elseif id > 40 && id <= 51
               value = str2int(value);
            elseif id > 51
               value = value; % split to two bytes
            end
            
        end

   end
end