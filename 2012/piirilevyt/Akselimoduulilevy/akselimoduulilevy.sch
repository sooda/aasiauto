EESchema Schematic File Version 2  date 15.10.2012 18:30:00
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:conn_16
LIBS:akselimoduulilevy-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "15 oct 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
NoConn ~ 1550 5400
NoConn ~ 1550 5300
$Comp
L CONN_16 elektroniikkaliitin1
U 1 1 507C2BC6
P 1200 4700
F 0 "elektroniikkaliitin1" V 1160 4700 60  0000 C CNN
F 1 "CONN_16" V 1280 4700 60  0000 C CNN
	1    1200 4700
	-1   0    0    -1  
$EndComp
NoConn ~ 1550 4900
Wire Wire Line
	7850 5900 7850 4700
Wire Wire Line
	7850 4700 1550 4700
Wire Wire Line
	8650 1750 8650 4800
Wire Wire Line
	8650 4800 1550 4800
Wire Wire Line
	9000 4400 9000 4800
Wire Wire Line
	9000 4400 1550 4400
Wire Wire Line
	9500 4300 9500 3650
Wire Wire Line
	9500 4300 1550 4300
Wire Wire Line
	3800 1700 3800 4000
Wire Wire Line
	3800 4000 1550 4000
Wire Wire Line
	3650 6550 3650 3900
Wire Wire Line
	3650 3900 1550 3900
Wire Wire Line
	10000 1400 10000 1700
Wire Wire Line
	1550 5200 1850 5200
Wire Wire Line
	9950 3450 9150 3450
Wire Wire Line
	5250 6150 5250 6550
Wire Wire Line
	4400 6600 4400 6150
Wire Wire Line
	4400 6150 4350 6150
Wire Wire Line
	9550 4700 9950 4700
Wire Wire Line
	9950 3550 9500 3550
Wire Wire Line
	6800 1750 6800 3050
Wire Wire Line
	3700 1700 3700 2600
Wire Wire Line
	4500 3300 4350 3300
Wire Wire Line
	4350 3300 4350 3200
Wire Wire Line
	7750 5600 7750 5900
Wire Wire Line
	1800 6450 1800 6600
Wire Wire Line
	1800 6600 1500 6600
Wire Wire Line
	8450 1750 8450 2000
Wire Wire Line
	6700 1750 6700 2000
Wire Wire Line
	5200 1700 5200 1950
Wire Wire Line
	3600 1700 3600 1950
Wire Wire Line
	1500 6800 1800 6800
Wire Wire Line
	1800 6800 1800 7050
Wire Wire Line
	7950 5900 7950 5700
Wire Wire Line
	7950 5700 8250 5700
Wire Wire Line
	8250 5700 8250 5900
Wire Wire Line
	4900 3600 4900 3800
Wire Wire Line
	3300 2900 3300 3100
Wire Wire Line
	2750 2500 2750 2600
Wire Wire Line
	2750 2600 2900 2600
Wire Wire Line
	6400 3350 6400 3550
Wire Wire Line
	5850 2950 5850 3050
Wire Wire Line
	5850 3050 6000 3050
Wire Wire Line
	8150 2900 8150 3100
Wire Wire Line
	7600 2500 7600 2600
Wire Wire Line
	7600 2600 7750 2600
Wire Wire Line
	5300 1700 5300 3300
Wire Wire Line
	8550 1750 8550 2600
Wire Wire Line
	9950 3850 9800 3850
Wire Wire Line
	9800 3850 9800 4000
Wire Wire Line
	9950 5000 9800 5000
Wire Wire Line
	9800 5000 9800 5150
Wire Wire Line
	3850 6150 3850 6550
Wire Wire Line
	5750 6150 5800 6150
Wire Wire Line
	5800 6150 5800 6600
Wire Wire Line
	9500 3650 9950 3650
Wire Wire Line
	9000 4800 9950 4800
Wire Wire Line
	10350 1500 10350 1650
Wire Wire Line
	9700 1400 9700 1700
Wire Wire Line
	1550 4100 5050 4100
Wire Wire Line
	5050 4100 5050 6550
Wire Wire Line
	1550 4200 5400 4200
Wire Wire Line
	5400 4200 5400 1700
Wire Wire Line
	1550 4500 9150 4500
