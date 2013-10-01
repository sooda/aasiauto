// Brakecontroller

#include <Wire.h>
#include <ITG3200.h>
#include <ADXL345.h>

// hard coded definitions
#define ENCODER_RESOLUTION 512

#define DEBUGTIMER TCCR4B
#define RUNNINGTIME TCNT4

// ****************************** Common Variables ******************************** //

//  ------------------------------------ Private ---------------------------------- //

//Muuttuja joka laskee ohjelman syklin
int program_phase = 1;

//Flag for running the main program
boolean main_program_flag = false;

// Parameter reading
unsigned char _param_buff[3];

int parameterCycle = 0;

boolean DbgMainRunning = false;

struct DebugData {
    uint16_t RunningOverloads;
    uint16_t Teensy;
    uint16_t MainComm;
    uint16_t ParamSend;
    uint16_t ReadGyro;
    uint16_t ReadAcc;
    uint16_t UpdBrakes;
    uint16_t UpdBrakeLights;
    uint16_t DataSend;
};

DebugData DbgTime = {0, 0, 0, 0, 0, 0, 0, 0, 0};
// ****************************************************************************** //

// ***************************** Measurement Variables ****************************** //

//  ------------------------------------ Private ---------------------------------- //

// Accelerometer
ADXL345 adxl; //variable adxl is an instance of the ADXL345 library

// Gyro
ITG3200 gyro = ITG3200();
int gyro_x = 0, gyro_y = 0, gyro_z = 0;

//  ------------------------------------ Public ---------------------------------- //

byte _adxl_buff[6];
unsigned char x_gyro_highbyte = 0, x_gyro_lowbyte = 0;
unsigned char y_gyro_highbyte = 0, y_gyro_lowbyte = 0;
unsigned char z_gyro_highbyte = 0, z_gyro_lowbyte = 0;

// ****************************************************************************** //

// ***************************** Communication Variables ************************** //

//  ------------------------------------ Private ---------------------------------- //

unsigned char serial3_cur_msgId = 0;
unsigned char serial3_reading_byte_num = 0;

unsigned char serial1_cur_msgId = 0;
unsigned char serial1_reading_byte_num = 0;

unsigned char zero = 0x00;

// ********************************************************************************* //

// ********************************* Driver variables ******************************** //

//  ------------------------------------- Public ------------------------------------- //

unsigned char drv_brake_pwr = 0;
unsigned char drv_steering = 125;

// **************************************************************************************** //

// ******************************* Brake Power variables ***************************** //

//  ------------------------------------- Public ------------------------------------- //

uint16_t fl_zero_pos = 1000;
uint16_t fr_zero_pos = 1100;
uint16_t rl_zero_pos = 800;
uint16_t rr_zero_pos = 1200;

uint16_t fl_max_pos = 1500;
uint16_t fr_max_pos = 1500;
uint16_t rl_max_pos = 1300;
uint16_t rr_max_pos = 1900;

uint16_t fl_brake_scale = 500;
uint16_t fr_brake_scale = 400;
uint16_t rl_brake_scale = 500;
uint16_t rr_brake_scale = 700;

byte fl_brake_leftHand = 0;
byte fr_brake_leftHand = 1;
byte rl_brake_leftHand = 0;
byte rr_brake_leftHand = 1;

// ************************************************************************************ //

// ********************************** ABS variables ********************************** //

//  ------------------------------------- Public ------------------------------------- //

byte abs_on = true;

// Thresholds
unsigned char abs_start_threshold = 140; // This is a little bit too high, could be 160? 200
unsigned char abs_high_threshold = 170;
unsigned char abs_middle_threshold = 180;
unsigned char phase5_gain_timer_threshold = 3;
unsigned char phase5_hold_timer_threshold = 6;

// Gains
unsigned char phase1_gain = 120; // 180
unsigned char phase3_gain = 120; // 100
unsigned char phase5_gain = 120; // 100

//  ------------------------------------- Private ------------------------------------- //

unsigned char flw_phase = 0;
unsigned char frw_phase = 0;
unsigned char rlw_phase = 0;
unsigned char rrw_phase = 0;

// previous cycle a values
int flw_ws_prev = 0;
int frw_ws_prev = 0;
int rlw_ws_prev = 0;
int rrw_ws_prev = 0;

unsigned char flw_pulsecountPrev = 0;
unsigned char frw_pulsecountPrev = 0;
unsigned char rlw_pulsecountPrev = 0;
unsigned char rrw_pulsecountPrev = 0;

// Current wheel speeds
unsigned char flw_pulsecount = 0;
unsigned char frw_pulsecount = 0;
unsigned char rlw_pulsecount = 0;
unsigned char rrw_pulsecount = 0;

// Wheel max brake pwr
uint16_t flw_max_brake_pwr = 0;
uint16_t frw_max_brake_pwr = 0;
uint16_t rlw_max_brake_pwr = 0;
uint16_t rrw_max_brake_pwr = 0;

