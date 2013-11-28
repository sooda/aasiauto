#include "abs.h"
#include "tyredata.h"
#include <stdlib.h>

static absData_t FLdata, FRdata, RLdata, RRdata;
static vehicleData_t vehicle;
static absParams_t absParams;

void initAbsData(void) {
    FLdata.otherSide = &FRdata;
    FRdata.otherSide = &FLdata;
    RLdata.otherSide = &RRdata;
    RRdata.otherSide = &RLdata;
    enableAbs();
    setAbsSlipTolerance(10);
    setAbsCutOffSpeed(3);
    setAbsMinAcc(2);
    setAbsMaxAcc(10);
    absParams.muSplitThreshold = 10;
}

void setCurrentSpeed(int deltaTime) {
    if(RRdata.brakeForce == 0 && RLdata.brakeForce == 0)
        vehicle.currentSpeed = (RRdata.speed + RLdata.speed) >> 2;
    else
        vehicle.currentSpeed += getAcc()*time;
}

int getVehicleSpeed(void) {
    return vehicle.currentSpeed;
}

void calculateBrakeForceReq(absData_t* wheel) {
   if (wheel->slip < minSlip(absParams.slipTolerance) || wheel->acc < absParams.minAcc)
       //More power
       wheel->forceReq += 10;
    else if(wheel->slip > maxSlip(absParams.slipTolerance) || wheel->acc > absParams.maxAcc)
        //Less power
        wheel->forceReq -= 10;
    //else
        //Same power
}

unsigned char getSlip(absData_t* wheel) {
    if(getVehicleSpeed() == 0) {
        if(wheel->speed == 0)
            return 0;
        else
            return 100;
    }
    else 
        return (unsigned char)( 100- (wheel->speed/getVehicleSpeed())*100); 
}

unsigned char isMuSplit(absData_t* wheel) {
    if (abs(wheel->forceReq-wheel->otherSide->forceReq) > absParams.muSplitThreshold)
        return 1;
    else
        return 0;
}

unsigned char setBrakeForce(absData_t* wheel, unsigned char driverReq) {
    if (!absParams.enabled || getVehicleSpeed() < absParams.cutOffSpeed)
        return driverReq;
    calculateBrakeForceReq(wheel);
    if(driverReq < wheel->forceReq)
        return driverReq;
    else {
        if((isMuSplit(wheel)) && (wheel->forceReq > wheel->otherSide->forceReq))
            return wheel->otherSide->forceReq;
        else
            return wheel->forceReq;
    }
}

void enableAbs(void) {
    absParams.enabled = 1;
}

void disableAbs(void) {
    absParams.enabled = 0;
}

void setAbsSlipTolerance(unsigned char tolerance) {
    absParams.slipTolerance = tolerance;
}

void setAbsCutOffSpeed(unsigned char speed) {
    absParams.cutOffSpeed = speed;
}

void setAbsMinAcc(unsigned char acc) {
    absParams.minAcc = acc;
}

void setAbsMaxAcc(unsigned char acc) {
    absParams.maxAcc = acc;
}

