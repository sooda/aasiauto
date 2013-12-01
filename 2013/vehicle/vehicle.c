#include "vehicle.h"

static vehicleData_t vData;
static sensorData_t sData;
static paramData_t paramData;
static driverInput_t dInput;

int getAccY() {
    int accY;//READ FROM SENSOR
    return accY; 
}

int getAccX() {
    int accX;
    //READ FROM SENSOR
    return accX;
}

int getYawZ() {
    int yawZ;
    //READ FROM SENSOR
    return yawZ;
}
void updateSensors(void) {
    sData.AccY = getAccY();
    sData.AxxX = getAccX();
    sData.YawZ = getYawZ();
}

void calculateCharacteristicSpeed(void) {
    paramData.cSpeed = (vData.cF * vData.cR*vData.wb * vData*wb) / (vData.mass * (vData.cF*vData.cgDistF*vData.cR*vData.cgDistR));
}

void updateVehicleParams(vehicleData_t* newParams) {
    vData = *newParams;
    paramData.coeff1 = vData.cgDistR*vData.wb*vData.cF*vData.cR;
    paramData.coeff2 = vData.cF*vData.cgDistR*vData.mass;
    paramData.coeff3 = vData.wb*vData.wb*vData.cF*vData.cR;
    paramData.coeff4 = vData.mass*(vData.cF*vData.cgDistF-vData.cR*vData.cgDistR);
    calculateCharasteristicSpeed();
}

vehicleData_t* vehicleData(void) {
    return &vData;
}

sensorData_t* sensorData(void) {
    return &sData;
}

driverInput_t* driverInput(void) {
    return &dInput;
}