// Wheel saved brake pwr
uint16_t flw_abs_brake_pwr = 0;
uint16_t frw_abs_brake_pwr = 0;
uint16_t rlw_abs_brake_pwr = 0;
uint16_t rrw_abs_brake_pwr = 0;

// Wheel time counters
unsigned long flw_counter = 0;
unsigned long frw_counter = 0;
unsigned long rlw_counter = 0;
unsigned long rrw_counter = 0;

// **************************************************************************************** //

// ************************************ ESP variables ************************************* //

//  ------------------------------------- Public ------------------------------------- //

byte esp_on = false;
unsigned char esp_w_sensitivity = 200;
unsigned char esp_b_sensitivity = 200;
unsigned char d_r = 100; // tire diameter
uint16_t esp_wheelbase = 600; // max 65535
unsigned char esp_w_P = 87;
unsigned char esp_w_D = 20;
unsigned char esp_brake_multi = 1;
unsigned char esp_brake_div = 2;
unsigned char esp_b_P = 87;
unsigned char esp_b_D = 20;
unsigned char esp_ss_start_threshold = 170;
uint16_t esp_l1 = 1;
uint16_t esp_l2 = 1;
uint16_t esp_m = 1;
uint16_t esp_C1 = 1;
uint16_t esp_C2 = 1;

//  ------------------------------------- Private ------------------------------------- //

byte flw_prev_braked = false;
byte frw_prev_braked = false;
byte rlw_prev_braked = false;
byte rrw_prev_braked = false;
double w_prev_error = 0.0;
double b_prev_error = 0.0;
uint32_t esp_b_timer = 0;
double esp_B_l2lC1C2 = 0.0;
double esp_B_l1C1m = 0.0;
double esp_B_l2C1C2 = 0.0;
double esp_B_ml1C1_l2C2 = 0.0;
double v_char2 = 0.9;

// **************************************************************************************** //

void setup(){
  
  //set pins as outputs
  pinMode(13, OUTPUT); //Built in led
  pinMode(24, OUTPUT); //Blue led
  pinMode(22, OUTPUT); //Brakelights
  pinMode(23, OUTPUT); //Brakelights
  
  // Serial ports
  Serial.begin(38400);
  Serial1.begin(38400); // main controller
  Serial3.begin(38400); // wheel speed controller
  
  // INITIALIZE I2C
  Wire.begin();
  delay(1000);

  // INITIALIZE BRAKE SERVOS
  pinMode(11, OUTPUT); // front left
  pinMode(12, OUTPUT); // front right
  pinMode(5, OUTPUT); // rear left
  pinMode(2, OUTPUT); // rear right
  
  // INITIALIZE ACCELEROMETER
  adxl.powerOn();
  
  //set activity/ inactivity thresholds (0-255)
  adxl.setActivityThreshold(75); //62.5mg per increment
  adxl.setInactivityThreshold(75); //62.5mg per increment
  adxl.setTimeInactivity(10); // how many seconds of no activity is inactive?
 
  //look of activity movement on this axes - 1 == on; 0 == off 
  adxl.setActivityX(1);
  adxl.setActivityY(1);
  adxl.setActivityZ(1);
 
  //look of inactivity movement on this axes - 1 == on; 0 == off
  adxl.setInactivityX(1);
  adxl.setInactivityY(1);
  adxl.setInactivityZ(1);
 
  //look of tap movement on this axes - 1 == on; 0 == off
  adxl.setTapDetectionOnX(0);
  adxl.setTapDetectionOnY(0);
  adxl.setTapDetectionOnZ(1);
 
  //set values for what is a tap, and what is a double tap (0-255)
  adxl.setTapThreshold(50); //62.5mg per increment
  adxl.setTapDuration(15); //625μs per increment
  adxl.setDoubleTapLatency(80); //1.25ms per increment
  adxl.setDoubleTapWindow(200); //1.25ms per increment
 
  //set values for what is considered freefall (0-255)
  adxl.setFreeFallThreshold(7); //(5 - 9) recommended - 62.5mg per increment
  adxl.setFreeFallDuration(45); //(20 - 70) recommended - 5ms per increment
 
  //setting all interupts to take place on int pin 1
  //I had issues with int pin 2, was unable to reset it
  adxl.setInterruptMapping( ADXL345_INT_SINGLE_TAP_BIT,   ADXL345_INT1_PIN );
  adxl.setInterruptMapping( ADXL345_INT_DOUBLE_TAP_BIT,   ADXL345_INT1_PIN );
  adxl.setInterruptMapping( ADXL345_INT_FREE_FALL_BIT,    ADXL345_INT1_PIN );
  adxl.setInterruptMapping( ADXL345_INT_ACTIVITY_BIT,     ADXL345_INT1_PIN );
  adxl.setInterruptMapping( ADXL345_INT_INACTIVITY_BIT,   ADXL345_INT1_PIN );
 
  //register interupt actions - 1 == on; 0 == off  
  adxl.setInterrupt( ADXL345_INT_SINGLE_TAP_BIT, 1);
  adxl.setInterrupt( ADXL345_INT_DOUBLE_TAP_BIT, 1);
  adxl.setInterrupt( ADXL345_INT_FREE_FALL_BIT,  1);
  adxl.setInterrupt( ADXL345_INT_ACTIVITY_BIT,   1);
  adxl.setInterrupt( ADXL345_INT_INACTIVITY_BIT, 1);
  
  // Set range
  adxl.setRangeSetting(16);
  
  // INITIALIZE GYRO
  gyro.init(ITG3200_ADDR_AD0_HIGH); 
  gyro.zeroCalibrate(2500, 2);

  // INITIALIZE CLOCK SYCLE
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
  
  //Settings for loop timer
  DEBUGTIMER = (1 << CS42) | (1 << CS40);
  
  sei();//allow interrupts
}//end setup

