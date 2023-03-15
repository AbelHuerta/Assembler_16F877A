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
TEMP1  EQU 0x20			;Registro de proposito general
 
 
PSECT HOLA,CLASS = CODE,delta=2 ;PSECT NOMBRE(FUNC),CLASS(default),DELTA = 2(NO ES PIC 18)

;****TIMER_0 - PARPADEO CON RETARDO*******

PSECT HOLA
Inicio:
;Banco 1 (CONFIGURA INT/OUT)
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BSF	Estado,5    ;PONE A 1 EL BIT5(RP0) DEL STATUS
    
;Establece RB como salida(0)(todos sus pines)
    CLRF TRISB
    
;CONFIGURACION DEL OPTION_REG(configuracion TMR0)
    MOVLW   0x07	    ;PRE = 256
    MOVWF   OPTION_REG  
    
;Ahora se selecciona el banco 0 para acceder al PORTB
    BCF Estado,6    ;PONE A 0 EL BIT6(RP1) DEL STATUS
    BCF	Estado,5    ;PONE A 0 EL BIT5(RP0) DEL STATUS
    
;PUERTO B INICIALMENTE APAGADO
    CLRF  PORTB
    
Principal:
    BSF	    PORTB,0 ;BIT "0" ENCENDIDO
    MOVLW   0b01100110    ;.100(DELAY DE 100ms)(REPITE 100 VECES)(.102 ES MAS EXACTO)
    CALL    DELAY_MS
    BCF	    PORTB,0 ;BIT "0" APAGADO
    MOVLW   0b01100110	 ;.100
    CALL    DELAY_MS
    GOTO    $-6
    
DELAY_MS:
    MOVWF   TEMP1
    CALL    DELAY_1MS
    DECFSZ  TEMP1,1	;TEMP1 <== TEMP1 - 1(SI TEMP1=0 SALTA UNA INSTRUCCION)
    GOTO    $-2
    RETURN
    
DELAY_1MS:
    CLRF    TMR0
    BTFSS   TMR0,4	;19VECES (0001 0011);SI EL BIT ES 1 SALTA UNA INSTRUCCION
    GOTO    $-1
    BTFSS   TMR0,1
    GOTO    $-3
    BTFSS   TMR0,0
    GOTO    $-5
    RETURN
    
    
    