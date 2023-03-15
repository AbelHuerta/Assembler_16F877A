PROCESSOR   16F877A
#include <xc.inc>

; CONFIG
  CONFIG  FOSC = XT          ; Oscillator Selection bits (RC oscillator)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = ON            ; Brown-out Reset Enable bit (BOR enabled)
  CONFIG  LVP = OFF             ; Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
  CONFIG  WRT = OFF             ; Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)
  
Estado EQU 0x03			;Status = Valor Hexadecimal(datasheet)


	
PSECT HOLA,CLASS = CODE,delta=2 ;PSECT NOMBRE(FUNC),CLASS(default),DELTA = 2(NO ES PIC 18)

;*********BINARIO**********
PSECT HOLA
Inicio:
;Limpia las salidas RA
    CLRF PORTA      
    
;Banco 1 (CONFIGURA INT/OUT)
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BSF	Estado,5    ;PONE A 1 EL BIT5(RP0) DEL STATUS

;Deshabilitar comparador OFF para que trabaje como entrada RA(SI NO SE COLOCA DA IGUAL)
    MOVLW 0x07	    ; W <== 0000 0111
    MOVWF CMCON	    ;TRISA <== W
    
;Configurar ADCON1 para RA funcionen como entrada digital
    MOVLW 0x06	    ; W <== 0000 0110
    MOVWF ADCON1    ;ADCON1 <== W
    BSF TRISA,0
    BSF TRISA,1
	
;Establece RB como salida(0)(todos sus pines)
    CLRF TRISB	
    

;Ahora se selecciona el banco 0 para acceder al PORTB
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BCF	Estado,5    ;PONE A 0 EL BIT5(RP0) DEL STATUS
    
;PUERTO B APAGADO
    CLRF    PORTB
    
Principal:
    BTFSC   PORTA,0 ;SI NO SE PRESIONA SALTA UNA INSTRUCCION
    GOTO    incre
    BTFSC   PORTA,1 ;SI NO SE PRESIONA SALTA UNA INSTRUCCION  
    GOTO    decre
    GOTO    Principal  
    
    	
incre:	
    INCF    PORTB,1	;PORTB <== PORTB + 1
    BTFSC   PORTA,0	;SI NO SIGUE PRESIONADO SALTA UNA INSTRUCCION
    GOTO    $-1		;PREGUNTA CONSTANTE A LA LINEA ANTERIOR
    GOTO    Principal	;VUELVE A PREGUNTAR DESDE PRINCIPAL
	
    	
decre:	
    DECF    PORTB,1	;PORTB <== PORTB - 1
    BTFSC   PORTA,1	;SI NO SIGUE PRESIONADO SALTA UNA INSTRUCCION
    GOTO    $-1	
    GOTO    Principal	    ;SE CREA UN BUCLE CERRADO E INFINITO

    END	Principal		    ;FIN DEL PROGRAMA