ISR(TIMER0_COMPA_vect){
  if (program_phase == 10){
    program_phase = 1;
    if(DbgMainRunning)
        DbgTime.RunningOverloads++;
    //raise the flag for running the main program
    main_program_flag = true;
  } else {
    program_phase += 1;
  }
}

// ---------------------------- SENSOR DATA HANDLING ---------------------------- //

void read_gyro()
{
  while (gyro.isRawDataReady()) {
    gyro.readGyroRawCal(&gyro_x,&gyro_y,&gyro_z);
    break;
  }
  
  x_gyro_highbyte = gyro_x >> 8;
  x_gyro_lowbyte = (unsigned char)char(gyro_x);
  y_gyro_highbyte = gyro_y >> 8;
  y_gyro_lowbyte = (unsigned char)char(gyro_y);
  z_gyro_highbyte = gyro_z >> 8;
  z_gyro_lowbyte = (unsigned char)char(gyro_z);
}

void read_accelerometer()
{
  adxl.readToBuffer(_adxl_buff); 
}

double get_speed(double flw_ws, double frw_ws, double rlw_ws, double rrw_ws)
{
  // first use bosch method
  if(flw_ws > rrw_ws && !flw_prev_braked)
    return flw_ws * (d_r * 1000 / 255) / 1000;
  else if (rrw_ws >= flw_ws && !rrw_prev_braked)
    return rrw_ws * (d_r * 1000 / 255) / 1000;
  else if (frw_ws > rlw_ws && !frw_prev_braked)
    return frw_ws * (d_r * 1000 / 255) / 1000;
  else if (rlw_ws >= frw_ws && !rlw_prev_braked)
    return rlw_ws * (d_r * 1000 / 255) / 1000;
  else
    return (flw_ws + frw_ws + rlw_ws + rrw_ws) / 4; // else use common method
}

// ---------------------------- BRAKE CALCULATION ---------------------------- //

void update_brakeLigths()
{
  if((int)drv_brake_pwr > 0)
  {
    PORTA |= B00000011;
  }
  else
  {
    PORTA &= B11111100;
  }
}

