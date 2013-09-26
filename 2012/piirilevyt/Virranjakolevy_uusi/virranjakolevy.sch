EESchema Schematic File Version 2  date 4.11.2012 20:43:41
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
LIBS:virranjakolevy-cache
EELAYER 25  0
EELAYER END
$Descr A4 11700 8267
encoding utf-8
Sheet 1 1
Title ""
Date "4 nov 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L +12V #PWR01
U 1 1 507C09C1
P 6900 1500
F 0 "#PWR01" H 6900 1450 20  0001 C CNN
F 1 "+12V" H 6900 1600 30  0000 C CNN
	1    6900 1500
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR02
U 1 1 507C09B9
P 3800 3350
F 0 "#PWR02" H 3800 3300 20  0001 C CNN
F 1 "+12V" H 3800 3450 30  0000 C CNN
	1    3800 3350
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR03
U 1 1 507C09B3
P 3050 3600
F 0 "#PWR03" H 3050 3550 20  0001 C CNN
F 1 "+12V" H 3050 3700 30  0000 C CNN
	1    3050 3600
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR04
U 1 1 507C09B0
P 3550 1750
F 0 "#PWR04" H 3550 1700 20  0001 C CNN
F 1 "+12V" H 3550 1850 30  0000 C CNN
	1    3550 1750
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 ele_supply1
U 1 1 507C0960
P 4950 1750
F 0 "ele_supply1" V 4900 1750 40  0000 C CNN
F 1 "CONN_2" V 5000 1750 40  0000 C CNN
	1    4950 1750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4850 2100 4850 2400
Wire Wire Line
	4850 2400 4450 2400
Wire Wire Line
	6050 2100 6050 2400
Wire Wire Line
	7700 2950 5750 2950
Wire Wire Line
	5750 2950 5750 2100
Wire Wire Line
	7750 3900 7400 3900
Wire Wire Line
	7400 3050 7700 3050
Wire Wire Line
	5550 2100 5550 3150
Wire Wire Line
	5550 3150 4850 3150
Wire Wire Line
	1900 1550 1900 1750
Wire Wire Line
	1450 1550 1450 1750
Wire Wire Line
	10000 3850 9750 3850
Wire Wire Line
	9400 2600 9100 2600
Wire Wire Line
	3550 1750 3550 2400
Wire Wire Line
	3550 2400 3950 2400
Wire Wire Line
	7450 1550 7450 1950
Connection ~ 6650 5150
Wire Wire Line
	6650 5150 6650 3150
Wire Wire Line
	7450 5600 7450 5150
Wire Wire Line
	7450 5150 7300 5150
Wire Wire Line
	5950 5150 5600 5150
Wire Wire Line
	5600 5150 5600 4850
Wire Wire Line
	5050 3800 4700 3800
Wire Wire Line
	9050 3700 9050 3850
Wire Wire Line
	9600 4550 9600 4050
Wire Wire Line
	9600 4050 10000 4050
Wire Wire Line
	3050 3600 3050 3850
Wire Wire Line
	3050 3850 2750 3850
Wire Wire Line
	3200 5500 3200 5200
Wire Wire Line
	3200 5200 2750 5200
Wire Wire Line
	2750 5000 3200 5000
Wire Wire Line
	3200 5000 3200 4850
Wire Wire Line
	2750 4050 3050 4050
Wire Wire Line
	3050 4050 3050 4350
Wire Wire Line
	10150 2800 9600 2800
Wire Wire Line
	9600 2800 9600 3300
Wire Wire Line
	9100 2600 9100 2250
Wire Wire Line
	3800 3350 3800 3800
Wire Wire Line
	3800 3800 4200 3800
Wire Wire Line
	5550 3800 5800 3800
Wire Wire Line
	5800 3800 5800 4250
Wire Wire Line
	6800 5150 6450 5150
Wire Wire Line
	4850 3150 4850 3800