Wire Wire Line
	9150 4500 9150 3450
Wire Wire Line
	9950 4600 1550 4600
Wire Wire Line
	1550 5000 6900 5000
Wire Wire Line
	6900 5000 6900 1750
NoConn ~ 1550 5100
Text Notes 3850 7450 0    60   ~ 0
Valkoisille ledeille 90 ohm\nPunaisille ledeille 145 ohm
$Comp
L PWR_FLAG #FLG01
U 1 1 50702905
P 10350 1500
F 0 "#FLG01" H 10350 1595 30  0001 C CNN
F 1 "PWR_FLAG" H 10350 1680 30  0000 C CNN
	1    10350 1500
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG02
U 1 1 50702903
P 10000 1700
F 0 "#FLG02" H 10000 1795 30  0001 C CNN
F 1 "PWR_FLAG" H 10000 1880 30  0000 C CNN
	1    10000 1700
	-1   0    0    1   
$EndComp
$Comp
L PWR_FLAG #FLG03
U 1 1 507028F2
P 9700 1700
F 0 "#FLG03" H 9700 1795 30  0001 C CNN
F 1 "PWR_FLAG" H 9700 1880 30  0000 C CNN
	1    9700 1700
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR04
U 1 1 507028EC
P 10350 1650
F 0 "#PWR04" H 10350 1650 30  0001 C CNN
F 1 "GND" H 10350 1580 30  0001 C CNN
	1    10350 1650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR05
U 1 1 507028EA
P 10000 1400
F 0 "#PWR05" H 10000 1490 20  0001 C CNN
F 1 "+5V" H 10000 1490 30  0000 C CNN
	1    10000 1400
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR06
U 1 1 507028E6
P 9700 1400
F 0 "#PWR06" H 9700 1370 20  0001 C CNN
F 1 "+8V" H 9700 1510 30  0000 C CNN
	1    9700 1400
	1    0    0    -1  
$EndComp
NoConn ~ 1950 1500
NoConn ~ 1650 1500
NoConn ~ 1350 1500
NoConn ~ 1050 1500
$Comp
L CONN_1 P6
U 1 1 50702892
P 1950 1350
F 0 "P6" H 2030 1350 40  0000 L CNN
F 1 "CONN_1" H 1950 1405 30  0001 C CNN
	1    1950 1350
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P5
U 1 1 50702890
P 1650 1350
F 0 "P5" H 1730 1350 40  0000 L CNN
F 1 "CONN_1" H 1650 1405 30  0001 C CNN
	1    1650 1350
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P4
U 1 1 5070288F
P 1350 1350
F 0 "P4" H 1430 1350 40  0000 L CNN
F 1 "CONN_1" H 1350 1405 30  0001 C CNN
	1    1350 1350
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P1
U 1 1 5070288A
P 1050 1350
F 0 "P1" H 1130 1350 40  0000 L CNN
F 1 "CONN_1" H 1050 1405 30  0001 C CNN
	1    1050 1350
	0    -1   -1   0   
$EndComp
$Comp
L R R2
U 1 1 507027E7
P 5500 6150
F 0 "R2" V 5580 6150 50  0000 C CNN
F 1 "R" V 5500 6150 50  0000 C CNN
	1    5500 6150
	0    -1   -1   0   
$EndComp
$Comp
L R R1
U 1 1 507027DF
P 4100 6150
F 0 "R1" V 4180 6150 50  0000 C CNN
F 1 "R" V 4100 6150 50  0000 C CNN
	1    4100 6150
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR07
U 1 1 507027A2
P 5800 6600
F 0 "#PWR07" H 5800 6600 30  0001 C CNN
F 1 "GND" H 5800 6530 30  0001 C CNN
	1    5800 6600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 507027A0
P 4400 6600
F 0 "#PWR08" H 4400 6600 30  0001 C CNN
F 1 "GND" H 4400 6530 30  0001 C CNN
	1    4400 6600
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 led2
U 1 1 50702542
P 5150 6900
F 0 "led2" V 5100 6900 40  0000 C CNN
F 1 "CONN_2" V 5200 6900 40  0000 C CNN
	1    5150 6900
	0    -1   1    0   
