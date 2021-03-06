""" HOX HOX
DO NOT READ THIS CODE
IT IS BAD
:(

last day hacks, quick tests and such.
python's serial or this script seems to malfunction somehow,
we go out of sync at some point but the gui does not
"""
import serial
from sys import argv
import struct
import time
import math

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
jj = 0

def parse_packet(data):
	global i, j, jj

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

			#ser.write("\xff\x08\x7a" + hax)

			jj += 1
			if jj == 10:
				jj = 0
				# steer
				hax = int(800 * math.sin(i / 100.0))
				print "hax",hax
				hax = struct.pack("<h", hax)
				#ser.write("\xff\x02\x79" + hax)
			i += 10
			#if i == 500:
			#	i = 0
	elif kind == MSG_ERR:
		print "YHYY MSGERR (id, sender, arg)"
		print "(id |= 128 if proxied (not used actually))"
		print map(ord, data[2:])
		time.sleep(1)
	elif kind == MSG_PONG:
		print "YAAAAAY PONG from %s" % data[2:]
		time.sleep(0.05) # user actually sees it, almost
		# keep them alive
		ser.write("\xff\x00\x00")
	else:
		print "wat %s %s %s %s" % (sz, kind, data, "".join(data))
		print consumed
		time.sleep(5.2)
		while True:
			x = ser.read()
			print list(x)
			if len(x) == 0:
				break

def parse(data):
	global consumed
	if len(data) < 2:
		return [], data
	sz = ord(data[0])
	kind = ord(data[1])
	blksz = 2 + sz
	if len(data) < blksz:
		return [], data
	consumed = consumed + blksz
	return data[:blksz], data[blksz:]

def main():
	if argv[1].startswith("/dev"):
		feed_serial(argv[1])
	else:
		feed_log(argv[1])

class fakeser():
	def write(self, x):
		pass

	def read(self):
		return []

def feed_log(filename):
	global ser
	global consumed
	consumed = 0
	ser = fakeser()
	data = list(open(filename, "rb").read())
	packet, data = parse(data)
	while packet:
		parse_packet(packet)
		packet, data = parse(data)

def feed_serial(sername):
	global ser
	global consumed
	consumed=0
	ser = serial.Serial(sername, 38400)
	ser.setTimeout(0.1)

	print "init flush"
	xx = []
	x = ser.read(1)
	while x != "":
		xx.append(x)
		x = ser.read(1)
	print "flushed: %s" % xx

	time.sleep(2)
	print "init send"
	if ser.write("\xff\x00\x00") != 3:
		print 1/0
	data = []

	last = time.time()
	logfile = open("measdisp.log", "w")
	while True:
		if time.time() - last > 2:
			print "timeout? data=%s %s" % (data, "".join(data))
			print "init send"
			if ser.write("\xff\x00\x00") != 3:
				print 1/0
		#print "read..."
		x = ser.read()
		logfile.write(x)
		logfile.flush() # would ^C lose data without this?
		if len(x):
			#print "got %s" % list(x)
			last = time.time()
			data.append(x)
			if len(data) > 100:
				print "bad? %s" % data
			packet, data = parse(data)
			while packet:
				parse_packet(packet)
				packet, data = parse(data)

if __name__ == "__main__":
	main()

