PROCESSOR   16F877A
#include <xc.inc>

; CONFIG
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = ON            ; Brown-out Reset Enable bit (BOR enabled)
  CONFIG  LVP = OFF             ; Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
  CONFIG  WRT = OFF             ; Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)
  
Estado EQU 0x03			;Status = Valor Hexadecimal(datasheet)  
VAR1   EQU 0x20			;Registro de proposito general
VAR2   EQU 0x21			;Registro de proposito general
   
 
PSECT HOLA,CLASS = CODE,delta=2 ;PSECT NOMBRE(FUNC),CLASS(default),DELTA = 2(NO ES PIC 18)

;*****PARPADEO LED*******

PSECT HOLA
Inicio: 
    
;Banco 1 (CONFIGURA INT/OUT)
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BSF	Estado,5    ;PONE A 1 EL BIT5(RP0) DEL STATUS
    
;Establece RB como salida(0)(todos sus pines)
    CLRF TRISB
    
;Ahora se selecciona el banco 0 para acceder al PORTB
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BCF	Estado,5    ;PONE A 0 EL BIT5(RP0) DEL STATUS
    
;PUERTO B INICIALMENTE APAGADO
    CLRF  PORTB
    
Principal:
    BSF	    PORTB,0 ;BIT "0" ENCENDIDO
    CALL    DELAY3
    BCF	    PORTB,0 ;BIT "0" APAGADO
    CALL    DELAY3
    GOTO    $-4

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

    
    
    