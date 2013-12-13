#include "pid.h"

void initPid(pidData_t* pid, int K, int Ti, int Td) {
    pid->K = K << 8;
    pid->Ti = Ti << 8;
    pid->Td = Td << 8;
}

void setLimits(pidData_t* pid, int max, int min) {
    pid->max = max << 8;
    pid->min = min << 8;
}

int ctrl(pidData_t* pid, int error) {
    int pCtrl = 0, tiCtrl = 0, tdCtrl = 0;
    pCtrl = pid->K*error;
    tdCtrl = pid->Td*(error-pid->prevError);
    if((pid->prevError+error) > pid->max && pid->Ti)
        tiCtrl = pid->max;
    else if((pid->prevError+error) < pid->min && pid->Ti)
        tiCtrl = pid->min;
    else
        if(pid->Ti)
            tiCtrl = pid->Ti*(pid->prevError+error);
        pid->prevError += error;
    }
    return ((pCtrl + tiCtrl + tdCtrl) > pid->max) ? pid->max >> 8 : (pCtrl+tiCtrl+tdCtrl) >> 8;

}



