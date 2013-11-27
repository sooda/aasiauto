% get byte stream, build numeric chunks pass them around

function rest = parse_buffer(buf)
headersize = 4; % size and type
n = numel(buf);
i = 1;
while i+1 <= n
	% header not included in size data
	% size in bytes
	bytes = buf2num(buf(i:i+1));
	chunksz = headersize + bytes;
	j = i + chunksz - 1;
	% full message chunk available?
	if j > n
		break;
	end
	parse_item(buf2num(buf(i:j)));
	i = i + chunksz;
end
rest = buf(i:end);
