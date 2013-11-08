#ifndef RCCAR_WHLSPEEDS_H
#define RCCAR_WHLSPEEDS_H

#define BUFSIZE 8

typedef struct {
    int Speed;
    int Acceleration;
    unsigned int Counter;
    unsigned char Buffer[BUFSIZE];
    unsigned char Time;
} whlData_t ;

typedef struct {
    int FLeft;
    int FRight;
    int RLeft;
    int RRight;
} rData_t;

void initWheelData(void);

void updateSpeeds(void);

int updateAcc(whlData_t* wheel);

int avgSpeed(whlData_t*);
unsigned char min(whlData_t*);
unsigned char max(whlData_t*);

void addFLCounter(void);
void addFRCounter(void);
void addRLCounter(void);
void addRRCounter(void);

rData_t getSpeeds(void);
rData_t getAccelerations(void);

#endif