void update_brakes()
{ 

    double flw_ws = (int)flw_pulsecount * 1.227; 
    double frw_ws = (int)frw_pulsecount * 1.227; //2 * PI * ((frw_pulsecount / (double)ENCODER_RESOLUTION) / 0.01); 
    double rlw_ws = (int)rlw_pulsecount * 1.227; //2 * PI * ((rlw_pulsecount / (double)ENCODER_RESOLUTION) / 0.01);
    double rrw_ws = (int)rrw_pulsecount * 1.227; //2 * PI * ((rrw_pulsecount / (double)ENCODER_RESOLUTION) / 0.01);
  
    double flw_a = (1.227 * ((int)flw_pulsecount - flw_ws_prev)) / 0.01;
    double frw_a = (1.227 * ((int)frw_pulsecount - frw_ws_prev)) / 0.01;
    double rlw_a = (1.227 * ((int)rlw_pulsecount - rlw_ws_prev)) / 0.01;
    double rrw_a = (1.227 * ((int)rrw_pulsecount - rrw_ws_prev)) / 0.01;
    
    flw_ws_prev = (int)flw_pulsecount;
    frw_ws_prev = (int)frw_pulsecount;
    rlw_ws_prev = (int)rlw_pulsecount;
    rrw_ws_prev = (int)rrw_pulsecount;

  if(esp_on)
  { 
    int fl_brake_power = ((int)drv_brake_pwr / esp_brake_div) * esp_brake_multi;
    int fr_brake_power = ((int)drv_brake_pwr / esp_brake_div) * esp_brake_multi;
    int rl_brake_power = ((int)drv_brake_pwr / esp_brake_div) * esp_brake_multi;
    int rr_brake_power = ((int)drv_brake_pwr / esp_brake_div) * esp_brake_multi;
    byte esp_active = 0;
    double v = get_speed(flw_ws, frw_ws, rlw_ws, rrw_ws);
    
    double w_calculated = drv_steering * ( v / ((esp_wheelbase/100000.0) * (1 + (v * v)/v_char2))); // TODO drv_steering to rad
    double w_measured =  gyro_z / gyro.scalefactor[2];    

    int16_t acc_y = (((int)_adxl_buff[3]) << 8) | _adxl_buff[2]; // TODO: acc negative?
    double acc_y_rescaled = (acc_y * (32/1024)) * 9.81;
    
    if(acc_y_rescaled > 0.1 || acc_y_rescaled < -0.1)
      esp_b_timer++;
    else
      esp_b_timer = 0;
    
    // estimate side slip
    double v_lateral = (v * w_measured + acc_y_rescaled) * (esp_b_timer / 1000);
    double B_estimated = v_lateral / v; // this is not degrees nor rads its tan(side-slip)
    double B_calculated = drv_steering * ((esp_B_l2lC1C2-(esp_B_l1C1m * v * v)) / (esp_B_l2C1C2 - (v*v*esp_B_ml1C1_l2C2)));
    
    flw_prev_braked = false;
    frw_prev_braked = false;
    rlw_prev_braked = false;
    rrw_prev_braked = false;
    
    if(B_estimated > (esp_ss_start_threshold / 1000))// use side slip if estimated side slip > 12 degrees
    {
      double b_error = B_calculated - B_estimated;
      
      if((abs(B_estimated)) >= (abs(B_calculated) * (1 / (esp_b_sensitivity / 255)))) // oversteer
      {
  	if(B_estimated > 0) //brake front left wheel
          {
            int brake_power = fl_brake_power + ((esp_b_P * 10 / 255) * abs(b_error) + (esp_b_D * 10 / 255) * (abs(b_error) - b_prev_error));
            fl_brake_power = brake_power >= 255 ? 255 : brake_power;
            flw_prev_braked = true;
          }
  	else  // brake front right wheel
          {
            int brake_power = fr_brake_power + ((esp_b_P * 10 / 255) * abs(b_error) + (esp_b_D * 10 / 255) * (abs(b_error) - b_prev_error));
            fr_brake_power = brake_power >= 255 ? 255 : brake_power;
            frw_prev_braked = true;
          }	
        esp_active = 1;
      }
      else if (abs(B_estimated) < abs(B_calculated) * (esp_b_sensitivity / 255)) // understeer
      {
  	if(w_measured < 0) // brake rear right wheel
          {
            int brake_power = rr_brake_power + ((esp_b_P * 10 / 255) * abs(b_error) + (esp_b_D * 10 / 255) * (abs(b_error) - b_prev_error));
            rr_brake_power = brake_power >= 255 ? 255 : brake_power;
            rlw_prev_braked = true;
          }
  	else // brake rear left wheel
  	{
            int brake_power = rl_brake_power + ((esp_b_P * 10 / 255) * abs(b_error) + (esp_b_D * 10 / 255) * (abs(b_error) - b_prev_error));
            rl_brake_power = brake_power >= 255 ? 255 : brake_power;
            rrw_prev_braked = true;
          }
        esp_active = 1;
      }
      b_prev_error = b_error;
    }
    else
    {
      double w_error = w_calculated - w_measured;      
      if((abs(w_measured)) >= (abs(w_calculated) * (1 / (esp_w_sensitivity / 255)))) // oversteer
      {
  	if(w_measured > 0) //brake front left wheel
          {
            int brake_power = fl_brake_power + ((esp_w_P * 10 / 255) * abs(w_error) + (esp_w_D * 10 / 255) * (abs(w_error) - w_prev_error));
            fl_brake_power = brake_power >= 255 ? 255 : brake_power;
            flw_prev_braked = true;
          }
  	else  // brake front right wheel
          {
            int brake_power = fr_brake_power + ((esp_w_P * 10 / 255) * abs(w_error) + (esp_w_D * 10 / 255) * (abs(w_error) - w_prev_error));
            fr_brake_power = brake_power >= 255 ? 255 : brake_power;
            frw_prev_braked = true;
          }	
        esp_active = 1;
      }
      else if (abs(w_measured) < abs(w_calculated) * (esp_w_sensitivity / 255)) // understeer
      {
  	if(w_measured < 0) // brake rear right wheel
          {
            int brake_power = rr_brake_power + ((esp_w_P * 10 / 255) * abs(w_error) + (esp_w_D * 10 / 255) * (abs(w_error) - w_prev_error));
            rr_brake_power = brake_power >= 255 ? 255 : brake_power;
            rlw_prev_braked = true;
          }
  	else // brake rear left wheel
  	{
            int brake_power = rl_brake_power + ((esp_w_P * 10 / 255) * abs(w_error) + (esp_w_D * 10 / 255) * (abs(w_error) - w_prev_error));
            rl_brake_power = brake_power >= 255 ? 255 : brake_power;
            rrw_prev_braked = true;
          }
        esp_active = 1;
      }     
      w_prev_error = w_error;
    }
    
    if(esp_active)
    {
      OCR1B = get_braking_force(fl_brake_power, flw_a, &flw_phase, &flw_max_brake_pwr, &flw_counter, &flw_abs_brake_pwr, fl_zero_pos, fl_max_pos, fl_brake_scale, fl_brake_leftHand);
      OCR1A = get_braking_force(fr_brake_power, frw_a, &frw_phase, &frw_max_brake_pwr, &frw_counter, &frw_abs_brake_pwr, fr_zero_pos, fr_max_pos, fr_brake_scale, fr_brake_leftHand);
      OCR3A = get_braking_force(rl_brake_power, rlw_a, &rlw_phase, &rlw_max_brake_pwr, &rlw_counter, &rlw_abs_brake_pwr, rl_zero_pos, rl_max_pos, rl_brake_scale, rl_brake_leftHand);
      OCR3B = get_braking_force(rr_brake_power, rrw_a, &flw_phase, &rrw_max_brake_pwr, &rrw_counter, &rrw_abs_brake_pwr, rr_zero_pos, rr_max_pos, rr_brake_scale, rr_brake_leftHand);  
    }
    else
    {
      OCR1B = get_braking_force((int)drv_brake_pwr, flw_a, &flw_phase, &flw_max_brake_pwr, &flw_counter, &flw_abs_brake_pwr, fl_zero_pos, fl_max_pos, fl_brake_scale, fl_brake_leftHand);
      OCR1A = get_braking_force((int)drv_brake_pwr, frw_a, &frw_phase, &frw_max_brake_pwr, &frw_counter, &frw_abs_brake_pwr, fr_zero_pos, fr_max_pos, fr_brake_scale, fr_brake_leftHand);
      OCR3A = get_braking_force((int)drv_brake_pwr, rlw_a, &rlw_phase, &rlw_max_brake_pwr, &rlw_counter, &rlw_abs_brake_pwr, rl_zero_pos, rl_max_pos, rl_brake_scale, rl_brake_leftHand);
      OCR3B = get_braking_force((int)drv_brake_pwr, rrw_a, &flw_phase, &rrw_max_brake_pwr, &rrw_counter, &rrw_abs_brake_pwr, rr_zero_pos, rr_max_pos, rr_brake_scale, rr_brake_leftHand);  
    }
  }
  else
  {
    OCR1B = get_braking_force((int)drv_brake_pwr, flw_a, &flw_phase, &flw_max_brake_pwr, &flw_counter, &flw_abs_brake_pwr, fl_zero_pos, fl_max_pos, fl_brake_scale, fl_brake_leftHand);
    OCR1A = get_braking_force((int)drv_brake_pwr, frw_a, &frw_phase, &frw_max_brake_pwr, &frw_counter, &frw_abs_brake_pwr, fr_zero_pos, fr_max_pos, fr_brake_scale, fr_brake_leftHand);
    OCR3A = get_braking_force((int)drv_brake_pwr, rlw_a, &rlw_phase, &rlw_max_brake_pwr, &rlw_counter, &rlw_abs_brake_pwr, rl_zero_pos, rl_max_pos, rl_brake_scale, rl_brake_leftHand);
    OCR3B = get_braking_force((int)drv_brake_pwr, rrw_a, &flw_phase, &rrw_max_brake_pwr, &rrw_counter, &rrw_abs_brake_pwr, rr_zero_pos, rr_max_pos, rr_brake_scale, rr_brake_leftHand);
  }
}

