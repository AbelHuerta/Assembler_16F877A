PROCESSOR   16F877A
#include <xc.inc>

; CONFIG
  CONFIG  FOSC = EXTRC          ; Oscillator Selection bits (RC oscillator)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = ON            ; Brown-out Reset Enable bit (BOR enabled)
  CONFIG  LVP = OFF             ; Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
  CONFIG  WRT = OFF             ; Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)    
    
Estado EQU 0x03			;Status = Valor Hexadecimal(datasheet)

  
PSECT HOLA,CLASS = CODE,delta=2 ;PSECT NOMBRE(FUNC),CLASS(default),DELTA = 2(NO ES PIC 18)

 
PSECT HOLA
Inicio:
;Primero se selecciona el banco 1 para acceder al TRISB(CONFIGURA INT/OUT)
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BSF	Estado,5    ;PONE A 1 EL BIT5(RP0) DEL STATUS

;Establece TRISB como salida(0)
    BCF TRISB,0
    BCF TRISB,1
    BCF TRISB,2
    BCF TRISB,3
    
;Ahora se selecciona el banco 0 para acceder al PORTB
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BCF	Estado,5    ;PONE A 0 EL BIT5(RP0) DEL STATUS
    
Principal:
;Establecer PORTB encendido(1),apagado(0)
    BSF	PORTB,0	    ;1
    BCF PORTB,1	    ;0
    BSF PORTB,2	    ;1
    BCF PORTB,3	    ;0
    GOTO Principal  ;SE CREA UN BUCLE CERRADO E INFINITO
    END		    ;FIN DEL PROGRAMA