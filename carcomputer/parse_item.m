% do what you want with the packets cause a pirate is free

function parse_item(nums)
sz = nums(1);
type = nums(2);
switch type
case 1
		disp('MSG pong');
	case 110
		disp('MSG measurements:')
		disp(nums(3:end))
	case 4
		disp('MSG err:')
		disp(nums(3:end))
	otherwise
		disp('MSG bad message')
		disp(nums)
end
