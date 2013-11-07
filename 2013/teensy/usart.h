#ifndef RCCAR_USART_H
#define RCCAR_USART_H

#define BAUDRATE 38400
#define UBRRVALUE F_CPU / (16*BAUDRATE) -1

void initUSART(void);
void RxByteUSART(unsigned char byte);
unsigned char TxByteUSART(void);

#endif
