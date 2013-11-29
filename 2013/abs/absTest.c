#include "abs.h"
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
const char *strs[ABSPARAM_MAX];

void printParams(void) {
    printf("Printing default ABS-parameters\n");
    printf("Enabled: %d\n", getAbsParam(ENABLED));
    printf("Slip tolerance: %d\n", getAbsParam(SLIPTOLERANCE));
    printf("Cut-off speed: %d\n", getAbsParam(CUTOFFSPEED));
    printf("Min-Acc for wheel: %d\n", getAbsParam(MINACC));
    printf("Max-acc for wheel: %u\n", getAbsParam(MAXACC));
    printf("Mu-split threshold: %u\n", getAbsParam(MUSPLITTHRESHOLD));
    
}

void testParameterChange(absParam param, unsigned char value) {
    printf("Set %s to %u: ", strs[param], value);
    setAbsParam(value, param);
    if(getAbsParam(param) == value)
        printf("success");
    else
        printf("failed");
    printf("\n");
}
    
int main(void) {
    srand(time(NULL));
    strs[SLIPTOLERANCE] = "Slip tolerance";
    strs[ENABLED] = "Enabled";
    strs[CUTOFFSPEED] = "Cut-off speed";
    strs[MINACC] = "Minimum acc";
    strs[MAXACC] = "Max acc";
    strs[MUSPLITTHRESHOLD] = "Mu-split threshold";
    printf("ABS-test\n");
    initAbsData();
    printParams();
    printf("Set new parameters:\n");
    for(size_t i = 0; i < ABSPARAM_MAX; ++i) 
        testParameterChange(i, rand()%100);
    printParams();
    return 0;
}