int get_braking_force(int brake_pwr, double a, unsigned char *phase, uint16_t *max_brake_pwr, unsigned long *counter, uint16_t *abs_brake_pwr, uint16_t zero_brake, uint16_t max_brake, uint16_t brake_scale, byte leftHand)
{
  int ret = (zero_brake + ((long(brake_pwr) * brake_scale) / 255)) <= max_brake ? zero_brake + ((long(brake_pwr) * brake_scale) / 255) : max_brake;
  if(abs_on && brake_pwr > 0)
  {
    if(a < (-1 * ((int)abs_start_threshold * 50 / 255)) && *phase == 0)
    {

      *max_brake_pwr = ret;
      *phase = 1;
    }
    else if(*phase == 1)
    {
      (*counter)++;     
      *abs_brake_pwr = *max_brake_pwr - (*counter * phase1_gain) > zero_brake ? *max_brake_pwr - (*counter * phase1_gain) : zero_brake;
      ret = *abs_brake_pwr;
      if(a > (-1 * ((int)abs_start_threshold * 50 / 255)))
      {
        *counter = 0;
        *phase = 2;
      }
    }
    else if(*phase == 2)
    {
      ret = *abs_brake_pwr;
      (*counter)++;
      
      if((abs(a) > ((int)abs_high_threshold * 50 / 255)))
      {
        *counter = 0;
        *phase = 3;
      }
      if((*counter) > 2)
      {
        *counter = 0;
        *phase = 3;
      }
    }
    else if(*phase == 3)
    {
      (*counter)++;
      *abs_brake_pwr = *abs_brake_pwr + (*counter * phase3_gain) < max_brake ? *abs_brake_pwr + (*counter * phase3_gain) : max_brake;
      ret = *abs_brake_pwr;
      
      // simplified
      if(a < (-1 * ((int)abs_start_threshold * 50 / 255)))
      {
        *max_brake_pwr = *abs_brake_pwr;
        *counter = 0;
        *phase = 1;
      }
      if((*counter) > 2)
      {
        *max_brake_pwr = *abs_brake_pwr;
        *counter = 0;
        *phase = 1;
      }
      
      // advanced
      /*
      if(a < ((int)abs_high_threshold * 50 / 255))
      {
        *counter = 0;
        *phase = 4;
      }
      */
    }
    /*else if(*phase == 4) // advanced
    {
      ret = *abs_brake_pwr;
      if(a < ((int)abs_middle_threshold * 50 / 255))
      {
        *counter = 0;
        *phase = 5;
      }
    }
    else if(*phase == 5)
    {
      (*counter)++;
      if(*counter < phase5_gain_timer_threshold)
      {
        *abs_brake_pwr = *abs_brake_pwr + (*counter * phase5_gain) < max_brake ? *abs_brake_pwr + (*counter * phase5_gain) : max_brake;
      }
      else if (*counter >= phase5_gain_timer_threshold && *counter < phase5_hold_timer_threshold)
      {
        // hold
      }
      else
      {
        *counter = 0;
      }
      
      ret = *abs_brake_pwr;
      
      if(a < (-1 * ((int)abs_start_threshold * 50 / 255)))
      {
        *max_brake_pwr = *abs_brake_pwr;
        *counter = 0;
        *phase = 1;
      }
    }*/
  }
  else
  {
    *phase = 0;
  }
  if(leftHand)
    ret = max_brake + zero_brake - ret;

  return ret;
}

