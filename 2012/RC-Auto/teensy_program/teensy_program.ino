//This is the program for the Teensy


// Definition of interrupt names
#include < avr/io.h >
// ISR interrupt service routine
#include < avr/interrupt.h >


// This line defines a "Uart" object to access the serial port
HardwareSerial Uart = HardwareSerial();


// Char value needed for the sending function
unsigned char zero = 0x00;

//Muuttuja joka laskee ohjelman syklin
int program_phase = 1;
//Flag for running the main program
boolean main_program_flag = false;

//Variables for storing the speed
unsigned char left_front_speed = 0;
unsigned char right_front_speed = 0;
unsigned char left_rear_speed = 0;
unsigned char right_rear_speed = 0;
//Variables for storing the old speeds -> filtering
unsigned char left_front_speed_1 = 0;
unsigned char right_front_speed_1 = 0;
unsigned char left_rear_speed_1 = 0;
unsigned char right_rear_speed_1 = 0;
unsigned char left_front_speed_2 = 0;
unsigned char right_front_speed_2 = 0;
unsigned char left_rear_speed_2 = 0;
unsigned char right_rear_speed_2 = 0;
//Variables for the filtered speed
unsigned char left_front_speed_filtered = 0;
unsigned char right_front_speed_filtered = 0;
unsigned char left_rear_speed_filtered = 0;
unsigned char right_rear_speed_filtered = 0;


//Variables for counting the speed
unsigned char left_front_pulses = 0;
unsigned char right_front_pulses = 0;
unsigned char left_rear_pulses = 0;
unsigned char right_rear_pulses = 0;

void setup(){
  
  delay(3000); //Wait 3 seconds, to make sure the brake controller starts, before Teensy starts sending data
  
  //set pins as outputs
  pinMode(6, OUTPUT); //Built in led
  
  
  //Serial.begin(9600);
  Uart.begin(38400); //Start the serial connection with the brake controller

  cli();//stop interrupts
  
  
  // This code makes the timer0 give an interrupt every 1 ms
  
  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: 250,000 kHz
  // Mode: CTC top=OCR0A
  // OC0A output: Disconnected
  // OC0B output: Disconnected
  // Timer Period: 1 ms
  TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (0<<WGM00);
  TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (1<<CS00);
  TCNT0=0x00;
  OCR0A=0xF9;
  OCR0B=0x00;
  //Enable timer compare interrupt
  TIMSK0 |= (1 << OCIE0A);
  
  
  
  
  
  // External Interrupt(s) initialization
  // INT0: On
  // INT0 Mode: Rising Edge
  // INT1: On
  // INT1 Mode: Rising Edge
  // INT2: Off
  // INT3: Off
  // INT4: Off
  // INT5: Off
  // INT6: On
  // INT6 Mode: Rising Edge
  // INT7: On
  // INT7 Mode: Rising Edge
  EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (1<<ISC11) | (1<<ISC10) | (1<<ISC01) | (1<<ISC00);
  EICRB=(1<<ISC71) | (1<<ISC70) | (1<<ISC61) | (1<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
  EIMSK=(1<<INT7) | (1<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (1<<INT1) | (1<<INT0);
  EIFR=(1<<INTF7) | (1<<INTF6) | (0<<INTF5) | (0<<INTF4) | (0<<INTF3) | (0<<INTF2) | (1<<INTF1) | (1<<INTF0);
  // PCINT0 interrupt: Off
  // PCINT1 interrupt: Off
  // PCINT2 interrupt: Off
  // PCINT3 interrupt: Off
  // PCINT4 interrupt: Off
  // PCINT5 interrupt: Off
  // PCINT6 interrupt: Off
  // PCINT7 interrupt: Off
  PCMSK0=(0<<PCINT7) | (0<<PCINT6) | (0<<PCINT5) | (0<<PCINT4) | (0<<PCINT3) | (0<<PCINT2) | (0<<PCINT1) | (0<<PCINT0);
  PCICR=(0<<PCIE0);

  
  sei();//allow interrupts
  
  
  digitalWrite(6, LOW);
 
}//end setup


//The Timer0 Interrupt service routine
//Will be executed every 1 ms
ISR(TIMER0_COMPA_vect){
  if (program_phase == 10){ //This number corresponds to how many milliseconds each cycle takes
    program_phase = 1;  
    //raise the flag for running the main program
    main_program_flag = true;
  } else {
    program_phase += 1;
  }
}




// The srevice routine for interrupt 0 (front left)
ISR(INT0_vect) {
  left_front_pulses++;
}

// The srevice routine for interrupt 1 (front right)
ISR(INT1_vect) {
  right_front_pulses++;
}


// The srevice routine for interrupt 6 (left rear)
ISR(INT6_vect) {
  left_rear_pulses++;
}

// The srevice routine for interrupt 7 (right rear)
ISR(INT7_vect) {
  right_rear_pulses++;
}




void sendByte(unsigned char byteToSend){
  if (byteToSend == 0xFF){
    Uart.write(0xFF);
    Uart.write(zero);
  } else {
    Uart.write(byteToSend);
  }
}


void loop(){
  if (main_program_flag == true){ //When executing the program once every 10 ms
    main_program_flag = false; //Lower the flag not to repeat the function
    
   
    //Blink the built in led to see that the program is running
    PORTD ^= B01000000;
    
    //Update the old speeds
    left_front_speed_2 = left_front_speed_1;
    right_front_speed_2 = right_front_speed_1;
    left_rear_speed_2 = left_rear_speed_1;
    right_rear_speed_2 = right_rear_speed_1;
    
    left_front_speed_1 = left_front_speed;
    right_front_speed_1 = right_front_speed;
    left_rear_speed_1 = left_rear_speed;
    right_rear_speed_1 = right_rear_speed;

    
    
    //Store the values from the encoders, and reset the encoders
    left_front_speed = left_front_pulses;
    left_front_pulses = 0;
    right_front_speed = right_front_pulses;
    right_front_pulses = 0;
    left_rear_speed = left_rear_pulses;
    left_rear_pulses = 0;
    right_rear_speed = right_rear_pulses;
    right_rear_pulses = 0;
    
    
    //Filter the speed values
    left_front_speed_filtered = ((int)left_front_speed + (int)left_front_speed_1 + (int)left_front_speed_2)/3;
    right_front_speed_filtered = ((int)right_front_speed + (int)right_front_speed_1 + (int)right_front_speed_2)/3;
    left_rear_speed_filtered = ((int)left_rear_speed + (int)left_rear_speed_1 + (int)left_rear_speed_2)/3;
    right_rear_speed_filtered = ((int)right_rear_speed + (int)right_rear_speed_1 + (int)right_rear_speed_2)/3;
 
    //Send the data
    Uart.write(0xFF); //Start command
    Uart.write(0x10); //Message ID
    sendByte(left_front_speed_filtered);
    sendByte(right_front_speed_filtered);
    sendByte(left_rear_speed_filtered);
    sendByte(right_rear_speed_filtered);
    
   
  }
}



