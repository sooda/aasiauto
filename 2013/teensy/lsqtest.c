#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "lsq.h"
unsigned char data[8] = {0, 1, 2, 3, 4, 5, 6, 7};

void print(void) {
    printf("\nData;\nX;");
    for(unsigned char i = 0; i < 8; ++i)
        printf("%d;", i+1);
    printf("\nY;");
    for(unsigned char i = 0; i < 8; ++i)
        printf("%d;", data[i]);
    printf("\nSlope; %d", slope(data));
}

int main(void) {
    srand(time(NULL));
    printf("\nSlope;1");
    print();
    printf("\nSlope;0");
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 1;
    print();
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 100;
    print();
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 255;
    print();
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 0;
    print();
    printf("\nSlope;Max");
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = i*36;
    print();
    printf("\nSlope;Min");
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 255 - i*36;
    print();
    printf("\nSlope;Rand"); 
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 0 + (rand() % 10);
    print();
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 10*i+(rand() % 10);
    print();
    for (unsigned char i = 0; i < 8; ++i)
        data[i] = 100-10*i + (rand() %10);
    print();
    return 0;
}