// ---------------------------- MAIN PROGRAM ---------------------------- //

void main_program(){
  DbgMainRunning = true;
  RUNNINGTIME = 0;
  //Put down the flag not to run the function again
  main_program_flag = false;
  
  //Shut the blue led to see that the program is running
  PORTA ^= B00000100; //(D2)
  PORTB ^= B10000000;
  
  read_serial3(); // Teensy
  DbgTime.Teensy = TIM16_ReadRUNNINGTIME();
  read_serial1(); // Main Controller
  DbgTime.MainComm = TIM16_ReadRUNNINGTIME() - DbgTime.Teensy;
  send_parameters();
  DbgTime.ParamSend = TIM16_ReadRUNNINGTIME() - DbgTime.MainComm;
  read_gyro();
  DbgTime.ReadGyro = TIM16_ReadRUNNINGTIME() - DbgTime.ParamSend;
  read_accelerometer();
  DbgTime.ReadAcc = TIM16_ReadRUNNINGTIME() - DbgTime.ReadGyro;
  update_brakes();
  DbgTime.UpdBrakes = TIM16_ReadRUNNINGTIME() - DbgTime.ReadAcc;
  update_brakeLigths();
  DbgTime.UpdBrakeLights = TIM16_ReadRUNNINGTIME() - DbgTime.UpdBrakes;
  send_data();
  DbgTime.DataSend = TIM16_ReadRUNNINGTIME() - DbgTime.UpdBrakeLights;
  DbgMainRunning = false;
}

void loop(){
  if (main_program_flag == true){
    main_program();      
  }
}

uint16_t TIM16_ReadRUNNINGTIME( void )
{
    uint8_t sreg;
    uint16_t i;
    sreg = SREG;
    cli();
    i = RUNNINGTIME;
    SREG = sreg;
    return i;
}

// ---------------------------- COMMUNICATION ---------------------------- //

//Function for sending the data to the computer
void send_data(){
  if(parameterCycle == 0)
  {
  Serial1.write(0xFF); //Start command
  Serial1.write(0x20); //Message ID  
  sendByteUart1(flw_pulsecount);
  sendByteUart1(frw_pulsecount);
  sendByteUart1(rlw_pulsecount);
  sendByteUart1(rrw_pulsecount);
  sendByteUart1(_adxl_buff[1]);
  sendByteUart1(_adxl_buff[0]);
  sendByteUart1(_adxl_buff[3]);
  sendByteUart1(_adxl_buff[2]);
  sendByteUart1(_adxl_buff[5]);
  sendByteUart1(_adxl_buff[4]);
  sendByteUart1(x_gyro_highbyte);
  sendByteUart1(x_gyro_lowbyte);
  sendByteUart1(y_gyro_highbyte);
  sendByteUart1(y_gyro_lowbyte);
  sendByteUart1(z_gyro_highbyte);
  sendByteUart1(z_gyro_lowbyte);
  }
}

void read_serial3()
{
  for(int i = 0; i < Serial3.available(); i++)
  {
    unsigned char j = Serial3.read();   
    serial3_reading_byte_num++; //Count which byte we're reading
    
    if (j == 0xFF){ //Check if it's maybe a new message
      j = Serial3.read(); //Pick the next byte to see what is following
      if (j != zero){ //If it's a new message
        serial3_cur_msgId = j;
        serial3_reading_byte_num = 0; //Reset the counter, not to place the current byte (msg_id) in any variable
      } else { //If it was FF + 00, meaning a data byte FF
        j = 0xFF;
      } 
    }   
    if(serial3_reading_byte_num != 0)
      read_serial3_byte(j);
  }
}

