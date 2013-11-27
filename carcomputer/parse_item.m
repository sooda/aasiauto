% do what you want with the packets cause a pirate is free

function parse_item(nums)
sz = nums(1);
type = nums(2);
if type == 1
	disp('pong');
elseif type == 3
	disp('speed:')
	disp(nums(3:6))
elseif type == 4
	disp('err:')
	disp(nums(3))
else
	disp('bad message')
	disp(nums)
end
