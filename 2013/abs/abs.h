#ifndef RCCAR_ABS_H
#define RCCAR_ABS_H

typedef struct absData_t absData_t;

//Datatype for holding wheel information for abs algorithm
struct absData_t {
    unsigned char slip;
    unsigned char forceReq;
    int speed;
    int acc;
    absData_t* otherSide;
};

//Datatype for holding vehicle information for abs algorithm
//Maybe should be moved to vehicle.c?
typedef struct {
    int currentSpeed;
} vehicleData_t;

//Abs parameters
typedef struct {
    unsigned char slipTolerance;
    unsigned char enabled;
    unsigned char cutOffSpeed;
    unsigned char minAcc;
    unsigned char maxAcc;
    unsigned char muSplitThreshold;
}absParams_t;

//initialize abs system with default settings
void initAbsData(void);

//if no braking speed is calulated from rear wheels
//if barking, speed is calculated from vehicle deceleration
void setCurrentSpeed(int deltaTime);

//returns current speed of vehicle
int getVehicleSpeed(void);

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

//enable or disable abs braking
void enableAbs(void);
void disableAbs(void);

//set different abs parameters
//slip tolerance = how much slip can differ from optimal
//abs cut-off speed = below this speed abs is not enabled
//min and max acc = acceleration thresholds for wheel acceleration
void setAbsSlipTolerance(unsigned char tolerance);
void setAbsCutOffSpeed(unsigned char speed);
void setAbsMinAcc(unsigned char acc);
void setAbsMaxAcc(unsigned char acc);
#endif
