PROCESSOR   16F877A
#include <xc.inc>


; CONFIG
  CONFIG  FOSC = HS             ; Oscillator Selection bits (XT oscillator)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = ON           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = OFF            ; Brown-out Reset Enable bit (BOR enabled)
  CONFIG  LVP = OFF             ; Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
  CONFIG  WRT = OFF             ; Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)

Estado EQU 0x03			;Status = Valor Hexadecimal(datasheet)  
VAR1   EQU 0x20			;Registro de proposito general
VAR2   EQU 0x21			;Registro de proposito general
VAR3   EQU 0x22			;Registro de proposito general   
 
   
ORG 0
PSECT HOLA,CLASS = CODE,delta=2 ;PSECT NOMBRE(FUNC),CLASS(default),DELTA = 2(NO ES PIC 18)

;*****DESPLAZAMIENTO DE BITS CON 74HC595*******

PSECT HOLA
Inicio:
    ;Banco 1 (CONFIGURA INT/OUT)
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BSF	Estado,5    ;PONE A 1 EL BIT5(RP0) DEL STATUS
    
;Establece RB como salida(0)(todos sus pines)
    BCF TRISB,0
    BCF TRISB,1
    BCF TRISB,2
    
;Ahora se selecciona el banco 0 para acceder al PORTB
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BCF	Estado,5    ;PONE A 0 EL BIT5(RP0) DEL STATUS
    
;PUERTO B INICIALMENTE APAGADO
    BCF PORTB,0
    BCF PORTB,1
    BCF PORTB,2
    
Principal:
    BSF	    PORTB,0	    ;BIT "0" ENCENDIDO(PULSO ALTO)//16
    BSF     PORTB,1	    ;BIT "1" ENCENDIDO(DATO)(ENVIA UNOS)
    CALL    DELAY3	    
    BCF	    PORTB,0	    ;BIT "0" APAGADO(PULSO BAJO)
    CALL    DELAY3
    BSF     PORTB,2	    ;BIT "2" ENCENDIDO(ENVIA EL DATO)
    CALL    DELAY3
    BCF     PORTB,2	    ;BIT "2" APAGADO(SE PREPARA PARA ENVIAR OTRO DATO)
    CALL    DELAY3
    INCF    VAR3,1	    ;VAR3 <== VAR3 + 1
    BTFSC   VAR3,4	    ;TESTEA EL BIT DE POSICION "XXX'X' XXXX"(SALTA EN 0)
    CALL    OPUESTO
    BTFSC   VAR3,4	    ;TESTEA EL BIT DE POSICION "XXX'X' XXXX"(SALTA EN 0)
    MOVLW   0x00	    ; W <== 0000 0000
    BTFSC   VAR3,4	    ;TESTEA EL BIT DE POSICION "XXX'X' XXXX"(SALTA EN 0)
    MOVWF   VAR3	    ;VAR3 <== W
    GOTO    $-16
    
OPUESTO:
    MOVLW   0x00	    ; W <== 0000 0000
    MOVWF   VAR3	    ;VAR3 <== W		     
    BSF	    PORTB,0	    ;BIT "0" ENCENDIDO(PULSO ALTO) //12
    BCF     PORTB,1	    ;BIT "1" APAGADO(DATO)(ENVIA CEROS)
    CALL    DELAY3
    BCF	    PORTB,0	    ;BIT "0" APAGADO(PULSO BAJO)
    CALL    DELAY3
    BSF     PORTB,2	    ;BIT "2" ENCENDIDO(ENVIA EL DATO)
    CALL    DELAY3
    BCF     PORTB,2	    ;BIT "2" APAGADO(SE PREPARA PARA ENVIAR OTRO DATO)
    CALL    DELAY3
    INCF    VAR3,1	    ;VAR3 <== VAR3 + 1
    BTFSC   VAR3,4	    ;TESTEA EL BIT DE POSICION "XXX'X' XXXX"(SALTA EN 0)
    RETURN
    GOTO    $-12
    
DELAY3:
    CALL DELAY1
    CALL DELAY1
    CALL DELAY1
    CALL DELAY1
    RETURN
    
DELAY1:
    CLRF    VAR1    ;TODOS LOS BITS DE 0x20 ESTAN EN 0000 0000
    BTFSC   VAR1,7  ;TESTEA EL BIT 7 DE VAR(SI ES 0 SALTA UNA INSTRUCCION)
    RETURN
    CALL    DELAY2  ;129.2us 
    INCF    VAR1,1  ;VAR <== VAR + 1
    GOTO    $-4

DELAY2:
    CLRF    VAR2    ;TODOS LOS BITS DE 0x20 ESTAN EN 0000 0000
    BTFSC   VAR2,7  ;TESTEA EL BIT 7 DE VAR(SI ES 0 SALTA UNA INSTRUCCION)
    RETURN  
    INCF    VAR2,1  ;VAR <== VAR + 1
    GOTO    $-3    