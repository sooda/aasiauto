#include "abs.h"

typedef enum {
    DISABLED,
    YAC,
    SSC,
} espCtrl;

typedef struct {
    unsigned char enabled;
    unsigned char yawP;
    unsigned char slipP;
    espCtrl activeState;
    int yawRequest;
    int yawActual;
    int slipActual;
    int slipRequest;
} espData_t;



//Needed moment to stabilize vehicle
//negative means counter-clockwise moment
int corrMoment(void);

//actual Yaw angle from sensor
void actualYaw(void);

//Requested yaw angle from driver input
//Calculated from steering wheel input and vehicle parameters
void desiredYaw(unsigned char steering);

//Actual slip angle
void actualSlip(unsigned char steering);

//desired slip angle
void desiredSlip(void);


