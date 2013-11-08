#include "wheelSpeeds.h"
#include "lsq.h"

static whlData_t FLeft, FRight, RLeft, RRight;
static whlData_t* Wheels[4] = { &FLeft, &FRight, &RLeft, &RRight };

void initWheelData(void) {
    for(unsigned char i = 0; i < 4; i++) {
        Wheels[i]->Speed = 0;
        Wheels[i]->Acceleration = 0;
        Wheels[i]->Counter = 0;
        Wheels[i]->Time = 0;
        for(unsigned char j = 0; j < BUFSIZE; ++j)
            Wheels[i]->Buffer[j] = 0;
    }
}

void updateSpeeds(void) {
    for(unsigned char i = 0; i < 4; ++i) {
        Wheels[i]->Buffer[Wheels[i]->Time] = Wheels[i]->Counter;
        Wheels[i]->Counter = 0; 
        if(Wheels[i]->Time == (BUFSIZE -1)) {
            Wheels[i]->Speed = avgSpeed(Wheels[i]);
            Wheels[i]->Acceleration = updateAcc(Wheels[i]);
            Wheels[i]->Time = 0;
        }
        else {
            Wheels[i]->Time++;
        }
        
    }
}

unsigned char max(whlData_t* wheel) {
    unsigned char max = 0;
    for(unsigned char i = 0; i < BUFSIZE; ++i) {
        if(wheel->Buffer[i] > max) 
            max = wheel->Buffer[i];
    }
    return max;
}

unsigned char min(whlData_t* wheel) {
    unsigned char min = 255;
    for(unsigned char i = 0; i < BUFSIZE; ++i) {
        if(wheel->Buffer[i] < min)
            min = wheel->Buffer[i];
    }
    return min;
}
int avgSpeed(whlData_t* wheel) {
    int speed = 0;
    for(unsigned char j = 0; j < BUFSIZE; ++j)
        speed += wheel->Buffer[j] << 4;
    speed = speed >> 3;
    return speed;
}

int updateAcc(whlData_t* wheel) {
    return slope(wheel->Buffer);
}

void addFLCounter(void) {
    FLeft.Counter++;
}

void addFRCounter(void) {
    FRight.Counter++;
}

void addRLCounter(void) {
    RLeft.Counter++;
}

void addRRCounter(void) {
    RRight.Counter++;
}

rData_t getSpeeds(void) {
    rData_t data;
    data.FLeft = FLeft.Speed;
    data.FRight = FRight.Speed;
    data.RLeft = RLeft.Speed;
    data.RRight = RRight.Speed;
    return data;
}

rData_t getAccelerations(void) {
    rData_t data;
    data.FLeft = FLeft.Acceleration;
    data.FRight = FRight.Acceleration;
    data.RLeft = RLeft.Acceleration;
    data.RRight = RRight.Acceleration;
    return data;
}


