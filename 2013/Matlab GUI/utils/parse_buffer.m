% get byte stream, build numeric chunks pass them around

function rest = parse_buffer(buf)
headersize = 4; % length of msg size and type
n = numel(buf);
i = 1;
c = Car.getInstance;

while i+3 <= n % minimum length of message is 4
	% header not included in size data
    % msg: [lenOfData][id][data] << each 2 bytes
	datasz = ByteTools.buf2num(buf(i:i+1)); % data size in bytes
	chunksz = headersize + datasz; % message size
	dataend = i + chunksz - 1; % last index of data
	
	if dataend > n % full message chunk not available?
		break;
	end
    
    data = ByteTools.buf2num(buf(i:dataend));
    Protocol.setCarValue(c, data(2), data(3:end));
    
	i = i + chunksz; % move pointer to start of the next message
end
rest = buf(i:end); % return rest of the buffer
