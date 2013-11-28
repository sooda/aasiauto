#include "tyredata.h"

unsigned char getTyreForce(unsigned char slip) {
    return tyreData[slip];
}

unsigned char maxTyreForce(void) {
    unsigned char max = 0;
    for(unsigned char i = 0; i < 101; ++i) {
        if(tyreData[i] > max)
            max = tyreData[i];
    }
    return max;
}

unsigned char maxTyreForceIndex(void) {
    unsigned char max = 0;
    unsigned char index = 0;
    for(unsigned char i = 0; i < 101; ++i) {
        if(tyreData[i] > max) {
            max = tyreData[i];
            index = i;
        }
    }
    return index;
}

unsigned char maxSlip(unsigned char diff) {
    unsigned char max = maxTyreForce();
    for(unsigned char i = maxTyreForceIndex(); i < 101; ++i) {
        if(tyreData[i] < max-diff)
            return i-1;
    }
    return maxTyreForceIndex();
}

unsigned char minSlip(unsigned char diff) {
    unsigned char max = maxTyreForce();
    for(unsigned char i = maxTyreForceIndex(); i >=0; --i) {
        if(tyreData[i] < max-diff)
            return i+1;
    }
    return maxTyreForceIndex();
}

