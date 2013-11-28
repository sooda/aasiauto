% do what you want with the packets cause a pirate is free

function parse_item(nums)
sz = nums(1);
type = nums(2);
switch type
    case 1
        disp('pong');
    case 3
        disp('speed:')
        disp(nums(3:6))
    case 4
    	disp('err:')
        disp(nums(3))
    otherwise
        disp('bad message')
        disp(nums)
end
