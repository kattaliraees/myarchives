/* ADC pins Initialisation: */

sbit CLK = P3^0;
sbit start = P3^1;
sbit ADD_A = P3^4;
sbit ADD_B = P3^5;
sbit ALE = P3^7;

sbit rs = P2^5;
sbit rw = P2^6;
sbit en = P2^7;

sbit buzzer = P3^6;
sfr ldata = 0x80; 		// port 0 LCD data
sfr ADC_data  = 0x90;	// port 1 ADC input


/*functions proto-types */
unsigned int temperature_conversion(unsigned char dat);
void ADC_value(void);
void buzzerON(void);
void temp_Sensor(void);
void lcdcmd(unsigned char value);
void lcddata(unsigned char value1);
void msdelay(unsigned int itime); // Delay of 1mesc
void Display(unsigned char[]);
void variable_peripheral_config();
void timer1_ISR (void);
