#include "abs.h"
#include "tyredata.h"
#include "vehicle.h"
#include "pwm.h"
#include "config.h"
#include "../pid/pid.h"
#include <stdlib.h>

static absData_t FLdata, FRdata, RLdata, RRdata;
static absData_t*[4] wheelData = {&FLdata, &FRdata, &RLdata, &RRdata };
static absParams_t absParams;
static pidData_t accPid, slipPid;

void initAbsData(void) {
    absParams_t defValues = {
        .slipTolerance = 10,
        .enabled = 1,
        .cutOffSpeed = 4,
        .minAcc = 2,
        .maxAcc = 8,
        .muSplitThreshold = 10,
        .accK = 1,
        .accTi = 1,
        .accTd = 0,
        .slipK = 1,
        .slipTi = 1,
        .slipTd = 0,
        .maxCtrl = 100,
        .minCtrl = 0,
    }; 
    FLdata.otherSide = &FRdata;
    FRdata.otherSide = &FLdata;
    RLdata.otherSide = &RRdata;
    RRdata.otherSide = &RLdata;
    setAbsParam(defValues.slipTolerance, SLIPTOLERANCE);
    setAbsParam(defValues.enabled, ENABLED);
    setAbsParam(defValues.cutOffSpeed, CUTOFFSPEED);
    setAbsParam(defValues.minAcc, MINACC);
    setAbsParam(defValues.maxAcc, MAXACC);
    setAbsParam(defValues.muSplitThreshold, MUSPLITTHRESHOLD);
    initPid(&accPid, defValues.accK, defValues.accTi, defValues.accTd);
    initPid(&slipPid, defValues.slipK, defValues.slipTi, defValues.slipTd);
    setLimits(&accPid, defValues.maxCtrl, defValues.minCtrl);
    setLimits(&slipPid, defValues.maxCtrl, defValues.minCtrl);
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
    
    int slipE = int(maxTyreForceIndex()) - int(wheel->slip);
    int accE = ((wheel->maxAcc - wheel->minAcc) >>2 ) - wheel->acc;
    
    wheel->brakeForce += K*ctrl(&slipPid, slipE) + (100-K)*ctrl(&accPid, accE);
    wheel->brakeForce = checkSaturation(&slipPid, wheel->brakeForce);
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
        case ACCK:
            absParams.accK = newValue;
            initPid(&accPid, newValue, accPid->Ti, accPid->Td);
            break;
        case ACCTI:
            absParams.accTi = newValue;
            initPid(&accPid, accPid->K, newValue, accPid->Td);
            break;
        case ACCTD:
            absParams.accTd = newValue;
            initPid(&accPid, accPid->K, accPid->Ti, newValue);
            break;
        case SLIPK:
            absParams.slipK = newValue;
            initPid(&slipPid, newValue, slipPid->Ti, slipPid->Td);
            break;
        case SLIPTI:
            absParams.slipTi = newValue;
            initPid(&slipPid, slipPid->K, newValue, slipPid->Td);
            break;
        case SLIPTD:
            absParams.slipTd = newValue;
            initPid(&slipPid, slipPid->K, slipPid->Ti, newValue);
            break;
        case MAXCTRL:
            absParams.maxCtrl = newValue;
            setLimits(&accPid, newValue, accPid->min);
            setLimits(&slipPid, newValue, slipPid->min);
            break;
        case MINCTRL:
            absParams.minCtrl = newValue;
            setLimits(&accPid, accPid->max, newValue);
            setLimits(&slipPid, slipPid->max, newValue);
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
        case ACCK:
            return absParams.accK;
            break;
        case ACCTI:
            return absParams.accTi;
            break;
        case ACCTD:
            return absParams.accTd;
            break;
        case SLIPK:
            return absParams.slipK;
            break;
        case SLIPTI:
            return absParams.slipTi;
            break;
        case SLIPTD:
            return absParams.slipTd;
            break;
        case MAXCTRL:
            return absParams.maxCtrl;
            break;
        case MINCTRL:
            return absParams.minCtrl;
            break;
        default:
            return -1;
            break;
    }

}

