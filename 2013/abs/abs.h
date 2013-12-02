#ifndef RCCAR_ABS_H
#define RCCAR_ABS_H

#define MAX(a,b)    ((a>b)?(a):(b))

typedef struct absData_t absData_t;

typedef enum{
    SLIPTOLERANCE,
    ENABLED,
    CUTOFFSPEED,
    MINACC,
    MAXACC,
    MUSPLITTHRESHOLD,
    P,
    ABSPARAM_MAX
}absParam; 

//Datatype for holding wheel information for abs algorithm
struct absData_t {
    unsigned char slip;
    unsigned char forceReq;
    unsigned char brakeForce;
    int speed;
    int acc;
    absData_t* otherSide;
};

//Abs parameters
typedef struct {
    unsigned char slipTolerance;
    unsigned char enabled;
    unsigned char cutOffSpeed;
    unsigned char minAcc;
    unsigned char maxAcc;
    unsigned char muSplitThreshold;
    unsigned char p;
}absParams_t;

//initialize abs system with default settings
void initAbsData(void);

//iterate one cycle
void absIter(unsigned char brakePos);

//Update sensor data
void updSensorData(absData_t* wheel);

//if no braking speed is calulated from rear wheels
//if barking, speed is calculated from vehicle deceleration
int currentSpeed(int deltaTime);

/*
//returns current speed of vehicle
int getVehicleSpeed(void);
*/

//calculates preferred braking force
//if wheel slip is bigger than optimal (set by tyremodel and slip tolerance) or wheel deceleration is too high, brake force is decreased
//if wheel slip is lower than optimal or wheel deceleration is too low, brake force is increased
//otherwise previous braking force is maintained
void calculateBrakeForceReq(absData_t* wheel);

//return slipratio in percentages for wheel
//0 slip means wheel is rolling freely, 100 slip means that wheel is spinning when vehicle is stationary or wheel is locked when vehicle is moving
unsigned char getSilp(absData_t* wheel);

//checks if friction on axle differs too much
unsigned char isMuSplit(absData_t* wheel);

//return brake force in percents (0 is no brakeforce and 100 is full force)
unsigned char setBrakeForce(absData_t* wheel, unsigned char driverReq);

//set one or all abs parameters,
//new values in absParams_t, what is set is defined with absParam
void setAbsParam(unsigned char newValue, absParam param);

//gets pointer to abs parameters
unsigned char getAbsParam(absParam param);
#endif
