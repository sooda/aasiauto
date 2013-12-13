#include "pid.h"
#include <stdio.h>

pidData_t pidData;

int main(void)
{
    int referenceValue, measurementValue, prevError, stabilizeCount = 0;
    initPid(&pidData, 1, 1, 1);
    setLimits(&pidData, 100, 0);
    referenceValue = 50;
    printf("PID K: %d I: %d D: %d\n", pidData.K, pidData.Ti, pidData.Td);
    printf("Control %d\n", ctrl(&pidData, 50, 0));
    printf("Control %d\n", ctrl(&pidData, 50, 50));
    return 0;
}

