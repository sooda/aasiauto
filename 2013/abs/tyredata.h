#ifndef RCCAR_WHEELDATA_H
#define RCCAR_WHEELDATA_H

unsigned char tyreData[101] = {0,8,16,23,30,36,42,47,52,56,60,64,67,69,72,74,76,77,78,79,80,80,81,81,81,80,80,80,79,79,78,77,77,76,75,75,74,74,73,73,72,71,71,71,70,70,69,69,69,68,68,68,68,67,67,67,67,67,66,66,66,66,66,65,65,65,65,65,65,65,64,64,64,64,64,64,64,63,63,63,63,63,63,63,63,62,62,62,62,62,62,62,62,62,62,61,61,61,61,61,61};

unsigned char getTyreForce(unsigned char slip);

unsigned char maxTyreForce(void);

unsigned char maxTyreForceIndex(void);

unsigned char maxSlip(unsigned char diff);

unsigned char minSlip(unsigned char diff);

#endif
