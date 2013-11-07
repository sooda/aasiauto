#ifndef RCCAR_USART_H
#define RCCAR_USART_H

#define BAUDRATE 38400
#define UBRRVALUE F_CPU / (16*BAUDRATE) -1

void initUSART(void);
unsigned char RxByteUSART(void);
void TxByteUSART(unsigned char byte);

#endif
