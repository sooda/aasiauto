//This is the program for the main controller


//Variable for counting the phase of the program
int program_phase = 1;
//Flag for running the main program
boolean main_program_flag = false;
//Variable telling if the motor battery is not empty
boolean motor_battery_ok = true;
//Variable telling if any parameters have been sent during this cycle
boolean parameters_sent = false;


// Char value needed for the sending function
unsigned char zero = 0x00;

//Variables for receiving the serial messages
unsigned char rx0_msg_id = 0;
unsigned char rx1_msg_id = 0;
unsigned char rx0_counter = 0;
unsigned char rx1_counter = 0;
unsigned char rx0_received_byte = 0;
unsigned char rx1_received_byte = 0;


//Variables coming from the computer
unsigned char throttle = 0;
unsigned char steering_direction = 128;
unsigned char brake_force = 0;
unsigned char clutch = 0;
unsigned char driving_direction = 0;
//Variables to send forward to the brake controller
unsigned char brake_parameter_keynumber = 0;
unsigned char brake_parameter_highbyte = 0;
unsigned char brake_parameter_lowbyte = 0;

//Variables coming from the brake controller
unsigned char left_front_speed = 0;
unsigned char right_front_speed = 0;
unsigned char left_rear_speed = 0;
unsigned char right_rear_speed = 0;
unsigned char x_acc_highbyte = 0;
unsigned char x_acc_lowbyte = 0;
unsigned char y_acc_highbyte = 0;
unsigned char y_acc_lowbyte = 0;
unsigned char z_acc_highbyte = 0;
unsigned char z_acc_lowbyte = 0;
unsigned char x_gyro_highbyte = 0;
unsigned char x_gyro_lowbyte = 0;
unsigned char y_gyro_highbyte = 0;
unsigned char y_gyro_lowbyte = 0;
unsigned char z_gyro_highbyte = 0;
unsigned char z_gyro_lowbyte = 0;

//Measured variables
unsigned char steering_potentiometer = 0;
unsigned char motor_battery_state = 0;
unsigned char electronics_battery_state = 0;

//Counter for counting cycles without contact with the computer
unsigned char communication_counter = 0;
//Counter for only sending updates to the computer every x:th cycle
unsigned char sending_counter = 0;
//Variable for counting the time the buzzer is on
unsigned char buzzer_counter = 11; // (buzzer is on when counter <= 10)


//Other variables
int left_motor_speed = 1500;
int right_motor_speed = 1500;






