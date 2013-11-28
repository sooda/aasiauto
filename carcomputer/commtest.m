% demo app for testing the simulation mode and showing how it works

% size type data
% size in bytes
hello = [0 0];
throttle = [4 2]; % append left right speeds here

cache = [];
for main_i=1:5
	disp('iter=');
	disp(main_i);
	% build control signals somehow...
	thr = [throttle main_i main_i-1];
	out = [hello thr];

	rawout = typecast(uint16(out), 'uint8')
	buf = controller(rawout)

	% simulate partial buffers
	% feed just a few bytes at a time
	fakeblk_sz = 3;
	while numel(buf) > 0
		b = buf;
        if numel(buf) > fakeblk_sz
			b = buf(1:fakeblk_sz);
        end
		% parse_buffer does some action
		cache = parse_buffer([cache b]);
		buf = buf(fakeblk_sz+1:end);
	end
	% .. and react here to UI or something.
end

% protocol (all 16bit ints so far):
% datasize type [data]
% type not included in datasize