void read_serial1()
{
  for(int i = 0; i < Serial1.available(); i++)
  {
    unsigned char j = (char)Serial1.read();   
    serial1_reading_byte_num++; //Count which byte we're reading
    
    if (j == 0xFF){ //Check if it's maybe a new message
      j = Serial1.read(); //Pick the next byte to see what is following
      if (j != zero){ //If it's a new message
        serial1_cur_msgId = j;
        serial1_reading_byte_num = 0; //Reset the counter, not to place the current byte (msg_id) in any variable
      } else { //If it was FF + 00, meaning a data byte FF
        j = 0xFF;
      } 
    }
    
    if(serial1_reading_byte_num != 0)
      read_serial1_byte(j);
  }
}


void read_serial3_byte(char c)
{
  if(serial3_cur_msgId == 0x10) // message from teensy
  {
    if(serial3_reading_byte_num == 1)
      flw_pulsecount = c;
    else if(serial3_reading_byte_num == 2)
      frw_pulsecount = c;
    else if(serial3_reading_byte_num == 3)
      rlw_pulsecount = c;
    else if(serial3_reading_byte_num == 4)
    {
      rrw_pulsecount = c;
      serial3_cur_msgId = 0;
      serial3_reading_byte_num = 0;
    }
    else
    {
      serial3_cur_msgId = 0;
      serial3_reading_byte_num = 0;
    }
  }
}

void read_serial1_byte(unsigned char c)
{
  if(serial1_cur_msgId == 0x31) // message from main controller
  {
    if(serial1_reading_byte_num == 1){
      drv_brake_pwr = c;
    }
    else if(serial1_reading_byte_num == 2)
    {
      drv_steering = c;
      serial1_cur_msgId = 0;
      serial1_reading_byte_num = 0;
    }
    else
    {
      serial1_cur_msgId = 0;
      serial1_reading_byte_num = 0;
    }
  }
  else if(serial1_cur_msgId == 0x32) // message from pc
  {
    _param_buff[serial1_reading_byte_num -1] = c;
    
    if(serial1_reading_byte_num == 3)
    {
      save_parameter();
      serial1_reading_byte_num = 0;
      serial1_cur_msgId = 0;
    }
  }
  else if(serial1_cur_msgId == 0x33) // message from pc, send parameters
  {
      parameterCycle = 1;
      serial1_reading_byte_num = 0;
      serial1_cur_msgId = 0;
  }
}

void save_parameter()
{
  byte update_dyn_values = false;
  
  switch((int)_param_buff[0])
  {
    case 10: // Brake Distribution parameters
      fl_zero_pos = ((((int)_param_buff[1]) << 8) | _param_buff[2]);
      fl_brake_scale = fl_max_pos - fl_zero_pos;
      break;
    case 11: // Brake Distribution parameters
      fr_zero_pos = ((((int)_param_buff[1]) << 8) | _param_buff[2]);
      fr_brake_scale = fr_max_pos - fr_zero_pos;
      break;
    case 12:
      rl_zero_pos = (((int)_param_buff[1]) << 8) | _param_buff[2];
      rl_brake_scale = rl_max_pos - rl_zero_pos;
      break;
    case 13:
      rr_zero_pos = (((int)_param_buff[1]) << 8) | _param_buff[2];
      rr_brake_scale = rr_max_pos - rr_zero_pos;
      break;
    case 14:
      fl_max_pos = (((int)_param_buff[1]) << 8) | _param_buff[2];
      fl_brake_scale = fl_max_pos - fl_zero_pos;
      break;
    case 15:
      fr_max_pos = (((int)_param_buff[1]) << 8) | _param_buff[2];
      fr_brake_scale = fr_max_pos - fr_zero_pos;
      break;
    case 16:
      rl_max_pos = (((int)_param_buff[1]) << 8) | _param_buff[2];
      rl_brake_scale = rl_max_pos - rl_zero_pos;
      break;
    case 17:
      rr_max_pos = (((int)_param_buff[1]) << 8) | _param_buff[2];
      rr_brake_scale = rr_max_pos - rr_zero_pos;
      break;
    case 20: // ABS Parameters
      abs_on = (byte)_param_buff[1];
      break;
    case 21:
      abs_start_threshold = _param_buff[1];
      break;
    case 22:
      abs_middle_threshold = _param_buff[1];
      break;
    case 23:
      abs_high_threshold = _param_buff[1];
      break;
    case 24:
      phase5_gain_timer_threshold = _param_buff[1];
      break;
    case 25:
      phase5_hold_timer_threshold = _param_buff[1];
      break;
    case 26:
      phase1_gain = _param_buff[1];
      break;
    case 27:
      phase3_gain = _param_buff[1];
      break;
    case 28:
      phase5_gain = _param_buff[1];
      break;
    case 40:
      esp_on = (byte)_param_buff[1];
      break;
    case 41:
      esp_w_sensitivity = _param_buff[1];
      break;
    case 42:
      esp_b_sensitivity = _param_buff[1];
      break;
    case 43:
      esp_brake_multi = _param_buff[1];
      break;
    case 44:
      esp_brake_div = _param_buff[1];
      break;
    case 45:
      esp_w_P = _param_buff[1];
      break;
    case 46:
      esp_w_D = _param_buff[1];
      break;
    case 47:
      esp_b_P = _param_buff[1];
      break;
    case 48:
      esp_b_D = _param_buff[1];
      break;
    case 49:
      esp_ss_start_threshold = _param_buff[1];
      break;
    case 50:
      d_r = _param_buff[1];
      break;
    case 51:
      esp_wheelbase = (((int)_param_buff[1]) << 8) | _param_buff[2];
      update_dyn_values = true;
      break;
    case 52:
      esp_m = (((int)_param_buff[1]) << 8) | _param_buff[2];
      update_dyn_values = true;
      break;
    case 53:
      esp_l1 = (((int)_param_buff[1]) << 8) | _param_buff[2];
      update_dyn_values = true;
      break;
    case 54:
      esp_l2 = (((int)_param_buff[1]) << 8) | _param_buff[2];
      update_dyn_values = true;
      break;
    case 55:
      esp_C1 = (((int)_param_buff[1]) << 8) | _param_buff[2];
      update_dyn_values = true;
      break;
    case 56:
      esp_C2 = (((int)_param_buff[1]) << 8) | _param_buff[2];
      update_dyn_values = true;
      break;
  }
  
  if(update_dyn_values) // precalculated values
  {
    double l1 = esp_l1/1000.0;
    double l2 = esp_l2/1000.0;
    double l = esp_wheelbase/1000.0;
    double m = esp_m / 1000.0;
    esp_B_l2lC1C2 = l2 * l * esp_C1 * esp_C2;
    esp_B_l1C1m = l1*esp_C1*m;
    esp_B_l2C1C2 = l*l*esp_C1*esp_C2;
    esp_B_ml1C1_l2C2 = m*(l1*esp_C1 - l2 * esp_C2);
    v_char2 = (esp_C1 * esp_C2 * l * l) / esp_B_ml1C1_l2C2;
  }
}

