#ifndef PID_RCCAR_H
#define PID_RCCAR_H

#define SAMPLETIME_MS 10
#define INV_SAMPLETIME_MS 1/SAMPLETIME_MS

typedef struct {
    int K;
    int Ti;
    int Td;
    int min;
    int max;
    int errors[2];
} pidData_t;

void initPid(pidData_t* pid, int K, int Ti, int Td);

void setLimits(pidData_t* pid, int max, int min);
int ctrl(pidData_t* pid, int error);
int checkSaturation(pidData_t* pid, int ctrl);

#endif
