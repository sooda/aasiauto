#ifndef RCCAR_ABS_H
#define RCCAR_ABS_H

typedef struct absData_t absData_t;

void initAbsData(void);

struct absData_t {
    unsigned char slip;
    unsigned char forceReq;
    int speed;
    int acc;
    absData_t* otherSide;
};

typedef struct {
    int currentSpeed;
} vehicleData_t;

typedef struct {
    unsigned char slipTolerance;
    unsigned char enabled;
    unsigned char cutOffSpeed;
    unsigned char minAcc;
    unsigned char maxAcc;
}absParams_t;


void setCurrentSpeed(int deltaTime);

int getVehicleSpeed(void);

void calculateBrakeForceReq(absData_t* wheel);

unsigned char getSilp(absData_t* wheel);

unsigned char isMuSplit(absData_t* wheel);

unsigned char setBrakeForce(absData_t* wheel, unsigned char driverReq);

void enableAbs(void);
void disableAbs(void);

void setAbsSlipTolerance(unsigned char tolerance);
void setAbsCutOffSpeed(unsigned char speed);
void setAbsMinAcc(unsigned char acc);
void setAbsMaxAcc(unsigned char acc);
#endif
