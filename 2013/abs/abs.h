#ifndef RCCAR_ABS_H
#define RCCAR_ABS_H

struct otherSide;

typedef struct {
    unsigned char slip;
    unsigned char brakeForce;
    int whlSpeed;
    int whlAcc;
    absData_t* otherSide;
} absData_t;

typedef struct {
    int initialSpeed;
    int t;
} vehicleData_t;

void setInitialSpeed(int speed);
void calculateCurrentSpeed(int time);

int getVehicleSpeed(void);

unsigned char getSilp(wheel);

unsigned char isMuSplit(wheel);

void setBrakeForce(wheel);


#endif
