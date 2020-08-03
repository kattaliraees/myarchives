#include<reg52.h>

sfr		ldata = 0x80; 		// port 0 LCD data
sbit	rs = P2^2;
sbit 	rw = P2^1;
sbit 	en = P2^0;

void LCD_Init(void);
void lcddata(unsigned char value1);
void msdelay(unsigned int itime);
void Display(unsigned char mesg[]);
void lcdcmd(unsigned char value);
