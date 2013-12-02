import serial
from sys import argv
import struct
import time

MSG_CAR_MEAS_VECTOR = 110
MSG_PONG = 1
MSG_ERR = 4
MEAS_NITEMS = 13

MEASNAMES = [
	"encoder 1",
	"encoder 2",
	"encoder 3",
	"encoder 4",
	"xacc",
	"yacc",
	"zacc",
	"xgyr",
	"ygyr",
	"zgyr",
	"steerwheel",
	"motorbatt",
	"ctrlbatt"
]

i = 0
j = 0

def parse_packet(data):
	global i, j

	sz = ord(data[0])
	kind = ord(data[1])
	if kind == MSG_CAR_MEAS_VECTOR:
		nums = struct.unpack("<" + "H" * MEAS_NITEMS, "".join(data[2:]))
		print "j",j
		print "i",i
		print "\n".join("%s:\t%d" % t for t in zip(MEASNAMES, nums))

		j += 1
		if j == 10:
			j = 0

			# brake cmd
			ii = 1000 + i
			i1 = ii & 0xff # low byte
			if i1 == 0xff:
				i1 = 0xfe # should duplicate ff's, not bothering
			i2 = (ii >> 8) & 0xff # hi byte
			hax = "".join(map(chr, [i1, i2, i1, i2, i1, i2, i1, i2]))

			ser.write("\xff\x08\x7a" + hax)
			ser.write("\xff\x00\x00")
			i += 10
			if i == 500:
				i = 0
	elif kind == MSG_ERR:
		print "YHYY"
		print map(ord, data[2:])
		time.sleep(1)
	elif kind == MSG_PONG:
		print "YAAAAAY PONG\n" * 20
		time.sleep(0.05)
	else:
		print "wat %s %s %s %s" % (sz, kind, data, "".join(data))
		time.sleep(1)

def parse(data):
	if len(data) < 2:
		return [], data
	sz = ord(data[0])
	kind = ord(data[1])
	blksz = 2 + sz
	if len(data) < blksz:
		return [], data
	return data[:blksz], data[blksz:]

ser = serial.Serial(argv[1], 38400)
data = []

last = time.time()
ser.setTimeout(1)
while True:
	if time.time() - last > 2:
		print "timeout? data=%s %s" % (data, "".join(data))
	x = ser.read()
	if len(x):
		last = time.time()
		data.append(x)
		packet, data = parse(data)
		while packet:
			parse_packet(packet)
			packet, data = parse(data)