$EndComp
NoConn ~ 9950 4900
NoConn ~ 9950 3750
$Comp
L CONN_2 led1
U 1 1 50702356
P 3750 6900
F 0 "led1" V 3700 6900 40  0000 C CNN
F 1 "CONN_2" V 3800 6900 40  0000 C CNN
	1    3750 6900
	0    -1   1    0   
$EndComp
$Comp
L +5V #PWR09
U 1 1 5070225A
P 1850 5200
F 0 "#PWR09" H 1850 5290 20  0001 C CNN
F 1 "+5V" H 1850 5290 30  0000 C CNN
	1    1850 5200
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR010
U 1 1 50702223
P 9550 4700
F 0 "#PWR010" H 9550 4790 20  0001 C CNN
F 1 "+5V" H 9550 4790 30  0000 C CNN
	1    9550 4700
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR011
U 1 1 5070221D
P 9800 5150
F 0 "#PWR011" H 9800 5150 30  0001 C CNN
F 1 "GND" H 9800 5080 30  0001 C CNN
	1    9800 5150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR012
U 1 1 5070220B
P 9800 4000
F 0 "#PWR012" H 9800 4000 30  0001 C CNN
F 1 "GND" H 9800 3930 30  0001 C CNN
	1    9800 4000
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR013
U 1 1 50702200
P 9500 3550
F 0 "#PWR013" H 9500 3640 20  0001 C CNN
F 1 "+5V" H 9500 3640 30  0000 C CNN
	1    9500 3550
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR014
U 1 1 50702141
P 8150 3100
F 0 "#PWR014" H 8150 3100 30  0001 C CNN
F 1 "GND" H 8150 3030 30  0001 C CNN
	1    8150 3100
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR015
U 1 1 50702140
P 7600 2500
F 0 "#PWR015" H 7600 2470 20  0001 C CNN
F 1 "+8V" H 7600 2610 30  0000 C CNN
	1    7600 2500
	1    0    0    -1  
$EndComp
$Comp
L 7805 U4
U 1 1 5070213F
P 8150 2650
F 0 "U4" H 8300 2454 60  0000 C CNN
F 1 "7805" H 8150 2850 60  0000 C CNN
	1    8150 2650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR016
U 1 1 5070212C
P 6400 3550
F 0 "#PWR016" H 6400 3550 30  0001 C CNN
F 1 "GND" H 6400 3480 30  0001 C CNN
	1    6400 3550
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR017
U 1 1 5070212B
P 5850 2950
F 0 "#PWR017" H 5850 2920 20  0001 C CNN
F 1 "+8V" H 5850 3060 30  0000 C CNN
	1    5850 2950
	1    0    0    -1  
$EndComp
$Comp
L 7805 U3
U 1 1 5070212A
P 6400 3100
F 0 "U3" H 6550 2904 60  0000 C CNN
F 1 "7805" H 6400 3300 60  0000 C CNN
	1    6400 3100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR018
U 1 1 50702125
P 3300 3100
F 0 "#PWR018" H 3300 3100 30  0001 C CNN
F 1 "GND" H 3300 3030 30  0001 C CNN
	1    3300 3100
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR019
U 1 1 50702124
P 2750 2500
F 0 "#PWR019" H 2750 2470 20  0001 C CNN
F 1 "+8V" H 2750 2610 30  0000 C CNN
	1    2750 2500
	1    0    0    -1  
$EndComp
$Comp
L 7805 U1
U 1 1 50702123
P 3300 2650
F 0 "U1" H 3450 2454 60  0000 C CNN
F 1 "7805" H 3300 2850 60  0000 C CNN
	1    3300 2650
	1    0    0    -1  
$EndComp
$Comp
L 7805 U2
U 1 1 507020C1
P 4900 3350
F 0 "U2" H 5050 3154 60  0000 C CNN
F 1 "7805" H 4900 3550 60  0000 C CNN
	1    4900 3350
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR020
U 1 1 5070207E
P 4350 3200
F 0 "#PWR020" H 4350 3170 20  0001 C CNN
F 1 "+8V" H 4350 3310 30  0000 C CNN
	1    4350 3200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR021