Connection ~ 4850 3800
Wire Wire Line
	6900 1500 6900 1950
Wire Wire Line
	8250 1600 8250 2000
Wire Wire Line
	9900 2600 10150 2600
Wire Wire Line
	9050 3850 9250 3850
Wire Wire Line
	1700 1550 1700 1750
Wire Wire Line
	2100 1550 2100 1750
Wire Wire Line
	6650 3150 5650 3150
Wire Wire Line
	5650 3150 5650 2100
Wire Wire Line
	7700 3150 7550 3150
Wire Wire Line
	7550 3150 7550 3400
Wire Wire Line
	7750 4000 7550 4000
Wire Wire Line
	7550 4000 7550 4300
Wire Wire Line
	5850 2100 5850 2850
Wire Wire Line
	5850 2850 6950 2850
Wire Wire Line
	6950 2850 6950 3800
Wire Wire Line
	6950 3800 7750 3800
Wire Wire Line
	7900 1950 7900 1550
Wire Wire Line
	5050 2100 5050 2700
$Comp
L PWR_FLAG #FLG05
U 1 1 50703459
P 7900 1950
F 0 "#FLG05" H 7900 2045 30  0001 C CNN
F 1 "PWR_FLAG" H 7900 2130 30  0000 C CNN
	1    7900 1950
	-1   0    0    1   
$EndComp
$Comp
L +5V #PWR06
U 1 1 50703449
P 7900 1550
F 0 "#PWR06" H 7900 1640 20  0001 C CNN
F 1 "+5V" H 7900 1640 30  0000 C CNN
	1    7900 1550
	1    0    0    -1  
$EndComp
NoConn ~ 5950 2100
$Comp
L +5V #PWR07
U 1 1 507033BE
P 6050 2400
F 0 "#PWR07" H 6050 2490 20  0001 C CNN
F 1 "+5V" H 6050 2490 30  0000 C CNN
	1    6050 2400
	-1   0    0    1   
$EndComp
$Comp
L +5V #PWR08
U 1 1 50703398
P 7400 3900
F 0 "#PWR08" H 7400 3990 20  0001 C CNN
F 1 "+5V" H 7400 3990 30  0000 C CNN
	1    7400 3900
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR09
U 1 1 5070338E
P 7400 3050
F 0 "#PWR09" H 7400 3140 20  0001 C CNN
F 1 "+5V" H 7400 3140 30  0000 C CNN
	1    7400 3050
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR010
U 1 1 50703382
P 7550 3400
F 0 "#PWR010" H 7550 3400 30  0001 C CNN
F 1 "GND" H 7550 3330 30  0001 C CNN
	1    7550 3400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR011
U 1 1 5070337F
P 7550 4300
F 0 "#PWR011" H 7550 4300 30  0001 C CNN
F 1 "GND" H 7550 4230 30  0001 C CNN
	1    7550 4300
	1    0    0    -1  
$EndComp
$Comp
L CONN_3 motor_driver2
U 1 1 50703330
P 8100 3900
F 0 "motor_driver2" V 8050 3900 50  0000 C CNN
F 1 "CONN_3" V 8150 3900 40  0000 C CNN
	1    8100 3900
	1    0    0    1   
$EndComp
$Comp
L CONN_3 motor_driver1
U 1 1 507032FB
P 8050 3050
F 0 "motor_driver1" V 8000 3050 50  0000 C CNN
F 1 "CONN_3" V 8100 3050 40  0000 C CNN
	1    8050 3050
	1    0    0    1   
$EndComp
$Comp
L CONN_6 data_conn1
U 1 1 5070322F
P 5800 1750
F 0 "data_conn1" V 5750 1750 60  0000 C CNN
F 1 "CONN_6" V 5850 1750 60  0000 C CNN
	1    5800 1750
	0    -1   -1   0   
