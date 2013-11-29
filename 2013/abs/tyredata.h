#ifndef RCCAR_TYREDATA_H
#define RCCAR_TYREDATA_H

unsigned char getTyreForce(unsigned char slip);

unsigned char maxTyreForce(void);

unsigned char maxTyreForceIndex(void);

unsigned char maxSlip(unsigned char diff);

unsigned char minSlip(unsigned char diff);

#endif
