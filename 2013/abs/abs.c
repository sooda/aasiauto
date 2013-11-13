#include "abs.h"

static absData_t FLdata, FRdata, RLdata, RRdata;
FLdata.otherSide = &FRdata;
FRdata.otherSide = &FLdata;
RLdata.otherSide = &RRdata;
RRdata.otherSide = &RLdata;

static vehicleData_t vehicle;

void setInitialSpeed(int speed) {
    vehicle.Speed = initialSpeed;
    vehicle.t = 0;
}

void calculateCurrentSpeed(int time) {
    
}

int getVehicleSpeed(void) {