U 1 1 50701FFE
P 4900 3800
F 0 "#PWR021" H 4900 3800 30  0001 C CNN
F 1 "GND" H 4900 3730 30  0001 C CNN
	1    4900 3800
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR022
U 1 1 50701DEE
P 1800 6450
F 0 "#PWR022" H 1800 6420 20  0001 C CNN
F 1 "+8V" H 1800 6560 30  0000 C CNN
	1    1800 6450
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR023
U 1 1 50701DC0
P 7750 5600
F 0 "#PWR023" H 7750 5690 20  0001 C CNN
F 1 "+5V" H 7750 5690 30  0000 C CNN
	1    7750 5600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR024
U 1 1 50701DA3
P 8250 5900
F 0 "#PWR024" H 8250 5900 30  0001 C CNN
F 1 "GND" H 8250 5830 30  0001 C CNN
	1    8250 5900
	1    0    0    -1  
$EndComp
$Comp
L CONN_3 potentiometer1
U 1 1 50701D6E
P 7850 6250
F 0 "potentiometer1" V 7800 6250 50  0000 C CNN
F 1 "CONN_3" V 7900 6250 40  0000 C CNN
	1    7850 6250
	0    -1   1    0   
$EndComp
$Comp
L CONN_5 right_encoder1
U 1 1 50701D4A
P 10350 4800
F 0 "right_encoder1" V 10300 4800 50  0000 C CNN
F 1 "CONN_5" V 10400 4800 50  0000 C CNN
	1    10350 4800
	1    0    0    -1  
$EndComp
$Comp
L CONN_5 left_encoder1
U 1 1 50701D46
P 10350 3650
F 0 "left_encoder1" V 10300 3650 50  0000 C CNN
F 1 "CONN_5" V 10400 3650 50  0000 C CNN
	1    10350 3650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR025
U 1 1 50701D0B
P 1800 7050
F 0 "#PWR025" H 1800 7050 30  0001 C CNN
F 1 "GND" H 1800 6980 30  0001 C CNN
	1    1800 7050
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 akkuliitin1
U 1 1 50701CFD
P 1150 6700
F 0 "akkuliitin1" V 1100 6700 40  0000 C CNN
F 1 "CONN_2" V 1200 6700 40  0000 C CNN
	1    1150 6700
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR026
U 1 1 50701C8A
P 8450 2000
F 0 "#PWR026" H 8450 2000 30  0001 C CNN
F 1 "GND" H 8450 1930 30  0001 C CNN
	1    8450 2000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR027
U 1 1 50701C86
P 6700 2000
F 0 "#PWR027" H 6700 2000 30  0001 C CNN
F 1 "GND" H 6700 1930 30  0001 C CNN
	1    6700 2000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR028
U 1 1 50701C83
P 5200 1950
F 0 "#PWR028" H 5200 1950 30  0001 C CNN
F 1 "GND" H 5200 1880 30  0001 C CNN
	1    5200 1950
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR029
U 1 1 50701C7B
P 3600 1950
F 0 "#PWR029" H 3600 1950 30  0001 C CNN
F 1 "GND" H 3600 1880 30  0001 C CNN
	1    3600 1950
	1    0    0    -1  
$EndComp
$Comp
L CONN_3 clutch_servo1
U 1 1 50701C23
P 8550 1400
F 0 "clutch_servo1" V 8500 1400 50  0000 C CNN
F 1 "CONN_3" V 8600 1400 40  0000 C CNN
	1    8550 1400
	0    -1   -1   0   
$EndComp
$Comp
L CONN_3 steering_servo1
U 1 1 50701C1E
P 6800 1400
F 0 "steering_servo1" V 6750 1400 50  0000 C CNN
F 1 "CONN_3" V 6850 1400 40  0000 C CNN
	1    6800 1400
	0    -1   -1   0   
$EndComp
$Comp
L CONN_3 right_brake_servo1
U 1 1 50701C0C
P 5300 1350
F 0 "right_brake_servo1" V 5250 1350 50  0000 C CNN
F 1 "CONN_3" V 5350 1350 40  0000 C CNN
	1    5300 1350
	0    -1   -1   0   
$EndComp
$Comp
L CONN_3 left_brake_servo1
U 1 1 50701BD2
P 3700 1350
F 0 "left_brake_servo1" V 3650 1350 50  0000 C CNN
F 1 "CONN_3" V 3750 1350 40  0000 C CNN
	1    3700 1350
	0    -1   -1   0   
$EndComp
$EndSCHEMATC
