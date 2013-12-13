#include "abs.h"
#include "tyredata.h"
#include "vehicle.h"
#include "pwm.h"
#include "config.h"
#include "pid.h"
#include <stdlib.h>

static absData_t FLdata, FRdata, RLdata, RRdata;
static absData_t*[4] wheelData = {&FLdata, &FRdata, &RLdata, &RRdata };
static absParams_t absParams;
static pidData_t accPid, slipPid;

void initAbsData(void) {
    absParams_t defaultValues = {
        .slipTolerance = 10,
        .enabled = 1,
        .cutOffSpeed = 4,
        .minAcc = 2,
        .maxAcc = 8,
        .muSplitThreshold = 10,
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

void absIter(unsigned char brakePos) {
    for(unsigned char i = 0; i < 4; ++i)
        updSensordata(wheelData[i]);
    int speed = currentSpeed(1);
    pwm_set(PWM_BRAKE_FL, setBrakeForce(&FLdata, brakePos));
    pwm_set(PWM_BRAKE_FR, setBrakeForce(&FRdata, brakePos));
    pwm_set(PWM_BRAKE_RL, setBrakeForce(&RLdata, brakePos));
    pwm_set(PWM_BRAKE_RR, setBrakeForce(&RRdata, brakePos));
}

void updSensorData(absData_t* wheel) {
//    wheel->speed = 0;
//    wheel->acc = 0;
}

int currentSpeed(int deltaTime) {
    if(RRdata.brakeForce == 0 && RLdata.brakeForce == 0)
        vehicle.speed = (RRdata.speed + RLdata.speed) >> 2;
    else
        vehicle.speed += getAcc()*deltaTime;
}

/*
void calculateBrakeForceReq(absData_t* wheel) {
   if (wheel->slip < minSlip(absParams.slipTolerance) || wheel->acc < absParams.minAcc)
       //More power
       
       wheel->forceReq += MAX(minSlip(absParams.slipTolerance) - wheel->slip, absParams.minAcc - wheel->acc)*absParams.p;
    else if(wheel->slip > maxSlip(absParams.slipTolerance) || wheel->acc > absParams.maxAcc)
        //Less power
        wheel->forceReq -= MAX(wheel->slip - maxSlip(absParams.sliptolerance), wheel->acc - absParams.maxAcc)*absParams.p;
    //else
        //Same power
}
*/

void calculateBrakeForceReq(absDAta_t* wheel) {
    unsigned char K = 0;
    if (wheel->acc < wheel->minAcc)
        K = 100;
    else if(wheel->acc < wheel->maxAcc)
        K = 100- wheel->acc/(wheel->maxAcc-wheel->minAcc);
    
    int slipE = int(maxTyreForceIndex()) - int(wheel->slip) << 7;
    int accE = ((wheel->maxAcc - wheel->minAcc) >>2 ) - wheel->acc;
    
    
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
        case P:
            absParams.p = newValue;
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
        case P:
            return absParams.P;
            break;
        default:
            return -1;
            break;
    }

}