$EndComp
NoConn ~ 2100 1750
NoConn ~ 1900 1750
NoConn ~ 1700 1750
NoConn ~ 1450 1750
$Comp
L CONN_1 P4
U 1 1 507003F1
P 2100 1400
F 0 "P4" H 2180 1400 40  0000 L CNN
F 1 "CONN_1" H 2100 1455 30  0001 C CNN
	1    2100 1400
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P3
U 1 1 507003EF
P 1900 1400
F 0 "P3" H 1980 1400 40  0000 L CNN
F 1 "CONN_1" H 1900 1455 30  0001 C CNN
	1    1900 1400
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P2
U 1 1 507003EE
P 1700 1400
F 0 "P2" H 1780 1400 40  0000 L CNN
F 1 "CONN_1" H 1700 1455 30  0001 C CNN
	1    1700 1400
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 P1
U 1 1 507003E5
P 1450 1400
F 0 "P1" H 1530 1400 40  0000 L CNN
F 1 "CONN_1" H 1450 1455 30  0001 C CNN
	1    1450 1400
	0    -1   -1   0   
$EndComp
$Comp
L FUSE rearservofuse1
U 1 1 506F1286
P 9500 3850
F 0 "rearservofuse1" H 9600 3900 40  0000 C CNN
F 1 "FUSE" H 9400 3800 40  0000 C CNN
	1    9500 3850
	1    0    0    -1  
$EndComp
$Comp
L FUSE frontservofuse1
U 1 1 506F1283
P 9650 2600
F 0 "frontservofuse1" H 9750 2650 40  0000 C CNN
F 1 "FUSE" H 9550 2550 40  0000 C CNN
	1    9650 2600
	1    0    0    -1  
$EndComp
$Comp
L FUSE elefuse1
U 1 1 506F127C
P 4200 2400
F 0 "elefuse1" H 4300 2450 40  0000 C CNN
F 1 "FUSE" H 4100 2350 40  0000 C CNN
	1    4200 2400
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG012
U 1 1 506F0410
P 8250 1600
F 0 "#FLG012" H 8250 1695 30  0001 C CNN
F 1 "PWR_FLAG" H 8250 1780 30  0000 C CNN
	1    8250 1600
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG013
U 1 1 506F040D
P 7450 1950
F 0 "#FLG013" H 7450 2045 30  0001 C CNN
F 1 "PWR_FLAG" H 7450 2130 30  0000 C CNN
	1    7450 1950
	-1   0    0    1   
$EndComp
$Comp
L PWR_FLAG #FLG014
U 1 1 506F0408
P 6900 1950
F 0 "#FLG014" H 6900 2045 30  0001 C CNN
F 1 "PWR_FLAG" H 6900 2130 30  0000 C CNN
	1    6900 1950
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR015
U 1 1 506F03F3
P 8250 2000
F 0 "#PWR015" H 8250 2000 30  0001 C CNN
F 1 "GND" H 8250 1930 30  0001 C CNN
	1    8250 2000
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR016
U 1 1 506F03F0
P 7450 1550
F 0 "#PWR016" H 7450 1520 20  0001 C CNN
F 1 "+8V" H 7450 1660 30  0000 C CNN
	1    7450 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR017
U 1 1 506F0390
P 7450 5600
F 0 "#PWR017" H 7450 5600 30  0001 C CNN
F 1 "GND" H 7450 5530 30  0001 C CNN
	1    7450 5600
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR018
U 1 1 506F038C
P 5600 4850
F 0 "#PWR018" H 5600 4820 20  0001 C CNN
F 1 "+8V" H 5600 4960 30  0000 C CNN
	1    5600 4850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR019
U 1 1 506F037D
P 5800 4250
F 0 "#PWR019" H 5800 4250 30  0001 C CNN
F 1 "GND" H 5800 4180 30  0001 C CNN
	1    5800 4250
	1    0    0    -1  
$EndComp
$Comp
L R R_motor2
U 1 1 506F0369
P 7050 5150
F 0 "R_motor2" V 7130 5150 50  0000 C CNN
F 1 "22k" V 7050 5150 50  0000 C CNN
	1    7050 5150
	0    -1   -1   0   
