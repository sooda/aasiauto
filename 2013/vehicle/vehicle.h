#ifndef RCCAR_VEHICLE_H
#define RCCAR_VEHICLE_H
//Datatype for holding vehicle information for algorithms
typedef struct {
    int wb; //wheelbase
    int cgDistR; //center of gravity distance from rear axle
    int cgDistF; //center of gravity distance from front axle
    int cF; //Front cornering stiffness
    int cR; //rear cornering stiffness
    int mass; //wehicle mass
} vehicleData_t;

typedef struct {
    int cSpeed; //characteristic speed v^2
    int coeff1; //coefficiencies calculated after parameter update
    int coeff2; //used for slip angle estimation
    int coeff3;
    int coeff4;
} paramData_t;

typedef struct {
    int speedFL;
    int speedFR;
    int speedRR;
    int speedRL;
    int speed;
    int yawZ;
    int accY;
    int accX;
} sensorData_t;

typedef struct {
    int steeringAngle;
    unsigned char throttlePosition;
} driverInput_t;

int accY(void);
int accX(void);
int yawZ(void);

void updateSensors(void);

void calculateCharacteristicSpeed(void);

void updateVehicleParams(vehicleData_t* newParams);

vehicleData_t* vehicleData(void);
sensorData_t* sensorData(void);
driverInput_t* driverInput(void);

#endif