void send_parameters()
{  
  if(parameterCycle == 1)
  {
    send_parameter2(10, fl_zero_pos);
    send_parameter2(11, fr_zero_pos);
  }else if(parameterCycle == 2){
    send_parameter2(12, rl_zero_pos);
    send_parameter2(13, rr_zero_pos);
  }else if(parameterCycle == 3){
    send_parameter2(14, fl_max_pos);
    send_parameter2(15, fr_zero_pos);
  }else if(parameterCycle == 4){
    send_parameter2(16, rl_max_pos);
    send_parameter2(17, rr_max_pos);
  }else if(parameterCycle == 5)
  {
    send_parameter(20, (char)abs_on);
    send_parameter(21, abs_start_threshold);
  }else if(parameterCycle == 6){
    send_parameter(22, abs_middle_threshold);
    send_parameter(23, abs_high_threshold);
  }else if(parameterCycle == 7){
    send_parameter(24, phase5_gain_timer_threshold);
    send_parameter(25, phase5_hold_timer_threshold);
  }else if(parameterCycle == 8){
    send_parameter(26, phase1_gain);
    send_parameter(27, phase3_gain);
    send_parameter(28, phase5_gain);
  }else if(parameterCycle == 9)
  {
    send_parameter(40, (char)esp_on);
    send_parameter(41, esp_w_sensitivity);
    send_parameter(42, esp_b_sensitivity); 
  }else if(parameterCycle == 10){
    send_parameter(43, esp_brake_multi); 
    send_parameter(44, esp_brake_div); 
  }else if(parameterCycle == 11){
    send_parameter(45, esp_w_P);
    send_parameter(46, esp_w_D);
  }else if(parameterCycle == 12){
    send_parameter(47, esp_b_P);
    send_parameter(48, esp_b_D);
    send_parameter(49, esp_ss_start_threshold);
  }else if (parameterCycle == 13){
    send_parameter(50, d_r);
    send_parameter2(51, esp_wheelbase);
  }else if(parameterCycle == 14){
    send_parameter2(52, esp_m);
    send_parameter2(53, esp_l1);
    send_parameter2(54, esp_l2);
  }else if(parameterCycle == 15){
    send_parameter2(55, esp_C1);
    send_parameter2(56, esp_C2);    
    parameterCycle = 0;
  }
  
  if(parameterCycle > 0)
    parameterCycle++;
}

void send_parameter(int id, unsigned char value)
{
  Serial1.write(0xFF);
  Serial1.write(0x21);
  Serial1.write((unsigned char)char(id));
  sendByteUart1(value);
  Serial1.write(zero);
}

void send_parameter2(int id, uint16_t value)
{
  Serial1.write(0xFF);
  Serial1.write(0x21);
  Serial1.write((unsigned char)char(id));
  sendByteUart1(value >> 8);
  sendByteUart1((unsigned char)char(value));
}

//Function for sending one byte to the computer
void sendByteUart1 (unsigned char byteToSend){
  if (byteToSend == 0xFF){
    Serial1.write(0xFF);
    Serial1.write(zero);
  } else {
    Serial1.write(byteToSend);
  }
}




