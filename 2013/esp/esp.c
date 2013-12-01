#include "esp.h"
#include <stdlib.h>

static espData_t espData;

int corrMoment(void) {
    if(actualYaw() < 12) { //yaw control
        int yawDiff = abs(espData.actualYaw) - abs(desiredYaw(sensordata.steering));
        espData.activeState = YAC;
        if (yawDiff > 0) //Oversteering
            return -yawDiff * espData.yawP;
        else //understeering
            return yawDiff * espData.yawP;
    }
    else { // side slip control
        int slipDiff = abs(desiredSlip(sensordata.steering)) - abs(actualSlip());
        espData.activeState = SSC;
        if(slipDiff > 0) //oversteering
            return -slipDiff * espData.slipP;
        else    //understeering
            return slipDiff * espData.slipP;
    return 0;
}

int desiredYaw(unsigned char steering) {
    espData.yawRequest = steering * getSpeed() / (getWheelbase() * (1 + getSpeed()*getSpeed() / getCharacteristicSpeed())) ;
    return espData.yawRequest;
}

int actualYaw(void) {
    espData.yawActual =  getSensorData(YAWZ);
    return espData.yawActual
}

int desiredSlip(void) {
    double v_lateral = (getSpeed() * getSensorData(YAWZ) + getSensorData(ACCY)) * (esp_b_timer / 1000);
    espData.slipRequest = v_lateral / getSpeed(); // this is not degrees nor rads its tan(side-slip)
}

int actualSlip(unsigned char steering) {
    espData.slipActual = steering * (((vehicle.coeff1 - (vehicle.coeff2 * getSpeed() * getSpeed())) / (vehicle.coeff3 - (getSpeed()*getSpeed() *vehicle.coeff4))));
}


