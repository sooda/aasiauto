import serial
from sys import argv
import struct
import time

MSG_CAR_MEAS_VECTOR = 110
MEAS_NITEMS = 12

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

def parse_packet(data):
	sz = ord(data[0])
	kind = ord(data[1])
	if kind == MSG_CAR_MEAS_VECTOR:
		nums = struct.unpack("<" + "H" * MEAS_NITEMS, "".join(data[2:]))
		print "\n".join("%s:\t%d" % t for t in zip(MEASNAMES, nums))
	else:
		print "wat %s %s" % (sz, kind)
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

while True:
	x = ser.read()
	data.append(x)
	packet, data = parse(data)
	while packet:
		parse_packet(packet)
		packet, data = parse(data)
