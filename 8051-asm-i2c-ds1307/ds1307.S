;***I2C Routines for 8051***

; I2C connections

SCL     BIT     P0.0           ;I2C serial clock line
SDA     BIT     P0.1           ;I2C serial data line
;----------------------------------------------------------------

SAW     EQU     0D0H           ;Slave address for write (DS1307)
SAR     EQU     0D1H           ;Slave address for read (DS1307)

;----------------------------------------------------------------

; Data storage locations

BitCnt  DATA    20H            ;Bit counter for I2C routines

;----------------------------------------------------------------

; Delay - insures minimum high and low clock times on I2C bus.
; This routine must be tuned for the actual oscilator frequency used, shown 
; here tuned for a 12MHz clock. Note that the CALL instruction that invokes 
; Delay already uses 2 machine cycles.

DELAY:    
        NOP                    ;NOPs to delay 5 microseconds (minus 4
                               ;machine cycles for CALL and RET)
        RET

;---------------------------------------------------------------

; start I2C communication

I2C_Start:
	SETB      SCL
	SETB      SDA
	ACALL     DELAY
	CLR       SDA
	ACALL     DELAY
	CLR       SCL
	RET

;---------------------------------------------------------------

; stop I2C communication

I2C_Stop:
	CLR       SDA
	SETB      SCL
	ACALL     DELAY
	SETB      SDA
	RET

;---------------------------------------------------------------

; write data to I2C devices

I2C_Write:
	MOV       R1,A
	MOV       BitCnt,#08H
I2C_Write_Loop:
	RLC       A
	MOV       SDA,C
	NOP
	SETB      SCL
	ACALL     DELAY
I2C_Write_Loop_Wait:
	JNB       SCL,$
	CLR       SCL
	DJNZ      BitCnt,I2C_Write_Loop
	NOP
	ACALL     I2C_Ack_Read
	JNC       label
	MOV       A,R1
	ACALL     I2C_Stop
	ACALL     I2C_Start
	SJMP      I2C_Write
label:	
	RET

;---------------------------------------------------------------

;

I2C_Read_Dummy:
	SETB      SDA
	CLR       A
	MOV       BitCnt,#08H
I2C_Read_Loop:
	CLR       SCL
	ACALL     DELAY
	SETB      SCL
I2C_Read_Check:
	JNB       SCL,$
	MOV       C,SDA
	RLC       A
	DJNZ      BitCnt,I2C_Read_Loop
	CLR       SCL
	RET

;---------------------------------------------------------------

;

I2C_Ack_Write:
	CLR       SDA
	NOP
	SETB      SCL
	ACALL     DELAY	
	CLR       SCL
	SETB      SDA
	ACALL     DELAY
	RET

;---------------------------------------------------------------

;

I2C_Ack_Read:
	SETB      SDA
	NOP
	SETB      SCL
	ACALL     DELAY
	MOV       C,SDA
	CLR       SCL
	NOP
	RET

;---------------------------------------------------------------

;

I2C_Nack_Write:
	SETB      SDA
	NOP
	SETB      SCL
	ACALL     DELAY
	CLR       SCL
	ACALL     DELAY
	RET 

;---------------------------------------------------------------

;

I2C_Read:
	ACALL     I2C_Read_Dummy
	ACALL     I2C_Ack_Write
	RET

;---------------------------------------------------------------

;

I2C_Read_Last:
	ACALL     I2C_Read_Dummy
	ACALL     I2C_Nack_Write
	RET

;---------------------------------------------------------------
        END
