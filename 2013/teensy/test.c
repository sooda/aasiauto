#include "wheelSpeeds.h"
#include <stdio.h>

int main(void) {
    initWheelData();
    /**
    for(unsigned int round = 0; round < 10; ++round) {
        printf("Front Left buffer index: %d, data: %d\n", round, FLeft.Buffer[round]);
        for(unsigned int i = 0; i < 20; ++i) {
            addFLCounter();
            addFRCounter();
            addRLCounter();
            addRRCounter();
        }
        if (round % 2) {
           for(unsigned int j = 0; j < 10; ++j)
              addFRCounter();
        } 
        updateSpeeds();
        printf("Front right buffer index: %d, data: %d\n", round, FRight.Buffer[round]);
    }
    **/
    for (unsigned int i = 0; i < BUFSIZE; ++i) { 
        FRight.Counter = i;
        updateSpeeds();
    }
    for (unsigned int i = 0; i < BUFSIZE; ++i)
        printf("%d ",FRight.Buffer[i]);
    printf("\n");
    rData_t speed = getSpeeds();
    rData_t acc = getAccelerations();
    printf("Max front right: %d\n", max(&FRight));
    printf("Min front right: %d\n", min(&FRight));
    for (unsigned int i = 0; i < BUFSIZE; ++i)
        printf("%d ",FRight.Buffer[i]);
    printf("\n");
    printf("Front left speed: %d Acc: %d \n", speed.FLeft, acc.FLeft);
    printf("Front right speed: %d Acc: %d \n", speed.FRight, acc.FRight);
    printf("Rear left speed: %d Acc: %d \n", speed.RLeft, acc.RLeft);
    printf("Rear Right speed: %d Acc: %d \n", speed.RRight, acc.RRight);
    return 0;
}

