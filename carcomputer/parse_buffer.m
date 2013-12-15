% get byte stream, build numeric chunks pass them around

function rest = parse_buffer(buf)
headersize = 2; % length of msg size and type
n = numel(buf);
i = 1;
while i+headersize-1 <= n % smallest packet has at least headers
	% header not included in size data
    % msg: [lenOfData][id][data] << each 2 bytes
	datasz = double(buf(i)); % data size in bytes
	chunksz = headersize + datasz; % total message size
	dataend = i + chunksz - 1; % last index of data
	
	if dataend > n % full message chunk not available?
		break;
	end

	msgid = double(buf(i+1));
	payload = buf2num(buf(i+2:dataend));
    parse_item([datasz msgid payload]); % get and parse one message
	i = i + chunksz; % move pointer to start of the next message
end
rest = buf(i:end); % return rest of the buffer