$EndComp
$Comp
L R R_motor1
U 1 1 506F0366
P 6200 5150
F 0 "R_motor1" V 6280 5150 50  0000 C CNN
F 1 "15k" V 6200 5150 50  0000 C CNN
	1    6200 5150
	0    -1   -1   0   
$EndComp
$Comp
L R R_ele2
U 1 1 506F034B
P 5300 3800
F 0 "R_ele2" V 5380 3800 50  0000 C CNN
F 1 "20k" V 5300 3800 50  0000 C CNN
	1    5300 3800
	0    -1   -1   0   
$EndComp
$Comp
L R R_ele1
U 1 1 506F0344
P 4450 3800
F 0 "R_ele1" V 4530 3800 50  0000 C CNN
F 1 "30k" V 4450 3800 50  0000 C CNN
	1    4450 3800
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR020
U 1 1 506F02F0
P 5050 2700
F 0 "#PWR020" H 5050 2700 30  0001 C CNN
F 1 "GND" H 5050 2630 30  0001 C CNN
	1    5050 2700
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR021
U 1 1 506F02B5
P 9100 2250
F 0 "#PWR021" H 9100 2220 20  0001 C CNN
F 1 "+8V" H 9100 2360 30  0000 C CNN
	1    9100 2250
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR022
U 1 1 506F02B1
P 9050 3700
F 0 "#PWR022" H 9050 3670 20  0001 C CNN
F 1 "+8V" H 9050 3810 30  0000 C CNN
	1    9050 3700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR023
U 1 1 506F027B
P 9600 3300
F 0 "#PWR023" H 9600 3300 30  0001 C CNN
F 1 "GND" H 9600 3230 30  0001 C CNN
	1    9600 3300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR024
U 1 1 506F0279
P 9600 4550
F 0 "#PWR024" H 9600 4550 30  0001 C CNN
F 1 "GND" H 9600 4480 30  0001 C CNN
	1    9600 4550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR025
U 1 1 506F024A
P 3050 4350
F 0 "#PWR025" H 3050 4350 30  0001 C CNN
F 1 "GND" H 3050 4280 30  0001 C CNN
	1    3050 4350
	1    0    0    -1  
$EndComp
$Comp
L +8V #PWR026
U 1 1 506F020D
P 3200 4850
F 0 "#PWR026" H 3200 4820 20  0001 C CNN
F 1 "+8V" H 3200 4960 30  0000 C CNN
	1    3200 4850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR027
U 1 1 506F0147
P 3200 5500
F 0 "#PWR027" H 3200 5500 30  0001 C CNN
F 1 "GND" H 3200 5430 30  0001 C CNN
	1    3200 5500
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 rear_servos1
U 1 1 506EFF93
P 10350 3950
F 0 "rear_servos1" V 10300 3950 40  0000 C CNN
F 1 "CONN_2" V 10400 3950 40  0000 C CNN
	1    10350 3950
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 front_servos1
U 1 1 506EFF90
P 10500 2700
F 0 "front_servos1" V 10450 2700 40  0000 C CNN
F 1 "CONN_2" V 10550 2700 40  0000 C CNN
	1    10500 2700
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 motor_battery1
U 1 1 506EFF8B
P 2400 5100
F 0 "motor_battery1" V 2350 5100 40  0000 C CNN
F 1 "CONN_2" V 2450 5100 40  0000 C CNN
	1    2400 5100
	-1   0    0    -1  
$EndComp
$Comp
L CONN_2 controller_battery1
U 1 1 506EFF0F
P 2400 3950
F 0 "controller_battery1" V 2350 3950 40  0000 C CNN
F 1 "CONN_2" V 2450 3950 40  0000 C CNN
	1    2400 3950
	-1   0    0    -1  
$EndComp
$EndSCHEMATC
