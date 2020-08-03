#include <lcd.h>

unsigned char comm[] = {0x38,0x0E,0x01,0x06,0x80,0x00};

void LCD_Init(void)
{
	int i;
	ldata = 0x00;
	for(i = 0;comm[i] != 0x00;i++)
	{
		lcdcmd(comm[i]);
	}
}


/*Function for writing a command to the LCD
 *
 */
void lcdcmd(unsigned char value) // LCD Commands
{
	ldata = value;
	rs = 0;
	rw = 0;
	en = 1;
	msdelay(1);
	en = 0;
	return;
}



/*Function for writing a single charactor to the LCD
 *
 */
void lcddata(unsigned char value1)
{
	ldata=value1;
	rs = 1;
	rw = 0;
	en = 1;
	msdelay(1);
	en = 0;
	return;
}

/*Delay Function for providing delay
 *Passing 1 will get 1 ms delay and so on
 */
void msdelay(unsigned int itime )
{
	unsigned int i, j;
	for(i = 0;i < itime;i++)
	for(j = 0;j < 112;j++);
}

/*Function for writing a charactor string to the LCD
 *
 */
void Display(unsigned char mesg[])
{
	unsigned char i;
	for (i = 0;mesg[i] != '$';i++)
	{
		lcddata(mesg[i]);
		msdelay(5);
	}
}