void setup(){
  
  //set pins as outputs
  pinMode(13, OUTPUT); //Built in led
  pinMode(22, OUTPUT); //Headlights
  pinMode(23, OUTPUT); //Headlights
  pinMode(24, OUTPUT); //Blue led
  
  
  pinMode(11, OUTPUT); //Left motor
  pinMode(12, OUTPUT); //Right motor
  pinMode(5, OUTPUT); //Steering servo
  pinMode(2, OUTPUT); //Clutch servo
  
  pinMode(32, OUTPUT); //Motor battery green led
  pinMode(33, OUTPUT); //Motor battery yellow led
  pinMode(34, OUTPUT); //Motor battery red led
  pinMode(35, OUTPUT); //Electronics battery green led
  pinMode(36, OUTPUT); //Electronics battery yellow led
  pinMode(37, OUTPUT); //Electronics battery red led
  
  pinMode(41, OUTPUT); //Buzzer
  
  Serial.begin(38400); //Start serial communication with the computer
  Serial1.begin(38400); //Start serial communication with the brake controller

  cli();//stop interrupts
  
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
  
  
  //Settings for Timer 1 to give out PWM
  TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
  TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
  TCNT1H=0x00;
  TCNT1L=0x00;
  ICR1H=0x4E;
  ICR1L=0x20;
  OCR1AH=0x05;
  OCR1AL=0xDC;
  OCR1BH=0x05;
  OCR1BL=0xDC;
  OCR1CH=0x00;
  OCR1CL=0x00;  
  //Settings for Timer 3 to give out PWM
  TCCR3A=(1<<COM3A1) | (0<<COM3A0) | (1<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
  TCCR3B=(0<<ICNC3) | (0<<ICES3) | (1<<WGM33) | (0<<WGM32) | (0<<CS32) | (1<<CS31) | (0<<CS30);
  TCNT3H=0x00;
  TCNT3L=0x00;
  ICR3H=0x4E;
  ICR3L=0x20;
  OCR3AH=0x05;
  OCR3AL=0xDC;
  OCR3BH=0x05;
  OCR3BL=0xDC;
  OCR3CH=0x00;
  OCR3CL=0x00;
  
  sei();//allow interrupts
  
  //Turn on the headlights (A0 and A1)
  PORTA |= B00000011;

}//end setup


//The Timer0 Interrupt service routine
//Will be executed every 1 ms
ISR(TIMER0_COMPA_vect){
  if (program_phase == 10){ //This number corresponds to the number of milliseconds the cycle takes
    program_phase = 1;  
    //raise the flag for running the main program
    main_program_flag = true;
  } else {
    program_phase += 1;
  }
}


//Function for updating the motors
void update_motors(){  
  if (motor_battery_ok == false){ //Don't spin the motors, if the battery is empty
    //throttle = 0; //Commented during debug 
  }
  OCR1A = 1500 + (2 - 4 * driving_direction) * throttle + (steering_direction - 128) * throttle / 200;
  OCR1B = 1500 + (2 - 4 * driving_direction) * throttle - (steering_direction - 128) * throttle / 200; 
}

//Function for updating the servos
void update_servos(){ 
  OCR3A = 1200 + 2.9 * steering_direction;
  
  //Open the clutch if we get a command for it, or if the brakes are on
  if(clutch == 1 || brake_force > 0){
    OCR3B = 2000;
  }else{
    OCR3B = 1000;
  }
  
}



//Function for sending one byte to the computer
void sendByteUart0 (unsigned char byteToSend){
  if (byteToSend == 0xFF){
    Serial.write(0xFF);
    Serial.write(zero);
  } else {
    Serial.write(byteToSend);
  }
}

//Function for sending the data to the computer
void send_uart0(unsigned char tx0_msg_id){
  Serial.write(0xFF); //Start command
  Serial.write(tx0_msg_id); //Message ID
  
  if (tx0_msg_id == 0x30){
    sendByteUart0(left_front_speed);
    sendByteUart0(right_front_speed);
    sendByteUart0(left_rear_speed);
    sendByteUart0(right_rear_speed);
    sendByteUart0(x_acc_highbyte);
    sendByteUart0(x_acc_lowbyte);
    sendByteUart0(y_acc_highbyte);
    sendByteUart0(y_acc_lowbyte);
    sendByteUart0(z_acc_highbyte);
    sendByteUart0(z_acc_lowbyte);
    sendByteUart0(x_gyro_highbyte);
    sendByteUart0(x_gyro_lowbyte);
    sendByteUart0(y_gyro_highbyte);
    sendByteUart0(y_gyro_lowbyte);
    sendByteUart0(z_gyro_highbyte);
    sendByteUart0(z_gyro_lowbyte);
    sendByteUart0(steering_potentiometer);
    sendByteUart0(motor_battery_state);
    sendByteUart0(electronics_battery_state); //These are commented for helping debugging
  } else if (tx0_msg_id == 0x34){        
    sendByteUart0(brake_parameter_keynumber);
    sendByteUart0(brake_parameter_highbyte);
    sendByteUart0(brake_parameter_lowbyte);
  }
  
  
}

//Function for sending one byte to the brake controller
void sendByteUart1 (unsigned char byteToSend){
  if (byteToSend == 0xFF){
    Serial1.write(0xFF);
    Serial1.write(zero);
  } else {
    Serial1.write(byteToSend);
  }
}

//Function for sending the data to the brake controller
void send_uart1(unsigned char tx1_msg_id){
  Serial1.write(0xFF); //Start command
  Serial1.write(tx1_msg_id); //Message ID
  
  if (tx1_msg_id == 0x31){
    sendByteUart1(brake_force);
    sendByteUart1(steering_direction);
  } else if (tx1_msg_id == 0x32){
    sendByteUart1(brake_parameter_keynumber);
    sendByteUart1(brake_parameter_highbyte);
    sendByteUart1(brake_parameter_lowbyte);
  } else if (tx1_msg_id == 0x33){
    sendByteUart1(255);
  }
}


//Function for reading the serial bus from the computer
void read_uart0(){
  while (Serial.available() > 0){ //Loop this as long as there is data in the buffer
    rx0_counter += 1; //Count which byte we're reading
    rx0_received_byte = Serial.read(); //Pick the first byte from the buffer
  
    if (rx0_received_byte == 0xFF){ //Check if it's maybe a new message
      rx0_received_byte = Serial.read(); //Pick the next byte to see what is following
      if (rx0_received_byte != zero){ //If it's a new message
        rx0_msg_id = rx0_received_byte; //Store the message id
        rx0_counter = 0; //Reset the counter, not to place the current byte (msg_id) in any variable
        communication_counter = 0; //Reset the communication counter, as long as there is contact with the computer
      } else { //If it was FF + 00, meaning a data byte FF
        rx0_received_byte = 0xFF;
      } 
    }

    if(rx0_msg_id == 0x41){ //Normal status update from the computer
      switch (rx0_counter) {
        case 1:
          throttle = rx0_received_byte;
          break;
        case 2:
          steering_direction = rx0_received_byte;
          break;
        case 3:
          brake_force = rx0_received_byte;
          break;
        case 4:
          clutch = rx0_received_byte;
          break;
        case 5:
          driving_direction = rx0_received_byte;
          break; 
      }   
    }
    
    if(rx0_msg_id == 0x42){ //New parameter to the brake controller
      switch (rx0_counter) {
        case 1:
          brake_parameter_keynumber = rx0_received_byte;
          break;
        case 2:
          brake_parameter_highbyte = rx0_received_byte;
          break;
        case 3:
          brake_parameter_lowbyte = rx0_received_byte;
          send_uart1(0x32);
          break;
      }   
    }

    if(rx0_msg_id == 0x43){ //The computer wants to get the parameters from the brake controller
      if (rx0_counter == 0){
         send_uart1(0x33);
      }
    }
    
    if(rx0_msg_id == 0x44){ //Turn on the buzzer
      if (rx0_counter == 0){
         buzzer_counter = 0; //Reset the buzzer counter
      }
    }
    
  }
  
  
}


//Function for reading the serial bus from the brake controller
void read_uart1(){
  while (Serial1.available() > 0){ //Loop this as long as there is data in the buffer
    rx1_counter += 1; //Count which byte we're reading
    rx1_received_byte = Serial1.read(); //Pick the first byte from the buffer
    //Serial.println(rx1_received_byte);
    if (rx1_received_byte == 0xFF){ //Check if it's maybe a new message
      rx1_received_byte = Serial1.read(); //Pick the next byte to see what is following
      //Serial.println(rx1_received_byte);
      if (rx1_received_byte != zero){ //If it's a new message
        rx1_msg_id = rx1_received_byte;
        rx1_counter = 0; //Reset the counter, not to place the current byte (msg_id) in any variable
      } else { //If it was FF + 00, meaning a data byte FF
        rx1_received_byte = 0xFF;
      } 
    }
    
    if(rx1_msg_id == 0x10){ //Test message straight from the Teensy
      switch (rx1_counter) {
        case 1:
          left_front_speed = rx1_received_byte;
          break;
        case 2:
          right_front_speed = rx1_received_byte;
          break;
        case 3:
          left_rear_speed = rx1_received_byte;
          break;
        case 4:
          right_rear_speed = rx1_received_byte;
          break;   
      }   
    }
    
    if(rx1_msg_id == 0x20){ //Update from the brake controller
      switch (rx1_counter) {
        case 1:
          left_front_speed = rx1_received_byte;
          break;
        case 2:
          right_front_speed = rx1_received_byte;
          break;
        case 3:
          left_rear_speed = rx1_received_byte;
          break;
        case 4:
          right_rear_speed = rx1_received_byte;
          break;   
        case 5:
          x_acc_highbyte = rx1_received_byte;
          break;
        case 6:
          x_acc_lowbyte = rx1_received_byte;
          break;
        case 7:
          y_acc_highbyte = rx1_received_byte;
          break;
        case 8:
          y_acc_lowbyte = rx1_received_byte;
          break;
        case 9:
          z_acc_highbyte = rx1_received_byte;
          break;
        case 10:
          z_acc_lowbyte = rx1_received_byte;
          break;
        case 11:
          x_gyro_highbyte = rx1_received_byte;
          break;
        case 12:
          x_gyro_lowbyte = rx1_received_byte;
          break;
        case 13:
          y_gyro_highbyte = rx1_received_byte;
          break;
        case 14:
          y_gyro_lowbyte = rx1_received_byte;
          break;
        case 15:
          z_gyro_highbyte = rx1_received_byte;
          break;
        case 16:
          z_gyro_lowbyte = rx1_received_byte;
          break;
      }   
    }
    
    if(rx1_msg_id == 0x21){ //The brake controller tells its parameters
      switch (rx1_counter) {
        case 1:
          brake_parameter_keynumber = rx1_received_byte;
          break;
        case 2:
          brake_parameter_highbyte = rx1_received_byte;
          break;
        case 3:
          brake_parameter_lowbyte = rx1_received_byte;
          send_uart0(0x34);
          parameters_sent = true;
          break;
      }   
    }
    
  }
  
}
  
  
//Function for reading the analog values
void read_analog(){
  steering_potentiometer = analogRead(A0) >> 2;
  motor_battery_state = analogRead(A1) >> 2;
  electronics_battery_state = analogRead(A2) >> 2;
  
  
  //light the leds according to the battery statuses
  if (motor_battery_state > 224){ //Motor battery full (8,4 V - 7,4 V)
    PORTC |= B00100000; //Light the green led (C5)
    PORTC &= B11100111; //Shut the yellow (C4) and the red (C3) led 
    motor_battery_ok = true;
  } else if (motor_battery_state > 197){ //Motor battery starting to run empty (7,4 V - 6,5 V)
    PORTC |= B00010000; //Light the yellow led (C4)
    PORTC &= B11010111; //Shut the green (C5) and the red (C3) led 
    motor_battery_ok = true;
  } else { //Motor battery empty ( < 6,5 V)
    PORTC |= B00001000; //Light the red led (C3)
    PORTC &= B11001111; //Shut the green (C5) and the yellow (C4) led
    motor_battery_ok = false;
  }
  
  if (electronics_battery_state > 224){ //Electronics battery full (12,6 V - 11,1 V)
    PORTC |= B00000100; //Light the green led (C2)
    PORTC &= B11111100; //Shut the yellow (C1) and the red (C0) led
  } else if (electronics_battery_state > 192){ //Electronics battery starting to run empty (11,1 V - 9,5 V)
    PORTC |= B00000010; //Light the yellow led (C1)
    PORTC &= B11111010; //Shut the green (C2) and the red (C0) led
  } else { //Electronics battery empty (< 9,5 V)
    PORTC |= B00000001; //Light the red led (C0)
    PORTC &= B11111001; //Shut the green (C2) and the yellow (C1) led
  }
}


void main_program(){
  //Blink the built in led and the blue led to see that the program is running
  PORTA ^= B00000100; //(A2)
  PORTB ^= B10000000; //(B7)
 
  communication_counter += 1; //Count cycles since last message from the computer
  parameters_sent = false; //No parameters have yet been sent during this cycle

  update_motors();
  read_analog();
  read_uart0(); //Read messages from the computer
  update_servos();
  send_uart1(0x31); //Send normal updates to the brake controller
  read_uart1(); //Read messages from the brake controller
  
  
  //Send updates to the computer only every x:th cycle
  sending_counter += 1;
  if (sending_counter == 5){
    sending_counter = 0;//Reset the counter
    if (parameters_sent == false){ //Send normal updates to the computer, if no parameters have been sent this cycle
      send_uart0(0x30);
    }
  }
  
  
  if(communication_counter >= 10){ //Ten cycles without messages from the computer
    //throttle = 0; //Stop the car
  }
  
  
  
  //Keep the buzzer on 10 cycles after the start command
  buzzer_counter += 1; 
  if(buzzer_counter <= 10){ //Turn on the buzzer
    PORTG |= B00000001;
  } else { 
    PORTG &= B11111110; //Turn off the buzzer
    buzzer_counter = 11;  
  }
  
  
}


void loop(){
  if (main_program_flag == true){
    //Put down the flag not to run the function again
    main_program_flag = false;
    main_program();      
  }
}



