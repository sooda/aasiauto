#ifndef RCCAR_ABS_H
#define RCCAR_ABS_H

typedef struct absData_t absData_t;

void initAbsData(void);

struct absData_t {
    unsigned char slip;
    unsigned char brakeForce;
    int whlSpeed;
    int whlAcc;
    absData_t* otherSide;
};

typedef struct {
    int initialSpeed;
    int t;
} vehicleData_t;

void setInitialSpeed(int speed);
void calculateCurrentSpeed(int time);

int getVehicleSpeed(void);

unsigned char getSilp(absData_t wheel);

unsigned char isMuSplit(absData_t wheel);

void setBrakeForce(absData_t wheel);


#endif
