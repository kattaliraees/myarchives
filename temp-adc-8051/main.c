#include <reg52.h>
#include <functions_proto.h>

/*
 *
 *	 Global Variable initializattion
 *
 */
unsigned char value_binary; //ADC output value
unsigned char comm[] = {0x38,0x0E,0x01,0x06,0x80,0};	/* LCD Initialaztion commands */


/*
 *
 *	 Main Function
 *
 */
void main(void)
{
	variable_peripheral_config();

	while(1)
	{
		temp_Sensor();
		msdelay(2000);
	}
}
/**************End of Main********************/
void timer1_ISR (void) interrupt 3
{
	CLK = ~CLK;
}

void variable_peripheral_config(void)
{
	unsigned int i;

	buzzerON();
	value_binary = 0;

	/*******Added for providing clock to ADC*****************/
	TMOD = (TMOD & 0x0F) | 0x20;  /* Set Mode (8-bit timer with reload) */
	TH1 = 256 - 2;              /* Reload TL1 to count 100 clocks */
	TL1 = TH1;
	ET1 = 1;                      /* Enable Timer 1 Interrupt */
	TF1 = 0;					  /* Clear Timer 1 Interrupt Flag */
	TR1 = 1;                      /* Start Timer 1 Running */
	CLK = 0;					  /* set pin as output */
	EA = 1;                       /* Global Interrupt Enable */
	/***************************************************************/
	
	ADC_data = 0xff; 	// input port1
	ALE = 0; 			// ALE should be low to high
	start = 0; 			// Start of conv should be low to high
	
	for(i = 0;comm[i] != 0;i++)
	{
		lcdcmd(comm[i]);
	}
}

void buzzerON(void) // Welcome Note Buzzer
{
	buzzer = 1;
	msdelay(10);
	buzzer = 0;
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
	for (i  =0;mesg[i] != '$';i++)
	{
		lcddata(mesg[i]);
		msdelay(5);
	}
	return;
}

void ADC_value(void)
{
	ADD_A = 0;
	ADD_B = 0;
	value_binary = 0;

	ALE = 0;
	msdelay(1);
	ALE = 1;

	start = 0;
	msdelay(1);
	start = 1;


	msdelay(1);
	ALE = 0;
	start = 0;
	msdelay(5);
	value_binary = ADC_data;
}

void temp_Sensor(void)
{
	unsigned int temp = 0;
	unsigned char ones_position = 0,tens_position = 0,hundreds_position = 0;
	ADC_value();
	lcdcmd(0xc0); 				//first line in LCD
	if(value_binary > 0x66)
	{
		Display("Error $");
		msdelay(2000);
	}
	else
	{
		temp =	temperature_conversion(value_binary);
		hundreds_position = temp >> 8;
		hundreds_position = (hundreds_position & 0x0F) + 0x30;
		tens_position = temp >> 4;
		tens_position = (tens_position & 0x0F) + 0x30;
	
		ones_position = temp & 0x000F; 
		ones_position = ones_position + 0x30;
	
		Display("T :$");
		if(temp & 0x0F00)
		{
			lcddata(hundreds_position);
		}
		lcddata(tens_position);
		lcddata(ones_position);
	}

	if(value_binary > 80)
	{
		  buzzerON();
		  value_binary = 0;
	}
}

unsigned int temperature_conversion(unsigned char dat)
{
	unsigned int val2 = 0;
	unsigned char val1 = 0;
	val1 = dat;
	while(val1--)
	{
		val2++;
		if((val2 & 0x00F0) == 0x00A0)
		{
			val2 = ((val2 & 0xF00F) | 0x0100);
		}
		if((val2 & 0x000F) == 0x0A)
		{
			val2--;
			val2 = ((val2 + 0x10) & 0x00F0);
		}
	}
	return val2;
}








