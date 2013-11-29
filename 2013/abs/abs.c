#include "abs.h"
#include "tyredata.h"
#include "vehicle.h"
#include <stdlib.h>

static absData_t FLdata, FRdata, RLdata, RRdata;
static vehicleData_t vehicle;
static absParams_t absParams;

void initAbsData(void) {
    absParams_t defaultValues = {
        .slipTolerance = 10,
        .enabled = 1,
        .cutOffSpeed = 4,
        .minAcc = 2,
        .maxAcc = 8,
        .muSplitThreshold = 10
    };
    FLdata.otherSide = &FRdata;
    FRdata.otherSide = &FLdata;
    RLdata.otherSide = &RRdata;
    RRdata.otherSide = &RLdata;
    setAbsParam(defaultValues.slipTolerance, SLIPTOLERANCE);
    setAbsParam(defaultValues.enabled, ENABLED);
    setAbsParam(defaultValues.cutOffSpeed, CUTOFFSPEED);
    setAbsParam(defaultValues.minAcc, MINACC);
    setAbsParam(defaultValues.maxAcc, MAXACC);
    setAbsParam(defaultValues.muSplitThreshold, MUSPLITTHRESHOLD);
}

void setCurrentSpeed(int deltaTime) {
    if(RRdata.brakeForce == 0 && RLdata.brakeForce == 0)
        vehicle.currentSpeed = (RRdata.speed + RLdata.speed) >> 2;
    else
        vehicle.currentSpeed += getAcc()*deltaTime;
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
        wheel->brakeForce = driverReq;
    calculateBrakeForceReq(wheel);
    if(driverReq < wheel->forceReq)
        wheel->brakeForce = driverReq;
    else {
        if((isMuSplit(wheel)) && (wheel->forceReq > wheel->otherSide->forceReq))
            wheel->brakeForce = wheel->otherSide->forceReq;
        else
            wheel->brakeForce = wheel->forceReq;
    }
    return wheel->brakeForce;
}

void setAbsParam(unsigned char newValue, absParam param) {
    switch(param) {
        case SLIPTOLERANCE:
            absParams.slipTolerance = newValue;
            break;
        case ENABLED:
            absParams.enabled = newValue;
            break;
        case CUTOFFSPEED:
            absParams.cutOffSpeed = newValue;
            break;
        case MINACC:
            absParams.minAcc = newValue;
            break;
        case MAXACC:
            absParams.maxAcc = newValue;
            break;
        case MUSPLITTHRESHOLD:
            absParams.muSplitThreshold = newValue;
            break;
        default:
            break;
    }
}

unsigned char getAbsParam(absParam param) {
    switch(param) {
        case SLIPTOLERANCE:
            return absParams.slipTolerance;
            break;
        case ENABLED:
            return absParams.enabled;
            break;
        case CUTOFFSPEED:
            return absParams.cutOffSpeed;
            break;
        case MINACC:
            return absParams.minAcc;
            break;
        case MAXACC:
            return absParams.maxAcc;
            break;
        case MUSPLITTHRESHOLD:
            return absParams.muSplitThreshold;
            break;
        default:
            return -1;
            break;
    }

}

