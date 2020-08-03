#INCLUDE<P16F877.INC>
ORG		00H
BANKSEL	TRISD	;Select bank 1
MOVLW	00H		;clear W reg,W=00H	
MOVWF	23H		;23H=W
MOVWF	TRISD	;clear TRISD for set PORTD as output port
BANKSEL	PORTD	;Select bank 0	
MOVLW	50H		;w=50H
MOVWF	20H		;20H=50H
MOVLW	1AH		;W=1AH
MOVWF	21H		;21H=1Ah
ADDWF	20H,W	;Add the content of W with the content of 
                                		 20H & store the result I W registor
MOVWF	22H		;copy the result to 22H
BTFSC	STATUS,C	;If carry occur execute next line otherwise skip it
INCF		23H,F		;Increment  22H
MOVWF	PORTD	;Give the result to PORTD
GOTO		$		;Halt the program here
END	

#INCLUDE<P16F877.INC>
ORG		00H
BANKSEL	TRISD	;Select bank 1
MOVLW	00H		;clear W reg,W=00H	
MOVWF	23H		;23H=W
MOVWF	TRISD	;clear TRISD for set PORTD as output port
BANKSEL	PORTD	;Select bank 0	
MOVLW	50H		;w=50H
MOVWF	20H		;20H=50H
MOVLW	1AH		;W=1AH
MOVWF	21H		;21H=1Ah
SUBWF	20H,W	;Subtract the content of W reg from 20H
MOVWF	22H		;Copy the result to 22H
MOVWF	PORTD	;Give the result to PORTD
GOTO		$		;Halt
END

#INCLUDE<P16F877.INC>
ORG		00H		
MOVLW	21H		;W=21H
MOVWF	FSR		;FSR=21H
MOVLW	05H		;W=05H
MOVWF	20H		;20H=05H
CLRW				;clear W registor
MOVWF	30H		;30H=00H
LOOP
ADDWF	INDF,W	;add the content of w reg and the content of
				 address location hold by FSR
BTFSC	STATUS,C	;If  carry occurs,execute next line else skip it
INCF		30H,F		;Increment 30H
INCF		FSR		;Increment FSR 
DECFSZ	20H,1		;Decrement 20H & skip next line when 20H=0
GOTO		LOOP
MOVWF	31H		;Copy the result to 31H
GOTO		$		;Halt  the program here
END


#INCLUDE<P16F877.INC>
ORG		00H
MOVLW	36H		;W=36H
MOVWF	20H		;20H=36H
CLRW				;W=00H
CLRF		23h		;23H=00h
LOOP
ADDLW	63H		;Add W with constant 63H
BTFSC	STATUS,C	;If carry occure execute next line else skip it
INCF		23H,1		;Increment 23H
DECFSZ	20H,1		;Decrement 20H & skip next line when 20H=00H
GOTO		LOOP
MOVWF	22H		;Copy the result to 22H
BANKSEL	TRISD	;Select bank 1
CLRW				;W=00H
MOVWF	TRISD	;Clear TRISD to set PORTD as output port
MOVWF	TRISB	;Clear TRISB to set PORTB as output port
BANKSEL	PORTD	;Select bank 0
MOVF		23H,W	;Copy the MSB of answer to W
MOVWF	PORTD	;give MSB to PORTD
MOVF		22H,W	;Copy the LSB of answer to W
MOVWF	PORTB	;give LSB to PORTB
GOTO		$		;Halt
END

#INCLUDE<P16F877.INC>
ORG		00H
MOVLW	11H		;W=11H
MOVWF	31H		;31H=11H
MOVLW	20H		;W=20H
MOVWF	FSR		;FSR=20H
LOOP
CLRF		INDF		;Clear addres location hold by FSR		
INCF		FSR		;Increment FSR
DECFSZ	31H,F		;Decrement 31H & skip next line when 31H=00H
GOTO		LOOP
GOTO		$		;Halt program here
END

#INCLUDE<P16F877.INC>
ORG		00H
CLRW				;W=00H
BANKSEL	TRISD	;Select  bank 1
MOVWF	TRISD	;Clear  TRISD to set PORTD as output port
BANKSEL 	PORTD	;Select bank 1
MOVWF	PORTD	;Clear PORTD
LOOP
CALL		DELAY	
INCF		PORTD,F	;Increment  PORTD
GOTO		LOOP
DELAY
MOVLW	0FFH
MOVWF	20H
RETURN			;Returns from the subroutine
END

#INCLUDE<P16F877.INC>
ORG		00H
CLRW				;W=00H
BANKSEL	TRISB	; Select bank 1
MOVWF	TRISB	;TRISB=00H, to set PORTB as output port
BANKSEL	 PORTB	; Select bank 0
CLRF		PORTB	;Clear PORTB
LOOP
COMF		PORTB,F	;Compliment  PORTB
CALL		DELAY	;Call delay subroutine 
GOTO		LOOP		;goto loop
DELAY			;delay subroutine
MOVLW	01H
MOVWF	20H
LOOP1
MOVWF	21H
LOOP2
DECFSZ	21H,F
GOTO		LOOP2
DECFSZ	20H,1
GOTO		LOOP1
RETURN			;Returns from the subroutine
END				;program ends



#INCLUDE<P16F877.INC>
ORG		00H
CLRW				;W=00H
BANKSEL	TRISD	; Select bank 1
MOVWF	TRISD	;TRISB=00H, to set PORTD as output port
BANKSEL	PORTD	; Select bank 0
CLRF		PORTD	;Clear PORTD
LOOP
CALL		DELAY	;call delay subroutine
INCF		PORTD,F	;Increment PORTD
GOTO		LOOP		;goto loop
DELAY			;Delay subroutine
MOVLW	0FFH
MOVWF	20H
LOOP1
DECFSZ	20H,F
GOTO		LOOP1
RETURN			;Returns from the subroutine 
END				;Program ends

#INCLUDE<P16F877A.INC>
ORG 00H
MOVLW	10H		;W=10H, Count Value
MOVWF 	20H		;20H=10H
MOVLW 	40H		;W=40H
MOVWF 	21H		;21H=40H
MOVLW 	30H		;W=30H
LOOP
MOVWF	FSR		;FSR=Content of w reg
MOVF 	INDF,W	;Copy the content of location hold by FSR to W
MOVWF 	23H		;23H=Content of W reg
INCF 		FSR,F		;Increment FSR
MOVF 	FSR,W	;Copy the contents of FSR to w reg
MOVWF 	22H		;22H=Content of W reg
MOVF 	21H,W	;W=Content of 21H
MOVWF	FSR		;FSR=content of W reg
MOVF 	23H,W	;W=Content of 23H
MOVWF	INDF		;Copy the content of W to location hold by FSR
INCF		FSR,F		;Increment FSR
MOVF		FSR,W	;W=Content of FSR
MOVWF	21H		;21H=Content of W reg
MOVF		22H,W	;W=Content of 22H
DECFSZ	20H,F		;Decrement 20H & skip next line when 20H=00H
GOTO		LOOP		;Goto lable loop
GOTO		$		; Program Halt here
END				;End of program

