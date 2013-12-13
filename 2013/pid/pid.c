#include "pid.h"

void initPid(pidData_t* pid, int K, int Ti, int Td) {
    pid->K = K << 8;
    pid->Ti = Ti << 8;
    pid->Td = Td << 8;
    pid->errors[0] = 0;
    pid->errors[1] = 0;
}

void setLimits(pidData_t* pid, int max, int min) {
    pid->max = max << 8;
    pid->min = min << 8;
}

int ctrl(pidData_t* pid, int error) {
    int pCtrl = 0, tiCtrl = 0, tdCtrl = 0;
    pCtrl = pid->K*(error-pid->errors[0]);
    tdCtrl = pid->Td*(error - 2*pid->errors([0] + pid->errors[2]);
    tiCtrl = pid->Ti*pid->errors[0]
    return pCtrl + tdCtrl + tiCtrl;
}

int checkSaturation(pidData_t* pid, int ctrl) {
    if(ctrl > pid->max)
        return pid->max;
    else if (ctrl < pid-min)
        return pid->min;
    else
        return ctrl;
}



